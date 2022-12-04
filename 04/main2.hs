-- import System.IO
-- import Data.List

split :: Char -> String -> [String]
split _ [] = [""]
split x (c:cs) | c == x = "" : rest
             | otherwise = (c : head rest) : tail rest
        where rest = split x cs


toint :: String -> Int
toint str = read str :: Int


mapARange :: [String] -> [Int]
mapARange strings = map toint strings


getElfPairs :: String -> [[String]]
getElfPairs line = map (split '-') (split ',' line)

sectionContains :: [Int] -> [Int] -> Bool

headOverlaps :: [Int] -> [Int] -> Bool
headOverlaps sectionA sectionB = head sectionA <= head sectionB && last sectionA >= head sectionB
lastOverlaps :: [Int] -> [Int] -> Bool
lastOverlaps sectionA sectionB = head sectionA <= last sectionB && last sectionA >= last sectionB

sectionContains sectionA sectionB = headOverlaps sectionA sectionB || lastOverlaps sectionA sectionB

anySectionContains :: [Int] -> [Int] -> Bool
anySectionContains sectionA sectionB = sectionContains sectionA sectionB || sectionContains sectionB sectionA

-- readLine :: Handle -> Int

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


countThing :: [[[Int]]] -> Int
countThing lines = do
  if length lines == 0 then 0
  else
    if (anySectionContains (head (head lines)) (last (head lines))) then
      1 + countThing (tail lines)
    else
      countThing (tail lines)


main = do
  linesStr <- readFile("input")
  let strlines = filter (\x -> not (null x)) (split '\n' linesStr)
  let lines = map getElfPairs strlines
  let numLines = (map (\line -> map mapARange line) lines)
  print(countThing numLines)
  -- inputHandle <- openFile "input" ReadMode
  -- let x = readLine inputHandle
  -- print("asdf")
