import           Test.Tasty           (defaultMain, testGroup)
import           Test.Tasty.HUnit     (assertEqual, assertFailure,assertBool,testCase)
import Lib

func :: Double -> Double
func x = 4 * sin x

linear :: Double->Double
linear x=25*x+10

main = defaultMain allTests

allTests=testGroup "Integral tests"[sinTest,linearTest]

sinTest =
  testCase "Sinus function integration test" $
  assertBool "Value not in range in sinus test" (7.999 <= calculate 0 pi 0.0001 8 func && calculate 0 pi 0.001 8 func <=8.001)

linearTest =
  testCase "Linear function integration test" $
  assertBool "Value not in range in linear test" (959.999<= calculate (-6) 10 0.0001 8 linear && calculate (-6) 10 0.001 8 linear <=960.001)