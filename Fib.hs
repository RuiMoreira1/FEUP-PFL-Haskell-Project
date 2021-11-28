module Fib (fibRec, fibLista, fibListaInfinita, fibRecBN, fibListaBN, fibListaInfinitaBN) where

import BigNumber ( BigNumber(..), somaBN, subBN )

{- Fibonacci Integral functions -}

--1.1: Fibonacci recursive naive version 
fibRec :: (Integral a) => a -> a
fibRec 0 = 0
fibRec 1 = 1
fibRec n = fibRec(n-1) + fibRec(n-2)

--1.2: Fibonacci dynamic programming list implementation
fibLista :: Integral a => a -> a
fibLista = fibListaAux [] 2

fibListaAux :: Integral a => [a] -> a -> a -> a
fibListaAux _ _ 0 = 0
fibListaAux _ _ 1 = 1
fibListaAux [] _ n = fibListaAux [0, 1] 2 n
fibListaAux lista i n
            | i<=n = fibListaAux (lista ++ [lista !! fromIntegral(i-1) + lista !! fromIntegral(i-2)]) (i+1) n
            | i>n = last lista

--1.3: Fibonacci infinit List implementation
fibListaInfinita :: Integral a => a -> a
fibListaInfinita n = fib !!  fromIntegral n
  where fib = 0 : 1 : zipWith (+) fib (tail fib)

{- Fibonacci BigNumber Functions -}

--1.4: Fibonacci recursive naive version 
fibRecBN :: BigNumber -> BigNumber
fibRecBN Zero = Zero
fibRecBN (BN _ [1]) = BN True [1]
fibRecBN (BN _ n) = somaBN (fibRecBN n1) (fibRecBN n2)
    where n1 = subBN (BN True n) (BN True [1])
          n2 = subBN (BN True n) (BN True [2])

--1.5: Fibonacci dynamic programming list implementation
fibListaBN :: Int -> BigNumber
fibListaBN = fibListaAuxBN [] 2

fibListaAuxBN :: [BigNumber] -> Int -> Int -> BigNumber
fibListaAuxBN _ _ 0 = Zero
fibListaAuxBN _ _ 1 = BN True [1]
fibListaAuxBN [] _ n = fibListaAuxBN [Zero, BN True [1]] 2 n
fibListaAuxBN lista i n
            | i<=n = fibListaAuxBN (lista ++ [ somaBN (lista !! fromIntegral(i-1))  (lista !! fromIntegral(i-2))]) (i+1) n
            | i>n = last lista

--1.6: Fibonacci infinit List implementation
fibListaInfinitaBN :: Int  -> BigNumber
fibListaInfinitaBN n = fib !! n
  where fib = Zero : BN True [1] : zipWith somaBN fib (tail fib)


