module Lib where
import Control.Parallel
import Control.DeepSeq
import Control.Parallel.Strategies

calculate :: Double -> Double -> Double -> Int ->(Double->Double)-> Double
calculate x1 x2 eps numOfThreads = calculate' x1 x2 (eps / fromIntegral numOfThreads) numOfThreads ((x2 - x1) / fromIntegral numOfThreads)

calculate' :: Double -> Double -> Double -> Int -> Double ->(Double->Double)-> Double
calculate' x1 x2 eps numOfThreads step f =
  let trap_squares =
        [ integrate_part (x1 + (step * fromIntegral i)) (x1 + (step * (fromIntegral i + 1))) step eps
          (trapSquaresSum (x1 + (step * fromIntegral i)) (x1 + (step * (fromIntegral i + 1))) step f) -- сума площ трапецій з певним кроком
          (trapSquaresSum (x1 + (step * fromIntegral i)) (x1 + (step * (fromIntegral i + 1))) (step / 2.0) f) -- сума площ трапецій з вдвічі меншим кроком
          f | i <- [0 .. numOfThreads - 1] ] `using` parList rdeepseq in sum trap_squares

integrate_part :: Double -> Double -> Double -> Double -> Double -> Double ->(Double->Double)-> Double
integrate_part x1 x2 step eps previous current f
    | checkIfStepIsCorrect previous current eps = current -- якщо таке розбиття задовольняє нашому eps, то повертаємо теперішню суму площ трапецій
    | otherwise = integrate_part x1 x2 (step / 2.0) eps (trapSquaresSum x1 x2 (step / 2.0) f) (trapSquaresSum x1 x2 (step / 4.0) f) f -- інакше зменшуємо крок вдвічі і знову перевіряємо(рекурсія)

checkIfStepIsCorrect :: Double -> Double -> Double -> Bool
checkIfStepIsCorrect h1 h2 eps | abs(h1 - h2) < eps = True
                               | otherwise = False

-- шукає суму площ трапецій з певним кроком у якихось межах
trapSquaresSum :: Double -> Double -> Double ->(Double->Double)-> Double
trapSquaresSum x1 x2 step f = step * (((f x1 + f x2) / 2) + sum_ (x1 + step) (x2 - step) step f)

-- допоміжна функція для пошуку суми площ трапецій
sum_ :: Double -> Double -> Double ->(Double->Double) ->Double
sum_ x1 x2 step f | x1 > x2 = 0
                | x1 == x2 = f x1
                | otherwise = (f x1 + f x2) + sum_ (x1 + step) (x2 - step) step f
