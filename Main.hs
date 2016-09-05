{-#Language BangPatterns#-}
{-#Language OverloadedStrings #-}
import Data.Map as M hiding (map,foldl) 
import Data.Sequence as S hiding (map,foldl,toList) 
import Data.Text as T
import System.IO
import Lib
import Serialize  

main = do
  handle <- openFile "book1.txt" ReadMode
  hSetEncoding handle utf8_bom
  contents <- hGetContents handle
  mapM_ (\((a,b),c)-> do
          putChar a
          putChar b
          putChar '-'
          putStrLn (show c))
    (M.toList $ digramsMap $ toLower $ pack contents)




