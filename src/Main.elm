module Main exposing (..)

import Html


main : Program Never Page Msg
main =
    Html.program
        { init = init
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }
