module Quizzes.Commands exposing
    ( createQuizSubmission
    , fetchQuizAnswers
    , fetchQuizGradeDistributions
    , fetchQuizGrades
    , fetchQuizQuestions
    , fetchQuizSubmissions
    , fetchQuizzes
    , submitQuizAnswers
    )

import Auth.Commands exposing (fetchForCurrentUser, requestForJWT)
import Auth.Model exposing (CurrentUser, JWT, currentUserDecoder)
import Http
import Json.Decode as Decode
import Json.Encode as Encode
import Msgs exposing (Msg)
import Quizzes.Model
    exposing
        ( Quiz
        , QuizGrade
        , QuizGradeDistribution
        , QuizSubmission
        , quizAnswersDecoder
        , quizGradeDistributionsDecoder
        , quizGradesDecoder
        , quizQuestionsDecoder
        , quizSubmissionDecoder
        , quizSubmissionsDecoder
        , quizzesDecoder
        )
import RemoteData exposing (WebData)
import Task


fetchQuizzes : CurrentUser -> Cmd Msg
fetchQuizzes currentUser =
    fetchForCurrentUser currentUser fetchQuizzesUrl quizzesDecoder Msgs.OnFetchQuizzes


fetchQuizzesUrl : String
fetchQuizzesUrl =
    "/rest/quizzes?order=closed_at"


fetchQuizSubmissions : CurrentUser -> Cmd Msg
fetchQuizSubmissions currentUser =
    fetchForCurrentUser currentUser (fetchQuizSubmissionsUrl currentUser.id) quizSubmissionsDecoder Msgs.OnFetchQuizSubmissions


fetchQuizSubmissionsUrl : Int -> String
fetchQuizSubmissionsUrl userID =
    "/rest/quiz_submissions_info?user_id=eq." ++ toString userID


fetchQuizAnswers : Int -> CurrentUser -> Cmd Msg
fetchQuizAnswers quizID currentUser =
    fetchForCurrentUser currentUser (fetchQuizAnswerUrl currentUser.id quizID) quizAnswersDecoder (Msgs.OnFetchQuizAnswers quizID)



-- fetchQuizAnswersForJWT : Int -> String -> Cmd Msg
-- fetchQuizAnswersForJWT quizID jwt =
--     fetchForJWT jwt (fetchQuizAnswerUrl currentUser.id quizID) quizAnswersDecoder (Msgs.OnFetchQuizAnswers quizID)


fetchQuizAnswerUrl : Int -> Int -> String
fetchQuizAnswerUrl userID quizID =
    "/rest/quiz_answers?user_id=eq." ++ toString userID ++ "&quiz_id=eq." ++ toString quizID


fetchQuizQuestionsUrl : Int -> String
fetchQuizQuestionsUrl quizID =
    "/rest/quiz_questions?select=id,body,options:quiz_question_options(id,body)&quiz_id=eq." ++ toString quizID


fetchQuizQuestions : Int -> CurrentUser -> Cmd Msg
fetchQuizQuestions quizID currentUser =
    fetchForCurrentUser currentUser (fetchQuizQuestionsUrl quizID) quizQuestionsDecoder (Msgs.OnFetchQuizQuestions quizID)


fetchQuizGrades : CurrentUser -> Cmd Msg
fetchQuizGrades currentUser =
    fetchForCurrentUser currentUser (fetchQuizGradesUrl currentUser.id) quizGradesDecoder Msgs.OnFetchQuizGrades


fetchQuizGradesUrl : Int -> String
fetchQuizGradesUrl userID =
    "/rest/quiz_grades?user_id=eq." ++ toString userID


fetchQuizGradeDistributions : CurrentUser -> Cmd Msg
fetchQuizGradeDistributions currentUser =
    fetchForCurrentUser currentUser fetchQuizGradeDistributionsUrl quizGradeDistributionsDecoder Msgs.OnFetchQuizGradeDistributions


fetchQuizGradeDistributionsUrl : String
fetchQuizGradeDistributionsUrl =
    "/rest/quiz_grade_distributions"



-- |> RemoteData.sendRequest
-- |> Cmd.map (Msgs.OnBeginQuizComplete quizID)


createQuizSubmission : JWT -> Int -> Cmd Msg
createQuizSubmission jwt quizID =
    let
        headers1 =
            [ Http.header "Authorization" ("Bearer " ++ jwt)
            , Http.header "Prefer" "return=representation"
            , Http.header "Accept" "application/vnd.pgrst.object+json"
            ]

        insertSubmissionRequest =
            Http.request
                { method = "POST"
                , headers = headers1
                , url = "/rest/quiz_submissions"
                , timeout = Nothing
                , expect = Http.expectJson (Decode.succeed quizID)
                , withCredentials = False
                , body = Http.jsonBody (Encode.object [ ( "quiz_id", Encode.int quizID ) ])
                }

        fetchSubmissionsRequest =
            Http.request
                { method = "GET"
                , headers = [ Http.header "Authorization" ("Bearer " ++ jwt) ]
                , url = "/rest/quiz_submissions_info"
                , timeout = Nothing
                , expect = Http.expectJson quizSubmissionsDecoder
                , withCredentials = False
                , body = Http.emptyBody
                }
    in
    Http.toTask insertSubmissionRequest
        |> Task.andThen (\x -> Http.toTask fetchSubmissionsRequest)
        |> Task.attempt RemoteData.fromResult
        |> Cmd.map (Msgs.OnBeginQuizComplete quizID)


submitQuizAnswers : CurrentUser -> Int -> List Int -> Cmd Msg
submitQuizAnswers currentUser quizID quizQuestionOptionIds =
    let
        headers =
            [ Http.header "Authorization" ("Bearer " ++ currentUser.jwt)
            , Http.header "Prefer" "return=representation"
            ]

        saveRequest =
            Http.request
                { method = "POST"
                , headers = headers
                , url = "/rest/rpc/save_quiz"
                , timeout = Nothing
                , expect = Http.expectJson quizAnswersDecoder
                , withCredentials = False
                , body =
                    Http.jsonBody
                        (Encode.object
                            [ ( "quiz_id", Encode.int quizID )
                            , ( "quiz_question_option_ids"
                              , quizQuestionOptionIds
                                    |> List.map Encode.int
                                    |> Encode.list
                              )
                            ]
                        )
                }
    in
    saveRequest
        |> RemoteData.sendRequest
        |> Cmd.map (Msgs.OnSubmitQuizAnswersComplete quizID)
