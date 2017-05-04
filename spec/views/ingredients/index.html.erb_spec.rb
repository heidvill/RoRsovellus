=begin
require 'rails_helper'

RSpec.describe "ingredients/index", type: :view do
  before(:each) do
    assign(:ingredients, [
      Ingredient.create!(:name => "MyString1"),
      Ingredient.create!(:name => "MyString2")
    ])
  end

  it "renders a list of ingredients" do
    render
    expect(rendered).to match(/MyString/)
  end
end
=end