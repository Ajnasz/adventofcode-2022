ghc -O2 --make main.hs -o main -threaded -rtsopts


some stuff I couldn't make work
```haskell

-- import System.IO
-- import Data.List

-- readLine :: Handle -> IO ()

-- readLine inputHandle = do
--   ineof <- hIsEOF inputHandle

--   if ineof
--   then return 0
--   else do
--     inputStr <- hGetLine inputHandle
--     let sections = getElfPairs inputStr
--     let x = map mapARange sections

--     return 1
--     return 1 + (readLine inputHandle)

--     if anySectionContains (head x) (last x)
--     then
--       1 + (readLine inputHandle)
--     else
--       0 + (readLine inputHandle)


-- main = do
--   inputHandle <- openFile "input" ReadMode
--   let x = readLine inputHandle
--   print("asdf")
```
