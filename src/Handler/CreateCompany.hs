{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}
module Handler.CreateCompany where

import Import
import qualified Companies.Base as CoB
import qualified Exceptions as Exc
import qualified Companies.Persist as CoP
import           Control.Applicative ((<$>), (<*>))
import           Data.Text           (Text)
import           Data.Time           (Day)
import           Yesod
import           Yesod.Form.Jquery

instance YesodJquery App

getCreateCompanyR :: Handler Html
getCreateCompanyR = do
    -- Generate the form to be displayed
    (widget, enctype) <- generateFormPost createCompanyForm
    defaultLayout
        [whamlet|
            <p>
                Enter name and stock symbol for company creation.
                Incude TSX: prefix for GuruFocus
            <form method=post action=@{CreateCompanyR} enctype=#{enctype}>
                ^{widget}
                <button>Submit
        |]

postCreateCompanyR :: Handler Html
postCreateCompanyR = do
    ((result, widget), enctype) <- runFormPost createCompanyForm
    case result of
        FormSuccess company -> do
          let
            myCompany = CoB.newCompany (CoB.newCompanyName $ name company)(CoB.newCompanySymbol $ symbol company)
          case myCompany of
            Right myGoodCompany -> do
               _ <- liftIO $ Import.putStrLn "jfkdl"
               eitherInsertedCompany <- liftIO $ CoP.insertCompany (Import.unpack $ name company)(Import.unpack $ symbol company)
               case eitherInsertedCompany of
                 Right insertedCompany -> defaultLayout [whamlet|<p>#{show company}|]
                 Left err -> defaultLayout [whamlet|<p>#{show err}|]
            Left err -> defaultLayout [whamlet|<p>#{show err}|]
        _ -> defaultLayout
            [whamlet|
                <p>Invalid input, let's try again.
                <form method=post action=@{CreateCompanyR} enctype=#{enctype}>
                    ^{widget}
                    <button>Submit
            |]




-- Local company to bind to the form. Needs to be transformed into an investingRIO.Companies.Base.Company to ensure it is valid.
data Company = Company {name :: Text, symbol :: Text} 
instance Show Company where
  show (Company name symbol) = unpack $ name <> " " <> symbol

--generate the form that is bound to the local Company
createCompanyForm :: Html -> MForm Handler (FormResult Company, Widget)
createCompanyForm = renderDivs $ Company
    <$> areq textField "Name" Nothing
    <*> areq textField "Symbol" Nothing



   
