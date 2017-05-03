require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    assign(:users, [
        User.create!(
            :username => "Username",
            :password => "Password1"
        ),
        User.create!(
            :username => "Username2",
            :password => "Password1"
        )
    ])
  end

  it "renders a list of users" do
    render
    expect(rendered).to match(/Username/)
  end
end
