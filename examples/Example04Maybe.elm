module Example04Maybe exposing (..)

import Browser
import Html exposing (Html, Attribute, span, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)



-- MAIN


main =
  Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
  { input : String
  }


init : Model
init =
  { input = "" }



-- UPDATE


type Msg
  = Change String


update : Msg -> Model -> Model
update msg model =
  case msg of
    Change newInput ->
      { model | input = newInput }



-- VIEW

type MaybeAge
  = Age Int
  | InvalidInput


view : Model -> Html Msg
view model =
  case String.toFloat model.input of
    Just celsius ->
      -- viewConverter model.input "blue" (String.fromFloat (celsius * 1.8 + 32))
      case String.toInt model.input of 
        Just val -> viewConverter model.input "blue" (String.fromFloat (celsius * 1.8 + 32))
        Nothing ->  text "Error" -- never reaches here as caught by MaybeAge
        

    Nothing ->
      viewConverter model.input "red" ("??? " ++ model.input ++ " is not valid")


viewConverter : String -> String -> String -> Html Msg
viewConverter userInput color equivalentTemp =
  span []
    [ input [ value userInput, onInput Change, style "width" "40px" ] []
    , text "°C = "
    , span [ style "color" color ] [ text equivalentTemp ]
    , text "°F"
    ]
