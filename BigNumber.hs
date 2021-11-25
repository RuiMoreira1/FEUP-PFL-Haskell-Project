import Data.Char(digitToInt, intToDigit)

data BigNumber = BigNumber Bool [Int] | Zero deriving (Show)

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
          | head s == '-' = BigNumber False (stringToNumbers xs)
          | head s == '+' = BigNumber True (stringToNumbers xs)
          | otherwise = error "Input value following this sintax: [+|-]*[0|1|2|3|4|5|6|7|8|9]*"
          where xs = trimString (tail s)

output :: BigNumber -> String
output Zero = "0"
output (BigNumber False digits) = "-" ++ trimString (numbersToString digits)
output (BigNumber True digits) = "+" ++ trimString (numbersToString digits)

{-
somaBN :: BigNumber -> BigNumber -> BigNumber
somaBN b1 b2 =

subBN :: BigNumber -> BigNumber -> BigNumber
subBn b1 b2 = 

mulBN :: BigNumber -> BigNumber -> BigNumber
mulBN b1 b2 = 

divBN :: BigNumber -> BigNumber -> (BigNumber, BigNumber)
divBN b1 b2 = 

--subtrair
--count n times
-}
