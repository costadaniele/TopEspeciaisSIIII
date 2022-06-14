{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell, ScopedTypeVariables #-}

module Frontend where

import Control.Monad
import qualified Data.Text as T
import qualified Data.Text.Encoding as T
import Language.Javascript.JSaddle (eval, liftJSM)

import Obelisk.Frontend
import Obelisk.Configs
import Obelisk.Route
import Obelisk.Generated.Static

import Reflex.Dom.Core

import Common.Api
import Common.Route
import Auxiliar
import Menu

getPath :: T.Text
getPath = renderBackendRoute checFullREnc $ BackendRoute_Contato :/ ()

nomeRequest :: T.Text -> XhrRequest T.Text
nomeRequest s = postJson getPath (Contato s)

req :: ( DomBuilder t m, Prerender t m) => m ()
req = do
    inputEl <- inputElement def
    (submitBtn,_) <- el' "button" (text "Inserir")
    let click = domEvent Click submitBtn
    let nm = tag (current $ _inputElement_value inputEl) click
    _ :: Dynamic t (Event t (Maybe T.Text)) <- prerender
        (pure never)
        (fmap decodeXhrResponse <$> performRequestAsync (nomeRequest <$> nm))
    return ()

-- This runs in a monad that can be run on the client or the server.
-- To run code in a pure client or pure server context, use one of the
-- `prerender` functions.
frontend :: Frontend (R FrontendRoute)
frontend = Frontend
  { _frontend_head = do
      el "title" $ text "Portfólio Criptomoeda"
      elAttr "link" ("href" =: $(static "main.css") <> "type" =: "text/css" <> "rel" =: "stylesheet") blank
  , _frontend_body = do
      elAttr "img" ("src" =: $(static "image3.jpg") <> "id" =: "logo") blank
      req
      el "h1" $ text "PortCripto"
      mainPag 
      return ()
  }
