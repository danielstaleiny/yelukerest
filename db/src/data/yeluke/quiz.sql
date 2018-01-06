
CREATE TABLE IF NOT EXISTS quiz (
    id SERIAL PRIMARY KEY,
    meeting_id INT REFERENCES meeting(id) ON DELETE CASCADE UNIQUE NOT NULL,
    -- Number of points possible on this quiz.
    points_possible smallint NOT NULL
        CHECK (points_possible >= 0),
    -- If this quiz is still being worked on by the faculty
    is_draft BOOLEAN NOT NULL DEFAULT true NOT NULL,
    -- The duration of time students have to finish
    -- a quiz once it is begun
    duration INTERVAL NOT NULL,
    -- The time after which students may take
    -- the quiz.
    open_at TIMESTAMP WITH TIME ZONE NOT NULL,
    -- The time after which students may not
    -- take the quiz
    closed_at TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE
        NOT NULL
        DEFAULT current_timestamp,
    updated_at  TIMESTAMP WITH TIME ZONE
        NOT NULL
        DEFAULT current_timestamp,
    CONSTRAINT updated_after_created CHECK (updated_at >= created_at),
    CONSTRAINT closed_after_open CHECK (closed_at > open_at)
);

CREATE OR REPLACE FUNCTION quiz_set_defaults() RETURNS trigger AS $$
BEGIN
  IF (NEW.closed_at IS NULL) THEN
    SELECT begins_at INTO NEW.closed_at
    FROM meeting
    WHERE id = NEW.meeting_id;
  END IF;
  NEW.updated_at = current_timestamp;
  RETURN NEW;
END; $$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS tg_quiz_default ON quiz;
CREATE TRIGGER tg_quiz_default
    BEFORE INSERT OR UPDATE
    ON quiz
    FOR EACH ROW
EXECUTE PROCEDURE quiz_set_defaults();