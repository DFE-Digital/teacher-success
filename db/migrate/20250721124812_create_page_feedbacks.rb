class CreatePageFeedbacks < ActiveRecord::Migration[8.0]
  def change
    create_table :page_feedbacks do |t|
      t.boolean :useful
      t.text :feedback
      t.string :url

      t.timestamps
    end
  end
end
