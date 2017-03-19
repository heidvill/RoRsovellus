class ChangeColumnNameTimeInRecipe < ActiveRecord::Migration[5.0]
  def change
    rename_column :recipes, :time, :duration
  end
end
