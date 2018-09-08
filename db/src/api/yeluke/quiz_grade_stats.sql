
CREATE OR REPLACE VIEW quiz_grade_stats AS
    SELECT
        quiz_id,
        COUNT(user_id), -- Best to not use * here, using user_id instead
        avg(points) AS average,
        min(points),
        max(points),
        -- points_possible should be the same for all quiz_grade per quiz_id
        max(points_possible) AS points_possible,        
        stddev_pop(points) AS stddev,
        array_agg(points ORDER BY points) AS grades
    FROM
        data.quiz_grade
        JOIN data.user
            ON user_id=data.user.id
    WHERE role='student'
    GROUP BY quiz_id;


COMMENT ON VIEW quiz_grade_stats IS
    'Statics on the grades received by students for each quiz';
COMMENT ON COLUMN quiz_grade_stats.quiz_id IS
    'The slug for the quiz to which these statistics correspond';
COMMENT ON COLUMN quiz_grade_stats.count IS
    'The number of students with grades for this quiz';
COMMENT ON COLUMN quiz_grade_stats.average IS
    'The average grade among students for this quiz';
COMMENT ON COLUMN quiz_grade_stats.min IS
    'The minmum grade among students for this quiz';
COMMENT ON COLUMN quiz_grade_stats.max IS
    'The maximum grade among students for this quiz';
COMMENT ON COLUMN quiz_grade_stats.points_possible IS
    'The number of points possible for this quiz';
COMMENT ON COLUMN quiz_grade_stats.stddev IS
    'The standard deviation of student grades for this quiz';
COMMENT ON COLUMN quiz_grade_stats.grades IS
    'The grades received by students for this quiz in ascending order';


-- NOTICE We do *NOT* alter the owner to API because
-- we will not have an RLS for quiz_grade_stats. This is
-- because then users would not be able to see accurate
-- stats because the RLS would flow through to the quiz_grade
-- table.
-- alter view quiz_grade_stats owner to api;