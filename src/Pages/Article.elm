module Pages.Article exposing (Model, Msg, page)

import Gen.Params.Article exposing (Params)
import Gen.Route as Route
import Html exposing (a, div, p, text)
import Html.Attributes exposing (href)
import Http
import Json.Decode exposing (Decoder, list)
import Page
import Pages.Article.Id_ exposing (Article, decodeArticle)
import RemoteData exposing (RemoteData(..), WebData)
import Request
import Shared
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page _ _ =
    Page.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Articles =
    List Article


type alias Model =
    { articles : WebData Articles }


init : ( Model, Cmd Msg )
init =
    ( { articles = Loading }
    , getArticles
    )


getArticles : Cmd Msg
getArticles =
    Http.get
        { url = "https://jsonplaceholder.typicode.com/posts"
        , expect = Http.expectJson (RemoteData.fromResult >> ArticlesResponse) decodeArticles
        }


decodeArticles : Decoder Articles
decodeArticles =
    list decodeArticle



-- UPDATE


type Msg
    = ArticlesResponse (WebData Articles)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ArticlesResponse response ->
            ( { model | articles = response }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View Msg
view model =
    case model.articles of
        NotAsked ->
            { title = "Initialising."
            , body = [ text "Initialising." ]
            }

        Loading ->
            { title = "Loading."
            , body = [ text "Loading." ]
            }

        Failure err ->
            { title = "Error."
            , body = [ text "Error." ]
            }

        Success articles ->
            { title = "Liste des articles"
            , body =
                let
                    displayArticle article =
                        div []
                            [ a
                                [ href (Route.toHref (Route.Article__Id_ { id = String.fromInt article.id })) ]
                                [ text article.title ]
                            ]
                in
                [ div []
                    (List.map
                        (\article -> displayArticle article)
                        articles
                    )
                ]
            }
