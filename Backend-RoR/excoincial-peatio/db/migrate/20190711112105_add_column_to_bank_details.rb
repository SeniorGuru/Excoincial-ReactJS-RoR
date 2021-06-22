class AddColumnToBankDetails < ActiveRecord::Migration
  def change
    add_column :bank_details, :iban, :string
  end
end
