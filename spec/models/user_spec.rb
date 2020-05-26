require 'rails_helper'

describe User do
  describe '#create' do
    # 1. nameとemail、passwordとpassword_confirmationが存在すれば登録できること
    before do
      @user = FactoryBot.build(:user)
    end
    it "is valid with a name, email, password, password_confirmation" do
      expect(@user).to be_valid
    end

    # 2. nameが空では登録できないこと
    it "is invalid without a name" do
      @user.name = nil
      @user.valid?
      expect(@user.errors[:name]).to include("を入力してください")
    end

    # 3. emailが空では登録できないこと
    it "is invalid without a email" do
      @user.email = nil
      @user.valid?
      expect(@user.errors[:email]).to include("を入力してください")
    end

    # 4. passwordが空では登録できないこと
    it "is invalid without a password" do
      @user.password = nil
      @user.valid?
      expect(@user.errors[:password]).to include("を入力してください")
    end

    # 5. passwordが存在してもpassword_confirmationが空では登録できないこと
    it "is invalid without a password_confirmation although with a password" do
      @user.password_confirmation = ""
      @user.valid?
      expect(@user.errors[:password_confirmation]).to include("とPasswordの入力が一致しません")
    end

    # 6. nameが7文字以上であれば登録できないこと
    it "is invalid with a name that has more than 7 characters " do
      @user.name = "aaaaaaa"
      @user.valid?
      expect(@user.errors[:name]).to include("は6文字以内で入力してください")
    end

    # 7. nameが6文字以下では登録できること
    it "is valid with a name that has less than 6 characters " do
      @user.name = "aaaaaa"
      expect(@user).to be_valid
    end

    # 8. 重複したemailが存在する場合登録できないこと
    it "is invalid with a duplicate email address" do
      @user.save
      another_user = FactoryBot.build(:user, email: @user.email)
      another_user.valid?
      expect(another_user.errors[:email]).to include("はすでに存在します")
    end

    # 9. passwordが6文字以上であれば登録できること
    it "is valid with a password that has more than 6 characters " do
      @user.password = "123456"
      @user.password_confirmation = "123456"
      @user.valid?
      expect(@user).to be_valid
    end

    # 10. passwordが5文字以下であれば登録できないこと
    it "is invalid with a password that has less than 5 characters " do
      @user.password = "12345"
      @user.password_confirmation = "12345"
      @user.valid?
      expect(@user.errors[:password]).to include("は6文字以上で入力してください")
    end
  end
end