module Utils.Update exposing (..)

import Browser.Navigation as Navigation
import Http
import LocalStorage exposing (removeToken)
import Message exposing (Message)
import Model exposing (Model, Page(..))


finishLoading : ( Model, Cmd Message ) -> ( Model, Cmd Message )
finishLoading ( model, cmd ) =
    ( { model
        | isLoading = False
      }
    , cmd
    )


startLoading : ( Model, Cmd Message ) -> ( Model, Cmd Message )
startLoading ( model, cmd ) =
    ( { model
        | isLoading = True
      }
    , cmd
    )


handleRequestError : Http.Error -> ( Model, Cmd Message ) -> ( Model, Cmd Message )
handleRequestError error =
    case error of
        Http.BadStatus code ->
            if code == 401 then
                handleNonExistenceSession "Session expired"

            else
                reportError error

        _ ->
            reportError error


handleNonExistenceSession : String -> ( Model, Cmd Message ) -> ( Model, Cmd Message )
handleNonExistenceSession message ( model, cmd ) =
    ( { model
        | page = Login
        , token = Nothing
        , errorMessage = Just message
        , ok = False
      }
    , Cmd.batch
        [ Navigation.pushUrl model.navKey "/login"
        , removeToken
        , cmd
        ]
    )


reportError : Http.Error -> ( Model, Cmd Message ) -> ( Model, Cmd Message )
reportError error ( model, cmd ) =
    ( { model
        | errorMessage = Just <| httpErrorToString error
        , ok = False
      }
    , cmd
    )


httpErrorToString : Http.Error -> String
httpErrorToString error =
    case error of
        Http.BadUrl url ->
            "Bad url: " ++ url

        Http.Timeout ->
            "Request timeout"

        Http.NetworkError ->
            "Network error"

        Http.BadStatus code ->
            "Server error with code " ++ String.fromInt code

        Http.BadBody str ->
            "Unable to send request because of bad request body " ++ str
