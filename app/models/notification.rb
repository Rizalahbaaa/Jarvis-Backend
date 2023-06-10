class Notification < ApplicationRecord
    include ActionView::Helpers::DateHelper

    belongs_to :user

    validates :title, presence: true, length: { maximum: 100}
    validates :body, presence: true, length: { maximum: 250}
    validates :user_id, presence: true
    validates :read, presence: false

    enum notif_type: {
      client: 0,
      system: 1,
      collab: 2,
      team: 3
    }

    def recipient
        Notification.find_by(id: self.id)&.user&.username
    end

    def sender
        User.find_by(id: self.sender_id)
    end

    def sending
        time_send = Time.now - created_at
        time_ago = distance_of_time_in_words(created_at, Time.now, locale: :id)
        
        {
          time_send: time_send,
          time_ago: time_ago
        }
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
            created: created_at,
            send: "#{sending[:time_ago]} yang lalu",
            notif_type: 
        }
    end

    def reminder_notif
      {
        title:, 
        body:,
        recipient:,
        sender_place:,
        created: created_at,
        notif_type: 
      }
    end
    
end
