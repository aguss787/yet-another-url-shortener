module Command.UrlEntry exposing (..)

import Http
import Message exposing (Message(..), UrlListMessageType(..))
import Model exposing (urlEntryListResponseDecoder)


getUrlEntry : Maybe String -> Int -> Int -> Cmd Message
getUrlEntry token page per_page =
    let
        query =
            String.concat
                [ "?page="
                , String.fromInt page
                , "&per_page="
                , String.fromInt per_page
                ]
    in
    Http.request
        { method = "GET"
        , url = "https://url.agus.dev/" ++ query
        , headers = [ Http.header "Authorization" (Maybe.withDefault "" token) ]
        , body = Http.emptyBody
        , expect = Http.expectJson (UrlListMessage << GetUrlEntry) urlEntryListResponseDecoder
        , timeout = Nothing
        , tracker = Nothing
        }
