import BigNumber
import Fib
import Test.QuickCheck ( (==>), withMaxSuccess, quickCheck, Property )

{- Tests for the Fibonacci Functions -}

-- made with extern data retrieved from "https://planetmath.org/listoffibonaccinumbers"
fibonacciList :: [Int]
fibonacciList = [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181, 6765, 10946, 17711, 28657, 46368, 75025, 121393, 196418, 317811, 514229, 832040]

-- fibRec function (1.1) tests
testFibRec :: Int -> Property
testFibRec n = (n < 10) ==> (fibRec n) == (fibonacciList !! n)

-- fibLista function (1.2) tests
testFibLista :: Int -> Property
testFibLista n = (n < 30) ==> fibLista n == fibonacciList !! n

-- fibListaInfinita function (1.3) tests
testFibListaInfinita :: Int -> Property
testFibListaInfinita n = (n < 30) ==> fibListaInfinita n == fibonacciList !! n

-- fibRecBN function (1.4) tests
testFibRecBN :: Int -> Property
testFibRecBN n = (n < 30) ==> bnToInt (fibRecBN (BN True (intToList n))) == fibonacciList !! n

-- fibListaBN function (1.5) tests
testFibListaBN :: Int -> Property
testFibListaBN n = (n < 30) ==>  bnToInt (fibListaBN n) == fibonacciList !! n

-- fibListaInfinitaBN function (1.6) tests
testFibListaInfinitaBN :: Int -> Property
testFibListaInfinitaBN n = (n < 30) ==> bnToInt (fibListaInfinitaBN n) == fibonacciList !! n

{- Tests for the BigNumber module -}

-- scanner function (2.2) tests
testScanner :: IO()
testScanner = if and
    [scanner "0" == Zero,
    scanner "+0000" == Zero,
    scanner "-000" == Zero,
    scanner  "-1" == BN False [0,0,0,1],
    scanner "+101" == BN True [0,1,0,1],
    scanner "-2567" == BN False [2,5,6,7],
    scanner "+8017" == BN True [0,0,0,8,0,1,7],
    scanner "-3450" == BN False [0,0,3,4,5,0] ]
    then putStrLn (testName ++ "PASSED")
    else putStrLn (testName ++ "FAILED")
    where testName = "Tests to scanner [BigNumber module] function -> " 

-- output function (2.3) tests
testOutput :: IO()
testOutput = if and
    [BigNumber.output Zero == "0",
    BigNumber.output (BN False [0,0,0,1]) == "-1",
    BigNumber.output (BN True [0,1,0,1]) == "+101",
    BigNumber.output (BN False [2,5,6,7]) == "-2567",
    BigNumber.output (BN True [0,0,0,8,0,1,7]) == "+8017",
    BigNumber.output (BN False [0,0,3,4,5,0]) == "-3450"]
    then putStrLn (testName ++ "PASSED")
    else putStrLn (testName ++ "FAILED")
    where testName = "Tests to ouput [BigNumber module] function -> " 

-- somaBN function (2.4) tests
testSomaBN :: Int -> Int -> Bool
testSomaBN x y = x + y == bnToInt( somaBN (intToBN x) (intToBN y))

-- subBN function (2.5) tests
testSubBN :: Int -> Int -> Bool
testSubBN x y = x - y == bnToInt( subBN (intToBN x) (intToBN y))

-- mulBN function (2.6) tests
testMulBN :: Int -> Int -> Bool
testMulBN x y = x * y == bnToInt( mulBN (intToBN x) (intToBN y))

-- divBN function (2.7) tests
testDivBN :: Int -> Int -> Property
testDivBN x y = (x > 0) && (y > 0) ==> x `div` y == bnFractionalToInt( divBN (intToBN x) (intToBN y))


main :: IO()
main = do
    putStrLn "Fibonacci Function Tests"
    quickCheck (withMaxSuccess 100 testFibRec){-}
    quickCheck (withMaxSuccess 100 testFibLista)
    quickCheck (withMaxSuccess 100 testFibListaInfinita)
    quickCheck (withMaxSuccess 100 testFibRecBN)
    quickCheck (withMaxSuccess 100 testFibListaBN)
    quickCheck (withMaxSuccess 100 testFibListaInfinitaBN) -}
    putStrLn "BigNumber Function Tests"
    testScanner
    testOutput
    quickCheck (withMaxSuccess 100 testSomaBN)
    quickCheck (withMaxSuccess 100 testSubBN)
    quickCheck (withMaxSuccess 100 testMulBN)
    quickCheck (withMaxSuccess 100 testDivBN)
