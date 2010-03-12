class AddStoreIdToDeliveries < ActiveRecord::Migration
  def self.up
    add_column :deliveries, :store_id, :integer
  end

  def self.down
    remove_column :deliveries, :store_id
  end
end
