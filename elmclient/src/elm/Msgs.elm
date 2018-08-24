module Msgs exposing (Msg(..), SSEMsg(..))

import Assignments.Model exposing (Assignment, AssignmentFieldSubmission, AssignmentSlug, AssignmentSubmission)
import Auth.Model exposing (CurrentUser)
import Engagements.Model exposing (Engagement)
import Meetings.Model exposing (Meeting)
import Navigation exposing (Location)
import Quizzes.Model exposing (Quiz, QuizAnswer, QuizQuestion, QuizSubmission)
import RemoteData exposing (WebData)
import Time exposing (Time)
import Users.Model exposing (User)


type SSEMsg
    = Noop
    | SSETableChange (Result String String)


type Msg
    = OnFetchMeetings (WebData (List Meeting))
    | OnFetchAssignments (WebData (List Assignment))
    | OnBeginAssignment AssignmentSlug
    | OnFetchAssignmentSubmissions (WebData (List AssignmentSubmission))
    | OnBeginAssignmentComplete AssignmentSlug (WebData AssignmentSubmission)
    | OnFetchCurrentUser (WebData CurrentUser)
    | OnFetchQuizzes (WebData (List Quiz))
    | OnFetchQuizSubmissions (WebData (List QuizSubmission))
    | OnLocationChange Location
    | Tick Time
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
