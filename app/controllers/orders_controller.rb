class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_item, only: [:index, :create]
  before_action :move_to_root_path, only: [:index, :create]

  def index
    @order_address = OrderAddress.new
    gon.public_key = ENV['PAYJP_PUBLIC_KEY']
  end

  def create
    @order_address = OrderAddress.new(order_params)
    logger.debug "Order params: #{order_params.inspect}" # デバッグ情報を追加

    if @order_address.valid?
      logger.debug "OrderAddress is valid" # デバッグ情報を追加
      pay_item
      if @order_address.save
        logger.debug "Order saved successfully" # デバッグ情報を追加
        redirect_to root_path
      else
        gon.public_key = ENV['PAYJP_PUBLIC_KEY']
        logger.error "Failed to save OrderAddress" # デバッグ情報を追加
        render :index
      end
    else
      gon.public_key = ENV['PAYJP_PUBLIC_KEY']
      logger.error "OrderAddress validation failed: #{@order_address.errors.full_messages}" # デバッグ情報を追加
      render :index
    end
  end

  private

  def order_params
    params.require(:order_address).permit(:postal_code, :prefecture_id, :city, :house_number, :building_name, :phone_number).merge(user_id: current_user.id, item_id: params[:item_id], token: params[:token])
  end

  def pay_item
    logger.debug "Starting payment process" # デバッグ情報を追加
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
    charge = Payjp::Charge.create(
      amount: @item.price,
      card: order_params[:token],
      currency: 'jpy'
    )
    logger.debug "Payment completed: #{charge.inspect}" # デバッグ情報を追加
  end

  def set_item
    @item = Item.find(params[:item_id])
    logger.debug "Item set: #{@item.inspect}" # デバッグ情報を追加
  end

  def move_to_root_path
    if current_user.id == @item.user_id || @item.order.present?
      logger.debug "Redirecting to root path due to unauthorized access or sold item" # デバッグ情報を追加
      redirect_to root_path
    end
  end
end
