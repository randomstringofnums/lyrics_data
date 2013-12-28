class CreateTracks < ActiveRecord::Migration
  def change
    create_table :tracks do |t|
      t.string :track_mbid
      t.string :track_name
      t.integer :mxm_track_rating
      t.integer :track_length
      t.integer :album_id
      t.string :album_name
      t.integer :artist_id
      t.string :artist_name
      t.string :photo_link
    end
    
    add_index :tracks, :artist_id
    add_index :tracks, :album_id    
  end
end
