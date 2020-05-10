module Routing.Page exposing (urlToPage)

import Command.Auth exposing (exchangeAuthCode)
import Command.UrlEntry exposing (getUrlEntry)
import Message exposing (Message)
import Model exposing (Model, Page(..))
import Url exposing (Url)
import Url.Parser as Url exposing ((</>), (<?>), Parser)
import Url.Parser.Query as Query
import Utils.Update exposing (handleNonExistenceSession, startLoading)


type alias PageSpec model msg =
    { init : model -> ( model, Cmd msg )
    }


urlToPage : Url -> PageSpec Model Message
urlToPage url =
    url
        |> Url.parse urlParser
        |> Maybe.withDefault notFoundSpec


urlParser : Parser (PageSpec Model Message -> a) a
urlParser =
    Url.oneOf
        [ Url.map urlListSpec (Url.top <?> Query.int "page" <?> Query.int "per_page")
        , Url.map urlListSpec (Url.s "list" <?> Query.int "page" <?> Query.int "per_page")
        , Url.map aboutSpec (Url.s "about")
        , Url.map loginSpec (Url.s "login")
        , Url.map callbackSpec (Url.s "callback" <?> Query.string "auth_code")
        ]


notFoundSpec : PageSpec Model Message
notFoundSpec =
    { init = noAction NotFound
    }


urlListSpec : Maybe Int -> Maybe Int -> PageSpec Model Message
urlListSpec page perPage =
    { init =
        requireLogin
            << withAction
                (\model ->
                    getUrlEntry
                        model.token
                        (Maybe.withDefault 0 page)
                        (Maybe.withDefault 10 perPage)
                )
            << noAction UrlList
    }


aboutSpec : PageSpec Model Message
aboutSpec =
    { init = noAction About
    }


loginSpec : PageSpec Model Message
loginSpec =
    { init = noAction Login
    }


callbackSpec : Maybe String -> PageSpec Model Message
callbackSpec authCodeQuery =
    { init =
        case authCodeQuery of
            Just authCode ->
                \model ->
                    startLoading
                        ( { model
                            | page = Login
                          }
                        , exchangeAuthCode authCode
                        )

            Nothing ->
                \model ->
                    handleNonExistenceSession "Unable to retrieve access token"
                        ( model
                        , Cmd.none
                        )
    }


noAction : Page -> Model -> ( Model, Cmd msg )
noAction page model =
    ( { model
        | page = page
      }
    , Cmd.none
    )


requireLogin : ( Model, Cmd Message ) -> ( Model, Cmd Message )
requireLogin ( model, cmd ) =
    case model.token of
        Just _ ->
            ( model, cmd )

        Nothing ->
            handleNonExistenceSession "Login required" ( model, Cmd.none )


withAction : (Model -> Cmd msg) -> ( Model, Cmd msg ) -> ( Model, Cmd msg )
withAction cmdFunc ( model, cmd ) =
    ( model, Cmd.batch [ cmdFunc model, cmd ] )
