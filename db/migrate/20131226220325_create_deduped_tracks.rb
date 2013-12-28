class CreateDedupedTracks < ActiveRecord::Migration
  def change
    create_table :deduped_tracks do |t|
      t.integer :track_id
    end

    add_index :deduped_tracks, :track_id
  end
end
