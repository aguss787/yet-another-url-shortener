module Main exposing (main)

import Bootstrap.Navbar as Navbar
import Browser exposing (Document, UrlRequest(..))
import Browser.Navigation as Navigation
import Html.Styled exposing (text, toUnstyled)
import Message exposing (Message(..))
import Model exposing (Model, Page(..))
import Routing.Message
import Routing.Page exposing (urlToPage)
import Routing.Update
import Url exposing (Url)
import View.About
import View.NotFound
import View.Style exposing (toUnstyledDocument)
import View.Template exposing (withTemplate)


init : () -> Url.Url -> Navigation.Key -> ( Model, Cmd Message )
init _ url key =
    let
        ( navBarState, navBarCmd ) =
            Navbar.initialState NavbarMessage

        model =
            { navKey = key
            , navBarState = navBarState
            , page = NotFound
            , isLoading = False
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
                    { title = "URLs"
                    , body = [ text "List" ]
                    }

                About ->
                    View.About.view
    in
    content
        |> withTemplate model
        |> toUnstyledDocument


update : Message -> Model -> ( Model, Cmd Message )
update msg model =
    case msg of
        NavbarMessage state ->
            ( { model | navBarState = state }, Cmd.none )

        RoutingMessage message ->
            Routing.Update.update message model

        None ->
            ( model, Cmd.none )


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


main : Program () Model Message
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = onUrlRequest
        , onUrlChange = RoutingMessage << Routing.Message.InternalJump
        }
