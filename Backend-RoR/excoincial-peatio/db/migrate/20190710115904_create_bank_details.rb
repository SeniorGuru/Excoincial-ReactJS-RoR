class CreateBankDetails < ActiveRecord::Migration
  def change
    create_table :bank_details do |t|
      t.integer :member_id
      t.string :bank_name
      t.string :account_no
      t.string :account_name
      t.string :swift_code
      t.string :bank_branch
      t.string :bank_branch_code
      t.string :bank_address

      t.timestamps null: false
    end
  end
end
