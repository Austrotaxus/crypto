module Serialize where

import Data.Serialize
import Data.ByteString as B
import Data.Either

putToFile ::(Serialize a)=> String ->a -> IO ()
putToFile  fileName d = do
  B.writeFile fileName $ encode d

getFromFile ::(Serialize a) => String -> IO(a) 
getFromFile filePath = do
  contents <- B.readFile filePath
  return $ Prelude.head $ rights $ [decode contents]
  
