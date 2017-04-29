require 'rails_helper'

RSpec.describe User, type: :model do
  it "is saved with correct parameters" do
    user = FactoryGirl.create(:user)
    expect(user).to be_valid
  end

  it "is not saved with invalid password" do
    user = User.create username: "john", password: "john"
    expect(user).not_to be_valid
  end
end
