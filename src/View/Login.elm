module View.Login exposing (view)

import Html.Styled exposing (button, text)
import Html.Styled.Events exposing (onClick)
import Message exposing (Message)
import Model exposing (Model)
import View.Style exposing (StyledDocument)


view : Model -> StyledDocument Message
view _ =
    { title = "URLs"
    , body =
        [ button [ onClick Message.LoginStart ] [ text "login with agus.dev" ]
        ]
    }
