# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)


# User.create!(first_name: "Het",last_name: "Joshi",username: "hetj1110" email: "hetj1110@gmail.com", password: "password", password_confirmation: "password",country: "India",gender:"male" date_of_birth:"11/10/2001",contact_number: "7046080557")AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

Article.create!(title: "Het Joshi",subject: "hetj1110 hetj1110@gmail.compasswordpasswordIndiacompasswordpasswordIndiacompasswordpasswordIndiacompasswordpasswordIndiacompasswordpasswordIndia", user_id: 13, status: "public")