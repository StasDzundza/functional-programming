import           Test.Tasty           (defaultMain, testGroup)
import           Test.Tasty.HUnit     (assertEqual, assertFailure,assertBool,testCase)
import Lib

fx :: Double -> Double
fx x = 2 * x^2

fx2 :: Double->Double
fx2 x = sin x

main = defaultMain allTests

allTests=testGroup "Integral tests"[firstTest, secondTest]

firstTest =
  testCase "2x^2" $
  assertBool "Integral of 2x from 0 to 5" (582.0 <= calculate 5 10 0.0001 10 fx && calculate 5 10 0.0001 10 fx <= 584)

secondTest =
  testCase "sin x" $
  assertBool "Integral of sin x from 0 to pi" (2.0 <= calculate 0 pi 0.0001 10 fx2 && calculate 0 pi 0.0001 10 fx2 <= 2.1)