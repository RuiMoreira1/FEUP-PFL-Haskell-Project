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

{-} Helper function to check wether BigNumber a > BigNUmber b 
0 -> if a > b 
1 -> if b > a
2 -> if a == b -}
biggerBN :: BigNumber -> BigNumber -> Int
biggerBN Zero (BN _ _) = 1
biggerBN (BN _ _) Zero = 0
biggerBN Zero Zero = 4
biggerBN (BN _ digitsA) (BN _ digitsB)
    | digitsA == digitsB = 2
    | length digitsA > length digitsB = 0
    | length digitsB > length digitsA = 1
    | head digitsA > head digitsB = 0
    | head digitsB > head digitsA = 1
    | otherwise = biggerBN (BN True (tail digitsA)) (BN True (tail digitsB)) {-} In case the heads are equal compare the next number -}

notBN :: BigNumber -> BigNumber
notBN Zero = Zero
notBN (BN sign digits) = BN (not sign) digits

somaBN :: BigNumber -> BigNumber -> BigNumber
somaBN Zero Zero = Zero
somaBN Zero (BN sign digits) = BN sign digits
somaBN (BN sign digits) Zero = BN sign digits
somaBN (BN False digitsA) (BN False digitsB) = notBN (BN True (somaBNaux 0 digitsA digitsB))             {-} -a + (-b) <=> -a - b <=> -(a+b) -}
somaBN (BN True digitsA) (BN True digitsB) = BN True (somaBNaux 0 digitsA digitsB)                       {-} a + b  -}
somaBN (BN True digitsA) (BN False digitsB) = subBN (BN True digitsA) (BN True digitsB)                  {-} a + (-b) <=> a - b -}
somaBN (BN False digitsA) (BN True digitsB) = subBN (BN True digitsB) (BN True digitsA)                  {-} -a + b <=> b - a -}

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
subBN Zero Zero = Zero
subBN bn Zero = bn
subBN Zero (BN sign digits) = BN (not sign) digits
subBN (BN True digitsA) (BN True digitsB)                                                               {-} a - b  -}
    | result == 2 || result == 4 = Zero                                                                 {-} If b > a do b - a and the negate the result 100 - 120 = -(120-100)-}
    | result == 0 = BN True (subBNaux 0 digitsA digitsB)
    | result == 1 = notBN (BN True (subBNaux 0 digitsB digitsA)) 
    | otherwise = error "Bad comparison"
    where result = biggerBN (BN True digitsB) (BN True digitsA)  
subBN (BN False digitsA) (BN False digitsB) = subBN (BN True digitsB) (BN True digitsA)                 {-} -a - (-b) <=> -a + b <=> b -a  -}                                                       
subBN (BN True digitsA) (BN False digitsB) = somaBN (BN True digitsA) (BN True digitsB)                 {-} a - (-b) <=> a + b -}
subBN (BN False digitsA) (BN True digitsB) = notBN (somaBN (BN True digitsB) (BN True digitsA))        {-} -a - b <=> - (a+b) -}

subBNaux :: Int -> [Int] -> [Int] -> [Int]
subBNaux 0 [] b = b
subBNaux 0 a [] = a 
subBNaux inc [] [] = [inc]
subBNaux inc a [] = subBNaux  (abs (div sub' 10)) (init a) [] ++ [mod sub' 10]
    where sub' = last a - inc
subBNaux inc [] b = subBNaux  (abs (div sub'' 10)) [] (init b) ++ [mod sub'' 10]
    where sub'' = - last b - inc
subBNaux inc a b = dropWhile(==0) (subBNaux (abs (div sub''' 10)) (init a) (init b) ++ [mod sub''' 10])
    where sub''' = last a - inc - last b

mulBN :: BigNumber -> BigNumber -> BigNumber
mulBN Zero _ = Zero
mulBN _ Zero = Zero
mulBN (BN False digitsA) (BN True digitsB) = notBN (BN True (mulBNaux digitsA digitsB))                                    {-} -a * b <=> - (a*b) -}
mulBN (BN True digitsA) (BN False digitsB) = notBN (BN True (mulBNaux digitsA digitsB))                                    {-} a * -b <=> - (a*b) -}
mulBN (BN True digitsA) (BN True digitsB) = BN True (mulBNaux digitsA digitsB)                                             {-} a * b -}
mulBN (BN False digitsA) (BN False digitsB) = BN True (mulBNaux digitsA digitsB)                                           {-} -a * -b <=> a *b -}

mulBNaux :: [Int] -> [Int] -> [Int]
mulBNaux [] _ = []
mulBNaux _ [0] = []
mulBNaux _ [] = []
mulBNaux digitsA digitsB = somaBNaux 0 digitsA (mulBNaux digitsA (subBNaux 0 digitsB [1]))

divBN :: BigNumber -> BigNumber -> (BigNumber, BigNumber)
divBN Zero _ = (Zero,Zero)
divBN _ Zero = error "Diving by Zero" 
divBN (BN False digitsA) (BN True digitsB) = let y = divBNaux [] digitsA digitsB in (BN False (fst y), BN True (snd y)) 
divBN (BN True digitsA) (BN True digitsB) = let y = divBNaux [] digitsA digitsB in (BN True (fst y), BN True (snd y))
divBN (BN True digitsA) (BN False digitsB) = let y = divBNaux [] digitsA digitsB in (BN False (fst y), BN True (snd y))
divBN (BN False digitsA) (BN False digitsB) = let y = divBNaux [] digitsA digitsB in (BN True (fst y), BN True (snd y))
    
divBNaux :: [Int] -> [Int] -> [Int] -> ([Int],[Int])
divBNaux _ _ [0] = error "Diving by Zero"
divBNaux _ [0] _ = ([0],[0])
divBNaux a digitsA digitsB 
    | biggerBN (BN True digitsA) (BN True digitsB) == 1 = (a, digitsA)
    | otherwise = divBNaux (somaBNaux 0 a [1]) list digitsB
    where list = subBNaux 0 digitsA digitsB