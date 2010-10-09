require 'spec_helper'

describe "FriendlyForwardings" do
	it "should forward to the requested page after signin" do
		user = Factory(:user)
		visit edit_user_path(user)
		# This test will automatically follow the redirect to the signin page.
		fill_in :email,			:with => user.email
		fill_in :password,		:with => user.password
		click_button
		# Should follow the redirect again, this time to users/show.
		response.should render_template('users/show')
	end
end
