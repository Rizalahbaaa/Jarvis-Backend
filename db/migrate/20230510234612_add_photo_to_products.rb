class AddPhotoToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :photo_product, :text
  end
end
