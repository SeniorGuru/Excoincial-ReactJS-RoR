# frozen_string_literal: true

#require 'doorkeeper/grape/helpers'

require 'doorkeeper/grape/helpers'
require 'lines/article'

module UserApi
  module V1
    class Articles < Grape::API
      desc 'Get Articles List'
      resource :articles do
        desc 'Return all articles List'
        get '/' do
          Lines::Article.all
        end
      end
    end
  end
end
