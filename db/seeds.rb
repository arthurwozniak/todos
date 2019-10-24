# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create! name: 'Applifter', email: 'info@applifting.cz', access_token: "93f39e2f-80de-4033-99ee-249d92736a25"
User.create! name: 'Batman', email: 'batman@applifting.cz', access_token: "dcb20f8a-5657-4f1b-9f7f-ce65739b359e"