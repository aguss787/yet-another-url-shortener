module Model exposing (..)

import Bootstrap.Navbar as Navbar
import Browser.Navigation as Navigation


type Page
    = NotFound
    | UrlList
    | About


type alias Model =
    { navKey : Navigation.Key
    , navBarState : Navbar.State
    , page : Page
    , isLoading : Bool
    }
