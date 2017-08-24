module Data.Tag exposing (Tag, Tags)

import Set exposing (Set)


type Tags
    = Tags (Set String)


type Tag
    = Tag String


contains : Tag -> Tags -> Bool
contains tag tags =
    case ( tags, tag ) of
        ( Tags labels, Tag label ) ->
            Set.member label labels
