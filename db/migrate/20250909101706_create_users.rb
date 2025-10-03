class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email_address, null: false, index: { unique: true }
      t.string :one_login_sign_in_uid, index: true
      t.datetime :last_signed_in_at
      t.string :trn
      t.date :date_of_birth

      t.timestamps
    end
  end
end
