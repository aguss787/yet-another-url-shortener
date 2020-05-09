module Message exposing (..)

import Bootstrap.Navbar as Navbar
import Routing.Message


type Message
    = None
    | NavbarMessage Navbar.State
    | RoutingMessage Routing.Message.Message
