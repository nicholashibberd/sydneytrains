import Html exposing (Html, Attribute, a, button, div, input, label, text)
import Html.Events exposing (keyCode,
                             on,
                             onBlur, 
                             onInput, 
                             onMouseDown, 
                             onMouseEnter, 
                             onMouseLeave,
                             onWithOptions)
import Html.Attributes exposing (autocomplete,
                                 class, 
                                 classList, 
                                 for, 
                                 id, 
                                 placeholder, 
                                 type_, 
                                 value)
import Json.Decode as Json
import List.Extra exposing (getAt)

main =
  Html.programWithFlags 
    { init = init
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }


-- MODEL

type alias Station =
  { name : String
  , stop_id : String
  }


type alias Model =
  { stations : List Station
  , error : Bool
  , errorMessage : String
  , suggestions : List Station
  , displayFromSuggestions : Bool
  , fromStation : Maybe Station
  , fromValue : String
  , suggestionIndex : Maybe Int
  }


type alias Flags =
  { stations : String }


-- stationsDecoder : Decoder (List Station)
-- stationsDecoder =
--   Json.list ()


stationDecoder : Json.Decoder Station
stationDecoder =
    Json.map2 Station
        (Json.field "name" Json.string)
        (Json.field "stop_id" Json.string)


decodeStations : String -> Result String (List Station)
decodeStations jsonString =
  Json.decodeString (Json.list stationDecoder) jsonString


init : Flags -> ( Model, Cmd Msg )
init { stations } =
  case decodeStations stations of
    Ok data ->
      { stations = data
      , error = False
      , errorMessage = ""
      , suggestions = []
      , displayFromSuggestions = False
      , fromStation = Nothing
      , fromValue = ""
      , suggestionIndex = Nothing
      } ! []

    Err msg ->
      { stations = []
      , error = True
      , errorMessage = msg
      , suggestions = []
      , displayFromSuggestions = False
      , fromStation = Nothing
      , fromValue = ""
      , suggestionIndex = Nothing
      } ! []


-- UPDATE

type Msg = 
  DoNothing
  | FromInputChanged String
  | FromInputBlur
  | HandleEnter
  | HandleKeyDown
  | HandleKeyUp
  | HighlightSuggestion Int
  | RemoveHighlight
  | SelectFromStation Station

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    DoNothing ->
      model ! []

    FromInputBlur ->
      { model | suggestions = []
              , displayFromSuggestions = False 
              } ! []

    FromInputChanged input ->
      let
          suggestions = suggestStations input model.stations
      in
          { model | suggestions = suggestions
                  , displayFromSuggestions = True 
                  , fromValue = input
                  } ! []

    HandleEnter ->
      case stationAtIndex model.suggestions model.suggestionIndex of
        Just station ->
          selectFromStation station model ! []
        Nothing ->
          model ! []

    HandleKeyDown ->
      if model.displayFromSuggestions == False
      then  model ! []
      else { model | suggestionIndex = incrementSuggestionIndex model } ! []

    HandleKeyUp ->
      { model | suggestionIndex = decrementSuggestionIndex model } ! []

    HighlightSuggestion idx ->
      { model | suggestionIndex = Just idx } ! []

    RemoveHighlight ->
      { model | suggestionIndex = Nothing } ! []

    SelectFromStation station ->
      selectFromStation station model ! []


selectFromStation : Station -> Model -> Model
selectFromStation station model =
  { model | displayFromSuggestions = False
          , fromStation = Just station
          , fromValue = station.name
          , suggestionIndex = Nothing
          }



matchFn : String -> Station -> Bool
matchFn text station =
  String.contains (String.toLower text) (String.toLower station.name)


maxIndex : Int
maxIndex = 
  5


suggestStations : String -> List Station -> List Station
suggestStations text stations =
  List.filter (matchFn text) stations |> List.take maxIndex


incrementSuggestionIndex : Model -> Maybe Int
incrementSuggestionIndex { suggestionIndex, suggestions } =
  let
    max = List.length suggestions
  in
    case suggestionIndex of
      Just val ->
        if val == max - 1 then Just <| max - 1 else Just <| val + 1

      Nothing ->
        Just 0


decrementSuggestionIndex : Model -> Maybe Int
decrementSuggestionIndex { suggestionIndex } =
  case suggestionIndex of
    Just val ->
      if val == 0 then Nothing else Just <| val - 1

    Nothing ->
      Nothing


stationAtIndex : List Station -> Maybe Int -> Maybe Station
stationAtIndex stations maybeInt =
  case maybeInt of
    Just int ->
      getAt int stations

    Nothing ->
      Nothing


-- VIEW

suggestion : Maybe Int -> Int -> Station -> Html Msg
suggestion maybeSelected idx station =
  let
      selected = case maybeSelected of
        Just selectedIdx ->
          idx == selectedIdx

        Nothing ->
          False
  in
    a [ classList
          [ ("suggestion", True)
          , ("active", selected)
          ]
      , onMouseDown (SelectFromStation station)
      , onMouseEnter (HighlightSuggestion idx)
      , onMouseLeave (RemoveHighlight)
      -- , onEnter HandleEnter
      ] [ text station.name ]


suggestionsDropdown : Model -> Html Msg
suggestionsDropdown { displayFromSuggestions, suggestions, suggestionIndex } =
  if displayFromSuggestions then
      div [ class "dropdown" ] <| List.indexedMap (suggestion suggestionIndex) suggestions
  else
      text ""


view : Model -> Html Msg
view model =
  if model.error then
     text model.errorMessage
  else
    div [ class "jumbotron" ]
      [ div [] 
          [ div [ class "form-group" ]
              [ label [ for "fromStation" ] [ text "From" ]
              , div [ class "autocomplete" ]
                  [ input [ id "fromStation"
                          , autocomplete False
                          , type_ "text"
                          , class "form-control"
                          , placeholder "Starting station"
                          , onBlur FromInputBlur
                          , onInput FromInputChanged 
                          , onKeyPress handleKeyPress
                          , value model.fromValue
                          ] []
                  , suggestionsDropdown model
                  ]
              ]
          , div [ class "form-group" ]
              [ label [ for "toStation" ] [ text "To" ]
              , div [ class "autocomplete" ]
                  [ input [ autocomplete False
                          , id "toStation"
                          , type_ "text"
                          , class "form-control"
                          , placeholder "Destination station" 
                          ] []
                  ]
              ]
          , div [ class "form-group" ]
              [ div [ class "row" ]
                  [ div [ class "col-md-6" ]
                      [ label [ for "date" ] [ text "Date" ]
                      , input [ id "date", type_ "date", class "form-control" ] []
                      ]
                  , div [ class "col-md-6" ]
                      [ label [ for "time" ] [ text "Time" ]
                      , input [ id "time", type_ "time", class "form-control" ] []
                      ]
                  ]
              ]
          , div [ class "form-group" ]
              [ button [ type_ "submit", class "btn btn-default" ] [ text "Search" ]
              ]
          ]
      ]


handleKeyPress : Int -> Msg
handleKeyPress keyCode =
  case keyCode of
    13 ->
      HandleEnter
    38 ->
      HandleKeyUp
    40 ->
      HandleKeyDown
    _ ->
      DoNothing


onKeyPress : (Int -> msg) -> Attribute msg
onKeyPress handler =
    on "keydown" (Json.map handler keyCode)
