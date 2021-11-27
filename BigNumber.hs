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

notBN :: BigNumber -> BigNumber
notBN Zero = Zero
notBN (BN sign digits) = BN (not sign) digits

somaBN :: BigNumber -> BigNumber -> BigNumber
somaBN Zero Zero = 0
somaBN Zero (BN sign digits) = BN sign digits
somaBN (BN sign digits) Zero = BN sign digits
somaBN (BN False digitsA) (BN False digitsB) = notBN (somaBNaux (BN True digitsA) (BN True digitsB))     {-} -a + (-b) <=> -a - b <=> -(a+b) -}
somaBN (BN True digitsA) (BN True digitsB) = somaBNaux (BN True digitsA) (BN True digitsB)               {-} a + b  -}
somaBN (BN True digitsA) (BN False digitsB) =  subBN (BN True digitsA) (BN False digitsB)                {-} a + (-b) <=> a - b -}
somaBN (BN False digitsA) (Bn True digitsB) =  subBN (BN True digitsB) (BN False digitsA)                {-} -a + b <=> b - a -}


{-} One strategy would be giving the function the big number list already reversed
and using head and tail, but he have the init and last functions that to the exact 
opposite of the head and tail, therefore not needing the function in reverse order -}

{-} The recursive function call with the where condition, is used to manage the increments
, given the sum of the last 2 indexes of the big number, if the sum is >= 10, we calculate use the 
div function that returns the integer value of those two numbers divided, given the increment for the next
operation and we concatenate to the end of the list, the mod operation of the sum -}

somaBNaux :: Int -> [Int] -> [Int] -> [Int]
somaBNaux 0 [] b = b
somaBNaux 0 a [] = a
somaBNaux inc [] [] = [inc]
somaBNaux inc a [] = somaBNaux (div sum' 10) (init a) [] ++ [mod sum' 10]
    where
        sum' = last a + inc 
somaBNaux inc [] b = somaBNaux (div sum'' 10) [] (init b) ++ [mod sum'' 10]
    where
        sum'' = last b + inc
somaBNaux inc a b = somaBNaux (div sum''' 10) (init a) (init b) ++ [mod sum''' 10] {-} Recursive call to aux function, with carry management-}
    where 
        sum''' = last a + last b + inc


subBN :: BigNumber -> BigNumber -> BigNumber
subBN _ Zero = Zero
subBN Zero (BN sign digits) = BN (not sign) digits
subBN (BN _ digitsA) (BN True digitsB) = 
subBN (BN _ _) (BN False _) = somaBN (BN __ _) (BN False _)


subBNaux :: Int -> [Int] -> [Int] -> [Int]

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

