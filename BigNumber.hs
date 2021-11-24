import Data.Char(digitToInt)

data Sign = NEG | POS | ZERO 

data BigNumber = BigNumber {sign :: Sign,  digits :: [Int]}

scanner :: String -> BigNumber
scanner s = 

signOfBig :: BigNumber -> String 
signOfBig big | sign(big) == ZERO = "0"
              | sign(big) == NEG = "-"
              | sign(big) == POS = "+"

numbersOfBig :: BigNumber -> String 
numbersOfBig big = intToDigit (head (digits(big))) ++ numbersOfBig(bigRec)
                let bigRec = BigNumber {sign = sign(big), digits = tail digits(big)}
                
output :: BigNumber -> String
output big  = signOfBig big ++ numbersOfBig big

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
