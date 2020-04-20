class Message < ApplicationRecord
  belongs_to :room
  belongs_to :user
  has_one_attached :image
  # validates :content, presence: true, unless: :image_upload

  def image_upload
    return self.image.variant(resize: '500x500')
  end
end
