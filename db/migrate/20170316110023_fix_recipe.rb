class FixRecipe < ActiveRecord::Migration[5.0]
  def change
    remove_column :recipes, :ingredients, :text
    add_column :recipes, :amount, :integer
    add_column :recipes, :time, :integer
  end
end
