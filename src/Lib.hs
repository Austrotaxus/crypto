{-#Language BangPatterns#-}
{-#Language OverloadedStrings #-}

module Lib where
import Data.Map as M(Map,fromList,member, (!),insert,empty,toList,keys)
import Data.Sequence as S (Seq,sortBy,fromList)
import Data.Text as T (pack,zip,tail,Text,toLower,cons,snoc)
import Data.Foldable
import qualified Data.Array as A (array,listArray, (!))
myKey = M.fromList [(14,' '),(31,'о'),(15, 'е'),(34,'а'),
                    (45,'и'),(51,'н'),(1,'т'),(3,'с'),
                    (13,'р'),(23,'в'),(33,'л'),(41,'к'),(50,'м'),
                    (53,'д'),(2,'п'),(5,'у'),(12,'я'),(21,'ы'),
                    (24,'ь'),(30,'г'),(4,'з'),(6,'б'),(7,'ч'),
                    (8,'й'), (9,'х'),(10,'ж'),(11,'ш'),(16,'ю'),
                    (17,'ц'),(18,'э'),(19,'ф'),(20,'ы')]

frequencyDict:: String -> Seq (Char,Int)
frequencyDict phrase = sortBy
                       order $
                       S.fromList $
                       M.toList (Prelude.foldl updateDict empty phrase)

order (a1,b1) (a2,b2) =
  compare b2 b1
updateDict::(Ord a)=> Map a Int -> a  -> Map a Int                       
updateDict !m !key
  |member key m = let l = (m ! key) in
                   insert key (l+1) m
  |otherwise = insert key 1 m

taskPhrase =  [12,14,23,14,03,15,02,45,14,31,41,31,33,14,50,45,23,31,34,41,14,03,14,50,51,34,24,01,13,15,33,51,51,31,01,30,21,14,13,45,15,53,31,05,34,45,15,34,53]


letters =   ['а','б','в','г','д','е','ж','з','и','й','к','л','м','н','о','п','р','с','т','у','ф','х','ц','ч','ш','щ','э','ю','я',',',' ','ь','ы']

digrams = [(a,b)|a<- letters, b<-letters]

threegrams = [(a,b,c)|a <-letters, b <- letters,c <-letters]

decodeText:: Map Int Char -> [Int] -> [Char]
decodeText !keyMap !seq =
  Prelude.map (\x -> decodeSymb keyMap x ) seq


decodeSymb ::Map Int  Char -> Int -> Char
decodeSymb !m !k 
  |member k m = (m M.! k)
  |otherwise =  '?'

digramsInitMap = M.fromList $ map (\(a,b)-> ((a,b),0)) digrams

digramsMap text = Prelude.foldl addToMap digramsInitMap (T.zip text (T.tail  text))

threegramsInitMap = M.fromList $  map (\x -> (x,0)) threegrams  

{-threegramsMap text = Prelude.foldl addToMap threegramsInitMap (zip3 text (T.tail  text) (T.tail  (T.tail text ) ) ) -}
addToMap ::(Ord a)=> Map a Int -> a -> Map a Int
addToMap !m !x
  |member x m =
     let n = m ! x in
         insert x (n+1) m
  |otherwise =  m



-- the less estimate value , the closer to the correct answer phrase is

badDigramsEstimate:: Text -> Map (Char,Char) Int -> Double
badDigramsEstimate !phrase !digramsSet  =
  foldl count  0 (T.zip p (T.tail p) )
  where p = toLower (snoc (cons ' ' phrase) ' ')
        count x k = x +1 / (1 + (fromIntegral $ (digramsSet ! k ) ) )


keysArray = A.listArray (0, (length lst) -1) lst
            where lst = keys myKey

swapVals !m a b =
  let v1 = m ! a
      v2 = m ! b
  in
   insert a v2 (insert b v1 m)

improveKey !digramsMap !keyMap (a,b) =
  let
    e1 = badDigramsEstimate (pack (decodeText keyMap taskPhrase)) digramsMap 
    newKeyMap = (swapVals keyMap (keysArray A.! a) (keysArray A.! b ) ) 
    e2 = badDigramsEstimate (pack (decodeText newKeyMap taskPhrase)) digramsMap
  in
   if (e1 <= e2)
   then
     keyMap
   else
     newKeyMap

throughTransposes transposelist !dgmp =
  foldl (improveKey dgmp) myKey transposelist
