# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'
# seeded the data base with 10000 user accounts to simulate the production level of load
# 10000.times do
#     is_verified = Random.new.rand(0...50)
#     spawned_user = User.create(email: Faker::Internet.safe_email, first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, username: Faker::Internet.username(specifier: 1..20), is_verified: is_verified == 1 ? true : false, password: Faker::Internet.password(min_length: 8), birth_date: Faker::Date.birthday(min_age: 13, max_age: 30))
# end
# 50000.times do
#     spawned_post = Post.create(user_id: Faker::Number.between(from: 1, to: 7_238), view_count: Faker::Number.within(range: 0...7_238), original_post_id: Random.new.rand(0..3) == 3 ? Faker::Number.within(range: 1...50000) : nil, caption: Faker::Lorem.sentence)
# end
5000.times do 
    spawned_comment = Comment.create(user_id: Faker::Number.between(from: 1, to: 800), body: Faker::Lorem.sentence, post_id: Faker::Number.within(range: 5...25), original_comment_id: Random.new.rand(0..3) == 3 ? Faker::Number.within(range: 1...300) : nil)
end
# 5_000.times do 
#     num = Random.new.rand(1..2)
#     likeable_type = nil
#     case num
#     when 1
#         likeable_type = "Post"
#     when 2
#         likeable_type = "Comment"
#     end
#     Like.create likeable_type: "Post", likeable_id: Faker::Number.between(from: 1, to: 25), user_id: Faker::Number.between(from: 1, to: 1_000)
# end
# 10_000.times do 
#     Tag.create(post_id: Faker::Number.between(from: 1, to: 51_018), text: Faker::Lorem.word)
# end
# Post.all.find_each do |post|
#     posts_media_url = url_for(post.post_image) if post.post_image.attached?
#     post.update(posts_media_url: posts_media_url)
# end
# User.all.find_each do |user|
#     puts user.follower_users.count
#     puts user.followed_users.count
#     followers = user.followed_users.count
#     following = user.follower_users.count
#     user.update(following_count: followers, follower_users: following)
# end
    # user.following_count = user.followed_users.count
    # user.followers_count = user.follower_users.count
    # puts user.save
#there are 7,238 seeded users 
#there are 100,000 seeded comments with the first 100 posts having a dispropotionate ammount of comments at 50,000. This disproportionality models how social networks handle the traffic with more engaging posts.
#there are 100,000 likes with the first 100 comments or posts having the majority of likes at 50_000 likes
#there are 10_000 relationships with users with the first ten users having a disproportionate amount of the followers at 5000
#user with id 2 is following 10000 other users. This simulates when a user is following alot of other users.
