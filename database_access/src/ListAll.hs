{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}

module ListAll where

import Data.List
import Data.String
import Database.MySQL.Base
import System.IO
import qualified System.IO.Streams as Streams
import Data.Typeable
import Data.Text.Conversions
import Utils

class ListAll a where
    listAll :: a -> MySQLConn -> IO ([ColumnDef],(Streams.InputStream [MySQLValue]))
  
instance ListAll TableName where
    listAll Activities conn = query_ conn "SELECT * FROM activities"
    listAll Users conn      = query_ conn "SELECT * FROM users"
    listAll Resources conn  = query_ conn "SELECT * FROM resources"
    listAll Catalogs conn   = query_ conn "SELECT * FROM catalogs"
    listAll Authors conn    = query_ conn "SELECT * FROM authors"

listAllHelper :: TableName -> MySQLConn -> IO ()
listAllHelper tableName conn = do
  (defs, is) <- listAll tableName conn
  print (["id"] ++ (tableColumns tableName))
  mapM_ print =<< Streams.toList is