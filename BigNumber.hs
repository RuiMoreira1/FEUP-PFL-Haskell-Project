import Data.Char(digitToInt, intToDigit)
import Distribution.Compat.Lens (_1)

data BigNumber = BN Bool [Int] | Zero deriving (Show)

stringToNumbers :: String -> [Int]
stringToNumbers [] = []
stringToNumbers digits = digitToInt(head digits) : stringToNumbers(tail digits)

numbersToString :: [Int] -> String
numbersToString [] = []
numbersToString digits = intToDigit(head digits) : numbersToString(tail digits)

trimString :: String -> String
trimString [] = "0"
trimString s | head s == '0' = trimString (tail s)
             | otherwise = s

trimSigns :: String -> String
trimSigns s | length s == 1 && head s == '+' = "+"
            | length s == 1 && head s == '-' = "-"
            | otherwise = if head s /= head (tail s) then trimSigns('-':drop 2 s) else trimSigns ('+':drop 2 s)

--not used yet, but may be needed
trimInts :: [Int] -> [Int]
trimInts [] = [0]
trimInts l | head l == 0 = trimInts (tail l)
           | otherwise = l

scanner :: String -> BigNumber
scanner s |  trimString s == "0" || '+':xs == "+0" || '-':xs == "-0" = Zero
          | head s == '-' = BN False (stringToNumbers xs)
          | head s == '+' = BN True (stringToNumbers xs)
          | otherwise = error "Input value following this sintax: [+|-]*[0|1|2|3|4|5|6|7|8|9]*"
          where xs = trimString (tail s)

output :: BigNumber -> String
output Zero = "0"
output (BN False digits) = "-" ++ trimString (numbersToString digits)
output (BN True digits) = "+" ++ trimString (numbersToString digits)


somaBN :: BigNumber -> BigNumber -> BigNumber
somaBN Zero (BN sign digits) = BN sign digits
somaBN (BN sign digits) Zero = BN sign digits
--somaBN (BN False digitsA) (BN False digitsB) = (BN False )
--somaBN (BN True digitsA) (BN True digitsB) = (BN True )
--somaBN (BN _ digitsA) (BN _ digitsB) = (BN )

{-}
subBN :: BigNumber -> BigNumber -> BigNumber
subBN _ Zero = Zero
subBN Zero (BN sign digits) = BN (not sign) digits
subBN (BN _ digitsA) (BN True digitsB) = 
subBN (BN _ _) (BN False _) = somaBN (BN __ _) (BN False _)
-}

mulBN :: BigNumber -> BigNumber -> BigNumber
mulBN Zero _ = Zero
mulBN _ Zero = Zero
--mulBN (BN False digitsA) (BN True digitsB) = (BN False )
--mulBN (BN True digitsA) (BN False digitsB) = (BN False )
--mulBN (BN _ digitsA) (BN _ digitsB) = (BN True )


--divBN :: BigNumber -> BigNumber -> (BigNumber, BigNumber)
--divBN b1 b2 = 

--subtrair
--count n times

