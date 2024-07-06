require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録' do
    context '新規登録できるとき' do
      it '全ての項目が正しく入力されていれば登録できる' do
        expect(@user).to be_valid
      end
    end

    context '新規登録できないとき' do
      it 'ニックネームが空では登録できない' do
        @user.nickname = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Nickname can't be blank")
      end

      it 'メールアドレスが空では登録できない' do
        @user.email = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Email can't be blank")
      end

      it '重複したメールアドレスが存在する場合登録できない' do
        @user.save
        another_user = FactoryBot.build(:user)
        another_user.email = @user.email
        another_user.valid?
        expect(another_user.errors.full_messages).to include("Email has already been taken")
      end

      it 'メールアドレスは@を含まないと登録できない' do
        @user.email = 'test.test.com'
        @user.valid?
        expect(@user.errors.full_messages).to include("Email is invalid")
      end

      it 'パスワードが空では登録できない' do
        @user.password = ''
        @user.valid?
        expect(@user.errors.full_messages).to include("Password can't be blank")
      end

      it 'パスワードが6文字未満では登録できない' do
        @user.password = 'a1b2c'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password is too short (minimum is 6 characters)")
      end

      it 'パスワードが半角英数字混合でなければ登録できない' do
        @user.password = 'abcdef'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password は半角英字と数字の両方を含めて設定してください")
      end

      it 'パスワードとパスワード（確認）が一致しなければ登録できない' do
        @user.password_confirmation = 'different'
        @user.valid?
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
      end

      it '名字が空では登録できない' do
          @user.last_name = ''
          @user.valid?
          expect(@user.errors.full_messages).to include("Last name can't be blank")
      end

      it '名前が空では登録できない' do
          @user.first_name = ''
          @user.valid?
          expect(@user.errors.full_messages).to include("First name can't be blank")
      end
  
      it '名字が全角（漢字・ひらがな・カタカナ）でなければ登録できない' do
          @user.last_name = 'yamada'
          @user.valid?
          expect(@user.errors.full_messages).to include("Last name is invalid")
      end
  
      it '名前が全角（漢字・ひらがな・カタカナ）でなければ登録できない' do
          @user.first_name = 'taro'
          @user.valid?
          expect(@user.errors.full_messages).to include("First name is invalid")
      end
  
      it '名字のカナが空では登録できない' do
          @user.last_name_kana = ''
          @user.valid?
          expect(@user.errors.full_messages).to include("Last name kana can't be blank")
      end
  
      it '名前のカナが空では登録できない' do
          @user.first_name_kana = ''
          @user.valid?
          expect(@user.errors.full_messages).to include("First name kana can't be blank")
      end
  
      it '名字のカナが全角（カタカナ）でなければ登録できない' do
          @user.last_name_kana = 'やまだ'
          @user.valid?
          expect(@user.errors.full_messages).to include("Last name kana is invalid")
      end
  
      it '名前のカナが全角（カタカナ）でなければ登録できない' do
          @user.first_name_kana = 'たろう'
          @user.valid?
          expect(@user.errors.full_messages).to include("First name kana is invalid")
      end
  
      it '生年月日が空では登録できない' do
          @user.birthdate = ''
          @user.valid?
          expect(@user.errors.full_messages).to include("Birthdate can't be blank")
      end
    end
  end
end