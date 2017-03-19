require 'rails_helper'

describe "Recipes page" do
  it "should not have any before been created" do
    visit recipes_path

    expect(page).to have_content 'Recipes'
    expect(page).not_to have_content 'Instruction'
  end
end