{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}
module Handler.CreateCompany where

import Import

getCreateCompanyR :: Handler Html
getCreateCompanyR = defaultLayout $ do
  [whamlet|Creating a new route CreateRouteR:
           <ul>
            <li>create 2 text inputs for the namd and symbol
            <li>do some in page validation of the fields
            <li>submit to the server, and insert the db
            <li>give a return msg. Should this be in ajax.
            
          |]


postCreateCompanyR :: Handler Html
postCreateCompanyR = error "Not yet implemented: postCreateCompanyR"
