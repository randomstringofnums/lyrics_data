/*
purpose: exclude brands whose names have common homographs or parsing issues

score (based on initial analysis of api requests for brand names)
3 - lyrics usually refer to homograph of brand name or do not include brand name
2 - lyrics often refer to homograph of brand name 
1 - lyrics sometimes refer to homograph of brand name
*/

INSERT INTO excludable_brands (id, brand_id, score)
  VALUES
      (1, 1, 3) -- Apple
    , (2, 5, 2) -- Intel
    , (3, 7, 3) -- Cisco
    , (4, 8, 3) -- HP
    , (5, 10, 3) -- Amazon
	, (6, 11, 3) -- H&M exclude due to string parsing
	, (7, 13, 3) -- SAP
	, (8, 14, 3) -- UPS
	, (9, 15, 3) -- Pampers
	, (10, 18, 3) -- Canon
	, (11, 37, 3) -- Shell
	, (12, 38, 3) -- Tiffany & Co. exclude due to string parsing
	, (13, 53, 3) -- GE
	, (14, 71, 3) -- Ford
	, (15, 88, 3) -- 3M
	, (16, 100, 3) -- Gap
	, (17, 59, 3) -- Oracle
	, (18, 79, 3) -- Caterpillar
	, (19, 41, 3) -- Johnson & Johnson, string parsing
	, (20, 85, 3) -- Discovery, string parsing
	, (21, 87, 1) -- Visa
	, (22, 68, 3)
	; 