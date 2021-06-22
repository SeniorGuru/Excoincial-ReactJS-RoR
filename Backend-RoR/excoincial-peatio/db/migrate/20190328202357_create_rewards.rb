class CreateRewards < ActiveRecord::Migration
  def change
    create_table :rewards do |t|
      t.string :ref_type
      t.decimal :amount, precision: 32, scale: 16, default: 0.0, null: false
      t.integer :order_id, null: false
      t.integer :member_id, null: false
      t.integer :ref_member_id
      t.timestamps null: false
    end
    add_index :rewards, :member_id
    add_index :rewards, :ref_member_id
  end
end
