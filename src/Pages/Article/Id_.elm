module Pages.Article.Id_ exposing (Article, Model, Msg, decodeArticle, page)

import Gen.Params.Article.Id_ exposing (Params)
import Html exposing (div, p, text)
import Http
import Json.Decode
import Page
import RemoteData exposing (RemoteData(..), WebData)
import Request
import Shared
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page _ req =
    Page.element
        { init = init req
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- INIT


type alias Article =
    { id : Int
    , title : String
    , body : String
    , userId : Int
    }


type alias Model =
    { article : WebData Article }


init : Request.With Params -> ( Model, Cmd Msg )
init req =
    ( { article = Loading }
    , getArticle req
    )


getArticle : Request.With Params -> Cmd Msg
getArticle req =
    Http.get
        { url = "https://jsonplaceholder.typicode.com/posts/" ++ req.params.id
        , expect = Http.expectJson (RemoteData.fromResult >> ArticleResponse) decodeArticle
        }


decodeArticle : Json.Decode.Decoder Article
decodeArticle =
    Json.Decode.map4 Article
        (Json.Decode.field "id" Json.Decode.int)
        (Json.Decode.field "title" Json.Decode.string)
        (Json.Decode.field "body" Json.Decode.string)
        (Json.Decode.field "userId" Json.Decode.int)



-- UPDATE


type Msg
    = ArticleResponse (WebData Article)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ArticleResponse response ->
            ( { model | article = response }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> View msg
view model =
    case model.article of
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

        Success article ->
            { title = article.title
            , body =
                [ div []
                    [ p [] [ text article.title ]
                    , p [] [ text article.body ]
                    ]
                ]
            }
