class Ringtone < ApplicationRecord
  has_many :notes

  mount_uploader :path, RingtoneUploader

  validates :name, presence: true, length: { maximum: 50 }
  validates :path, presence: false

  def new_attr
    {
      id:,
      name:,
      path: self.path.url
    }
  end
end