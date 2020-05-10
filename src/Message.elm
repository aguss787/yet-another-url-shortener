module Message exposing (..)

import Bootstrap.Navbar as Navbar
import Http
import Json.Decode exposing (field, map2, string)
import Model exposing (UrlEntryListResponse)
import Routing.Message


type alias TokenPayload =
    { accessToken : String
    , refreshToken : String
    }


tokenPayloadDecoder : Json.Decode.Decoder TokenPayload
tokenPayloadDecoder =
    map2 TokenPayload
        (field "access_token" string)
        (field "refresh_token" string)


type UrlListMessageType
    = GetUrlEntry (Result Http.Error UrlEntryListResponse)


type Message
    = None
    | NavbarMessage Navbar.State
    | RoutingMessage Routing.Message.Message
    | Logout
    | LoginStart
    | LoginSuccess (Result Http.Error TokenPayload)
    | UrlListMessage UrlListMessageType
