require 'rails_helper'

RSpec.describe "チャットールームの削除機能", type: :system do
  before do
    @member = FactoryBot.create(:member)
  end

  it 'チャットルームを削除すると、関連するメッセージが全て削除されていること' do
    sign_in(@member.user)
    click_on @member.room.name
    
    # メッセージ情報を5つDBに追加する
    FactoryBot.create_list(:message, 5, room_id: @member.room.id, user_id: @member.user.id)

    # 「チャットを終了する」ボタンをクリックすることで、作成した5つのメッセージが削除されていることを期待する
    expect{
      find_link("チャットを終了する",  href: room_path(@member.room)).click
    }.to change { @member.room.messages.count }.by(-5)

    # ルートページに遷移されることを期待する
    expect(current_path).to eq root_path
  end
end

RSpec.describe "チャットールームの削除機能", type: :system do
  before do
    @member = FactoryBot.create(:member)
  end

  it 'チャットルームを削除すると、関連するメッセージが全て削除されていること' do
    sign_in(@member.user)
    click_on @member.room.name

    # メッセージ情報を5つDBに追加する
    FactoryBot.create_list(:message, 5, room_id: @member.room.id, user_id: @member.user.id)

    # 「チャットを終了する」ボタンをクリックすることで、作成した5つのメッセージが削除されていることを期待する
    expect{
      find_link("チャットを終了する",  href: room_path(@member.room)).click
    }.to change { @member.room.messages.count }.by(-5)

    # ルートページに遷移されることを期待する
    expect(current_path).to eq root_path
  end
end