{-#Language BangPatterns#-}
{-#Language OverloadedStrings #-}
import Data.Map as M hiding (map,foldl) 
--import Data.Sequence as S hiding (map,foldl,toList) 
--import Data.Text as T
import System.IO
import Lib
import Serialize  
import System.Random
import Data.Text (pack)
main:: IO()
main = do
  g1 <- newStdGen
  g2 <- newStdGen
  let seqA = randomRs  (0,length keysArray -1) g1
  let seqB = randomRs  (0,length keysArray -1) g2
  dmp <- readTolstoiDigramsMap
  let finalKey = throughTransposes (take 1000000(zip seqA seqB)) dmp
  putStrLn (decodeText finalKey taskPhrase)
  print (take 20 seqA)
  print (take 20 seqB)
  print "badDigramsEstimate first = "
  print $ badDigramsEstimate ( pack ( decodeText myKey  taskPhrase ) ) dmp
  print "badDigramsEstimate last = "
  print $ badDigramsEstimate ( pack (  decodeText finalKey  taskPhrase) ) dmp


{-
  handle <- openFile "book1.txt" ReadMode
  hSetEncoding handle utf8_bom
  contents <- hGetContents handle
  mapM_ (\((a,b),c)-> do
          putChar a
          putChar b
          putChar '-'
          putStrLn (show c))
    (M.toList $ digramsMap $ toLower $ pack contents)
-}
