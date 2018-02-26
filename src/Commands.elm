module Commands exposing (..)

import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode as Encode
import Msgs exposing (Msg)
import Models exposing (PlayerId, Player, NewPlayer)
import RemoteData

playerUrl : PlayerId -> String
playerUrl playerId =
  "http://localhost:4000/players/" ++ playerId

savePlayerCmd : Player -> Cmd Msg
savePlayerCmd player =
  savePlayerRequest player
    |> Http.send Msgs.OnPlayerSave

savePlayerRequest : Player -> Http.Request Player
savePlayerRequest player =
  Http.request
    { body = playerEncoder player |> Http.jsonBody
    , expect = Http.expectJson playerDecoder
    , headers = []
    , method = "PATCH"
    , timeout = Nothing
    , url = playerUrl player.id
    , withCredentials = False
    }

playerEncoder : Player -> Encode.Value
playerEncoder player =
  let
      attributes =
        [ ("id", Encode.string player.id)
        , ("name", Encode.string player.name)
        , ("level", Encode.int player.level)
        ]
  in
      Encode.object attributes

createPlayerCmd : NewPlayer -> Cmd Msg
createPlayerCmd newPlayer =
  createPlayerRequest newPlayer
    |> Http.send Msgs.OnPlayerCreate

createPlayerRequest : NewPlayer -> Http.Request Player
createPlayerRequest newPlayer =
  Http.request
    { body = newPlayerEncoder newPlayer |> Http.jsonBody
    , expect = Http.expectJson playerDecoder
    , headers = []
    , method = "POST"
    , timeout = Nothing
    , url = "http://localhost:4000/players"
    , withCredentials = False
    }

newPlayerEncoder : NewPlayer -> Encode.Value
newPlayerEncoder newPlayer =
  let
      attributes =
        [ ("name", Encode.string newPlayer.name)
        , ("level", Encode.int newPlayer.level)
        ]
  in
      Encode.object attributes

deletePlayerCmd : Player -> Cmd Msg
deletePlayerCmd player =
  let 
    request = Http.request
      { body = Http.emptyBody
      -- , expect = Ok player |> always >> Http.expectStringResponse
      , expect =  Http.expectStringResponse << always <| Ok player
      -- , expect = Http.expectStringResponse (\x -> Ok player)
      , headers =[]
      , method = "DELETE"
      , timeout = Nothing
      , url = playerUrl player.id
      , withCredentials = False
      }
  in
    Http.send Msgs.OnPlayerDelete request

fetchPlayers : Cmd Msg
fetchPlayers =
  Http.get fetchPlayersUrl playersDecoder
    |> RemoteData.sendRequest
    |> Cmd.map Msgs.OnFetchPlayers

fetchPlayersUrl : String
fetchPlayersUrl =
  "http://localhost:4000/players"

playersDecoder : Decode.Decoder (List Player)
playersDecoder =
  Decode.list playerDecoder

playerDecoder : Decode.Decoder Player
playerDecoder =
  decode Player
    |> required "id" Decode.string
    |> required "name" Decode.string
    |> required "level" Decode.int
