module Quizzes.Model
    exposing
        ( Quiz
        , QuizAnswer
        , QuizOpenState(..)
        , QuizQuestion
        , QuizQuestionOption
        , QuizSubmission
        , SubmissionEditableState(..)
        , quizAnswersDecoder
        , quizQuestionsDecoder
        , quizSubmissionDecoder
        , quizSubmissionsDecoder
        , quizSubmitability
        , quizzesDecoder
        )

import Date exposing (Date)
import Json.Decode as Decode
import Json.Decode.Extra exposing (date)
import Json.Decode.Pipeline exposing (decode, required)


type alias Quiz =
    { id : Int
    , meeting_id : Int
    , points_possible : Int
    , is_draft : Bool
    , duration : String
    , open_at : Date
    , closed_at : Date
    , is_open : Bool
    , created_at : Date
    , updated_at : Date
    }


quizzesDecoder : Decode.Decoder (List Quiz)
quizzesDecoder =
    Decode.list quizDecoder


quizDecoder : Decode.Decoder Quiz
quizDecoder =
    decode Quiz
        |> required "id" Decode.int
        |> required "meeting_id" Decode.int
        |> required "points_possible" Decode.int
        |> required "is_draft" Decode.bool
        |> required "duration" Decode.string
        |> required "open_at" Json.Decode.Extra.date
        |> required "closed_at" Json.Decode.Extra.date
        |> required "is_open" Decode.bool
        |> required "created_at" Json.Decode.Extra.date
        |> required "updated_at" Json.Decode.Extra.date



-- ----------------
-- Quiz submissions
-- ----------------


type QuizOpenState
    = BeforeQuizOpen
    | QuizOpen
    | AfterQuizClosed


type SubmissionEditableState
    = EditableSubmission QuizSubmission
    | NotEditableSubmission


dateIsLessThan : Date -> Date -> Bool
dateIsLessThan a b =
    case Basics.compare (Date.toTime a) (Date.toTime b) of
        LT ->
            True

        _ ->
            False


quizSubmitability : Date -> Quiz -> Maybe QuizSubmission -> ( QuizOpenState, SubmissionEditableState )
quizSubmitability currentDate quiz maybeQuizSubmission =
    let
        quizOpenState =
            if dateIsLessThan currentDate quiz.open_at then
                BeforeQuizOpen
            else if dateIsLessThan quiz.closed_at currentDate then
                AfterQuizClosed
            else
                QuizOpen
    in
    case maybeQuizSubmission of
        Just quizSubmission ->
            ( quizOpenState, EditableSubmission quizSubmission )

        Nothing ->
            ( quizOpenState, NotEditableSubmission )


type alias QuizSubmission =
    { quiz_id : Int
    , user_id : Int
    , closed_at : Date
    , is_open : Bool
    , created_at : Date
    , updated_at : Date
    }


quizSubmissionsDecoder : Decode.Decoder (List QuizSubmission)
quizSubmissionsDecoder =
    Decode.list quizSubmissionDecoder


quizSubmissionDecoder : Decode.Decoder QuizSubmission
quizSubmissionDecoder =
    decode QuizSubmission
        |> required "quiz_id" Decode.int
        |> required "user_id" Decode.int
        |> required "closed_at" Json.Decode.Extra.date
        |> required "is_open" Decode.bool
        |> required "created_at" Json.Decode.Extra.date
        |> required "updated_at" Json.Decode.Extra.date



-- Encoder not yet needed


type alias QuizQuestion =
    { id : Int
    , body : String
    , options : List QuizQuestionOption
    }


type alias QuizQuestionOption =
    { id : Int
    , body : String
    }


type alias QuizAnswer =
    { user_id : Int
    , quiz_question_option_id : Int
    , quiz_id : Int
    }


quizAnswerDecoder : Decode.Decoder QuizAnswer
quizAnswerDecoder =
    decode QuizAnswer
        |> required "user_id" Decode.int
        |> required "quiz_question_option_id" Decode.int
        |> required "quiz_id" Decode.int


quizAnswersDecoder : Decode.Decoder (List QuizAnswer)
quizAnswersDecoder =
    Decode.list quizAnswerDecoder


quizQuestionDecoder : Decode.Decoder QuizQuestion
quizQuestionDecoder =
    decode QuizQuestion
        |> required "id" Decode.int
        |> required "body" Decode.string
        |> required "options" quizQuestionOptionsDecoder


quizQuestionsDecoder : Decode.Decoder (List QuizQuestion)
quizQuestionsDecoder =
    Decode.list quizQuestionDecoder


quizQuestionOptionDecoder : Decode.Decoder QuizQuestionOption
quizQuestionOptionDecoder =
    decode QuizQuestionOption
        |> required "id" Decode.int
        |> required "body" Decode.string


quizQuestionOptionsDecoder : Decode.Decoder (List QuizQuestionOption)
quizQuestionOptionsDecoder =
    Decode.list quizQuestionOptionDecoder
