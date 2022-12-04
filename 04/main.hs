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

sectionContains sectionA sectionB = head sectionA <= head sectionB && last sectionA >= last sectionB

anySectionContains :: [Int] -> [Int] -> Bool
anySectionContains sectionA sectionB = sectionContains sectionA sectionB || sectionContains sectionB sectionA

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
