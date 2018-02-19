module Players.Edit exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, value, href, placeholder)
import Html.Events exposing (onClick, onInput)
import Msgs exposing (Msg)
import Models exposing (Player)
import Players.Navbar exposing (nav)

view : Player -> Html Msg
view player =
  div []
      [ Players.Navbar.nav
      , form player
      ]

form : Player -> Html Msg
form player =
  div [ class "m3" ]
      [ h1 [] [ text player.name ]
      , changeName player
      , formLevel player
      ]

formLevel : Player -> Html Msg
formLevel player =
  div
    [ class "clearfix py1"
    ]
    [ div [ class "col col-5" ] [ text "Level"]
    , div [ class "col col-7" ]
        [ span [ class "h2 bold" ] [ text (toString player.level) ]
        , btnLevelDecrease player
        , btnLevelIncrease player
        ]
    ]

changeName : Player -> Html Msg
changeName player =
  let message =
    Msgs.ChangeName player
  in
    input [ value player.name, onInput message] []

btnLevelDecrease : Player -> Html Msg
btnLevelDecrease player =
  let
      message =
        Msgs.ChangeLevel player -1
  in 
    a [ class "btn ml1 h1", onClick message ]
      [ i [ class "fa fa-minus-circle" ] [] ]

btnLevelIncrease : Player -> Html Msg
btnLevelIncrease player =
  let
      message =
        Msgs.ChangeLevel player 1
  in 
    a [ class "btn ml1 h1", onClick message ]
      [ i [ class "fa fa-plus-circle" ] [] ]
