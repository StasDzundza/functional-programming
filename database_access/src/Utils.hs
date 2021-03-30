module Utils where

tableNames = ["activities", "users", "resources", "catalogs", "authors"]

data TableName = Activities | Users | Resources | Catalogs | Authors

toNum str = fromInteger (read (str) :: Integer)

tableExists :: [Char] -> Bool
tableExists name = if name `elem` tableNames then True else False

tableColumns :: TableName -> [[Char]]
tableColumns Activities = ["user_id", "resource_id"]
tableColumns Users      = ["name", "surname", "date_of_birth"]
tableColumns Resources  = ["author_id", "catalog_id", "title", "annotation", "kind", "usage_cond", "link"]
tableColumns Catalogs   = ["name"]
tableColumns Authors    = ["name", "surname"]

updatableTableColumns :: [Char] -> [[Char]]
updatableTableColumns "activities" = ["user_id", "resource_id"]
updatableTableColumns "users" = ["name", "surname"]
updatableTableColumns "resources" = ["title", "annotation"]
updatableTableColumns "catalogs" = ["name"]
updatableTableColumns "authors" = ["name", "surname"]
updatableTableColumns x = []

tableUpdatable :: [Char] -> [Char] -> Bool
tableUpdatable tableName columnName = if columnName `elem` (updatableTableColumns tableName) then True else False

getTableName :: [Char] -> TableName
getTableName  "activities" = Activities
getTableName  "users"      = Users
getTableName  "resources"  = Resources
getTableName  "catalogs"   = Catalogs
getTableName  "authors"    = Authors