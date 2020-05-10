module Update exposing (..)

import Browser.Navigation as Navigation
import LocalStorage exposing (removeToken, storeToken)
import Message exposing (Message(..))
import Model exposing (Model)
import Routing.Update
import UrlList.Update
import Utils.Update exposing (finishLoading, httpErrorToString)


update : Message -> Model -> ( Model, Cmd Message )
update msg old_model =
    let
        model =
            { old_model | ok = True }
    in
    handleOk <|
        case msg of
            NavbarMessage state ->
                ( { model | navBarState = state }, Cmd.none )

            RoutingMessage message ->
                Routing.Update.update message model

            None ->
                ( model, Cmd.none )

            Logout ->
                handleLogout ( model, Cmd.none )

            LoginStart ->
                ( model, Navigation.load <| "https://sso.agus.dev/authorize?client_id=" ++ model.clientID ++ "&redirect_uri=" ++ model.callbackUrl )

            LoginSuccess httpResp ->
                finishLoading <|
                    case httpResp of
                        Ok tokenPayload ->
                            ( { model
                                | token = Just tokenPayload.accessToken
                              }
                            , Cmd.batch
                                [ storeToken tokenPayload.accessToken
                                , Navigation.pushUrl model.navKey "/"
                                ]
                            )

                        Err error ->
                            ( { model
                                | token = Nothing
                                , errorMessage = Just <| httpErrorToString error
                                , ok = False
                              }
                            , Cmd.batch
                                [ removeToken
                                , Navigation.pushUrl model.navKey "/login"
                                ]
                            )

            UrlListMessage urlListMessage ->
                UrlList.Update.update urlListMessage model


handleLogout : ( Model, Cmd Message ) -> ( Model, Cmd Message )
handleLogout ( model, cmd ) =
    ( { model
        | token = Nothing
      }
    , Cmd.batch
        [ removeToken
        , Navigation.pushUrl model.navKey "/"
        , cmd
        ]
    )


handleOk : ( Model, Cmd Message ) -> ( Model, Cmd Message )
handleOk ( model, cmd ) =
    if model.ok then
        ( { model | errorMessage = Nothing }, cmd )

    else
        ( model, cmd )
