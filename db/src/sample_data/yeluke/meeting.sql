
-- This file is generated by the DataFiller free software.
-- This software comes without any warranty whatsoever.
-- Use at your own risk. Beware, this script may destroy your data!
-- License is GPLv3, see http://www.gnu.org/copyleft/gpl.html
-- Get latest version from http://www.coelho.net/datafiller.html

-- Data generated by: /usr/local/bin/datafiller
-- Version 2.0.1-dev (r832 on 2015-11-01)
-- For postgresql on 2017-12-27T19:55:50.184175 (UTC)
-- 
-- fill table data.meeting (3)
\echo # filling table data.meeting (3)
COPY data.meeting (id,slug,summary,description,begins_at,duration,is_draft,created_at,updated_at) FROM STDIN (ENCODING 'utf-8', FREEZE ON);
1	intro	summary_2_2_2	description_1_	2017-12-27 14:54:50	80 minutes	FALSE	2017-12-27 14:54:50	2017-12-27 14:55:50
2	structuredquerylang	summary_1_1_1_1_	descripti	2017-12-27 14:54:50	80 minutes	TRUE	2017-12-27 14:55:50	2017-12-27 14:53:50
3	entrepreneurship-woot	summary_3_	description_1_	2017-12-27 14:55:50	80 minutes	FALSE	2017-12-27 14:53:50	2017-12-27 14:53:50
\.
-- 
-- restart sequences
ALTER SEQUENCE data.meeting_id_seq RESTART WITH 4;
-- 
-- analyze modified tables
ANALYZE data.meeting;
