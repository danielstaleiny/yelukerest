

\ir ./yeluke/user.sql
\ir ./yeluke/meeting.sql
\ir ./yeluke/engagement.sql
\ir ./yeluke/team.sql
\ir ./yeluke/quiz.sql
\ir ./yeluke/quiz_submission.sql
\ir ./yeluke/quiz_question.sql
\ir ./yeluke/quiz_question_option.sql
\ir ./yeluke/quiz_answer.sql
\ir ./yeluke/ui_element.sql
\ir ./yeluke/assignment.sql
\ir ./yeluke/assignment_field.sql
\ir ./yeluke/assignment_submission.sql
\ir ./yeluke/assignment_field_submission.sql
\ir ./yeluke/quiz_grade.sql
\ir ./yeluke/assignment_grade.sql
\ir ./yeluke/quiz_grade_distributions.sql
\ir ./yeluke/assignment_grade_distributions.sql
\ir ./yeluke/assignment_grade_exception.sql
\ir ./yeluke/quiz_grade_exception.sql
\ir ./yeluke/user_secret.sql

-- Remove api's ability to execute functions in public schema.
ALTER DEFAULT PRIVILEGES FOR ROLE api REVOKE EXECUTE ON FUNCTIONS FROM PUBLIC;
