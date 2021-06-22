module Worker
  class DepositFiat
    def process(payload)
      Rails.logger.debug { "Received request for deposit collection at #{Time.now} deposit_id: #{payload['id']}." }
      deposit = Deposit.find_by_id(payload['id'])
      return if deposit.aasm_state != "submitted"

      if deposit.currency.escrow?
        Rails.logger.info {"Skipping escrow type currency"}
      elsif deposit.txid.slice(0..1) == "PG"
        check_payment_status(deposit.id)
      else
        Rails.logger.warn {"Unknown transaction"}
      end
    end

    def check_payment_status(id)
      Rails.logger.warn {" Contacting Paygate "}
      deposit = Deposit.find(id)

      conn = Faraday.new

      url = "https://fidelitypaygate.fidelitybank.ng/CIPG/MerchantServices/UpayTransactionStatus.ashx?Order_ID=#{deposit.txid}&Merchant_Id=83349"
      response = conn.get url
      response = Hash.from_xml response.body
      Rails.logger.warn { response.to_s }
      status = response["CIPG"]["StatusCode"]
      order_id = response["CIPG"]["OrderID"]
      deposit = Deposit.find_by_txid(order_id)
      case status
      when "00"
        #Successful
        Rails.logger.debug { "deposit state before receive! #{deposit.aasm_state.inspect}" }
        deposit.receive!
        Rails.logger.debug { "deposit state after receive! #{deposit.aasm_state.inspect}" }
      when "01"
        #Failed
        deposit.reject!
        deposit.update_attributes(comment: "Rejected at PayGate")
      when "02"
        #Pending
       	AMQPQueue.enqueue(:deposit_fiat, id: deposit.id)
      when "03"
        #Cancelled
        deposit.cancel!
      when "04"
      	#Not processed
       	deposit.reject!
       	deposit.update_attributes(comment: "Not processed at Paygate")
      else
        Rails.logger.warn {"Unknown response status"}
      end
    end
  end
end