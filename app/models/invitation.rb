class Invitation < ApplicationRecord
    belongs_to :team
    belongs_to :note
    belongs_to :user

    enum type: {
        personal: 0,
        team: 1
    }

    enum status: {
        confirm: 1,
        didnt_confirm: 0
    }

    validates :type, presence: true
    validates :link, presence: true
    validates :status, presence: true
    validates :user_id, presence: true

    def new_attr
        {
            type: self.type,
            link: self.link,
            status: self.status,
            user_id: self.user_id
        }
    end
end
