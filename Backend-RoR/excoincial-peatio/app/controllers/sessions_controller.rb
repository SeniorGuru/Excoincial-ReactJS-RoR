# encoding: UTF-8
# frozen_string_literal: true

class SessionsController < ApplicationController
  before_action :auth_member!, only: :destroy
  before_action :auth_anybody!, only: :failure

  def callback
    local_referer_path_push params
    redirect_to "/accounts/login"
  end

  def create
    @member = Member.from_auth(auth_hash)
    Rails.logger.debug { @member.inspect }
    return redirect_on_unsuccessful_sign_in unless @member
    return redirect_to(root_path, alert: t('.disabled')) if @member.disabled?

    reset_session rescue nil
    session[:member_id] = @member.id
    local_referer_path_fetch
    # memoize_member_session_id @member.id, session.id

    user_agent = UserAgent.parse(request.env["HTTP_USER_AGENT"])
    user_agent = user_agent.browser + " " + user_agent.version.to_s + " (" + user_agent.os + ")"
    city = Geocoder.search(request.ip).first.city rescue nil
    ip = request.ip
    user_history = {}
    options = {}
    user_history[:browser] = user_agent
    user_history[:city] = city
    user_history[:ip] = ip
    options[:expire_after] ||= ENV.fetch('SESSION_LIFETIME').to_i
    redis = Rails.cache.instance_variable_get(:@data)
    if @member.present? && redis.keys("peatio:sessions:#{@member.id}:*").present?
      @path = "/users/api/v1/accounts/last_login"
      @json_rpc_endpoint = URI.parse("#{ENV.fetch('URL_SCHEME')}://#{ENV.fetch('BARONG_DOMAIN')}")
      @success = false
      begin
        Rails.logger.info do
          Faraday.new(@json_rpc_endpoint).tap do |connection|
            @response = connection.get(@path,{:access_token => @member.auth('barong').token}) do |req|
            end
          end
        end
        @success = true
      rescue => e
        report_exception(e)
        Rails.logger.error { "Member id=#{@member.id} failed to fetch last login history." }
        Rails.logger.info { params.inspect }
      end
      if @success && @response.success?
        Rails.logger.info { "#{params.inspect}\tCall fetch history to barong succeeded\t\t#{@response&.headers.inspect}\t\t#{@response.body.inspect}" }
        begin
          @login_history = JSON.parse @response&.body
        rescue => e
          report_exception(e)
        end
      else
        Rails.logger.error { "Member id=#{@member.id} failed to fetch login history." }
        Rails.logger.info { "#{params.inspect}\tCall to barong #{@response&.success? ? :succeeded : :failed }\t\t#{@response&.headers.inspect}\t\t#{@response&.body.inspect}" }
      end

      if @login_history.present?
        time = time_cal(@login_history["updated_at"].to_time,Time.current.to_time)
        flash[:notice] = "You last logged in #{time} on " +
          "#{@login_history["updated_at"].to_time.strftime("%d %b %Y")} " +
          "at #{@login_history["updated_at"].to_time.utc.strftime("%H:%M")} UTC " +
          "from #{@login_history["ip_address"]}"
      end
      Rails.logger.info { "Show value of parameter \nENV['login_referer_path']\t#{ENV['login_referer_path']}" }
      session[session.id] = Time.now
      if redis.keys("peatio:sessions:#{@member.id}:*").map { |keys| Rails.cache.read(keys)[:ip] == ip }.flatten.include?(true)
        #send mail for browser
        session["valid_user"] = false
        LoginMailer.browser_mail(@member.id,user_agent,city,ip,session.id,ENV['login_referer_path']).deliver_later
        redirect_to "/login_alert#{ENV['login_referer_path'].nil? ? '' : '?' + Hash[:login_referer_path, ENV['login_referer_path']].to_query}"
      else
        #send mail for ip address
        session["valid_user"] = false
        LoginMailer.diff_ip_mail(@member.id,user_agent,city,ip,session.id,ENV['login_referer_path']).deliver_later
        redirect_to "/login_alert#{ENV['login_referer_path'].nil? ? '' : '?' + Hash[:login_referer_path, ENV['login_referer_path']].to_query}"
      end
    else
      Rails.cache.write("peatio:sessions:#{@member.id}:#{session.id}", user_history, options)
      LoginMailer.successful_login(@member.id,user_agent,city,ip).deliver_later
      redirect_on_successful_sign_in
    end
  end

  def failure
    redirect_to root_path, alert: t('.error')
  end

  def destroy
    destroy_member_sessions(current_user.id)
    reset_session rescue nil
    if request.referer.present?
      @referer_path = URI(request.referer).path
      if @referer_path.starts_with? '/trading'
        redirect_to "/accounts/logout?#{Hash[:logout_referer_path,@referer_path].to_query}"
        return
      else
        begin
          referer_params = Rails.application.routes.recognize_path(@referer_path, method: request.env["REQUEST_METHOD"])
          if referer_params[:controller].starts_with? 'private', 'admin'
            redirect_to '/accounts/logout'
            return
          end
        rescue => e
          report_exception(e)
          Rails.logger.error { "Failed to recognize controller for path #{@referer_path}" }
        end
      end
    elsif
      redirect_to login_path
      return
    end
    redirect_to root_path
    return
  end

private

  def auth_hash
    @auth_hash ||= request.env['omniauth.auth']
  end

  def redirect_on_successful_sign_in
    @member ||= currenct_user
    @member ||= Member.find_by_sn params[:id]
    @response = nil
    @path = "/users/api/v1/accounts/update_login_history"
    @json_rpc_endpoint = URI.parse("#{ENV.fetch('URL_SCHEME')}://#{ENV.fetch('BARONG_DOMAIN')}")
    @success = false
    begin
      Rails.logger.info do
        Faraday.new(@json_rpc_endpoint).tap do |connection|
          @response = connection.post(@path,{:access_token => @member.auth('barong').token}) do |req|
          end
        end
      end
      @success = true
    rescue => e
      report_exception(e)
      Rails.logger.error { "Member id=#{@member.id} failed to update login history." }
      Rails.logger.info { params.inspect }
    end
    Rails.logger.error { "Response from barong contents #{@response.inspect}" }
    if @success && @response.success? && @response&.body == "true"
      Rails.logger.info { "#{params.inspect}\tCall update history to barong succeeded\t\t#{@response&.headers.inspect}\t\t#{@response.body.inspect}" }
    else
      Rails.logger.error { "Member id=#{@member.id} failed to update login history." }
      Rails.logger.info { "#{params.inspect}\tCall to barong #{@response&.success? ? :succeeded : :failed }\t\t#{@response&.headers.inspect}\t\t#{@response&.body.inspect}" }
    end
    "#{params[:provider].to_s.gsub(/(?:_|oauth2)+\z/i, '').upcase}_OAUTH2_REDIRECT_URL".tap do |key|
      if ENV[key] && params[:provider].to_s == 'barong'
        puts "auth_hash.fetch('credentials') #{auth_hash.fetch('credentials').inspect}"
        redirect_to "#{ENV[key]}?#{auth_hash.fetch('credentials').to_query}"
      elsif ENV[key]
        redirect_to ENV[key]
      else
        Rails.logger.info { "ENV['login_referer_path'].nil? ? '/trading/' + get_default_market : ENV['login_referer_path']\n" +
          "#{ENV['login_referer_path'].nil?} ? /trading/" + "#{get_default_market} : #{ENV['login_referer_path']}"
        }
        redirect_to ENV['login_referer_path'].nil? ? '/trading/' + get_default_market : ENV['login_referer_path']
      end
    end
  end

  def get_default_market
    cookies[:market_id].present? ? cookies[:market_id] : "ethbtc"
  end

  def local_referer_path_fetch
    begin
      redis = Rails.cache.instance_variable_get(:@data)
      Rails.logger.info { "session hash #{client_hash}" }
      Rails.logger.info { Rails.cache.fetch("peatio:sessions:unknown:#{client_hash}").inspect }
      if redis.keys("peatio:sessions:unknown:#{client_hash}").present?
        Rails.logger.info { "reading from redis keys " + redis.keys("peatio:sessions:unknown:#{client_hash}").inspect }
        begin
          ENV["login_referer_path"] = redis.keys("peatio:sessions:unknown:#{client_hash}")[:login_referer_path]
        rescue => e
          Rails.logger.error { "failed above, reading rails cache instead" }
          Rails.logger.info { Rails.cache.fetch("peatio:sessions:unknown:#{client_hash}").inspect }
          ENV["login_referer_path"] = Rails.cache.fetch("peatio:sessions:unknown:#{client_hash}")[:login_referer_path]
        end
      else
        Rails.logger.info { Rails.cache.fetch("peatio:sessions:unknown:#{client_hash}").inspect }
        ENV["login_referer_path"] = Rails.cache.fetch("peatio:sessions:unknown:#{client_hash}")[:login_referer_path]
      end
      Rails.logger.info { "ENV[:login_referer_path]\t" + ENV["login_referer_path"].inspect }
    rescue => e
      report_exception(e)
      Rails.logger.error {e.inspect}
    end
  end

  def local_referer_path_push(path = "")
    begin
      redis = Rails.cache.instance_variable_get(:@data)
      Rails.logger.info { "session hash #{client_hash}" }
      Rails.cache.fetch("peatio:sessions:unknown:#{client_hash}"){path unless path.blank?}
      Rails.logger.info { redis.keys("peatio:sessions:unknown:#{client_hash}") }
      #redis.rpush(:local_referer_path, path[:local_referer_path]) unless path.blank? || path[:local_referer_path]&.blank?
      Rails.logger.info { Rails.cache.fetch("peatio:sessions:unknown:#{client_hash}").inspect }
    rescue => e
      Rails.logger.error {e.inspect}
    end
  end

  def client_hash
    Base64.urlsafe_encode64( request.ip.to_s + request.env["HTTP_USER_AGENT"].to_s )[0..9]
  end

  def redirect_on_unsuccessful_sign_in
    redirect_to root_path, alert: t('.error')
  end
end
