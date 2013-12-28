class CreateAltBrandNames < ActiveRecord::Migration
  def change
    create_table :alt_brand_names do |t|
      t.integer :brand_id
      t.string :name
    end
    
    add_index :alt_brand_names, :brand_id
  end
end
