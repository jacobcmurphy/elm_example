module Update exposing (..)

import Commands exposing (savePlayerCmd, createPlayerCmd, deletePlayerCmd)
import Msgs exposing (Msg)
import Models exposing (Model, Player, NewPlayer)
import Navigation
import RemoteData
import Routing exposing(parseLocation, playersPath)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Msgs.OnFetchPlayers response ->
      ( { model | players = response }, Cmd.none )
    Msgs.OnLocationChange location ->
      ( { model | route = parseLocation location }, Cmd.none)
    Msgs.ChangeLocation path ->
      ( model, Navigation.newUrl path )
    Msgs.ChangeLevel player howMuch ->
      let
          updatedPlayer =
            { player | level = player.level + howMuch }
      in
          ( updatePlayer model updatedPlayer, Cmd.none )
    Msgs.ChangeName player newName ->
      let updatedPlayer =
        { player | name = newName }
      in
        ( updatePlayer model updatedPlayer, Cmd.none )
    Msgs.SavePlayer player ->
      ( model , savePlayerCmd player )
    Msgs.OnPlayerSave (Ok player) ->
      ( model, Navigation.newUrl playersPath )
    Msgs.OnPlayerSave (Err error) ->
      ( model, Cmd.none)
    Msgs.AddPlayer newPlayer playerName ->
      let newPlayer =
        { name = playerName, level = 0 } 
      in
        ( { model | newPlayer = newPlayer }, Cmd.none )
    Msgs.CreatePlayer newPlayer ->
      ( model, createPlayerCmd newPlayer )
    Msgs.OnPlayerCreate (Ok player) ->
      ( addCreatedPlayer model player, Navigation.newUrl playersPath)
    Msgs.OnPlayerCreate (Err error) ->
      ( model, Cmd.none )
    Msgs.DeletePlayer player ->
      ( model, deletePlayerCmd player)
    Msgs.OnPlayerDelete (Ok player) ->
      ( removePlayer model player, Navigation.newUrl playersPath )
    Msgs.OnPlayerDelete (Err error) ->
      ( model, Cmd.none )

addCreatedPlayer : Model -> Player -> Model
addCreatedPlayer model createdPlayer =
  let
      addPlayerToList players =
        List.append players [createdPlayer]
      playerList =
        RemoteData.map addPlayerToList model.players
  in
      { model | players = playerList }

removePlayer : Model -> Player -> Model
removePlayer model player =
  let
    removePlayerFromList players =
      players
        |> List.filter (\p -> p.id /= player.id)
    playerList =
      RemoteData.map removePlayerFromList model.players
  in
    { model | players = playerList}

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
    playerList =
      RemoteData.map updatePlayerList model.players
  in
      { model | players = playerList }
