module Players.List exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Link
import Msgs exposing (Msg)
import Models exposing (Player)
import Players.Navbar exposing (nav)
import RemoteData exposing (WebData)
import Routing exposing (playerPath)


view : WebData (List Player) -> Html Msg
view response = 
  div []
      [ Players.Navbar.nav
      , maybeList response
     ]

maybeList : WebData (List Player) -> Html Msg
maybeList response =
  case response of
    RemoteData.NotAsked ->
      text ""
    RemoteData.Loading ->
      text "Loading ..."
    RemoteData.Success players ->
      list players
    RemoteData.Failure error ->
      text (toString error)

list : List Player -> Html Msg
list players =
  div [ class "p2"]
      [ table []
        [ thead []
          [ tr []
            [ th [] [text "Id"]
            , th [] [text "Name"]
            , th [] [text "Level"]
            , th [] [text "Actions"]
            ]
          ]
        , tbody [] (List.map playerRow players)
        ]
      ]

playerRow : Player -> Html Msg
playerRow player =
  tr []
      [ td [] [ text player.id ]
      , td [] [ text player.name ]
      , td [] [ text (toString player.level) ]
      , td []
          [ editBtn player]
      ]

editBtn : Player -> Html.Html Msg
editBtn player =
  let
      path =
        playerPath player.id
  in
      a 
        [ class "btn regular"
        , Link.onLinkClick (Msgs.ChangeLocation path)
        ]
        [ i [ class "fa fa-pencil mr1" ] [], text "Edit" ]



