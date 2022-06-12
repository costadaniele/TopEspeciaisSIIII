module Backend where

import Common.Route
import Obelisk.Backend
import Database.PostgreSQL.Simple

backend :: Backend BackendRoute FrontendRoute
backend = Backend
  { _backend_run = \serve -> serve $ const $ return ()
  , _backend_routeEncoder = fullRouteEncoder
  }
