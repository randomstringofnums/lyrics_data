-- Note: dedup only on artist_id, track_name pairs; so if similar track has multiple arists ids because some reflect that someone else was featured, keep
-- select all tracks where another track with same artist, and track name is included in other track name (e.g. 'Song', 'Song Remix')
CREATE TABLE duplicate_tracks(
	id INTEGER
  , track_name VARCHAR(255)
  , mxm_track_rating INTEGER
  , dup_id INTEGER
  , dup_track_name VARCHAR(255)
  , dup_mxm_track_rating INTEGER);

INSERT INTO duplicate_tracks
SELECT 
    t.id
  , t.track_name
  , t.mxm_track_rating
  , t2.id AS dup_id
  , t2.track_name AS dup_track_name
  , t2.mxm_track_rating AS dup_mxm_track_rating
FROM tracks t
JOIN tracks t2
  ON t.artist_id = t2.artist_id
 AND t.id <> t2.id
 AND t2.track_name like ('%' || t.track_name || '%');

-- insert all tracks with no dups (i.e, track name included in another, or track name includes another)
INSERT INTO deduped_tracks
SELECT
    NULL 
  , id AS track_id
FROM tracks
WHERE id NOT IN (SELECT dup_id FROM duplicate_tracks)
  AND id NOT IN (SELECT id FROM duplicate_tracks);

-- for tracks with dups, insert version with highest rating

INSERT INTO deduped_tracks
SELECT
     NULL AS id
   , COALESCE(
       MIN(dt_max.id) -- if dups with higher rating exists select dup with highest rating (or if multiple, pick with min track_id = arbitrary)
     , dt.dup_id -- else take track
   ) AS track_id
FROM
  (SELECT
      rowid AS row_id
    , id
    , track_name
    , mxm_track_rating
    , MAX(dup_mxm_track_rating) AS max_dup_mxm_track_rating -- max rating for master dup name and all other names
  FROM duplicate_tracks
  WHERE id NOT IN (SELECT dup_id FROM duplicate_tracks)
  GROUP BY id) dt_max
  LEFT JOIN duplicate_tracks dt
  -- join all dup pairs for master dup where
    ON dt_max.id = dt.id
   AND dt_max.max_dup_mxm_track_rating = dt.dup_mxm_track_rating -- rating is highest dup rating
   AND dt_max.max_dup_mxm_track_rating > dt_max.mxm_track_rating -- AND rating is higher than master
GROUP BY dt_max.id;