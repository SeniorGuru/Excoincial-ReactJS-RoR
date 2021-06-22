# encoding: UTF-8
# frozen_string_literal: true

module Private
  class BankDetailsController < BaseController
    layout 'funds'
#    before_action :auth_member!

  def index
      @bank_details = current_user.bank_details.order(id: :desc)
    end

  def new
      @bank_detail = BankDetail.new
    end

  def create
      @bank_detail = current_user.bank_details.new(bank_params)
      if @bank_detail.save
        flash[:notice] = "Bank details successfully created"
        redirect_to bank_details_path
      else
        flash[:notice] = @bank_detail.errors.full_messages
        render :new
      end
    end

  def edit
      @bank_detail = BankDetail.find(params[:id])
    end

  def update
      @bank_detail = BankDetail.find(params[:id])
      if @bank_detail.update(bank_params)
        flash[:notice] = "Bank details successfully updated"
        redirect_to bank_details_path
      else
        flash[:notice] = @bank_detail.errors.full_messages
        render :edit
      end
    end

  def destroy
      @bank_detail = BankDetail.find(params[:id])
      @bank_detail.destroy
      redirect_to bank_details_path
    end

  private

  def bank_params
      params.require(:bank_detail).permit!
    end
  end
end