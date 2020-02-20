module Example08Time exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Iso8601
import Svg exposing (Svg, line, svg)
import Svg.Attributes exposing (height, stroke, viewBox, width, x1, x2, y1, y2)
import Task
import Time
import Time.Extra exposing (Interval(..), diff)



-- MAIN


main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { zone : Time.Zone
  , time : Time.Posix,
  test: String,
  counter: Int,
  subscribe: Bool
  }


init : () -> (Model, Cmd Msg)
init _ =
  ( Model Time.utc (Time.millisToPosix 0) "" 0 True
  , Task.perform AdjustTimeZone Time.here
  )



-- UPDATE


type Msg
  = Tick Time.Posix
  | AdjustTimeZone Time.Zone
  | IncreaseCounter



update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case (msg, model.subscribe) of
    (Tick newTime, True) ->
              ( { model | time = newTime }
              , Cmd.none
              )
    (Tick _, False) ->
                 (model, Cmd.none)

    (AdjustTimeZone newZone, _) ->
      ( { model | zone = newZone }
      , Cmd.none
      )
    (IncreaseCounter, _) ->
        ( {model | counter = model.counter + 1, subscribe = not model.subscribe }
        , Cmd.none
        )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every 1000 Tick



-- VIEW

buttonMsg : Model -> String
buttonMsg model =
    case model.subscribe of
        True ->
            "stop Clock!"
        False ->
            "start Clock"

getSecond: Model -> Float
getSecond m = toFloat (Time.toSecond m.zone m.time)

angle: Float -> Float
angle s = (s / 60) * 360

x: Float -> String
x a = String.fromFloat(60 + (sin (degrees a))* 60)

y: Float -> String
y a = String.fromFloat (60 - (cos (degrees a)) * 60)

secondHand: Float -> Svg Msg
secondHand sec =
    line [x1 "60", y1 "60", x2 (x (angle sec)), y2 (y (angle sec)), stroke "black"] []



now = "2020-02-08T16:52:19.956973+00:00"
badnow = "2020-20"


displayDifference: Int -> String
displayDifference seconds =
    let
        minute = 60
        hour = 60 * minute
        day = hour * 24
        secondsFloat = toFloat seconds
    in
    if secondsFloat < 0 then
        "this project is made in the future???"
    else if  secondsFloat < 60 then
        "less than a minute"
    else  if secondsFloat < 3600 then
        String.fromInt(round (secondsFloat / minute)) ++ " minutes"
    else if secondsFloat < day then
        String.fromInt(round (secondsFloat / hour)) ++ " hours"
    else
        String.fromInt(round (secondsFloat / day)) ++ " days"


diffStr: Model -> String
diffStr model =
    case (Iso8601.toTime now) of
        Ok parsedTime ->
            let
                d = diff Second model.zone parsedTime model.time
            in
            "Good:" ++ (d  |> displayDifference)
        Err _ ->
            "Error parsing date"

view : Model -> Html Msg
view model =
  let
    hourString   = String.fromInt (Time.toHour   model.zone model.time)
    minuteString = String.fromInt (Time.toMinute model.zone model.time)
    second = Time.toSecond model.zone model.time
    secondString = String.fromInt second
  in
  div [style "font-family" "Arial", style "padding" "30px"]
    [
        h1 [] [ text (hourString ++ ":" ++ minuteString ++ ":" ++ secondString) ],
        p [] [ text (case model.subscribe of
                        True ->
                            "Clock is active"
                        False ->
                            "Clock is inactive"
                     )],
        p [] [ text (String.fromInt model.counter)]
        , button [ onClick IncreaseCounter, style "display" "block" ] [ text (buttonMsg model) ]
        , svg [ width "120"
                  , height "120"
                  , viewBox "0 0 120 120"
                  , style "border" "solid black"
                  ] [ secondHand (getSecond model) ],

        p [] [ text ("angle:" ++ String.fromFloat (angle (toFloat second)))]
        , p [] [ text ("x:" ++ (x (angle(toFloat second))))]
        , p [] [ text ("y:" ++ (y (angle(toFloat second))))]
        , p [] [ text ("diff:" ++ diffStr model)]
        ]