{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}

module UpdateTest where
import Data.List
import Data.String
import Database.MySQL.Base
import System.IO
import qualified System.IO.Streams as Streams
import qualified Data.Text as Text
import Data.Typeable
import Data.Text.Conversions
import Control.Monad
import Test.Tasty (testGroup)
import Test.Tasty.HUnit (assertEqual, assertFailure, testCase)
import Create
import Delete
import Update
import Utils
import Control.Concurrent

updateAuthorTest = 
    testCase "Update author" $ do
        conn <- connect defaultConnectInfo {ciUser = "stas", ciPassword = "stas", ciDatabase = "data_resources_test1"}

        createRow Authors ["2", "stas", "dzundza"] conn
        threadDelay 1000000

        (defs, is) <- query_ conn "SELECT name FROM authors where id = 2"
        list <- Streams.toList is
        forM_ list $ \[MySQLText name] ->
            assertEqual "Name before update" "stas" name

        updateRow Authors "name" "stasUpdated" "2" conn
        threadDelay 1000000

        (defs, is) <- query_ conn "SELECT name FROM authors where id = 2"
        list <- Streams.toList is
        forM_ list $ \[MySQLText name] ->
            assertEqual "Name after update" "stasUpdated" name

        deleteRow Authors "2" conn
        threadDelay 2000000
        close conn