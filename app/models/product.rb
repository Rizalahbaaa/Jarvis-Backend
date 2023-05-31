class Product < ApplicationRecord
  mount_uploader :photo_product, ProductUploader

    has_many :transactions
    has_many :users, through: :transactions
    
    validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
    validates :terms, presence: true ,length: { maximum: 100 }
    validates :reward, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
    validates :price, presence: true, numericality: { greater_than: 0 }
    validates :photo_product, presence: false
    validates_presence_of :status

    enum status: { unredeemed: false, redeemed: true }
  
    def new_attr
      {
        id: self.id,
        name: self.name,
        reward: self.reward,
        terms: self.terms,
        price: self.price,
        photo_product: self.photo_product.url,
        status: self.status,
        notes_quantity:
      }
    end
end
