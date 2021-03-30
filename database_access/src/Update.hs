{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}

module Update where

import Data.List
import Data.String
import Database.MySQL.Base
import System.IO
import qualified System.IO.Streams as Streams
import Data.Typeable
import Data.Text.Conversions
import Utils

class Update a where
  updateRow :: a -> [Char] -> [Char]-> [Char] -> MySQLConn -> IO OK

instance Update TableName where
    updateRow Activities "user_id" value index conn = execute conn "UPDATE activities SET user_id=? WHERE id=?" [MySQLInt32 (toNum value),MySQLInt32 (toNum index)]
    updateRow Activities "resource_id" value index conn = execute conn "UPDATE activities SET recource_id=? WHERE id=?" [MySQLInt32 (toNum value),MySQLInt32 (toNum index)]
    
    updateRow Users "name" value index conn = execute conn "UPDATE users SET name=? WHERE id=?" [MySQLText (toText value),MySQLInt32 (toNum index)]
    updateRow Users "surname" value index conn = execute conn "UPDATE users SET surname=? WHERE id=?" [MySQLText (toText value),MySQLInt32 (toNum index)]

    updateRow Resources "title" value index conn = execute conn "UPDATE resources SET title=? WHERE id=?" [MySQLText (toText value),MySQLInt32 (toNum index)]
    updateRow Resources "annotation" value index conn = execute conn "UPDATE resources SET annotation=? WHERE id=?" [MySQLText (toText value),MySQLInt32 (toNum index)]

    updateRow Catalogs "name" value index conn = execute conn "UPDATE catalogs SET name=? WHERE id=?" [MySQLText (toText value),MySQLInt32 (toNum index)]

    updateRow Authors "name" value index conn = execute conn "UPDATE authors SET name=? WHERE id=?" [MySQLText (toText value),MySQLInt32 (toNum index)]
    updateRow Authors "surname" value index conn = execute conn "UPDATE authors SET surname=? WHERE id=?" [MySQLText (toText value),MySQLInt32 (toNum index)]

updateRowHelper :: [Char] -> MySQLConn -> IO ()
updateRowHelper name conn = do
  putStrLn "Enter row id: "
  index <- getLine
  putStrLn "Choose field you want to update from the list: "
  putStrLn (intercalate "\n" (updatableTableColumns name))
  field <- getLine
  if tableUpdatable name field
    then do
      putStrLn "Enter new field data: "
      value <- getLine
      updateRow (getTableName name) field value index conn
      putStrLn "Field Updated !!!"
    else
      putStrLn "Field is not updatable"