 --Fibonacci recursive version 1
 fibRec :: (Integral a) => a -> a
 fibRec 0 = 0
 fibRec 1 = 1
 fibRec n = fibRec(n-1) + fibRec(n-2)

--Fibonacci partial list implementation


--Fibonacci infinit List implementation
 fibListaInfinita :: Int -> Integer
 fibListaInfinita n = (fib !! n)
    where
      fib = 0 : 1 : (zipWith (+) fib (tail fib))
