require 'rails_helper'

feature 'メッセージ投稿', type: :feature do
  background do
    # 中間テーブルを作成して、usersテーブルとroomsテーブルのレコードを作成する
    @member = FactoryBot.create(:member)

    # サインインする
    sign_in(@member.user)

    # 作成されたチャットルームへ遷移する
    click_on(@member.room.name)
  end

  scenario 'テキストの投稿に成功すると、投稿一覧に遷移して、投稿した内容が表示されている' do
    # 値をテキストフォームに入力する
    post = "テストテスト"
    fill_in 'message_content', with: post

    # 送信した値がDBに保存されていることを期待する
    expect{
      find('input[name="commit"]').click
    }.to change { Message.count }.by(1)

    # 投稿一覧画面に遷移することを期待する
    expect(current_path).to eq room_messages_path(@member.room)

    # 送信した値がブラウザに表示されていることを期待する
    expect(page).to have_content(post)
  end
  scenario '画像の投稿に成功すると、投稿一覧に遷移して、投稿した画像が表示されている' do
    # 画像選択フォームに画像を添付する
    image_path = Rails.root.join('public/images/test_image.png')
    attach_file('message[image]', image_path)

    # 送信した値がDBに保存されていることを期待する
    expect{
      find('input[name="commit"]').click
    }.to change { Message.count }.by(1)

    # 投稿一覧画面に遷移することを期待する
    expect(current_path).to eq room_messages_path(@member.room)

    # 送信した画像がブラウザに表示されていることを期待する
    expect(page).to have_selector("img")
  end
  scenario 'テキストと画像の投稿に成功すること' do
    # 模擬的な値を画像選択フォームに入力する
    image_path = Rails.root.join('public/images/test_image.png')
    attach_file('message[image]', image_path)

    # 値をテキストフォームに入力する
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
    expect(current_path).to eq  room_messages_path(@member.room.id)
  end
end

