module View.Template exposing (withTemplate)

import Bootstrap.Grid as Grid
import Bootstrap.Navbar as Navbar
import Html.Attributes as Unstyled
import Html.Styled exposing (Html, fromUnstyled, node, text, toUnstyled)
import Html.Styled.Attributes exposing (href, rel)
import Message exposing (Message(..))
import Model exposing (Model)
import View.Style exposing (StyledDocument)


withTemplate : Model -> StyledDocument Message -> StyledDocument Message
withTemplate model document =
    { title = document.title ++ " - YAUS"
    , body =
        document.body
            |> withNavbar model
            |> withCss
    }


withCss : List (Html Message) -> List (Html Message)
withCss content =
    List.concat
        [ [ cssLink "https://cdn.agus.dev/bootstrap.min.css"
          , cssLink "https://cdn.agus.dev/font-awesome.min.css"
          ]
        , content
        ]


withNavbar : Model -> List (Html Message) -> List (Html Message)
withNavbar model content =
    List.map fromUnstyled <|
        List.concat
            [ [ Navbar.config NavbarMessage
                    |> Navbar.withAnimation
                    |> Navbar.brand [ Unstyled.href "/" ] [ toUnstyled <| text "Yet Another URL Shortener" ]
                    |> Navbar.items
                        [ Navbar.itemLink [ Unstyled.href "/list" ] [ toUnstyled <| text "Urls" ]
                        , Navbar.itemLink [ Unstyled.href "/about" ] [ toUnstyled <| text "Why?" ]
                        ]
                    |> Navbar.view model.navBarState
              ]
            , [ Grid.container [ Unstyled.style "margin-top" "10px" ] <| List.map toUnstyled content ]
            ]


cssLink str =
    node "link"
        [ rel "stylesheet"
        , href str
        ]
        []
