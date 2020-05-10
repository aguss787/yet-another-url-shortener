module View.Template exposing (withTemplate)

import Bootstrap.Alert as Alert
import Bootstrap.Button as Button
import Bootstrap.Grid as Grid
import Bootstrap.Navbar as Navbar
import Bootstrap.Spinner as Spinner
import Bootstrap.Text as Text
import Css exposing (pct, px)
import Html.Attributes as Unstyled
import Html.Styled exposing (Html, div, fromUnstyled, node, text, toUnstyled)
import Html.Styled.Attributes exposing (css, href, rel)
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
    List.map
        fromUnstyled
    <|
        List.concat
            [ [ Navbar.config NavbarMessage
                    |> Navbar.withAnimation
                    |> Navbar.brand [ Unstyled.href "/" ] [ toUnstyled <| text "Yet Another URL Shortener" ]
                    |> Navbar.items
                        [ Navbar.itemLink [ Unstyled.href "/list" ] [ toUnstyled <| navItem "Urls" ]
                        , Navbar.itemLink [ Unstyled.href "/about" ] [ toUnstyled <| navItem "Why?" ]
                        ]
                    |> withLogoutButton model.token
                    |> Navbar.view model.navBarState
              ]
            , case model.errorMessage of
                Nothing ->
                    []

                Just message ->
                    [ Alert.simpleDanger [] [ toUnstyled <| text message ] ]
            , [ Grid.container [ Unstyled.style "margin-top" "10px" ] <| List.map toUnstyled content ]
            , if model.isLoading then
                [ toUnstyled <| loadingOverlay ]

              else
                []
            ]


withLogoutButton : Maybe a -> Navbar.Config Message -> Navbar.Config Message
withLogoutButton token =
    case token of
        Nothing ->
            identity

        Just _ ->
            Navbar.customItems
                [ Navbar.textItem []
                    [ Button.button
                        [ Button.primary
                        , Button.small
                        , Button.onClick Logout
                        ]
                        [ toUnstyled <| text "Logout" ]
                    ]
                ]


navItem : String -> Html msg
navItem content =
    div [ css [ Css.paddingTop (px 5) ] ] [ text content ]


loadingOverlay : Html msg
loadingOverlay =
    div
        [ css
            [ Css.height (pct 100)
            , Css.width (pct 100)
            , Css.position Css.fixed
            , Css.zIndex (Css.int 1)
            , Css.top (px 0)
            , Css.left (px 0)
            , Css.textAlign Css.center
            , Css.backgroundColor (Css.rgba 0 0 0 0.9)
            ]
        ]
        [ div
            [ css
                [ Css.position Css.relative
                , Css.top (pct 20)
                ]
            ]
            [ fromUnstyled <| Spinner.spinner [ Spinner.large, Spinner.color Text.primary ] [] ]
        ]


cssLink str =
    node "link"
        [ rel "stylesheet"
        , href str
        ]
        []
