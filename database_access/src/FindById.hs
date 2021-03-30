{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}

module FindById where

import Data.List
import Data.String
import Database.MySQL.Base
import System.IO
import qualified System.IO.Streams as Streams
import Data.Typeable
import Data.Text.Conversions
import Utils

class FindById a where
  findById :: a -> [Char] -> MySQLConn -> IO ([ColumnDef],(Streams.InputStream [MySQLValue]))

instance FindById TableName where
  findById Activities index conn  = query conn "SELECT * FROM activities WHERE id=?" [MySQLInt32 (toNum index)]
  findById Users index conn       = query conn "SELECT * FROM users WHERE id=?" [MySQLInt32 (toNum index)]
  findById Resources index conn   = query conn "SELECT * FROM resources WHERE id=?" [MySQLInt32 (toNum index)]
  findById Catalogs index conn    = query conn "SELECT * FROM catalogs WHERE id=?" [MySQLInt32 (toNum index)]
  findById Authors index conn     = query conn "SELECT * FROM authors WHERE id=?" [MySQLInt32 (toNum index)]

findByHelper :: TableName -> MySQLConn -> IO ()
findByHelper tableName conn = do
  putStrLn "Enter id: "
  index <- getLine
  (defs, is) <- findById tableName index conn
  print (["id"] ++ (tableColumns tableName))
  print =<< Streams.toList is