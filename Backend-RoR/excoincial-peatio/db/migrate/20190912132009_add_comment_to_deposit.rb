class AddCommentToDeposit < ActiveRecord::Migration
  def change
    add_column :deposits, :comment, :string
  end
end
