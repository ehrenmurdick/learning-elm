module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Svg exposing (Svg, svg, polygon)
import Svg.Attributes exposing (points)
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
    ( Model (4 :+ 3), Cmd.none )


numberInput v msg =
    input [ value (toString v), attribute "type" "number", onInput msg ] []


view : Model -> Html Msg
view model =
    let
        n =
            square model.n
    in
        div [ style [ ( "padding", "3em" ) ] ]
            [ triangle model
            , br [] []
            , numberInput model.n.realPart (parseInput SetReal)
            , numberInput model.n.imagPart (parseInput SetImag)
            , text (toString [ n.realPart, n.imagPart, sqMag model.n ])
            ]


triangle : Model -> Svg Msg
triangle model =
    let
        scale =
            1

        n =
            square model.n

        x =
            ((scale * 500) - n.realPart) - 250

        y =
            n.imagPart + 250
    in
        svg [ height 500, width 500 ]
            [ polygon [ points ("250,250 250," ++ (toString x) ++ " " ++ (toString y) ++ ",250") ] []
            ]



-- <svg height="210" width="500">
--   <polygon points="200,10 250,190 160,210" style="fill:lime;stroke:purple;stroke-width:1" />
-- </svg>


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
