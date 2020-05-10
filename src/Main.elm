module Main exposing (main)

import Bootstrap.Navbar as Navbar
import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Navigation
import Message exposing (Message(..))
import Model exposing (Model, Page(..))
import Routing.Message
import Routing.Page exposing (urlToPage)
import Update exposing (update)
import Url exposing (Url)
import View.About
import View.Login
import View.NotFound
import View.Style exposing (toUnstyledDocument)
import View.Template exposing (withTemplate)
import View.UrlList


init : Flag -> Url.Url -> Navigation.Key -> ( Model, Cmd Message )
init flag url key =
    let
        ( navBarState, navBarCmd ) =
            Navbar.initialState NavbarMessage

        model : Model
        model =
            { navKey = key
            , navBarState = navBarState
            , page = NotFound
            , token = flag.token
            , isLoading = False
            , urlList =
                { urls = []
                , page = 0
                , perPage = 10
                }
            , errorMessage = Nothing
            , callbackUrl = flag.callbackUrl
            , clientID = flag.clientID
            , ok = True
            }

        ( nextModel, nextCmd ) =
            (urlToPage url).init model
    in
    ( nextModel
    , Cmd.batch
        [ navBarCmd
        , nextCmd
        ]
    )


view : Model -> Document Message
view model =
    let
        content =
            case model.page of
                NotFound ->
                    View.NotFound.view

                UrlList ->
                    View.UrlList.view model

                About ->
                    View.About.view

                Login ->
                    View.Login.view model
    in
    content
        |> withTemplate model
        |> toUnstyledDocument


onUrlRequest : UrlRequest -> Message
onUrlRequest urlRequest =
    Message.RoutingMessage <|
        case urlRequest of
            Internal url ->
                Routing.Message.InternalRequest url

            External url ->
                Routing.Message.ExternalRequest url


subscriptions : Model -> Sub Message
subscriptions model =
    Navbar.subscriptions model.navBarState NavbarMessage


type alias Flag =
    { token : Maybe String
    , callbackUrl : String
    , clientID : String
    }


main : Program Flag Model Message
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = onUrlRequest
        , onUrlChange = RoutingMessage << Routing.Message.InternalJump
        }
