{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}

import Data.List
import Data.String
import Database.MySQL.Base
import System.IO
import qualified System.IO.Streams as Streams
import qualified Data.Text as Text
import Data.Typeable
import Data.Text.Conversions
import Utils
import ListAll
import FindById
import Create
import Delete
import Update
import Control.Monad

main = do
  conn <- connect defaultConnectInfo {ciUser = "stas", ciPassword = "stas", ciDatabase = "data_resources"}

  putStrLn "Choose table from the list: \n"
  putStrLn (intercalate "\n" tableNames)
  tableName <- getLine

  if tableExists tableName
    then do
      putStrLn "Enter command: \n"
      putStrLn "1 - show all rows"
      putStrLn "2 - find one by id"
      putStrLn "3 - create"
      putStrLn "4 - update"
      putStrLn "5 - delete"
      x <- getLine
      case x of
        "1"       -> listAllHelper (getTableName tableName) conn
        "2"       -> findByHelper (getTableName tableName) conn
        "3"       -> createRowHelper (getTableName tableName) conn
        "4"       -> updateRowHelper tableName conn
        "5"       -> deleteRowHelper (getTableName tableName) conn
        otherwise -> putStrLn "Finish"
    else do
      putStrLn "Table doesn't exist"

  close conn