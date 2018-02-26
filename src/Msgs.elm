module Msgs exposing (..)

import Http
import Models exposing (Player, NewPlayer)
import Navigation exposing (Location)
import RemoteData exposing (WebData)

type Msg
  = OnFetchPlayers (WebData (List Player))
  | OnLocationChange Location
  | ChangeLocation String
  | ChangeLevel Player Int
  | ChangeName Player String
  | SavePlayer Player
  | OnPlayerSave (Result Http.Error Player)
  | AddPlayer NewPlayer String
  | CreatePlayer NewPlayer
  | OnPlayerCreate (Result Http.Error Player)
  | DeletePlayer Player
  | OnPlayerDelete (Result Http.Error Player)


