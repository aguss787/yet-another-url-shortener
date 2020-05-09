module View.About exposing (view)

import Html.Styled exposing (text)
import View.Style exposing (StyledDocument, centered)


view : StyledDocument msg
view =
    { title = "Why?"
    , body =
        [ centered
            [ text "Why not? I need something to do (pls send help)"
            ]
        ]
    }
