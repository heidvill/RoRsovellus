=begin
require 'rails_helper'

RSpec.describe "categories/show", type: :view do
  before(:each) do
    @category = assign(:category, Category.create!(
      :name => "Name"
    ))
    user = FactoryGirl.create :user
    allow(view).to receive_messages(:current_user => user)
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
  end
end
=end