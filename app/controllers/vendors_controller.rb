class VendorsController < ApplicationController
  def create
    @vendor = Vendor.new(vendor_params)

    if @vendor.save
      render json: @vendor, status: :created
    else
      render json: @vendor.errors, status: :unprocessable_entity
    end
  end
  
  private
    def vendor_params
      params.require(:vendor).permit(:name, :country, :city, :zipcode)
    end
end
