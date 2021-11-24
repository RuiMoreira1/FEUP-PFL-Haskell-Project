import Data.Char(digitToInt)

data BigNumber = BigNumber (sign :: Bool,  digits :: [Int])

--scanner :: String -> BigNumber
--scanner s = 

numbersOfBig :: BigNumber -> String 
numbersOfBig big = intToDigit (head (scnd big)) ++ numbersOfBig(tail (scnd big))
                
output :: BigNumber -> String
output empty = "0"
output False _ = "-" ++ numbersOfBig big
output True _ = "+" ++ numbersOfBig big 

{-
somaBN :: BigNumber -> BigNumber -> BigNumber
somaBN b1 b2 =

subBN :: BigNumber -> BigNumber -> BigNumber
subBn b1 b2 = 

mulBN :: BigNumber -> BigNumber -> BigNumber
mulBN b1 b2 = 

divBN :: BigNumber -> BigNumber -> (BigNumber, BigNumber)
divBN b1 b2 = 
-}
