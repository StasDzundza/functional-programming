{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE OverloadedStrings #-}

import Data.List
import Data.String
import Database.MySQL.Base
import System.IO
import qualified System.IO.Streams as Streams
import qualified Data.Text as Text
import Data.Typeable
import Control.Monad
import Test.Tasty (defaultMain, testGroup)
import CreateTest (createAuthorTest)
import DeleteTest (deleteAuthorTest)
import UpdateTest (updateAuthorTest)
import FindByIdTest (findAuthorTest)

main = defaultMain allTests

allTests = testGroup "All tests" [
                                  deleteAuthorTest
                                  --createAuthorTest
                                  --updateAuthorTest
                                  --findAuthorTest
                                 ]