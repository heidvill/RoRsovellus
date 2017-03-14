class CreateSubsections < ActiveRecord::Migration[5.0]
  def change
    create_table :subsections do |t|
      t.integer :recipe_id
      t.string :title

      t.timestamps
    end
  end
end
