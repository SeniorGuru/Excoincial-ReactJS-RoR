class CreateLoginHistories < ActiveRecord::Migration[5.2]
  def change
    create_table :login_histories do |t|
      t.string :apparaat
      t.string :location
      t.string :ip_address
      t.integer :account_id
      t.boolean :verified, default: false

      t.timestamps
    end
  end
end
