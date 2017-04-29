require 'rails_helper'

include Helpers

describe "Users page" do

  it "should not have any before been created" do
    visit users_path

    expect(page).to have_content 'Users'
    expect(page).not_to have_content 'jack'
  end

  describe "when users exists" do
    before :each do
      r1 = FactoryGirl.create(:user)
      r2 = FactoryGirl.create(:user2)

      visit users_path
    end

    it "has two users" do
      expect(page).to have_content "jack"
      expect(page).to have_content "john"
    end

    it "allows user to navigate to page of a user" do
      click_link "john"

      expect(page).to have_content "john"
      expect(page).not_to have_content "jack"
    end
  end
end

describe "User" do
  before :each do
    FactoryGirl.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: "jack", password: "Word1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'jack'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username: "jack", password: "wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end

    it "is deleted from db after signin and delete" do
      sign_in(username: "jack", password: "Word1")

      click_link "Destroy"

      expect(User.count).to eq(0)
    end
  end

  it "when signed up with good credentials, is added to the system" do
    visit signup_path
    fill_in('user_username', with: 'Brian')
    fill_in('user_password', with: 'Secret55')
    fill_in('user_password_confirmation', with: 'Secret55')

    expect {
      click_button('Create User')
    }.to change { User.count }.by(1)
  end

  it "is recirected back to signup form if wrong credientals given" do
    visit signup_path
    fill_in('user_username', with: 'Brian')
    fill_in('user_password', with: 'Secret')
    fill_in('user_password_confirmation', with: 'Secret')

    expect {
      click_button('Create User')
    }.to change { User.count }.by(0)
  end
end

describe "User page" do
  let!(:user) { FactoryGirl.create :user }
  let!(:recipe) { FactoryGirl.create :recipe }
  let!(:recipe2) { FactoryGirl.create :recipe2 }

  it "should not have any recipes before been created" do
    visit user_path(user)
    expect(page).to have_content %q[You don't have any recipes]
  end

  it "lists recipes correctly" do
    user.recipes << recipe
    user.recipes << recipe2

    visit user_path(user)

    expect(page).to have_content "Cake"
    expect(page).to have_content "Rice"
  end

  it "deletes users's recipe from db" do
    user.recipes << recipe
    user.recipes << recipe2
    sign_in(username: "jack", password: "Word1")

    visit user_path(user)
    page.find('li', :text => 'Rice').click_link('delete')

    expect(page).to have_content "Cake"
    expect(page).not_to have_content "Rice"
  end

  it "is signed out" do
    sign_in(username: "jack", password: "Word1")

    click_link('signout')

    expect(page).to have_content("Recipes")
    expect(page).not_to have_content("jack")
  end

  it "shows edit page if invalid new password" do
    sign_in(username: "jack", password: "Word1")

    visit edit_user_path(user)

    fill_in('user_password', with: 'jack')
    fill_in('user_password_confirmation', with: 'jack')

    click_button "Update User"

    expect(page).to have_content "Change password"
  end

  it "changes password with valid new password" do
    sign_in(username: "jack", password: "Word1")

    visit edit_user_path(user)

    fill_in('user_password', with: 'Jack1')
    fill_in('user_password_confirmation', with: 'Jack1')

    click_button "Update User"

    expect(page).to have_content "successfully"
  end
end