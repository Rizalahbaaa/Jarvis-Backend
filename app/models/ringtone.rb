class Ringtone < ApplicationRecord
  has_many :notes

  validates :name, presence: true, length: { maximum: 100 }
  validates :path, presence: true

  def new_attr
    {
      id:,
      name:,
      path:
    }
  end
end