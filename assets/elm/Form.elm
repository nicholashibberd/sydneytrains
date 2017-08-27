import Date exposing (Date)
import Date.Extra.Config.Config_en_gb exposing (config)
import Date.Extra.Core exposing (toFirstOfMonth)
import Date.Extra.Format exposing (format)
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
import Task
import Time exposing (Time)

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
  { date : Maybe Date
  , displayFromSuggestions : Bool
  , displayToSuggestions : Bool
  , error : Bool
  , errorMessage : String
  , fromStation : Maybe Station
  , fromValue : String
  , stations : List Station
  , suggestions : List Station
  , suggestionIndex : Maybe Int
  , toStation : Maybe Station
  , toValue : String
  }


type alias Flags =
  { stations : String }


stationDecoder : Json.Decoder Station
stationDecoder =
    Json.map2 Station
        (Json.field "name" Json.string)
        (Json.field "stop_id" Json.string)


decodeStations : String -> Result String (List Station)
decodeStations jsonString =
  Json.decodeString (Json.list stationDecoder) jsonString


emptyModel : Model
emptyModel =
  { date = Nothing
  , displayFromSuggestions = False
  , displayToSuggestions = False
  , error = False
  , errorMessage = ""
  , fromStation = Nothing
  , fromValue = ""
  , stations = []
  , suggestions = []
  , suggestionIndex = Nothing
  , toStation = Nothing
  , toValue = ""
  }


init : Flags -> ( Model, Cmd Msg )
init { stations } =
  case decodeStations stations of
    Ok data ->
      { emptyModel | stations = data } ! [ Task.perform CurrentTimeFetched Time.now ]

    Err msg ->
      { emptyModel | errorMessage = msg
                   , error = False
                   } ! []


-- UPDATE

type Msg
  = CurrentTimeFetched Time
  | DoNothing
  | FromInputChanged String
  | FromInputBlur
  | HandleFromEnter
  | HandleFromKeyDown
  | HandleKeyUp
  | HandleToEnter
  | HandleToKeyDown
  | HighlightSuggestion Int
  | RemoveHighlight
  | SelectFromStation Station
  | SelectToStation Station
  | SetDate String
  | SetTime String
  | ToInputChanged String
  | ToInputBlur

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    CurrentTimeFetched time ->
      { model | date = Just <| Date.fromTime time } ! []

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

    HandleFromEnter ->
      case stationAtIndex model.suggestions model.suggestionIndex of
        Just station ->
          selectFromStation station model ! []
        Nothing ->
          model ! []

    HandleFromKeyDown ->
      if model.displayFromSuggestions == False
      then  model ! []
      else { model | suggestionIndex = incrementSuggestionIndex model } ! []

    HandleKeyUp ->
      { model | suggestionIndex = decrementSuggestionIndex model } ! []

    HandleToEnter ->
      case stationAtIndex model.suggestions model.suggestionIndex of
        Just station ->
          selectToStation station model ! []
        Nothing ->
          model ! []

    HandleToKeyDown ->
      if model.displayToSuggestions == False
      then  model ! []
      else { model | suggestionIndex = incrementSuggestionIndex model } ! []

    HighlightSuggestion idx ->
      { model | suggestionIndex = Just idx } ! []

    RemoveHighlight ->
      { model | suggestionIndex = Nothing } ! []

    SelectFromStation station ->
      selectFromStation station model ! []

    SelectToStation station ->
      selectToStation station model ! []

    SetDate dateString ->
      case newDate model dateString of
        Ok date ->
          { model | date = Just date } ! []

        Err msg ->
          { model | errorMessage = msg } ! []

    SetTime timeString ->
      case newTime model timeString of
        Ok date ->
          { model | date = Just date } ! []

        Err msg ->
          { model | errorMessage = msg } ! []

    ToInputBlur ->
      { model | suggestions = []
              , displayToSuggestions = False 
              } ! []

    ToInputChanged input ->
      let
          suggestions = suggestStations input model.stations
      in
          { model | suggestions = suggestions
                  , displayToSuggestions = True 
                  , toValue = input
                  } ! []


selectFromStation : Station -> Model -> Model
selectFromStation station model =
  { model | displayFromSuggestions = False
          , fromStation = Just station
          , fromValue = station.name
          , suggestionIndex = Nothing
          }



selectToStation : Station -> Model -> Model
selectToStation station model =
  { model | displayToSuggestions = False
          , toStation = Just station
          , toValue = station.name
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


newDate : Model -> String -> Result String Date
newDate { date } dateString =
  case date of
    Just currentDate ->
      dateString ++ " " ++ format config "%H:%M" currentDate |> Date.fromString
    Nothing ->
      Err "no date set"


newTime : Model -> String -> Result String Date
newTime { date } timeString =
  case date of
    Just currentDate ->
      format config "%Y-%m-%d" currentDate ++ " " ++ timeString |> Date.fromString
    Nothing ->
      Err "no date set"


-- VIEW

suggestion : (Station -> Msg) -> Maybe Int -> Int -> Station -> Html Msg
suggestion msg maybeSelected idx station =
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
      , onMouseDown (msg station)
      , onMouseEnter (HighlightSuggestion idx)
      , onMouseLeave (RemoveHighlight)
      -- , onEnter HandleEnter
      ] [ text station.name ]


suggestionsDropdown : List Station -> Maybe Int -> Bool -> (Station -> Msg) -> Html Msg
suggestionsDropdown suggestions suggestionIndex displaySuggestions msg =
  if displaySuggestions then
      div [ class "dropdown" ] <| List.indexedMap (suggestion msg suggestionIndex) suggestions
  else
      text ""


view : Model -> Html Msg
view model =
  let
    suggestionsFn = suggestionsDropdown model.suggestions model.suggestionIndex
    dateValue = case model.date of 
                  Nothing -> ""
                  Just date -> format config "%Y-%m-%d" date
    timeValue = case model.date of 
                  Nothing -> ""
                  Just date -> format config "%H:%M" date
  in
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
                            , onKeyPress handleFromKeyPress
                            , value model.fromValue
                            ] []
                    , suggestionsFn model.displayFromSuggestions SelectFromStation
                    ]
                ]
            , div [ class "form-group" ]
                [ label [ for "toStation" ] [ text "To" ]
                , div [ class "autocomplete" ]
                    [ input [ id "toStation"
                            , autocomplete False
                            , type_ "text"
                            , class "form-control"
                            , placeholder "Destination station"
                            , onBlur ToInputBlur
                            , onInput ToInputChanged 
                            , onKeyPress handleToKeyPress
                            , value model.toValue
                            ] []
                    , suggestionsFn model.displayToSuggestions SelectToStation
                    ]
                ]
            , div [ class "form-group" ]
                [ div [ class "row" ]
                    [ div [ class "col-md-6" ]
                        [ label [ for "date" ] [ text "Date" ]
                        , input [ id "date"
                                , class "form-control"
                                , onInput SetDate
                                , type_ "date"
                                , value dateValue
                                ] []
                        ]
                    , div [ class "col-md-6" ]
                        [ label [ for "time" ] [ text "Time" ]
                        , input [ id "time"
                                , class "form-control"
                                , onInput SetTime
                                , type_ "time"
                                , value timeValue
                                ] []
                        ]
                    ]
                ]
            , div [ class "form-group" ]
                [ button [ type_ "submit", class "btn btn-default" ] [ text "Search" ]
                ]
            ]
        ]


handleFromKeyPress : Int -> Msg
handleFromKeyPress keyCode =
  case keyCode of
    13 ->
      HandleFromEnter
    38 ->
      HandleKeyUp
    40 ->
      HandleFromKeyDown
    _ ->
      DoNothing


handleToKeyPress : Int -> Msg
handleToKeyPress keyCode =
  case keyCode of
    13 ->
      HandleToEnter
    38 ->
      HandleKeyUp
    40 ->
      HandleToKeyDown
    _ ->
      DoNothing


onKeyPress : (Int -> msg) -> Attribute msg
onKeyPress handler =
    on "keydown" (Json.map handler keyCode)
