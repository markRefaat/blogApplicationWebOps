class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.string :message
      t.belongs_to :post
      t.belongs_to :user
      t.timestamps
    end
  end
end
