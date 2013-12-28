# top sectors
CREATE TABLE top_sectors (
	interbrand_sector VARCHAR(255)
  , ct INTEGER
);

INSERT INTO top_sectors
SELECT 
  b.interbrand_sector
, COUNT(*) AS ct
FROM brand_mentions bm
JOIN brands b
  ON bm.brand_id = b.id
JOIN tracks t
  ON bm.track_id = t.id
JOIN albums a
  ON a.id = t.album_id
JOIN deduped_tracks dt
  ON t.id = dt.track_id
WHERE t.mxm_track_rating > 31
GROUP BY b.interbrand_sector
ORDER BY ct DESC
LIMIT 10;

# top brands

CREATE TABLE top_brands (
	brand_id VARCHAR(255)
  , ct INTEGER
);

INSERT INTO top_brands
SELECT 
  b.id
, COUNT(*) AS ct
FROM brand_mentions bm
JOIN brands b
  ON bm.brand_id = b.id
JOIN tracks t
  ON bm.track_id = t.id
JOIN albums a
  ON a.id = t.album_id
JOIN deduped_tracks dt
  ON t.id = dt.track_id
WHERE t.mxm_track_rating > 31
GROUP BY b.name
ORDER BY ct DESC;

CREATE TABLE brand_rank (
	brand_id INTEGER
  , rank INTEGER
);
INSERT INTO brand_rank
SELECT 
  brand_id
, rowid
FROM top_brands;

# top artist
CREATE TABLE top_artists (
	artist_id INTEGER
  , ct INTEGER
);

INSERT INTO top_artists
SELECT 
  t.artist_id
, COUNT(*) AS ct
FROM brand_mentions bm
JOIN brands b
  ON bm.brand_id = b.id
JOIN tracks t
  ON bm.track_id = t.id
JOIN albums a
  ON a.id = t.album_id
JOIN deduped_tracks dt
  ON t.id = dt.track_id
WHERE t.mxm_track_rating > 31
GROUP BY t.artist_name
ORDER BY ct DESC;

CREATE TABLE artist_rank (
	artist_id INTEGER
  , rank INTEGER
);

INSERT INTO artist_rank
SELECT 
  artist_id
, rowid
FROM top_artists;

# final sql for csv
SELECT
	  b.name AS 'Brand Name'
	, b.interbrand_rank_2013 AS 'Interbrand Rank'
	, CASE
		WHEN b.interbrand_sector IN (SELECT interbrand_sector
									 FROM top_sectors)
			THEN b.interbrand_sector
		ELSE 'Other'
	  END AS 'Sector'
	, b.interbrand_country AS 'Country'
	, t.track_name AS 'Track'
	, t.artist_name AS 'Artist'
	, t.mxm_track_rating AS 'Track Rating'
	, ar.rank AS 'Artist Rank'
    , br.rank AS 'Brand Rank'
	, t.album_name AS 'Album'
	, strftime('%Y', a.album_release_date) AS 'Release Year' 
	, 1 AS 'Mentions'
FROM brand_mentions bm
JOIN brands b
  ON bm.brand_id = b.id
JOIN tracks t
  ON bm.track_id = t.id
JOIN albums a
  ON a.id = t.album_id
JOIN deduped_tracks dt
  ON t.id = dt.track_id
JOIN brand_rank br
  ON b.id = br.brand_id
JOIN artist_rank ar
  ON t.artist_id = ar.artist_id
WHERE t.mxm_track_rating > 31;