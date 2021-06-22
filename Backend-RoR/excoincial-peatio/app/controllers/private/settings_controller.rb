# encoding: UTF-8
# frozen_string_literal: true

module Private
  class SettingsController < BaseController
    layout 'funds'
    def index
      begin
        @login_histories = RestClient.get(
          "#{ENV.fetch('BARONG_DOMAIN')}/users/api/v1/accounts/login_history?access_token="+current_user.auth('barong').token
        )
        @login_histories =  JSON.parse @login_histories
      rescue
        flash[:notice] = "Login history not created yet."
      end

      begin
        data = RestClient.get(
          "#{ENV.fetch('BARONG_DOMAIN')}/users/api/v1/accounts/edit_profile?access_token="+current_user.auth('barong').token
        )
        data =  JSON.parse data
        if data[0].present?
          @profile = data[0]
        else
          @profile = {}
        end
        @phone = data[1]
        @contact = @phone["number"].split(ISO3166::Country.find_country_by_alpha3(@profile["country"]).country_code).last rescue " "
      rescue
        @profile = {}
        flash[:notice] = "Profile not created yet."
      end
    end
  end
end
