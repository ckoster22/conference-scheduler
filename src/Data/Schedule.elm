module Data.Schedule exposing (Schedule, Session, crossoverSchedules, evaluateSchedule, mutateScheduleGenerator, scheduleGenerator, sessions)

import Data.Tag exposing (Tags)
import Dict exposing (Dict)
import List.Extra exposing (getAt, indexedFoldl, updateIfIndex)
import Random exposing (Generator, list)
import Random.Extra exposing (constant)
import Random.List exposing (shuffle)


type Schedule
    = Schedule (List Session)


type alias Session =
    { title : String
    , description : String
    , time : Float
    , speaker : Speaker
    , tags : Tags
    }


type alias Speaker =
    { name : String
    , availability : Availability
    }


type alias Availability =
    Dict Int Bool


isSessionSpeakerAvailable : Session -> Int -> Bool
isSessionSpeakerAvailable session index =
    session.speaker.availability
        |> Dict.get index
        |> Maybe.withDefault False


sessions : Schedule -> List Session
sessions schedule =
    case schedule of
        Schedule sessions ->
            sessions


isScheduleValid : Schedule -> Bool
isScheduleValid schedule =
    {-
       1. speaker availability
       2. speaker speaking at different time slots
    -}
    sessions schedule
        |> indexedFoldl
            (\index session isValid ->
                if isValid then
                    isSessionSpeakerAvailable session index
                else
                    False
            )
            True


maybeTryAgain : Int -> Generator Schedule -> Schedule -> Generator Schedule
maybeTryAgain iterations generator schedule =
    if isScheduleValid schedule || iterations > 100 then
        constant schedule
    else
        generator


scheduleGenerator : List Session -> Int -> Generator Schedule
scheduleGenerator allSessions iterations =
    allSessions
        |> shuffle
        |> Random.map (List.take 18)
        |> Random.map Schedule
        |> Random.andThen
            (maybeTryAgain
                iterations
                (scheduleGenerator allSessions (iterations + 1))
            )


crossoverSchedules : Schedule -> Schedule -> Schedule
crossoverSchedules schedule1 schedule2 =
    case ( schedule1, schedule2 ) of
        ( Schedule s1Sessions, Schedule s2Sessions ) ->
            let
                size =
                    List.length s1Sessions // 2
            in
            List.take size s2Sessions
                |> List.append (List.drop size s1Sessions)
                |> Schedule


mutateScheduleGenerator : List Session -> Int -> Schedule -> Generator Schedule
mutateScheduleGenerator allSessions iterations schedule =
    case schedule of
        Schedule sessions ->
            Random.int 0 (List.length sessions - 1)
                |> Random.map (mutateSessions allSessions)
                |> Random.map Schedule
                |> Random.andThen
                    (maybeTryAgain
                        iterations
                        (scheduleGenerator allSessions (iterations + 1))
                    )


mutateSessions : List Session -> Int -> List Session
mutateSessions allSessions index =
    allSessions
        |> updateIfIndex
            (\listIndex -> index == listIndex)
            (\original ->
                case getAt index allSessions of
                    Just session ->
                        session

                    Nothing ->
                        original
            )


evaluateSchedule : Schedule -> Float
evaluateSchedule schedule =
    {-
       Similar topics spread out at different times
       Similar topics in the same room
    -}
    Debug.crash ""
