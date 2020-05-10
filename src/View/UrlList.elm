module View.UrlList exposing (view)

import Bootstrap.Table as Table
import Html.Styled exposing (Html, a, fromUnstyled, text, toUnstyled)
import Html.Styled.Attributes exposing (href)
import Message exposing (Message)
import Model exposing (Model)
import View.Style exposing (StyledDocument)


view : Model -> StyledDocument Message
view model =
    { title = "URLs"
    , body =
        [ fromUnstyled <|
            Table.table
                { options = []
                , thead =
                    Table.simpleThead
                        [ Table.th [] [ toUnstyled <| text "Key" ]
                        , Table.th [] [ toUnstyled <| text "Target" ]
                        , Table.th [] [ toUnstyled <| text "Action" ]
                        ]
                , tbody =
                    Table.tbody
                        []
                        (List.map
                            (\urlEntry ->
                                Table.tr []
                                    [ Table.td [] [ toUnstyled <| urlKeyView urlEntry.key ]
                                    , Table.td [] [ toUnstyled <| text urlEntry.target ]
                                    , Table.td [] [ toUnstyled <| text "Edit" ]
                                    ]
                            )
                            model.urlList.urls
                        )
                }
        ]
    }


urlKeyView : String -> Html msg
urlKeyView key =
    a [ href <| toUrl key ] [ text key ]


toUrl : String -> String
toUrl key =
    "https://s.agus.dev/" ++ key
