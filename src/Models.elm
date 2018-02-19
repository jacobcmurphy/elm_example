module Models exposing (..)

import RemoteData exposing (WebData)

type alias Model =
  { players : WebData (List Player)
  , newPlayer : NewPlayer
  , route : Route
  }

initialModel : Route -> Model
initialModel route =
  { players = RemoteData.Loading
  , newPlayer = { name = "", level = 0 }
  , route = route
  }

type alias PlayerId =
  String

type alias Player = 
  { id: PlayerId
  , name: String
  , level: Int
  }

type alias NewPlayer =
  { name: String
  , level: Int
  }

type Route
  = PlayersRoute
  | PlayerRoute PlayerId
  | NewPlayerRoute
  | NotFoundRoute
