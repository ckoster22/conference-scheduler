module View exposing (view)

import Html exposing (Html, text)
import Model exposing (Model, Msg)


view : Model -> Html Msg
view model =
    text "Hello world"
