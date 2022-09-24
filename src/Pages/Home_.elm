module Pages.Home_ exposing (view)

import Gen.Route as Route
import Html exposing (a, div, text)
import Html.Attributes exposing (href)
import View exposing (View)


view : View msg
view =
    { title = "Homepage"
    , body =
        [ div []
            [ a
                [ href (Route.toHref Route.Article) ]
                [ text "Voir tous nos articles !" ]
            ]
        ]
    }
