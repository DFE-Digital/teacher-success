class CreateFeedbacks < ActiveRecord::Migration[8.0]
  def change
    create_table :feedbacks do |t|
      t.integer :rating
      t.string :url
      t.text :description
      t.string :email
      t.integer :topic
      t.boolean :can_contact

      t.timestamps
    end
  end
end
