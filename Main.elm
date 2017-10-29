module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode
import Time exposing (Time, second)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { topic : String
    , gifUrl : String
    , status : String
    , paused : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( Model "puppies" "" ":)" False, getRandomGif "puppies" )


type Msg
    = MorePlease
    | MorePleaseTick Time
    | NewGif (Result Http.Error String)
    | NewTopic String
    | Stop
    | Start


subscriptions : Model -> Sub Msg
subscriptions model =
    case model.paused of
        True ->
            Sub.none

        False ->
            Time.every (second * 10) MorePleaseTick


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MorePlease ->
            ( { model
                | gifUrl = "https://i.giphy.com/media/3oEjI6SIIHBdRxXI40/giphy.webp"
                , status = ":3"
              }
            , getRandomGif model.topic
            )

        NewTopic s ->
            ( { model | topic = s, status = ":O" }, Cmd.none )

        NewGif (Ok newUrl) ->
            ( { model | gifUrl = newUrl, status = ":)" }, Cmd.none )

        NewGif (Err m) ->
            ( { model | status = ">:(" }, Cmd.none )

        MorePleaseTick t ->
            ( { model | gifUrl = "https://i.giphy.com/media/3oEjI6SIIHBdRxXI40/giphy.webp", status = ":3" }, getRandomGif model.topic )

        Stop ->
            ( { model | paused = True }, Cmd.none )

        Start ->
            ( { model | paused = False }, Cmd.none )


getRandomGif : String -> Cmd Msg
getRandomGif topic =
    let
        url =
            "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic

        request =
            Http.get url decodeGifUrl
    in
        Http.send NewGif request


decodeGifUrl : Decode.Decoder String
decodeGifUrl =
    Decode.at [ "data", "image_url" ] Decode.string


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text model.topic ]
        , img [ src model.gifUrl ] []
        , hr [] []
        , input [ onInput NewTopic ] []
        , button [ onClick MorePlease ] [ text "more plz" ]
        , div [] [ text model.status ]
        , pauseButton model
        ]


pauseButton : Model -> Html Msg
pauseButton model =
    case model.paused of
        True ->
            div []
                [ button [ onClick Start ] [ text "start" ]
                ]

        False ->
            div []
                [ button [ onClick Stop ] [ text "stop" ]
                ]
