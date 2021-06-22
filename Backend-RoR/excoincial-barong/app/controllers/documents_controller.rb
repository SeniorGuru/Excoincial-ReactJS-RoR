# frozen_string_literal: true

class DocumentsController < ApplicationController
  before_action :authenticate_account!
  # before_action :check_account_level

  def new
    @document = current_account.documents.new
  end

  def create
    if current_account.documents.count >= ENV.fetch('DOCUMENTS_LIMIT', 20)
      redirect_to index_path, alert: 'Maximum number of documents submission (20) is reached.'
    else
      if current_account.level > 1
        redirect_to index_path, alert: 'Your KYC has already been approved, please contact Admin for any further action'
      else
        @document = current_account.documents.new(document_params)
        if @document.save
          MemberMailer.kyc_complete(current_account,new_profile_url,new_document_url).deliver
          redirect_to index_path, notice: 'KYC successfully submitted! Please check your email for further instruction'
        else
          flash[:alert] = 'Some fields are empty or invalid'
          render :new
        end
      end
    end
  end

private

  # def check_account_level
  #   redirect_to new_phone_path if current_account.level < 2
  # end

  def document_params
    params.require(:document)
          .permit(:doc_type, :doc_number, :doc_expire, :upload)
  end
end
