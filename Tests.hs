import BigNumber
import Fib
import Test.QuickCheck ( (==>), withMaxSuccess, quickCheck, Property )

{- Tests for the Fibonacci Functions -}

-- fibRec function (1.1) tests
testFibRec :: Int -> Property
testFibRec n = (n > 2) && (n < 22) ==> fibRec n == fibRec(n-1) + fibRec(n-2)

-- fibLista function (1.2) tests
testFibLista :: Int -> Property
testFibLista n = (n > 2) && (n < 22) ==> fibLista n == fibLista(n-1) + fibLista(n-2)

-- fibListaInfinita function (1.3) tests
testFibListaInfinita :: Int -> Property
testFibListaInfinita n = (n > 2) && (n < 22) ==> fibListaInfinita n == fibListaInfinita(n-1) + fibListaInfinita(n-2)

-- fibRecBN function (1.4) tests
testFibRecBN :: Int -> Property
testFibRecBN n = (n > 2) && (n < 22) ==> bnToInt (fibRecBN (BN True (intToList n))) == bnToInt (fibRecBN (BN True (intToList (n-1)))) + bnToInt (fibRecBN (BN True (intToList (n-2))))

-- fibListaBN function (1.5) tests
testFibListaBN :: Int -> Property
testFibListaBN n = (n > 2) && (n < 22) ==>  bnToInt (fibListaBN n) == bnToInt (fibListaBN (n-1)) + bnToInt (fibListaBN (n-2))

-- fibListaInfinitaBN function (1.6) tests
testFibListaInfinitaBN :: Int -> Property
testFibListaInfinitaBN n = (n > 2) && (n < 22) ==> bnToInt (fibListaInfinitaBN n) == bnToInt (fibListaInfinitaBN (n-1)) + bnToInt (fibListaInfinitaBN (n-2))

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
    where testName = "Tests to ouput   [BigNumber module] function -> " 

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
    putStrLn "\n####### Fibonacci Function Tests #######\n"
    quickCheck (withMaxSuccess 100 testFibRec)
    quickCheck (withMaxSuccess 100 testFibLista)
    quickCheck (withMaxSuccess 100 testFibListaInfinita)
    quickCheck (withMaxSuccess 100 testFibRecBN)
    quickCheck (withMaxSuccess 100 testFibListaBN)
    quickCheck (withMaxSuccess 100 testFibListaInfinitaBN)
    putStrLn "\n####### BigNumber Function Tests #######\n"
    testScanner
    testOutput
    quickCheck (withMaxSuccess 100 testSomaBN)
    quickCheck (withMaxSuccess 100 testSubBN)
    quickCheck (withMaxSuccess 100 testMulBN)
    quickCheck (withMaxSuccess 100 testDivBN)
    putStrLn ""
