class AddCustomAttrsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :username, :string
    add_column :users, :contact_number, :string
    add_column :users, :address, :string
    add_column :users, :country, :string
    add_column :users, :state, :string
    add_column :users, :city, :string
    add_column :users, :date_of_birth, :date
    add_column :users, :gender, :string, default: "select"
  end
end
