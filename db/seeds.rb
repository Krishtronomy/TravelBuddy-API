# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


if User.count == 0
    User.create(username:"test", email: "test@test.com", password: "test", password_confirmation: "test")
    User.create(username:"test2", email: "test2@test.com", password: "test2", password_confirmation: "test2")
    User.create(username:"test3", email: "test3@test.com", password: "test3", password_confirmation: "test3")
    puts"Users successfully created"
end


if Post.count == 0 
    
    Post.create(title: "my first post", description: "This is my first post, thanks for coming", rating: 5, user_id: 1)
    Post.create(title: "2nd post", description: "This is my 2nd post", rating: 3, user_id: 2)
    Post.create(title: "Hey there", description: "Awesome stuff", rating: 5, user_id: 3)
    Post.create(title: "Tasmania", description: "Great place", rating: 5, user_id: 1)
    puts"Posts successfully created"
end