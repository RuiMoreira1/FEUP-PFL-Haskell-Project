import BigNumber
import Test.QuickCheck

{- Tests for the Fibonacci Functions -}

{- Tests for the BigNumber module -}

--scanner function (2.2) tests
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

--output function (2.3) tests
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

--somaBN function (2.4) tests
testSomaBN :: Int -> Int -> Bool
testSomaBN x y = x + y == bnToInt( somaBN (intToBN x) (intToBN y))

--subBN function (2.5) tests
testSubBN :: Int -> Int -> Bool
testSubBN x y = x - y == bnToInt( subBN (intToBN x) (intToBN y))

--mulBN function (2.6) tests
testMulBN :: Int -> Int -> Bool
testMulBN x y = x * y == bnToInt( mulBN (intToBN x) (intToBN y))

--divBN function (2.7) tests
testDivBN :: Int -> Int -> Property
testDivBN x y = (x > 0) && (y > 0) ==> x `div` y == bnFractionalToInt( divBN (intToBN x) (intToBN y))


main :: IO()
main = do
    quickCheck (withMaxSuccess 1000 testSomaBN)
    quickCheck (withMaxSuccess 1000 testSubBN)
    quickCheck (withMaxSuccess 1000 testMulBN)
    quickCheck (withMaxSuccess 1000 testDivBN)



