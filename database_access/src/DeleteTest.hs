{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}

module DeleteTest where
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
import Utils
import Control.Concurrent

deleteAuthorTest = 
    testCase "Delete author" $ do
        conn <- connect defaultConnectInfo {ciUser = "stas", ciPassword = "stas", ciDatabase = "data_resources_test1"}

        createRow Authors ["1", "stas", "dzundza"] conn
        threadDelay 2000000

        (defs, is) <- query_ conn "SELECT COUNT(*) FROM authors"
        list <- Streams.toList is
        forM_ list $ \[MySQLInt64 count] ->
            assertEqual "Test num of authors before delete" 1 count

        deleteRow Authors "1" conn
        threadDelay 2000000

        (defs1, is1) <- query_ conn "SELECT COUNT(*) FROM authors"
        list1 <- Streams.toList is1
        forM_ list1 $ \[MySQLInt64 count2] ->
            assertEqual "Test num of authors after delete" 0 count2
        close conn
        threadDelay 2000000
        