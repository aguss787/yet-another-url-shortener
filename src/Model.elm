module Model exposing (..)

import Bootstrap.Navbar as Navbar
import Browser.Navigation as Navigation
import Json.Decode exposing (field, int, list, map2, map3, string)


type Page
    = NotFound
    | UrlList
    | About
    | Login


type alias UrlEntry =
    { key : String
    , target : String
    }


urlEntryDecoder : Json.Decode.Decoder UrlEntry
urlEntryDecoder =
    map2 UrlEntry
        (field "key" string)
        (field "target" string)


type alias UrlEntryListResponse =
    { urls : List UrlEntry
    , page : Int
    , perPage : Int
    }


urlEntryListResponseDecoder : Json.Decode.Decoder UrlEntryListResponse
urlEntryListResponseDecoder =
    map3 UrlEntryListResponse
        (field "urls" (list urlEntryDecoder))
        (field "page" int)
        (field "per_page" int)


type alias UrlListPageModel =
    { urls : List UrlEntry
    , page : Int
    , perPage : Int
    }


type alias Model =
    { navKey : Navigation.Key
    , navBarState : Navbar.State
    , token : Maybe String
    , urlList : UrlListPageModel
    , page : Page
    , isLoading : Bool
    , errorMessage : Maybe String
    , callbackUrl : String
    , clientID : String
    , ok : Bool
    }
