class ItemsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]
  before_action :set_item, only: [:show, :edit, :update]
  before_action :check_item_owner, only: [:edit, :update]
  before_action :redirect_if_sold_out, only: [:edit, :update]

  def index
    @items = Item.all.order(created_at: :desc)
  end 

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to root_path, notice: '商品が正常に出品されました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def edit
  end

  def update
    if params[:item][:image].present?
      if @item.update(item_params)
        redirect_to @item, notice: '商品情報が更新されました。'
      else
        render :edit, status: :unprocessable_entity
      end
    else
      if @item.update(item_params.except(:image))
        redirect_to @item, notice: '商品情報が更新されました。'
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def check_item_owner
    redirect_to root_path, alert: '権限がありません。' unless @item.user == current_user
  end

  def redirect_if_sold_out
    redirect_to root_path, alert: '売却済み商品のため編集できません。' if @item.sold_out?
  end

  def item_params
    params.require(:item).permit(:name, :description, :category_id, :condition_id, :shipping_fee_id, :prefecture_id, :shipping_time_id, :price, :image).merge(user_id: current_user.id)
  end
  
end
