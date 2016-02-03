module Main where

-- import Debug exposing (log)
-- import Html exposing (text)


type alias UserRecord =
  { age : Int
  , job : String
  }


port addUser : Signal (String, UserRecord)
-- port addUser = Signal.constant ("rozgo", {age = 37, job = "programmer"})

port requestUser : Signal String
port requestUser =
    Signal.map (\(name, data) -> name) addUser


-- main =
--   -- Signal.map (\(name, data) -> text name) addUser
--   let a = Signal.map (\(name, data) -> log name) addUser
--   in
--     text "hello folks"
  -- log <~ user

-- port requestUser : Signal String
-- port requestUser =
--     Signal "rozgo"
