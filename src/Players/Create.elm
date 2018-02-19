module Players.Create exposing (view)

import Html exposing (..)
import Html.Attributes exposing (class, placeholder, value)
import Html.Events exposing (onClick, onInput)
import Msgs exposing (Msg)
import Models exposing (Model, Player, NewPlayer)
import Players.Navbar exposing (nav)

view : Model -> Html Msg
view model =
  div []
      [ Players.Navbar.nav
      , form model.newPlayer
      ]

form : NewPlayer -> Html Msg
form newPlayer =
    div [] [
        div
            [ class "clearfix py1"
            ]
            [ div [] [ text "Name"]
            , setName newPlayer
            ]
    ]

setName : NewPlayer -> Html Msg
setName newPlayer =
    div []
        [ input [ placeholder "Name", value newPlayer.name, onInput (Msgs.AddPlayer newPlayer)] []
        , button [ onClick  (Msgs.CreatePlayer newPlayer) ] [ text "Create" ]
        ]
