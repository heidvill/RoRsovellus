require 'rails_helper'

RSpec.describe Category, type: :model do
  it "is saved with correct parametres" do
    category = Category.create name:"dessert"

    expect(category).to be_valid
    expect(Category.count).to eq 1
  end

  it "is not saved with too short name" do
    category = Category.create name:"de"

    expect(category).not_to be_valid
  end
end
