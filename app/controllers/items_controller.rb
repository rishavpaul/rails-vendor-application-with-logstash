class ItemsController < ApplicationController
  def create
    @item = Item.new(item_params)

    if @item.save
      render json: @item, status: :created
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end
  
  private
    def item_params
      params.require(:item).permit(:name, :category)
    end
end
