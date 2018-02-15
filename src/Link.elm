module Link exposing (..)

import Html exposing (..)
import Json.Decode as Decode
import Html.Events exposing (onWithOptions)

onLinkClick : msg -> Attribute msg
onLinkClick message =
    let
        options =
            { stopPropagation = False
            , preventDefault = True
            }
    in
        onWithOptions "click" options (Decode.succeed message)