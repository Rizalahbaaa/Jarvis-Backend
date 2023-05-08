class Note < ApplicationRecord
  has_many :user_note
  has_many :users, through: :user_note, source: :user, dependent: :destroy
  has_many :notification

  belongs_to :column, optional: true
  belongs_to :ringtone

  attr_accessor :reminder
  validates :subject, presence: {message: "can't be blank"}, length: { maximum: 30}
  validates :description, presence: {message: "can't be blank"}, length: { maximum: 100}
  validates :event_date, comparison: { greater_than: Time.now }
  validates :ringtone_id, presence: {message: 'ringtone must be assigned'}
  validates :column_id, presence: false

  accepts_nested_attributes_for :user_note

  validates :reminder, presence: true, comparison: { greater_than: Time.now, less_than: :event_date }

  scope :join_usernote, -> { joins(:user_note) }
  scope :notefunc, -> (note_id) { join_usernote.where(user_note: { note_id: note_id })}
  scope :owners?, -> (user_id){ join_usernote.where(user_note: { role: 'owner', user_id: user_id }).limit(1).present?}
  scope :ownersfilter, -> (user_id){ join_usernote.where(user_note: { role: 'owner', user_id: user_id })}

  enum note_type: {
    personal: 0,
    collaboration: 1,
    team: 2
  }

  enum status: {
    in_progress: 0,
    completed: 1
  }

  def new_attr
    {
      id:,
      subject:,
      description:,
      event_date:,
      reminder:,
      ringtone: ringtone.name,
      reminder: user_note.map{ |user_note| user_note.reminder},
      column: self.column&.title,
      note_type:,
      status:,
      member: users.map { |user| user.username }
    }
  end


end
