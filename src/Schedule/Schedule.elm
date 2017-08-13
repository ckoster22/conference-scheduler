module Schedule.Schedule exposing (Day, Schedule, Session)


type Schedule
    = Schedule String (List Day)


schedule : String -> List Day -> Schedule
schedule =
    Schedule


type Day
    = Day Session Session Session Session Session Session


day : Session -> Session -> Session -> Session -> Session -> Session -> Day
day =
    Day


type alias Session =
    { title : String
    , description : String
    , time_ : Maybe Float
    }
