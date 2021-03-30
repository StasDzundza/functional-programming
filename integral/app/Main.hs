module Main where
import Data.Time
import Lib

f :: Double -> Double
f x = 2 * x^2

main = do
     start <- getCurrentTime
     print (calculate 5 10 0.00005 10 f)
     end <- getCurrentTime
     print (diffUTCTime end start)