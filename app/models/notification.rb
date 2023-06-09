class Notification < ApplicationRecord
    belongs_to :user

    validates :title, presence: true, length: { maximum: 100}
    validates :body, presence: true, length: { maximum: 100}
    validates :user_id, presence: true
    validates :read, presence: false

    enum notif_type: {
      client: 0,
      system: 1
    }

    def recipient
        Notification.find_by(id: self.id)&.user&.username
    end

    def sender
        User.find_by(id: self.sender_id)
    end
    

    def new_attr
        {
            title: self.title,
            body: self.body,
            recipient: recipient,
            read:self.read,
            sender: sender&.username,
            photo: sender&.photo&.url,
            sender_place: self.sender_place,
            created: created_at
        }
    end
end
