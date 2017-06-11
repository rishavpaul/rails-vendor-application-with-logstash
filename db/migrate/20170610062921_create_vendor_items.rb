class CreateVendorItems < ActiveRecord::Migration[5.1]
  def change
    create_table :vendor_items do |t|
      t.decimal :price, :precision => 10, :scale => 2
      t.integer :version
      t.references :vendor
      t.references :item
      t.timestamps
    end
  end
end
