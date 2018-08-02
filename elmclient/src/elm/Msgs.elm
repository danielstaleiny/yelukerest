module Msgs exposing (..)

import Assignments.Model exposing (Assignment, AssignmentSlug, AssignmentSubmission)
import Auth.Model exposing (CurrentUser)
import Date exposing (Date)
import Meetings.Model exposing (Meeting)
import Navigation exposing (Location)
import Quizzes.Model exposing (Quiz)
import RemoteData exposing (WebData)


type Msg
    = OnFetchMeetings (WebData (List Meeting))
    | OnFetchAssignments (WebData (List Assignment))
    | OnBeginAssignment AssignmentSlug
    | OnFetchAssignmentSubmissions (WebData (List AssignmentSubmission))
    | OnBeginAssignmentComplete AssignmentSlug (WebData AssignmentSubmission)
    | OnFetchCurrentUser (WebData CurrentUser)
    | OnFetchQuizzes (WebData (List Quiz))
    | OnLocationChange Location
    | OnFetchDate Date
    | OnSubmitAssignmentFieldSubmissions Assignment
    | OnUpdateAssignmentFieldSubmissionInput Int String
