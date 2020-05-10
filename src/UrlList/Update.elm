module UrlList.Update exposing (..)

import Message exposing (Message, UrlListMessageType(..))
import Model exposing (Model, Page(..))
import Utils.Update exposing (handleRequestError)


update : UrlListMessageType -> Model -> ( Model, Cmd Message )
update message model =
    case message of
        GetUrlEntry httpResp ->
            case httpResp of
                Ok resp ->
                    ( { model
                        | urlList =
                            { urls = resp.urls
                            , page = resp.page
                            , perPage = resp.perPage
                            }
                      }
                    , Cmd.none
                    )

                Err error ->
                    handleRequestError error ( model, Cmd.none )
