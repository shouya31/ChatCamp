require 'rails_helper'

RSpec.describe "ユーザーログイン機能", type: :system do
  before do
    # 予め、ユーザーをDBに保存する
    @user = FactoryBot.create(:user)
  end

  it 'ログインしていないと、強制的にログインページへ遷移する' do
    # トップページに遷移させる
    visit root_path

    # ログインしていない場合、サインインページに遷移する
    expect(current_path).to eq new_user_session_path
  end

  it 'ログインに成功し、ルートパスに遷移する' do
    # ログインページへ移動する
    visit  new_user_session_path

    # すでに保存されているユーザーのnameとemailを入力する
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password

    # ログインボタンをクリックする
    click_on "Log in"

    # ルートページに遷移することを期待する
    expect(current_path).to eq root_path
  end
  it 'ログインに失敗し、再びサログインページに戻ってくる' do
    # ログインページへ移動する
    visit  new_user_session_path

    # 誤ったユーザー情報を入力する
    fill_in 'user_email', with: "test"
    fill_in 'user_password', with: "example@test.com"

    # ログインボタンをクリックする
    click_on "Log in"

    # ログインページに遷移していることを期待する
    expect(current_path).to eq  new_user_session_path
  end
end