class CreateSupportRequests < ActiveRecord::Migration[8.0]
  def change
    create_enum :area_of_website, %w[whole_site specific_page]

    create_table :support_requests do |t|
      t.string :name
      t.string :email
      t.enum :area_of_website, enum_type: "area_of_website"
      t.string :area_of_website_url
      t.text :problem
      t.timestamps
    end
  end
end
