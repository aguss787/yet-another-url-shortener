module Command.Auth exposing (..)

import Http
import Message exposing (Message(..), tokenPayloadDecoder)


exchangeAuthCode : String -> Cmd Message
exchangeAuthCode authCode =
    Http.post
        { url = "https://url.agus.dev/exchange"
        , body = Http.stringBody "text/plain" authCode
        , expect = Http.expectJson LoginSuccess tokenPayloadDecoder
        }
