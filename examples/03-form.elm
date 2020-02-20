import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)

minAge = 18
maxAge = 65
minPasswordLength = 8

-- MAIN


main =
  Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
  { name : String
  , age: Int
  , ageString: String
  , ageValid: Bool
  , password : String
  , passwordAgain : String
  , passwordValid : Bool
  , saved : Bool
  }


init : Model
init =
  -- Debug.log "run update"
  -- _ = Debug.log "my message" someValue
  -- in
  -- case Debug.log "action" action of
  Model "" 0 "" False "" "" False False



-- UPDATE


type Msg
  = Name String
  | Age String
  | Password String
  | PasswordAgain String
  | SubmitForm
  | ResetForm


update : Msg -> Model -> Model
update msg model =
  -- Debug.log("run update")
  -- 1 + log "number" 1
  let _ = Debug.log "my message" 
    in
  case msg of
    Name name ->
      { model | name = name }
    
    Age ageString ->
      { model | age = Maybe.withDefault 0 (String.toInt ageString)  }

    Password password ->
      { model | password = password }

    PasswordAgain password ->
      { model | passwordAgain = password }
    
    
    -- model | saved = true

    SubmitForm ->
     { model | saved = True }

    ResetForm ->
     { model | saved = False , name = "" }
    
    -- Saved saved ->
    --   { model | saved = saved }



-- VIEW

stylesheet =
    let
        tag = "link"
        attrs =
            [ attribute "rel"       "stylesheet"
            , attribute "property"  "stylesheet"
            , attribute "href"      "//maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css"
            ]
        children = []
    in 
        node tag attrs children

form: Model -> Html Msg
form model = div []
    [ 
    stylesheet
    , h3 [] [ text "Name" ]
    , viewInput "text" "Name" model.name Name
    , h3 [] [ text "Age" ]
--    , input [ placeholder "Age in years", value (String.fromInt model.age), onInput Age ] []
    , viewInput "text" "Age in years" (String.fromInt model.age) Age
    -- , viewIntInput "number" "Age" model.age Age
    , h3 [] [ text "Password" ]
    , viewInput "password" "Password" model.password Password
    , viewInput "password" "Re-enter Password" model.passwordAgain PasswordAgain
    , viewValidation model
    , div [] [text (model.name ++ " --" ++ (String.fromInt model.age))]
    ,  button [onClick SubmitForm] [ text "Submit" ] 
    ]

view : Model -> Html Msg
view model =
  -- Debug.log "run view"  
  div []
    [ 
    stylesheet,
    if model.saved == False then
    form model
    else div [] [text "form has been saved"]
    ,  button [onClick ResetForm] [ text "Reset" ] 
    ]


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
  input [ type_ t, placeholder p, value v, onInput toMsg ] []

-- viewIntInput : String -> String -> Int -> (Int -> msg) -> Html msg
-- viewIntInput t p vI iToMsg =
--   input [ type_ t, placeholder p, value vI, onInput iToMsg ] []


viewValidation : Model -> Html msg
viewValidation model =
  -- Debug.log model.password
  -- if String.toInt model.age
  div []
  [
  h4 [] [ text "Validation"],
  if model.age < minAge || model.age > maxAge then
     div [ style "color" "red" ] [ text ("age must be between " ++ String.fromInt(minAge) ++ " and  " ++ String.fromInt(maxAge))]
  else if String.length model.password <= minPasswordLength then
    div [ style "color" "red" ] [ text ("Password must be over length " ++ (String.fromInt minPasswordLength) ++ "!") ]
  else if model.password /= model.passwordAgain then
    div [ style "color" "red" ] [ text "Passwords do not match!" ]
--  else then
--  else if model.validAge && model.validPassword then
    else
    div [ style "color" "green" ] [ text "OK" ]
--  else then
    ]
