class FixIngredient < ActiveRecord::Migration[5.0]
  def change
    remove_column :ingredients, :amount, :float
    remove_column :ingredients, :unit, :string
  end
end
