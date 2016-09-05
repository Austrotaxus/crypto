{-#Language BangPatterns#-}
{-#Language OverloadedStrings #-}

module Lib where
import Data.Map as M
import Data.Sequence as S
import Data.Text as T
myKey = M.fromList [(14,' '),(31,'О'),(15, 'Е'),(34,'А'),
                    (45,'И'),(51,'Н'),(1,'Т'),(3,'С'),
                    (13,'Р'),(23,'В'),(33,'Л'),(41,'К'),(50,'М'),
                    (53,'Д'),(2,'П'),(5,'У'),(12,'Я'),(21,'Ы'),
                    (24,'Ь'),(30,'Г'),(4,'З'),(6,'Б'),(7,'Ч'),
                    (8,'Й'), (9,'X'),(10,'Ж'),(11,'Ш'),(16,'Ю'),
                    (17,'Ц'),(18,'Э'),(19,'Ф')]

frequencyDict phrase = sortBy
                       order $
                       S.fromList $
                       toList (Prelude.foldl updateDict M.empty phrase) 

order (a1,b1) (a2,b2) =
  compare b2 b1
                       
updateDict !m !key
  |member key m = let l = (m ! key) in
                   insert key (l+1) m
  |otherwise = insert key 1 m

taskPhrase =  [12,14,23,14,03,15,02,45,14,31,41,31,33,14,50,45,23,31,34,41,14,03,14,50,51,34,24,01,13,15,33,51,51,31,01,30,21,14,13,45,15,53,31,05,34,45,15,34,53]


letters =['а','б','в','г','д','е','ж','з','и','й','к','л','м','н','о','п','р','с','т','у','ф','х','ц','ч','щ','э','ю','я',',',' ']

digrams = [(a,b)|a<- letters, b<-letters]


decodeText:: Map Int Char -> [Int] -> [Char]
decodeText keyMap seq =
  Prelude.map (\x -> decodeSymb keyMap x ) seq


decodeSymb ::Map Int  Char -> Int -> Char
decodeSymb m k 
  |member k m = (m ! k)
  |otherwise =  '?'

digramsInitMap = M.fromList $ Prelude.map (\(a,b)-> ((a,b),0)) digrams

digramsMap text = Prelude.foldl addDigram digramsInitMap (T.zip text (T.tail  text))

addDigram::Map (Char,Char) Int -> (Char,Char)->Map (Char,Char) Int
addDigram !m (!a,!b) 
  |member (a,b) m =
     let n = m ! (a,b) in
         insert (a,b) (n+1) m
  |otherwise =  m



-- the less estimate value is, the closer to the correct answer phrase is

estimate:: Text -> Map (Char,Char) Int -> Int
estimate phrase prohibitedDigramsSet  =
  Prelude.foldl count  0 (T.zip phrase (T.tail phrase))
  where count x k = x + (prohibitedDigramsSet ! k)