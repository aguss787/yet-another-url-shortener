module Routing.Page exposing (urlToPage)

import Message exposing (Message)
import Model exposing (Model, Page(..))
import Url exposing (Url)
import Url.Parser as Url exposing ((</>), Parser)


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
        [ Url.map urlListSpec Url.top
        , Url.map urlListSpec (Url.s "list")
        , Url.map aboutSpec (Url.s "about")
        ]


notFoundSpec : PageSpec Model Message
notFoundSpec =
    { init = noAction NotFound
    }


urlListSpec : PageSpec Model Message
urlListSpec =
    { init = noAction UrlList
    }


aboutSpec : PageSpec Model Message
aboutSpec =
    { init = noAction About
    }


noAction : Page -> Model -> ( Model, Cmd msg )
noAction page model =
    ( { model
        | page = page
      }
    , Cmd.none
    )
