# encoding: UTF-8
# frozen_string_literal: true
require 'json'
require 'openssl'

class WelcomeController < ApplicationController
  before_action :auth_member!,:only => [:disable_account,:confirm_withdrawal,:approve_login]
  layout 'landing'
  include Concerns::DisableCabinetUI

  # def index
  #   @faq_all = FaqSetting.order(id: :desc)
  # end

  def index
    @faq_all = FaqSetting.order(id: :desc)
    if params[:reason] == 'signed_out'
      flash[:notice] = "Signed out Successfully"
      redirect_to root_path
    end
  end

  def aboutus
  end

  def login_privacy
  end

  def login_supportfooter
    @faq_less = FaqSetting.order(id: :desc).first(6)
  end

  def login_terms_cond
  end

  def cookies_eu
  end

  def setmode
    session[:daymode] = params[:mode]
    redirect_to :back
  end

  def coins_info
    @currencies = Currency.enabled
    article = RestClient.get(ENV['BARONG_DOMAIN']+"/users/api/v1/articles")
    @currencies_body = JSON.parse(article.body)

  end

  def disable_account
    @member = Member.find_by_sn params[:id]
    @member.update(disabled: true)
    @success =  false
    @response = ""
    @path = "/users/api/v1/accounts/disable_account"
    @json_rpc_endpoint = URI.parse("#{ENV.fetch('URL_SCHEME')}://#{ENV.fetch('BARONG_DOMAIN')}")
    begin
      Faraday.new(@json_rpc_endpoint).tap do |connection|
        @response = connection.post(@path,{:access_token => current_user.auth('barong').token}) do |req|
          #req.headers['Authentication'] = "Bearer #{current_user.auth('barong').token}"
          #req.body = ""
        end
      end
      @success = true
    rescue
    end
    destroy_member_sessions(current_user.id)
    reset_session
    flash[:notice] = "Account successfully disabled. Please contact Admin for reactivation" \
      "\n#{@success ? """success RestClient""" : """failed RestClient"""} #{@response.inspect}"
    return redirect_to '/logout'
  end

  def confirm_withdrawal
    @withdraw = Withdraw.find_by_tid params[:id]
    @withdraw.audit!
    flash[:notice] = "Withdrawal authorisation successfully confirmed."
    redirect_to root_path
  end

  def approve_login
    if session[params[:sid]].nil?
      flash[:error] = "Session expired, please logout then login and verify your browser from the link in your email."
      render "welcome/login_alert", :layout => "funds"
    elsif
      if session[params[:sid]].to_time < session[params[:sid]].to_time + 3.hours
        @member = Member.find_by_sn params[:id]
        user_agent = UserAgent.parse(request.env["HTTP_USER_AGENT"])
        user_agent = user_agent.browser + " " + user_agent.version.to_s + " (" + user_agent.os + ")"
        city = Geocoder.search(request.ip).first.city rescue nil
        ip = request.ip
        user_history = {}
        user_history[:browser] = user_agent
        user_history[:city] = city
        user_history[:ip] = ip
        if session.id == params[:sid]
          session["valid_user"] = true
          options = {}
          options[:expire_after] ||= ENV.fetch('SESSION_LIFETIME').to_i
          @success =  false
          @response = ""
          @path = "/users/api/v1/accounts/update_login_history"
          @json_rpc_endpoint = URI.parse("#{ENV.fetch('URL_SCHEME')}://#{ENV.fetch('BARONG_DOMAIN')}")
          begin
            Faraday.new(@json_rpc_endpoint).tap do |connection|
              @response = connection.post(@path,{:access_token => @member.auth('barong').token}) do |req|
                #req.headers['Authentication'] = "Bearer #{current_user.auth('barong').token}"
                #req.body = ""
              end
            end
            @success = true
          rescue
          end
#          begin
#            RestClient.get(
#              "#{ENV.fetch('BARONG_DOMAIN')}/users/api/v1/accounts/update_login_history?access_token="+@member.auth('barong').token
#            )
#          rescue
#          end
          redis = Rails.cache.instance_variable_get(:@data)
          if (
              redis.keys("peatio:sessions:#{@member.id}:*").map do |keys|
                Rails.logger.info { "check peatio session IP keys Rails.cache.read(keys)[:ip] #{Rails.cache.read(keys)[:ip]} ip:#{ip} " }
                Rails.cache.read(keys)[:ip] == ip
              end
            ).flatten.include?(true)
            LoginMailer.successful_login(@member.id,user_agent,city,ip).deliver_later
          else
            LoginMailer.successful_ip_verification(@member.id,user_agent,city,ip).deliver_later
          end
          Rails.cache.write("peatio:sessions:#{@member.id}:#{session.id}", user_history,options)
          flash[:notice] = "Success. Browser has been verified!"
          fetched_referer_path = ENV['login_referer_path']
          fetched_referer_path ||= params[:login_referer_path]
          redirect_to fetched_referer_path.nil? ? '/trading/' + get_default_market : fetched_referer_path
        else
          @user_history = user_history
          render "welcome/invaild_browser", :layout => "funds"
        end
      else
        flash[:notice] = "Link expired."
        render "welcome/login_alert", :layout => "funds"
      end
    end
  end

  def change_pwd
    if params[:new_password] == params[:password_confirmation]
      begin
        @change_password = RestClient.put(
          "#{ENV.fetch('BARONG_DOMAIN')}/users/api/v1/accounts/password",{:old_password => params[:old_password], :new_password => params[:new_password], :access_token => current_user.auth('barong').token}
        )
        flash[:notice] = JSON.parse @change_password
      rescue => e
        flash[:notice] = e.message.gsub("500 ","").gsub("400 ","").gsub("401 ","")
      end
    else
      flash[:notice] = "Password confirmation doesn't match."
    end
    redirect_to :back 
  end

  def update_profile
    begin
      data = RestClient.post(
        "#{ENV.fetch('BARONG_DOMAIN')}/users/api/v1/accounts/update_profile",{:first_name => params[:first_name],:last_name => params[:last_name], :contact => params[:contact],:country => params[:country],:address => params[:address], :access_token => current_user.auth('barong').token}
      )
      data =  JSON.parse data
      if data == "Number is invalid"
        flash[:notice] = data 
      else
        flash[:notice] = "Personal Details successfully updated."
      end
    rescue => e
      flash[:alert] = e.message
    end
    redirect_to :back
  end

  def update_profile_image
    Rails.logger.debug { params[:image].inspect }
    if params[:image].present?
      begin
        data = RestClient.post(
          "#{ENV.fetch('URL_SCHEME')}://#{ENV.fetch('BARONG_DOMAIN')}/users/api/v1/accounts/update_image",{:image => params[:image], :access_token => current_user.auth('barong').token}
        )
        data =  JSON.parse data
        if data.present?
          flash[:notice] = "Profile Picture successfully updated."
        else
          flash[:notice] = "Sorry, we could not upload this file. Try saving it in a different format and upload again"
        end
      rescue => e
        flash[:notice] = e.message
      end
    else
      flash[:notice] = "Select image for upload."
    end
    redirect_to :back
  end

  def get_default_market
    cookies[:market_id].present? ? cookies[:market_id] : "ethbtc"
  end
end
