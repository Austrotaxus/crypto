module Serialize where

import Data.Serialize
import Data.ByteString as B
import Data.Either
import System.IO as I
import Data.Text as T
import Data.Map(Map)
import Lib
putToFile ::(Serialize a)=> String ->a -> IO ()
putToFile  fileName d = do
  B.writeFile fileName $ encode d

getFromFile ::(Serialize a) => String -> IO(a) 
getFromFile filePath = do
  contents <- B.readFile filePath
  return $ Prelude.head $ rights $ [decode contents]
  

writeTolstoiDigramsMap = do
  handle <- I.openFile "book1.txt" ReadMode
  hSetEncoding handle utf8_bom
  contents <- I.hGetContents handle
  B.writeFile "WarAndPeaseDigMap" $ encode $ digramsMap $ toLower $ T.pack contents

readTolstoiDigramsMap :: IO( Map (Char,Char) Int)
readTolstoiDigramsMap = do 
  getFromFile "WarAndPeaseDigMap"

