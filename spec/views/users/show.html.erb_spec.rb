require 'rails_helper'

=begin
RSpec.describe "users/show", type: :view do
  before(:each) do
    @user = assign(:user, User.create!(
      :username => "Username",
      :password => "Password1"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to contain("Username")
  end
end
=end