module Models exposing (..)

import Assignments.Model exposing (Assignment, AssignmentFieldSubmissionInputs, AssignmentSlug, AssignmentSubmission, PendingAssignmentFieldSubmissionRequests, PendingBeginAssignments)
import Auth.Model exposing (CurrentUser)
import Date exposing (Date)
import Dict exposing (Dict)
import Meetings.Model exposing (Meeting, MeetingSlug)
import Quizzes.Model exposing (Quiz, QuizAnswer, QuizQuestion, QuizSubmission)
import RemoteData exposing (WebData)
import Set exposing (Set)


type alias Flags =
    { courseTitle : String
    , piazzaURL : Maybe String
    }


type alias UIElements =
    { courseTitle : String
    , piazzaURL : Maybe String
    }


type alias Model =
    { current_date : Maybe Date
    , route : Route
    , meetings : WebData (List Meeting)
    , currentUser : WebData CurrentUser
    , assignments : WebData (List Assignment)
    , quizzes : WebData (List Quiz)
    , quizSubmissions : WebData (List QuizSubmission)
    , uiElements : UIElements
    , assignmentSubmissions : WebData (List AssignmentSubmission)

    -- A dictionary that tracks requests initiated to begin a
    -- particular assignment, that is, to create an assignment submission
    -- for the current user.
    , pendingBeginAssignments : PendingBeginAssignments

    -- A dictionary tracking the current value of <input> elements
    -- that the user has edited for particular assignment field submissions.
    , assignmentFieldSubmissionInputs : AssignmentFieldSubmissionInputs

    -- A dictionary tracking POST requests to the server to save
    -- assigment field submissions.
    , pendingAssignmentFieldSubmissionRequests : PendingAssignmentFieldSubmissionRequests

    -- A dictionary tracking POST requests to the server to create
    -- new quiz submissions.
    , pendingBeginQuizzes : Dict Int (WebData QuizSubmission)
    , quizAnswers : Dict Int (WebData (List QuizAnswer))
    , quizQuestions : Dict Int (WebData (List QuizQuestion))
    , quizQuestionOptionInputs : Set Int
    }


initialModel : Flags -> Route -> Model
initialModel flags route =
    { current_date = Nothing
    , route = route
    , meetings = RemoteData.Loading
    , currentUser = RemoteData.Loading
    , assignments = RemoteData.NotAsked
    , quizzes = RemoteData.NotAsked
    , quizSubmissions = RemoteData.NotAsked
    , uiElements =
        { courseTitle = flags.courseTitle
        , piazzaURL = flags.piazzaURL
        }
    , assignmentSubmissions = RemoteData.NotAsked
    , pendingBeginAssignments = Dict.empty
    , pendingBeginQuizzes = Dict.empty
    , assignmentFieldSubmissionInputs = Dict.empty
    , pendingAssignmentFieldSubmissionRequests = Dict.empty
    , quizAnswers = Dict.empty
    , quizQuestions = Dict.empty
    , quizQuestionOptionInputs = Set.empty
    }


type Route
    = IndexRoute
    | CurrentUserDashboardRoute
    | MeetingListRoute
    | MeetingDetailRoute MeetingSlug
    | AssignmentListRoute
    | AssignmentDetailRoute AssignmentSlug
    | TakeQuizRoute Int
    | NotFoundRoute
