{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}

module Auxiliar where

import Control.Monad
import qualified Data.Text as T
import qualified Data.Text.Encoding as T
import Language.Javascript.JSaddle (eval, liftJSM)

import Obelisk.Frontend
import Obelisk.Configs
import Obelisk.Route
import Obelisk.Generated.Static

import Reflex.Dom.Core
import Data.Map.Strict
import Common.Api
import Common.Route

caixas :: (PostBuild t m, DomBuilder t m) => m ()
caixas = do
    t <- inputElement def -- Dynamic Text
    s <- inputElement def -- Dynamic Text 
    text " "
    dynText (zipDynWith (<>) (_inputElement_value t) (_inputElement_value s))

listaAtributos :: Map T.Text T.Text
listaAtributos = "id" =: "li2" <> "class" =: "class1"

menu :: DomBuilder t m => m () 
menu = do

	el "div" $ do
		el "ul" $ do
			el "li" $ text "Home"
			elAttr "li" listaAtributos $ text "Carteira"
			el "li" $ text "Sobre"
			el "li" $ text "Contato"
        
