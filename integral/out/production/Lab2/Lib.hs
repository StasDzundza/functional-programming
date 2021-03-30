module Lib where
import Control.Parallel
import Control.DeepSeq
import Control.Parallel.Strategies
someFunc :: IO ()
someFunc = putStrLn "someFunc"

calculate :: Double -> Double -> Double -> Int ->(Double->Double)-> Double
calculate a b eps p = calc a b (eps / fromIntegral p) p ((b - a) / fromIntegral p)


calc :: Double -> Double -> Double -> Int -> Double ->(Double->Double)-> Double
calc a b eps p h func=
  let chunks =
        [ integrate
          (a + (h * fromIntegral i))
          (a + (h * (fromIntegral i + 1)))
          h
          eps
          (trap (a + (h * fromIntegral i)) (a + (h * (fromIntegral i + 1))) h func)
          (trap (a + (h * fromIntegral i)) (a + (h * (fromIntegral i + 1))) (h / 2.0) func)
          func
        | i <- [0 .. p - 1]
        ] `using`
        parList rdeepseq
   in sum chunks

integrate :: Double -> Double -> Double -> Double -> Double -> Double ->(Double->Double)-> Double
integrate a b step eps previous current func
    | runge previous current eps = current
  | otherwise = integrate a b (step / 2.0) eps (trap a b (step / 2.0) func) (trap a b (step / 4.0) func) func

trap :: Double -> Double -> Double ->(Double->Double)-> Double
trap a b step func = step * (((func a + func b) / 2) + summ (a + step) (b - step) step func)

summ :: Double -> Double -> Double ->(Double->Double) ->Double
summ a b step func| a > b = 0
                 | a == b = func a
                 | otherwise = (func a + func b) + summ (a + step) (b - step) step func

f :: Double -> Double
f x = 4*sin(x) + 10

g :: Double -> Double
g x= cos(x)
runge :: Double -> Double -> Double -> Bool
runge h1 h2 eps | abs(h1 - h2)/3 < eps = True
                  | otherwise = False