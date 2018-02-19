module Players.Navbar exposing (nav)

import Html exposing (..)
import Html.Attributes exposing (class, value, href, placeholder)
import Link
import Msgs exposing (Msg)
import Routing exposing (playersPath, newPlayerPath)


nav : Html Msg
nav =
    div [ class "bg-black p1 clearfix"]
        [ span [ class "mb2 white " ] [ listLink ]
        , span [ class "mb2 white" ] [ createLink ]
        ]

listLink : Html Msg
listLink =
  a
    [ class "btn regular"
    , Link.onLinkClick (Msgs.ChangeLocation playersPath)
    ]
    [ text "Players" ]


createLink : Html Msg
createLink =
  a
    [ class "btn regular"
    , Link.onLinkClick (Msgs.ChangeLocation newPlayerPath)
    ]
    [ text "Create" ]
