Factory.define :user do |user|
	user.name						"Example User"
	user.email						"foo@bar.com"
	user.password					"password"
	user.password_confirmation		"password"
end

Factory.sequence :email do |n|
	"person-#{n}@example.com"
end

Factory.define :micropost do |micropost|
	micropost.content "Foo Bar"
	micropost.association :user
end
