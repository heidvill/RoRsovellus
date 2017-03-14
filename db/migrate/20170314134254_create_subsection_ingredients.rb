class CreateSubsectionIngredients < ActiveRecord::Migration[5.0]
  def change
    create_table :subsection_ingredients do |t|
      t.integer :ingredient_id
      t.integer :subsection_id
      t.float :amount
      t.string :unit

      t.timestamps
    end
  end
end
