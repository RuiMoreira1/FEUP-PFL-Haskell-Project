module BigNumber (BigNumber (..), scanner, output, somaBN, subBN, mulBN, divBN, notBN, bnToInt, intToBN, bnFractionalToInt, intToList) where

import Data.Char(digitToInt, intToDigit)

{- BigNumber Definition (2.1) -}
data BigNumber = BN Bool [Int] | Zero deriving (Show)
instance Eq BigNumber where
    Zero == Zero = True
    (BN signA digitsA) == (BN signB digitsB) = (signA == signB) && (trimInts digitsA == trimInts digitsB)

{- Util functions -}

-- Converts a BigNumber to an Int
bnToInt :: BigNumber -> Int
bnToInt Zero = 0
bnToInt (BN True digits) = listToInt digits 
bnToInt (BN False digits) = negate(listToInt digits)

-- Converts tuple of BigNumbers into a Int
bnFractionalToInt :: (BigNumber, BigNumber) -> Int 
bnFractionalToInt (Zero, Zero) = 0
bnFractionalToInt (Zero, BN _ _) = 0
bnFractionalToInt (BN sign digits, _) = bnToInt(BN sign digits)

-- Converts and Int to a BigNumber
intToBN :: Int -> BigNumber
intToBN n | n == 0 = Zero
          | n > 0 = BN True (intToList n)
          | n < 0 = BN False (intToList (negate n))

-- Converts Int into a list of Ints
-- pre-condition: positive numbers only
intToList :: Int -> [Int]
intToList 0 = []
intToList n =  intToList x ++ [n `mod` 10]
    where x = n `div` 10

-- Converts Int list to an Int (point free function)
listToInt :: [Int] -> Int
listToInt = foldl ((+).(*10)) 0

-- Converts a String to a list of Ints
stringToNumbers :: String -> [Int]
stringToNumbers [] = []
stringToNumbers digits = digitToInt(head digits) : stringToNumbers(tail digits)

-- Converts a list of Ints into a String
numbersToString :: [Int] -> String
numbersToString [] = []
numbersToString digits = intToDigit(head digits) : numbersToString(tail digits)

-- Removes trailling "0"'s from a String
trimString :: String -> String
trimString [] = "0"
trimString s | head s == '0' = trimString (tail s)
             | otherwise = s

-- Reduces a list of signs into one
trimSigns :: String -> String
trimSigns s | length s == 1 && head s == '+' = "+"
            | length s == 1 && head s == '-' = "-"
            | otherwise = if head s /= head (tail s) then trimSigns('-':drop 2 s) else trimSigns ('+':drop 2 s)

-- Removes the trailling 0's from a list of Ints
trimInts :: [Int] -> [Int]
trimInts [] = [0]
trimInts l | head l == 0 = trimInts (tail l)
           | otherwise = l

{- Compares two BigNumbers (a and b) and returns:
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
    | otherwise = biggerBN (BN True (tail digitsA)) (BN True (tail digitsB)) {- In case the heads are equal compare the next number -}

-- Negates a BigNumber
notBN :: BigNumber -> BigNumber
notBN Zero = Zero
notBN (BN sign digits) = BN (not sign) digits

{- One strategy would be giving the function the BigNumber list already reversed
and using head and tail, but he have the init and last functions that to the exact 
opposite of the head and tail, therefore there is no need to reverse the order of the list. -}

{- The recursive function call with the where condition is used to manage the increments. 
Given the sum of the last 2 indexes of the BigNumber, if the sum is >= 10, we use the 
div function that returns the value of those two numbers divided, giving the increment for the next
operation. Finaly, we concatenate to the end of the list, the mod operation of the sum. -}

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
somaBNaux inc a b = somaBNaux (div sum''' 10) (init a) (init b) ++ [mod sum''' 10] {- Recursive call to aux function, with carry management -}
    where
        sum''' = last a + last b + inc

-- pre-condition: array of Ints sorted (bigger one first)
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

mulBNaux :: [Int] -> [Int] -> [Int]
mulBNaux [] _ = []
mulBNaux _ [0] = []
mulBNaux _ [] = []
mulBNaux digitsA digitsB = somaBNaux 0 digitsA (mulBNaux digitsA (subBNaux 0 digitsB [1]))

divBNaux :: [Int] -> [Int] -> [Int] -> ([Int],[Int])
divBNaux _ _ [0] = error "Diving by Zero"
divBNaux _ [0] _ = ([0],[0])
divBNaux a digitsA digitsB
    | biggerBN (BN True digitsA) (BN True digitsB) == 1 = (a, digitsA)
    | otherwise = divBNaux (somaBNaux 0 a [1]) list digitsB
    where list = subBNaux 0 digitsA digitsB

divAuxEmptyToZero :: ([Int], [Int]) -> (BigNumber, BigNumber)
divAuxEmptyToZero ([], []) = (Zero, Zero)
divAuxEmptyToZero ([], x) = (Zero, BN True x)
divAuxEmptyToZero (x, []) = (BN True x, Zero)
divAuxEmptyToZero (x, y) = (BN True x, BN True x)

{- BigNumber Functions -}

--2.2: scanner - Converts a String into BigNumber 
scanner :: String -> BigNumber
scanner s |  trimString s == "0" || '+':xs == "+0" || '-':xs == "-0" = Zero
          | head s == '-' = BN False (stringToNumbers xs)
          | head s == '+' = BN True (stringToNumbers xs)
          | otherwise = error "Input value following this sintax: [+|-]*[0|1|2|3|4|5|6|7|8|9]*"
          where xs = trimString (tail s)

--2.3: output - Converts a BigNumber into a String
output :: BigNumber -> String
output Zero = "0"
output (BN False digits) = "-" ++ trimString (numbersToString digits)
output (BN True digits) = "+" ++ trimString (numbersToString digits)

--2.4: Adds two BigNumbers together
somaBN :: BigNumber -> BigNumber -> BigNumber
somaBN Zero Zero = Zero
somaBN Zero (BN sign digits) = BN sign digits
somaBN (BN sign digits) Zero = BN sign digits
somaBN (BN False digitsA) (BN False digitsB) = notBN (BN True (somaBNaux 0 digitsA digitsB))                  {-} (-a) + (-b) <=> -a-b <=> -(a+b)-}
somaBN (BN True digitsA) (BN True digitsB) = BN True (somaBNaux 0 digitsA digitsB)                            {-} (+a) + (+b) <=> a+b            -}
somaBN (BN True digitsA) (BN False digitsB) = subBN (BN True digitsA) (BN True digitsB)                       {-} (+a) + (-b) <=> a-b            -}
somaBN (BN False digitsA) (BN True digitsB) = subBN (BN True digitsB) (BN True digitsA)                       {-} (-a) + (+b) <=> b-a            -}

--2.5: Subtracts two BigNumbers
subBN :: BigNumber -> BigNumber -> BigNumber
subBN Zero Zero = Zero
subBN bn Zero = bn
subBN Zero (BN sign digits) = BN (not sign) digits
subBN (BN True digitsA) (BN True digitsB)                                                                     {-} (+a) - (+b) <=> a-b           -}
    | result == 2 || result == 4 = Zero                            {-} If a==b -> a-b=0 -}
    | result == 0 = BN True (subBNaux 0 digitsA digitsB)           {-} If a>b -> (a-b)  -}
    | result == 1 = BN False (subBNaux 0 digitsB digitsA)          {-} If b>a -> -(b-a) -}
    | otherwise = error "Error on BiggerBN comparison"
    where result = biggerBN (BN True digitsA) (BN True digitsB)
subBN (BN False digitsA) (BN False digitsB) = subBN (BN True digitsB) (BN True digitsA)                       {-} (-a) - (-b) <=> -a+b <=> b-a  -}
subBN (BN True digitsA) (BN False digitsB) = somaBN (BN True digitsA) (BN True digitsB)                       {-} (+a) - (-b) <=> a+b           -}
subBN (BN False digitsA) (BN True digitsB) = notBN (somaBN (BN True digitsB) (BN True digitsA))               {-} (-a) - (+b) <=> -(a+b)        -}

--2.6: Multiplies two BigNumber 
mulBN :: BigNumber -> BigNumber -> BigNumber
mulBN Zero _ = Zero
mulBN _ Zero = Zero
mulBN (BN False digitsA) (BN True digitsB) = BN False (mulBNaux digitsA digitsB)                              {-} (-a) * (+b) <=> -(a*b)        -}
mulBN (BN True digitsA) (BN False digitsB) = BN False (mulBNaux digitsA digitsB)                              {-} (+a) * (-b) <=> -(a*b)        -}
mulBN (BN True digitsA) (BN True digitsB) = BN True (mulBNaux digitsA digitsB)                                {-} (+a) * (+b) <=> a*b           -}
mulBN (BN False digitsA) (BN False digitsB) = BN True (mulBNaux digitsA digitsB)                              {-} (-a) * (-b) <=> a*b           -}

--2.7: Division between two BigNumbers
divBN :: BigNumber -> BigNumber -> (BigNumber, BigNumber)
divBN Zero _ = (Zero,Zero)
divBN _ Zero = error "Diving by Zero"
divBN (BN False digitsA) (BN True digitsB) = divBN (BN True digitsA) (BN False digitsB)                       {-} (-a) / (+b) <=> -(a/b)        -}
divBN (BN True digitsA) (BN True digitsB) = divBN (BN False digitsA) (BN False digitsB)                       {-} (+a) / (+b) <=> a/b           -}
divBN (BN True digitsA) (BN False digitsB) = (notBN (fst (divAuxEmptyToZero y)), snd (divAuxEmptyToZero y))   {-} (+a) / (-b) <=> -(a/b)        -}
    where y = divBNaux [] digitsA digitsB
divBN (BN False digitsA) (BN False digitsB) = divAuxEmptyToZero y                                             {-} (-a) / (-b) <=> a/b           -}
    where y = divBNaux [] digitsA digitsB

--3: Division between two BigNumbers with division by 0 safeguard
safeDivBN :: BigNumber -> BigNumber -> Maybe (BigNumber, BigNumber)
safeDivBN _ Zero = Nothing
safeDivBN n m = Just (divBN n m)
