class VendorItemsController < ApplicationController
  def create
    vendor_item = VendorItem.new(vendor_item_params)
    vendor_item.vendor_id = params[:vendor_id]

    if vendor_item.create_item
      render json: vendor_item, status: :created
    else
      render json: vendor_item.errors, status: :unprocessable_entity
    end
  end
  
  private
    def vendor_item_params
      params.require(:vendor_item).permit(:price, :item_id)
    end
end
