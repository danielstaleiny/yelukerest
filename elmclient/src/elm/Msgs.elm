module Msgs exposing (Msg(..), SSEMsg(..))

import Assignments.Model
    exposing
        ( Assignment
        , AssignmentFieldSubmission
        , AssignmentGrade
        , AssignmentGradeDistribution
        , AssignmentSlug
        , AssignmentSubmission
        )
import Auth.Model exposing (CurrentUser)
import Engagements.Model exposing (Engagement)
import Meetings.Model exposing (Meeting)
import Quizzes.Model
    exposing
        ( Quiz
        , QuizAnswer
        , QuizGrade
        , QuizGradeDistribution
        , QuizQuestion
        , QuizSubmission
        )
import RemoteData exposing (WebData)
import Time exposing (Posix)
import Url exposing (Url)
import Users.Model exposing (User)


type SSEMsg
    = Noop
    | SSETableChange (Result String String)


type Msg
    = OnFetchMeetings (WebData (List Meeting))
    | OnFetchAssignments (WebData (List Assignment))
    | OnFetchAssignmentGrades (WebData (List AssignmentGrade))
    | OnFetchAssignmentGradeDistributions (WebData (List AssignmentGradeDistribution))
    | OnBeginAssignment AssignmentSlug
    | OnFetchAssignmentSubmissions (WebData (List AssignmentSubmission))
    | OnBeginAssignmentComplete AssignmentSlug (WebData AssignmentSubmission)
    | OnFetchCurrentUser (WebData CurrentUser)
    | OnFetchQuizzes (WebData (List Quiz))
    | OnFetchQuizGrades (WebData (List QuizGrade))
    | OnFetchQuizGradeDistributions (WebData (List QuizGradeDistribution))
    | OnFetchQuizSubmissions (WebData (List QuizSubmission))
    | OnLocationChange Url
    | Tick Posix
    | OnSubmitAssignmentFieldSubmissions Assignment
    | OnSubmitAssignmentFieldSubmissionsResponse AssignmentSlug (WebData (List AssignmentFieldSubmission))
    | OnUpdateAssignmentFieldSubmissionInput Int String
    | OnBeginQuiz Int
    | OnBeginQuizComplete Int (WebData (List QuizSubmission))
    | OnFetchQuizQuestions Int (WebData (List QuizQuestion))
    | TakeQuiz Int
    | OnFetchQuizAnswers Int (WebData (List QuizAnswer))
    | OnSubmitQuizAnswers Int (List Int)
    | OnSubmitQuizAnswersComplete Int (WebData (List QuizAnswer))
    | OnToggleQuizQuestionOption Int Bool
    | OnSSE SSEMsg
    | OnFetchEngagements (WebData (List Engagement))
    | OnFetchUsers (WebData (List User))
    | OnChangeEngagement Int Int String
    | OnSubmitEngagementResponse Int Int (WebData Engagement)
