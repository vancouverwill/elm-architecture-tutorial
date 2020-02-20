module Example08Time exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)
import Task
import Time



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
        --if model.subscribe then
              ( { model | time = newTime }
              , Cmd.none
              )
        --else
        --      (model, Cmd.none)
    (Tick _, False) ->
            --if model.subscribe then
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


view : Model -> Html Msg
view model =
  let
    hour   = String.fromInt (Time.toHour   model.zone model.time)
    minute = String.fromInt (Time.toMinute model.zone model.time)
    second = String.fromInt (Time.toSecond model.zone model.time)
  in
  div []
    [
        h1 [] [ text (hour ++ ":" ++ minute ++ ":" ++ second) ],
        p [] [ text (case model.subscribe of
                        True ->
                            "True"
                        False ->
                            "FAlse"
                     )],
        p [] [ text (String.fromInt model.counter)]
        , button [ onClick IncreaseCounter, style "display" "block" ] [ text "stop Clock!" ]
        ]