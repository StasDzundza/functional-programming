{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}

module Delete where

import Data.List
import Data.String
import Database.MySQL.Base
import System.IO
import qualified System.IO.Streams as Streams
import Data.Typeable
import Data.Text.Conversions
import Utils

class Delete a where
  deleteRow :: a -> [Char] -> MySQLConn -> IO OK

instance Delete TableName where
  deleteRow Activities index conn  = execute conn "DELETE FROM activities WHERE id=?" [MySQLInt32 (toNum index)]
  deleteRow Users index conn       = execute conn "DELETE FROM users WHERE id=?" [MySQLInt32 (toNum index)]
  deleteRow Resources index conn   = execute conn "DELETE FROM resources WHERE id=?" [MySQLInt32 (toNum index)]
  deleteRow Catalogs index conn    = execute conn "DELETE FROM catalogs WHERE id=?" [MySQLInt32 (toNum index)]
  deleteRow Authors index conn     = execute conn "DELETE FROM authors WHERE id=?" [MySQLInt32 (toNum index)]

deleteRowHelper :: TableName -> MySQLConn -> IO ()
deleteRowHelper tableName conn = do
  putStrLn "Enter id: "
  index <- getLine
  deleteRow tableName index conn
  putStrLn "Deleted !!!"