class CreateFaqSettings < ActiveRecord::Migration
  def change
    create_table :faq_settings do |t|
      t.string :question, null: false
      t.text :answer, null: false

      t.timestamps null: false
    end
  end
end
