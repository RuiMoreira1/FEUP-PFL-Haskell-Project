# Programação Funcional e em Lógica

Project developed for PFL unit

## Project Team

* Rui Pedro Mendes Moreira **up201906355**
* Sérgio Rodrigues da Gama **up201906690**

## Test Cases

- There are tests for all the main BigNumber and Fibonacci modules functions in the Tests.hs file. The tests for `output and scanner` were done with `IO Monad`, comparing some expected values with the ones computed by those functions and returning PASSED or FAILED to the screen.

- All the other tests were made with the help of QuickTest module, making a property function for the Fibonacci functions and somaBN, subBn, mulBN and divBn, from BigNumber module. Finaly, the tests are run in the main IO function, in order to execute all of them with one function call.

## Functions Descriptions

### Fibonacci Functions

- **1.1 fibRec**: This function takes one argument which is the index of the Fibonacci sequence we want to have calculated. It is implemented using a `naive recursive strategy`, calculating the value fib(n), by adding fib(n-1) + fib(n-2), aside from the base cases which are fib(0) = 0 and fib(1) = 1;

- **1.2 fibLista**: This function is based in fibRec, however, taking advantage of a `dynamic programming` approach. It saves the calculated results in a list that it is passed to the next function calls, retrivieng the values need from that list and preventing multiple computations of the same value. In order to achieve this, fibLista() uses an external auxiliary function `fibListaAux()`.

- **1.3 fibListaInfinita**: In contrary to the last function that uses finite lists, this one takes advantage of infinit lists. Due to the lazy computation feature of Haskell, the list is only calculated upon what it is requested.

- **1.4 fibRecBN**: 

- **1.5 fibListaBN**: 

- **1.6 fibListaInfinitaBN**:

### BigNumber Functions
This functions are succinctly described, because in the next section they are detailed explained.

- **scanner**: Converts a String into a BigNumber.

- **output**: Converts a BigNumber into a String.

- **somaBN**: Adds two BigNumbers together, returning the result in a BigNumber.

- **subBN**: Substracts one BigNumber from another.

- **mulBN**: Multiplies two BigNumbers together.

- **divBN**: Divides one BigNumber by another.

### BigNumber Util functions

- **numbersToString**: Converts an array of Int's into a String (an array of Char's).

- **stringToNumbers**: Converts a String into an array of Int's. When the String has non digits characters, it is outputted the correspondant error, by digitToInt() prelude function.

- **trimString**: Removes all the trailling '0' characters from the beginning of the String, until a different one is found.

- **trimInts**: Removes all the trailling 0's from an array of Int's from the beginning of the array, until it is found a none 0 Int.

- **notBN**: Negates a BigNumber, by changing its sign (Bool). Zero prevails Zero.

- **biggerBN**:

- **somaBNaux**:

- **subBNaux**:

- **mulBNaux**:

- **divBNaux**:


## Strategies used on implementig BigNumber functions

### Data Definition

- The BigNumbers (Numbers in which the size is only limited by the computer memory) definition was created with the intent of simplifying the further development of the functions needed to manipulate them. Therefore, we define a constructor BN as being a list of digits and a Bool dictating the sign `(True: positive, False: negative)`. However, 0 dos not has sign, so we added a constructor (Zero) to represent it.

### Main BigNumber Manipulation Functions

- **scanner**: When the String is in the correct format following this Regular Expression `(+|-)(0|1|2|3|4|5|6|7|8|9)* + (+|-|ε)(0)*`, otherwise an error is shown. The convertion is done firstly by checking the sign and atributting the correspondant Bool in the BigNumber (True -> positive, False -> negative) and then converting the numbers int a list of Ints using stringToNumbers() util function. When one or multiple 0 are inputted, we call the Zero constructor of BigNumber data. It also removes the trailling zeros from the String using `trimString()` util function.

- **output**: When the BigNumber it is Zero, returns "0", otherwise it checks for the number signal and parses into "+" or "-", followed by the concatenation of the digits previously converted and trimmed with the composed function made by `trimString . numbersToString` functions. 

- **somaBN**: SomaBN is composed by the 6 cases that can occour in addition operation:
Both numbers are Zero -> returns Zero
Only one number is Zero -> returns the other number
When both (a and b) are none Zero numbers:
(-a) + (-b) <=> -a - b <=> -(a+b)  -> returns the sum of a + b, through somaBNaux() function, and its sign to False (meaning a negative number)
(+a) + (+b) <=> a + b -> returns the sum of a + b, through somaBNaux() function, and its sign to True (meaning a positive number)
(+a) + (-b) <=> a - b -> returns the subtraction of a - b, by calling the subBN function with a (positive) and b (positive, opposite of the inputted)
(-a) + (+b) <=> b - a -> returns the subtraction of b - a, by calling the subBN function with b (positive) and a (positive, opposite of the inputted)

- **subBN**:

- **mulBN**:

- **divBN**: 

### Auxiliary BigNumber Calculations Functions

- **somaBNaux**:

- **subBNaux**:

- **mulBNaux**:

- **divBNaux**:

## Function Comparisons (answer to topic 4)

### Int 

### Integer

### BigNumber
