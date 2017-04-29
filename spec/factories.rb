FactoryGirl.define do
  factory :user do
    username "jack"
    password "Word1"
    password_confirmation "Word1"
  end

  factory :user2, class: User do
    username "john"
    password "Word1"
    password_confirmation "Word1"
  end

  factory :recipe do
    name "Cake"
    description "Mix everything"
    amount 8
    duration 120
  end

  factory :recipe2, class: Recipe do
    name "Rice"
    description "Boil"
    amount 4
    duration 10
  end

  factory :ingredient do
    name "flour"
  end

  factory :subsection do
    title "cake"
  end

  factory :subsection_ingredient do
    amount 5
    unit "dl"
  end
end