# class ItemsController < ApplicationController
#   def initialize
#     @items_service = ItemsService.new
#   end    

#   def ListAll
#     render json?@items_service.ListAll
#   end
# end
  
class ItemsController < ApplicationController
  before_action :set_item, only: [:show]

  def index
    @items = Item.all
    render json: @items
  end

  def show
    render json: @item
  end

  def create
    @item = Item.new(item_params)

    if @item.save
      render json: @item, status: :created
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :description)
  end
end
