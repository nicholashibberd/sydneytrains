import Html exposing (Html, button, div, input, form, label, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (class, placeholder, type_, for, id)


main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL

type alias Model = Int

model : Model
model =
  0


-- UPDATE

type Msg = Increment | Decrement

update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      model + 1

    Decrement ->
      model - 1


-- VIEW

view : Model -> Html Msg
view model =
  div [ class "jumbotron" ]
    [ form [] 
        [ div [ class "form-group" ]
            [ label [ for "fromStation" ] [ text "From" ]
            , input [ id "fromStation", type_ "text", class "form-control", placeholder "Starting station" ] []
            ]
        , div [ class "form-group" ]
            [ label [ for "toStation" ] [ text "To" ]
            , input [ id "toStation", type_ "text", class "form-control", placeholder "Destination station" ] []
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
