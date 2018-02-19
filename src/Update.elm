module Update exposing (..)

import Commands exposing (savePlayerCmd, createPlayerCmd)
import Msgs exposing (Msg)
import Models exposing (Model, Player, NewPlayer)
import Navigation
import RemoteData
import Routing exposing(parseLocation)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Msgs.OnFetchPlayers response ->
      ( { model | players = response }, Cmd.none )
    Msgs.OnLocationChange location ->
      let
          newRoute =
            parseLocation location
      in
          ( { model | route = newRoute }, Cmd.none)
    Msgs.ChangeLocation path ->
      ( model, Navigation.newUrl path )
    Msgs.ChangeLevel player howMuch ->
      let
          updatedPlayer =
            { player | level = player.level + howMuch }
      in
          ( model, savePlayerCmd updatedPlayer )
    Msgs.ChangeName player newName ->
      let updatePlayer =
        { player | name = newName }
      in
        ( model, savePlayerCmd updatePlayer )
    Msgs.AddPlayer newPlayer playerName ->
      let newPlayer =
        { name = playerName, level = 0 } 
      in
        ( { model | newPlayer = newPlayer }, Cmd.none )
    Msgs.CreatePlayer newPlayer ->
      ( model, createPlayerCmd newPlayer )
    Msgs.OnPlayerCreate (Ok player) ->
      ( addCreatedPlayer model player, Cmd.none)
    Msgs.OnPlayerCreate (Err error) ->
      ( model, Cmd.none )
    Msgs.OnPlayerSave (Ok player) ->
      ( updatePlayer model player, Cmd.none)
    Msgs.OnPlayerSave (Err error) ->
      ( model, Cmd.none)

addCreatedPlayer : Model -> Player -> Model
addCreatedPlayer model createdPlayer =
  let
      addPlayerToList players =
        List.append players [createdPlayer]

      newPlayerList =
        RemoteData.map addPlayerToList model.players
  in
      { model | players = newPlayerList }

updatePlayer : Model -> Player -> Model
updatePlayer model updatedPlayer =
  let
      pick currentPlayer =
        if updatedPlayer.id == currentPlayer.id then
          updatedPlayer
        else
          currentPlayer

      updatePlayerList players =
        List.map pick players

      updatePlayers =
        RemoteData.map updatePlayerList model.players

  in
      { model | players = updatePlayers }
