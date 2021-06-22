class AddStopLossToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :stop_loss, :boolean, default: false
  end
end
