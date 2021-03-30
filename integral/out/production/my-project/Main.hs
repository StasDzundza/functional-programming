module Main where
import Data.Time
import Lib


main :: IO ()
main = do
     start <- getCurrentTime
     print (calculate 0 10 0.0000001 80 f)
     end <- getCurrentTime
     print (diffUTCTime end start)