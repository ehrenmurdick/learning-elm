module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Complex exposing (..)


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


type alias Model =
    { n : Complex
    }


type Msg
    = SetReal Int
    | SetImag Int


parseInput a s =
    let
        parsed =
            String.toInt s
    in
        case parsed of
            Err _ ->
                a 0

            Ok n ->
                a n


init : ( Model, Cmd Msg )
init =
    ( Model (0 :+ 0), Cmd.none )


numberInput msg =
    input [ attribute "type" "number", onInput msg ] []


view : Model -> Html Msg
view model =
    div []
        [ numberInput (parseInput SetReal)
        , numberInput (parseInput SetImag)
        , text (toString (square model.n))
        , text (toString (sqMag model.n))
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetReal n ->
            ( { model | n = n :+ model.n.imagPart }, Cmd.none )

        SetImag n ->
            ( { model | n = model.n.realPart :+ n }, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none
