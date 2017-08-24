module Update exposing (update)

import Data.Schedule exposing (Schedule, Session, crossoverSchedules, evaluateSchedule, mutateScheduleGenerator, scheduleGenerator, sessions)
import Dict exposing (Dict)
import Genetic exposing (Method(..), evolveSolution)
import Model exposing (Model, Msg)
import Random exposing (Generator, Seed)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    ( model, Cmd.none )


args :
    Dict String Session
    ->
        { randomDnaGenerator : Generator Schedule
        , evaluateSolution : Schedule -> Float
        , crossoverDnas : Schedule -> Schedule -> Schedule
        , mutateDna : Schedule -> Generator Schedule
        , isDoneEvolving : Schedule -> Float -> Int -> Bool
        , initialSeed : Seed
        , method : Method
        }
args sessionsDict =
    let
        allSessions =
            Dict.values sessionsDict
    in
    { randomDnaGenerator = scheduleGenerator allSessions 0
    , evaluateSolution = evaluateSchedule
    , crossoverDnas = crossoverSchedules
    , mutateDna = mutateScheduleGenerator allSessions 0
    , isDoneEvolving = isDoneEvolving
    , initialSeed = Random.initialSeed 123
    , method = MinimizePenalty
    }


isDoneEvolving : Schedule -> Float -> Int -> Bool
isDoneEvolving schedule score generations =
    Debug.crash ""
