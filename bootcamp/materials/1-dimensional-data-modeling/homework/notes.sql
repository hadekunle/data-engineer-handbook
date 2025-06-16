--  Select * from player_seasons;

-- Create type scoring_class as ENUM('star', 'good', 'average', 'bad');

-- Create Type season_stats as (
-- 	season INTEGER,
-- 	gp INTEGER,
-- 	pts REAL,
-- 	reb REAL,
-- 	ast REAL
-- )
-- Create Table players 
-- (
--  player_name TEXT,
--  height TEXT,
--  College TEXT,
--  country TEXT,
--  draft_year TEXT,
--  draft_round TEXT,
--  draft_number TEXT,
--  season_stats season_stats[],
--  current_season INTEGER,
--  scoring_class scoring_class,
--  years_since_last_season INTEGER,
--  PRIMARY KEY (player_name, current_season)
-- )

--Select MIN(season) from player_seasons;
-- -- DROP TABLE players;
-- INSERT INTO players

-- WITH yesterday AS (
-- select * from players 
-- where current_season = 2000

-- ), 
-- today as (
--  select * from player_seasons
--  where season = 2001
-- )
-- select 
-- 	COALESCE(t.player_name, y.player_name) as player_name,
-- 	COALESCE(t.height, y.height) as height,
-- 	COALESCE(t.College, y.College) as College,
-- 	COALESCE(t.country, y.country) as country,
-- 	COALESCE(t.draft_year, y.draft_year) as draft_year,
-- 	COALESCE(t.draft_round, y.draft_round) as draft_round,
-- 	COALESCE(t.draft_number, y.draft_number) as draft_number,

-- 	CASE when y.season_stats is NULL
-- 		then ARRAY[ROW(
-- 				t.season,
-- 				t.gp,
-- 				t.pts,
-- 				t.reb,
-- 				t.ast
-- 		):: season_stats]
-- 	WHEN t.season is NOT NULL THEN  y.season_stats || ARRAY[ROW(
-- 			t.season,
-- 			t.gp,
-- 			t.pts,
-- 			t.reb,
-- 			t.ast
-- 		)::season_stats]
-- 	ELSE y.season_stats
-- 	END as season_stats,
-- 	case 
-- 		when t.season is not null then 
-- 			case when t.pts > 20 then 'star'
-- 				when t.pts > 15 then 'good'
-- 				when t.pts > 10 then 'average'
-- 				else 'bad'
-- 		end ::scoring_class
-- 		else y.scoring_class
-- 		end as scoring_class,
-- 		case when t.season is not null then 0 
-- 			else y.years_since_last_season + 1
-- 		end as years_since_last_season,
-- 			COALESCE(t.season, y.current_season+1) as current_season
	
-- 	from today t full outer join yesterday y
-- 		on t.player_name = y.player_name;



WITH yesterday AS (
    SELECT * FROM players 
    WHERE current_season = 2000
), 
today AS (
    SELECT * FROM player_seasons
    WHERE season = 2001
)

INSERT INTO players (
    player_name,
    height,
    college,
    country,
    draft_year,
    draft_round,
    draft_number,
    season_stats,
    scoring_class,
    years_since_last_season,
    current_season
)
SELECT 
    COALESCE(t.player_name, y.player_name) AS player_name,
    COALESCE(t.height, y.height) AS height,
    COALESCE(t.college, y.college) AS college,
    COALESCE(t.country, y.country) AS country,
    COALESCE(t.draft_year, y.draft_year) AS draft_year,
    COALESCE(t.draft_round, y.draft_round) AS draft_round,
    COALESCE(t.draft_number, y.draft_number) AS draft_number,

    CASE 
        WHEN y.season_stats IS NULL THEN 
            ARRAY[
                ROW(
                    t.season, 
                    t.gp, 
                    t.pts, 
                    t.reb, 
                    t.ast
                )::season_stats
            ]
        WHEN t.season IS NOT NULL THEN 
            y.season_stats || ARRAY[
                ROW(
                    t.season, 
                    t.gp, 
                    t.pts, 
                    t.reb, 
                    t.ast
                )::season_stats
            ]
        ELSE 
            y.season_stats
    END AS season_stats,

    CASE 
        WHEN t.season IS NOT NULL THEN 
            CASE 
                WHEN t.pts > 20 THEN 'star'
                WHEN t.pts > 15 THEN 'good'
                WHEN t.pts > 10 THEN 'average'
                ELSE 'bad'
            END::scoring_class
        ELSE 
            y.scoring_class
    END AS scoring_class,

    CASE 
        WHEN t.season IS NOT NULL THEN 0
        ELSE y.years_since_last_season + 1
    END AS years_since_last_season,

    COALESCE(t.season, y.current_season + 1) AS current_season

FROM today t
FULL OUTER JOIN yesterday y ON t.player_name = y.player_name;




With unnested As (
 	select player_name
	 	unnest (season_stats) :: season_stats AS season_stats
	 From players
	 where current_season = 2000
	 and player_name = 'Avery Johnson'
)
select player_name,
	(season_stats::season_stats).*
--	(season_stats::season_stats).pts
	
from unnested

select player_name, 
UNNEST(season_stats) AS season_stats
from players
where current_season = 2000
and player_name = 'Avery Johnson';

Select * from players
Where current_season = 2000
and player_name = 'Avery Johnson';
Select * from players where current_season = 2000 ;


select * from players where current_season = 2001
and player_name LIKE '%Mich%l%Jordan%';

select player_name,
season_stats[1] AS first_season,
season_Stats[CARDINALITY(season_stats)] as latest_season
from players
where current_Season = 2001

select player_name,
	(season_stats[CARDINALITY(season_stats)]::season_stats).pts/
	case when (season_stats[1]::season_stats).pts = 0 then 1 else(season_stats[1]::season_stats).pts end
from players
where current_Season = 2001
and scoring_Class = 'star'
order by 2 desc