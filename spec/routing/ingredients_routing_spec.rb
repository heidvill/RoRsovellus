require "rails_helper"

RSpec.describe IngredientsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/ingredients").to route_to("ingredients#index")
    end

    it "routes to #show" do
      expect(:get => "/ingredients/1").to route_to("ingredients#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/ingredients/1/edit").to route_to("ingredients#edit", :id => "1")
    end

    it "routes to #update via PUT" do
      expect(:put => "/ingredients/1").to route_to("ingredients#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/ingredients/1").to route_to("ingredients#update", :id => "1")
    end

  end
end
