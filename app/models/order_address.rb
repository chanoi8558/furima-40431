class OrderAddress
  include ActiveModel::Model
  attr_accessor :postal_code, :prefecture_id, :city, :house_number, :building_name, :phone_number, :user_id, :item_id, :token

  with_options presence: true do
    validates :postal_code, format: { with: /\A\d{3}-\d{4}\z/, message: 'is invalid. Include hyphen(-)' }
    validates :prefecture_id, numericality: { other_than: 1, message: 'must be other than 1' }
    validates :city
    validates :house_number
    validates :phone_number, format: { with: /\A\d{10,11}\z/, message: 'is invalid' }
    validates :user_id
    validates :item_id
    validates :token
  end

  def save
    ActiveRecord::Base.transaction do
      order = Order.create!(user_id: user_id, item_id: item_id)
      Rails.logger.debug "Order created: #{order.inspect}" # デバッグ情報を追加

      Address.create!(
        postal_code: postal_code,
        prefecture_id: prefecture_id,
        city: city,
        house_number: house_number,
        building_name: building_name,
        phone_number: phone_number,
        order_id: order.id
      )
      Rails.logger.debug "Address created for order: #{order.id}" # デバッグ情報を追加
    end
  rescue => e
    Rails.logger.error "Failed to save OrderAddress: #{e.message}" # エラーハンドリング
    return false
  end
  true
end

