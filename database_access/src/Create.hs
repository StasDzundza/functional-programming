{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}

module Create where

import Data.List
import Data.String
import Database.MySQL.Base
import System.IO
import qualified System.IO.Streams as Streams
import Data.Typeable
import Data.Text.Conversions
import Utils

class Create a where
  createRow :: a -> [[Char]] -> MySQLConn -> IO OK

instance Create TableName where
  createRow Activities params conn  = execute conn "INSERT INTO activities (user_id,resource_id) VALUES(?,?)" [MySQLInt32 (toNum (params!!0)),MySQLInt32 (toNum (params!!1))]
  createRow Users params conn       = execute conn "INSERT INTO users (name,surname) VALUES(?,?)" [MySQLText (toText (params!!0)),MySQLText (toText (params!!1))]
  createRow Resources params conn   = execute conn "INSERT INTO resources (author_id,catalog_id,title,annotation,kind,usage_cond,link) VALUES(?,?,?,?,?,?,?)" [MySQLInt32 (toNum (params!!0)),MySQLInt32 (toNum (params!!1)),MySQLText (toText (params!!2)),MySQLText (toText (params!!3)),MySQLText (toText (params!!4)),MySQLText (toText (params!!5)),MySQLText (toText (params!!6))]
  createRow Catalogs params conn    = execute conn "INSERT INTO catalogs (name) VALUES(?)" [MySQLText (toText (params!!0))]
  createRow Authors params conn     = execute conn "INSERT INTO authors (name,surname) VALUES(?,?)" [MySQLText (toText (params!!0)),MySQLText (toText (params!!1))]

createRowHelper :: TableName -> MySQLConn -> IO ()
createRowHelper tableName conn = do
  putStrLn "Enter these values: "
  putStrLn (intercalate "\n" (tableColumns tableName))
  field1 <- getLine
  field2 <- getLine
  field3 <- getLine

  let params = [field1, field2, field3]
  createRow tableName params conn
  putStrLn "Created !!!"