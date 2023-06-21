class Attach < ApplicationRecord
  mount_uploader :path, AttachUploader

  belongs_to :user_note
  # belongs_to :card

  validates :path, presence: true
  validates :user_note_id, presence: true

  def new_attr
    {
      id:,
      file: path.url,
      uploader: user_note.user.username
    }
  end
end
