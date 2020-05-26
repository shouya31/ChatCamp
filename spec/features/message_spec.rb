require 'rails_helper'

feature 'メッセージ投稿', type: :feature do
  background '必要なレコードの準備' do
    @user = FactoryBot.create(:user)
    @room = FactoryBot.create(:room)
    @member = FactoryBot.create(:member, user_id: @user.id, room_id: @room.id)
  end

  background 'ログインする' do
    visit root_path
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_on("Log in")
    expect(current_path).to eq root_path
    click_on(@room.name)
  end

  scenario 'テキストの投稿に成功すること' do
    # 模擬的な値をテキストフォームに入力する
    post = "テストテスト"
    fill_in 'message_content', with: post

    # 送信した値がDBに保存されていることを期待する
    expect{
      find('input[name="commit"]').click
    }.to change { Message.count }.by(1)

    # 送信した値がブラウザに表示されていることを期待する
    expect(page).to have_content(post)
  end
  scenario '画像の投稿に成功すること' do
    # 模擬的な値を画像選択フォームに入力する
    image_path = Rails.root.join('public/images/test_image.png')
    attach_file('message[image]', image_path)

    # 送信した値がDBに保存されていることを期待する
    expect{
      find('input[name="commit"]').click
    }.to change { Message.count }.by(1)

    # 送信した画像がブラウザに表示されていることを期待する
    expect(page).to have_selector("img")
  end
  scenario 'テキストと画像の投稿に成功すること' do
    # 模擬的な値を画像選択フォームに入力する
    image_path = Rails.root.join('public/images/test_image.png')
    attach_file('message[image]', image_path)

    # 模擬的な値をテキストフォームに入力する
    post = "テストテスト"
    fill_in 'message_content', with: post

    # 送信した値がDBに保存されていることを期待する
    expect{
      find('input[name="commit"]').click
    }.to change { Message.count }.by(1)

    # 送信した値がブラウザに表示されていることを期待する
    expect(page).to have_content(post)

    # 送信した画像がブラウザに表示されていることを期待する
    expect(page).to have_selector("img")
  end
  scenario '送る値が空の為、メッセージの送信に失敗すること' do
    # DBに保存されていないことを期待する
    expect{
      find('input[name="commit"]').click
    }.not_to change { Message.count }

    # モデルのカウントは変わらずに元のページに戻ってくる
    expect(current_path).to eq  room_messages_path(@room.id)
  end
  scenario 'チャットルームを削除すると、関連するメッセージが全て削除されていること' do
    # メッセージ情報を5つDBに追加する
    FactoryBot.create_list(:message, 5, room_id: @room.id, user_id: @user.id)

    # 「チャットを終了する」ボタンをクリックすることで、作成した5つのメッセージが削除されていることを期待する
    expect{
      find_link("チャットを終了する",  href: room_path(@room)).click
    }.to change { @room.messages.count }.by(-5)

    # ルートページに遷移されることを期待する
    expect(current_path).to eq root_path
  end
end

