require 'rails_helper'

feature 'チャットールームの削除機能', type: :feature do
  background do
    @member = FactoryBot.create(:member)
    sign_in(@member.user)
    click_on(@member.room.name)
  end

  scenario 'チャットルームを削除すると、関連するメッセージが全て削除されていること' do
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