Factory.define :user do |user|
  user.name                  "Matt Diebolt"
  user.email                 "mdiebolt@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.define :micropost do |micropost|
  micropost.content "Foo bar"
  micropost.association :user
end

Factory.define :user_with_microposts, :parent => :user do |user|
  user.after_create { |a| Factory(:micropost, :user => a) }
  user.after_create { |a| Factory(:micropost, :user => a) }
end

