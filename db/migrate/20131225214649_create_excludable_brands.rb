class CreateExcludableBrands < ActiveRecord::Migration
  def change
    create_table :excludable_brands do |t|
      t.integer :brand_id
      t.integer :score
    end
    
    add_index :excludable_brands, :brand_id
  end
end
