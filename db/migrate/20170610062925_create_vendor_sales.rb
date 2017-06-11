class CreateVendorSales < ActiveRecord::Migration[5.1]
  def change
    create_table :vendor_sales do |t|
      t.integer :quantity
      t.references :vendor_item
      t.timestamps
    end
  end
end
