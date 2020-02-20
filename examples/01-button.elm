import Browser
import Html exposing (Html, button, div, text, h2, input)
import Html.Events exposing (onClick, onInput)
import Html exposing (..)
import Html.Attributes exposing (..)


main =
  Browser.sandbox { init = init, update = update, view = view }


-- MODEL

type alias Model =
    {value: Int, base: Int}

init : Model
init = { value = 1, base = 1 }

-- UPDATE

type Msg = Increment | Decrement | Change String | Reset

update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      { model | value = model.value + model.value}

    Decrement ->
      {model | value = round (toFloat model.value / 2)}

    Change newContent ->
       {model | base = Maybe.withDefault 0 (String.toInt
       newContent)}

    Reset -> {model  | value = model.base}



-- VIEW

view : Model -> Html Msg
view model =
  div []
    [
    h2 [] [ text "Base Value" ]
    , div [] [ text (String.fromInt model.base) ]
    , input [ placeholder "Text to reverse", value (String.fromInt model.base), onInput Change ] []
    , h2 [] [ text "Calculated value" ]
    , div [] [ text (String.fromInt model.value) ]
    , button [ onClick Decrement ] [ text "-" ]
    , button [ onClick Increment ] [ text "+" ]
    , button [ onClick Reset ] [ text "Reset" ]

    ]