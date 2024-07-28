class User < ApplicationRecord
  has_many :items
  has_many :orders
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # ニックネームが必須
  validates :nickname, presence: true

  # 名前は全角（漢字、カナ、かな）で、名字と名前が必須。生年月日が必須
  VALID_NAME_REGEX = /\A[ぁ-んァ-ヶ一-龥々ー]+\z/
  VALID_KANA_NAME_REGEX = /\A[ァ-ヶー－]+\z/
  validates :last_name, :first_name, presence: true, format: { with: VALID_NAME_REGEX }
  validates :last_name_kana, :first_name_kana, presence: true, format: { with: VALID_KANA_NAME_REGEX }
  validates :birthdate, presence: true

  # パスワードは半角英数字混合
  VALID_PASSWORD_REGEX = /\A(?=.*?[a-z])(?=.*?\d)[a-z\d]+\z/i
  validates_format_of :password, with: VALID_PASSWORD_REGEX, message: 'は半角英字と数字の両方を含めて設定してください'

  
end
