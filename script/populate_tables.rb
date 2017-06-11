require 'rest-client'
require 'faker'
require 'pry'
require 'typhoeus'
require 'benchmark'
require 'json'

NO_OF_VENDORS = 2000

NO_OF_ITEMS = 30000

ITEMS_ARRAY = Array(1..NO_OF_ITEMS)
VENDORS_ARRAY = Array(1..NO_OF_VENDORS)

BASE_URL = "localhost:3000/"
VENDORS_URL = BASE_URL + "vendors/"
ITEMS_URL = BASE_URL + "items/"

def get_random_vendor
  {
    :"name" => Faker::Name.name,
    :"country" => Faker::Address.country_code,
    :"city" => Faker::Address.city,
    :"zipcode" => Faker::Address.zip_code
  }
end

def get_random_item
  {
    :"name" => Faker::Commerce.product_name,
    :"category" => Faker::Commerce.department(1)
  }
end

def get_vendor_item(base_price, item_id, price_fluctutation = true)
  new_price = base_price
  
  if price_fluctutation
    new_price = base_price*( 1 + Faker::Number.between(-0.1, 0.1))
  end
  
  price_increased = new_price > base_price
  
  return {
    item_id: item_id,
    price: new_price,
    price_increased: price_increased
  }
end

def get_actual_quantity_sold(base_quantity_sold, price_increased)
  price_increased ? 
    [ base_quantity_sold - Faker::Number.digit.to_i , 0].max :
    base_quantity_sold + Faker::Number.digit.to_i
end

def get_vendor_sale(vendor_item_id, quantity)
  {
    vendor_item_id: vendor_item_id.to_i,
    quantity: quantity.to_i
  }
end

NO_OF_VENDORS.times do
  Typhoeus.post(VENDORS_URL, body: {vendor: get_random_vendor})
end

NO_OF_ITEMS.times do
  Typhoeus.post(ITEMS_URL, body: {item: get_random_item})
end

# For NO_OF_ITEMS times do
# 1. Pick an item_id randomly from the ITEMS_ARRAY
# 2. Assign this item to 5 vendors randomly with a fixed price and
#    a small deviation unique to each vendor
ITEMS_ARRAY.each do |item_id|
  vendor_ids = VENDORS_ARRAY.shuffle.take(2)
  
  base_price = Faker::Commerce.price
  base_quantity_sold = Faker::Number.number(2).to_i
  is_first_vendor = true
  
  vendor_ids.each do |vendor_id|
    vendor_items_url = VENDORS_URL + vendor_id.to_s + "/vendor_items"
    vendor_sales_url = VENDORS_URL + vendor_id.to_s + "/vendor_sales"
    
    if is_first_vendor
      vendor_item = get_vendor_item(base_price, item_id, false)
      quantity_sold = base_quantity_sold
      is_first_vendor = false
    else
      vendor_item = get_vendor_item(base_price, item_id)
      quantity_sold = get_actual_quantity_sold(base_quantity_sold, vendor_item[:price_increased])
    end
    
    response = Typhoeus.post(vendor_items_url, body: {vendor_item: vendor_item})
    vendor_item_id = JSON.parse(response.options[:response_body])["id"].to_i
    Typhoeus.post(vendor_sales_url, body: {vendor_sale: get_vendor_sale(vendor_item_id, quantity_sold), vendor_id: vendor_id})
  end
end
