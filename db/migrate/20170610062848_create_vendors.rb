class CreateVendors < ActiveRecord::Migration[5.1]
  def change
    create_table :vendors do |t|
      t.string :name
      t.string :country
      t.string :city
      t.string :zipcode

      t.timestamps
    end
  end
end
