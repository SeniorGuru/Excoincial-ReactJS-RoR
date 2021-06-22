# encoding: UTF-8
# frozen_string_literal: true

require_dependency 'admin/withdraws/base_controller'

module Admin
  module Withdraws
    class FiatsController < BaseController
      before_action :find_withdraw, only: [:show, :update, :destroy]

      def index
        case params.fetch(:state, 'all')
        when 'all'
          all_withdraws
        when 'latest'
          latest_withdraws
        when 'pending'
          pending_withdraws
        end
      end

      def index
        @latest_withdraws  = ::Withdraws::Fiat.where(currency: currency)
                                              .where('created_at <= ?', 1.day.ago)
                                              .order(id: :desc)
                                              .includes(:member, :currency)
        @all_withdraws     = ::Withdraws::Fiat.where(currency: currency)
                                              .where('created_at > ?', 1.day.ago)
                                              .order(id: :desc)
                                              .includes(:member, :currency)
      end

      def show

      end

      def update
        @withdraw.transaction do
          @withdraw.accept!
          @withdraw.process!
          @withdraw.dispatch!
          @withdraw.success!
        end
        redirect_to :back, notice: t('admin.withdraws.fiats.update.notice')
      end

      def destroy
        @withdraw.reject!
        redirect_to :back, notice: t('admin.withdraws.fiats.update.notice')
      end

      private

        def all_withdraws
          if (currency.escrow?)
            @all_withdraws = 
              ::Withdraws::Escrow.where(currency: currency)
                                 .order(id: :desc)
                                 .includes(:member, :currency)
          elsif (currency.fiat?)
            @all_withdraws = 
              ::Withdraws::Fiat.where(currency: currency)
                               .order(id: :desc)
                               .includes(:member, :currency)
          end
        end

        def latest_withdraws
          if (currency.escrow?)
            @latest_withdraws = 
              ::Withdraws::Escrow.where(currency: currency)
                                 .where('created_at > ?', 1.day.ago)
                                 .order(id: :desc)
                                 .includes(:member, :currency)
          elsif (currency.fiat?)
            @latest_withdraws = 
              ::Withdraws::Fiat.where(currency: currency)
                               .where('created_at > ?', 1.day.ago)
                               .order(id: :desc)
                               .includes(:member, :currency)
          end
        end

        def pending_withdraws
          if (currency.escrow?)
            @pending_withdraws = 
              ::Withdraws::Escrow.where(currency: currency, aasm_state: 'accepted')
                                 .where('created_at  < ?', 1.minute.ago)
                                 .order(id: :desc)
                                 .includes(:member, :currency)
          elsif (currency.fiat?)
            @pending_withdraws = 
              ::Withdraws::Escrow.where(currency: currency, aasm_state: 'accepted')
                                 .where('created_at  < ?', 1.minute.ago)
                                 .order(id: :desc)
                                 .includes(:member, :currency)
          end
        end


#     def process!
#       @withdraw.transaction do
#         @withdraw.accept!
#         @withdraw.process!
#       end
#       redirect_to :back, notice: 'Withdraw successfully processed!'
#     end
#

    end
  end
end
