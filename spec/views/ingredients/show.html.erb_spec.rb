require 'rails_helper'

RSpec.describe "ingredients/show", type: :view do
  before(:each) do
    @ingredient = Ingredient.create name:'lettuce'
  end

  it "renders attributes in <h2>" do
    render
    expect(rendered).to match('lettuce')
  end
end
