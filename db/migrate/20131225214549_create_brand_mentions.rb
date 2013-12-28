class CreateBrandMentions < ActiveRecord::Migration
  def change
    create_table :brand_mentions do |t|
      t.integer :brand_id
      t.integer :track_id
      t.integer :alt_brand_name_id
    end
    
    add_index :brand_mentions, :brand_id
    add_index :brand_mentions, :track_id 
  end
end
