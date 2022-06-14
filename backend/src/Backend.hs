{-# LANGUAGE LambdaCase, GADTs, OverloadedStrings #-}

module Backend where

import Common.Route
import Obelisk.Backend
import Database.PostgreSQL.Simple
import Data.Text
import Obelisk.Route
import Snap.Core
import Control.Monad.IO.Class (liftIO)
import qualified Data.Aeson as A

migration :: Query
migration = "CREATE TABLE IF NOT EXISTS contato\
            \ (id SERIAL PRIMARY KEY, nome TEXT NOT NULL)"

getConn :: ConnectInfo
getConn = ConnectInfo "ec2-52-72-99-110.compute-1.amazonaws.com"
                      5432 -- porta
                      "gqtibiwnwspkyr"
                      "e23689914c801917b1ad815a1bf5f1b8440aa97700b86a45bbb94f308839d882"
                      "d2bomkhqj5vrrt"


backend :: Backend BackendRoute FrontendRoute
backend = Backend
  { _backend_run = \serve -> do
      dbcon <- connect getConn
      serve $ do 
        \case
          BackendRoute_Contato :/ () -> do
              Just nome <- A.decode <$> readRequestBody 2000
              liftIO $ do
                  execute_ dbcon migration
                  execute dbcon "INSERT INTO contato (nome) VALUES (?)" [nome :: Text]
                  
              modifyResponse $ setResponseStatus 200 "OK"
          _ -> return ()

  , _backend_routeEncoder = fullRouteEncoder
  }
