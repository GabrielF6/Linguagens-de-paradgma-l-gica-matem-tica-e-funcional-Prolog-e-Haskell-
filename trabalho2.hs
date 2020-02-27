data Formula = Lit Bool
	| Var String
	| E Formula Formula
	| Ou Formula Formula
	| Nao Formula
	deriving( Show , Eq )


type Contexto = [(String, Bool)]

type TabelaVerdade = [(Contexto, Bool)]





-- avalia :: Contexto -> Formula -> Bool



primeiroContexto :: [String] -> Contexto
primeiroContexto a 
	| length a == 1 =  [(head a, True)]
	| head a == "true" = [("true", True)] ++ primeiroContexto (tail a)
	| head a == "false" = [("false", True)] ++ primeiroContexto (tail a)
	| otherwise = [(head a, True)] ++ primeiroContexto (tail a)



trocaNzimoValorDeContexto :: Int -> a -> [a] -> [a]
trocaNzimoValorDeContexto _ _ [] = []
trocaNzimoValorDeContexto n newVal (x:xs)
	| n == 0 = newVal:xs
    | otherwise = x:trocaNzimoValorDeContexto (n-1) newVal xs




todosOsContextos :: [Contexto] -> Int -> Int-> [Contexto]
todosOsContextos a ponteiro max
	| ponteiro == max +1 = preenc a ponteiro tam
	| ponteiro == 1 =  todosOsContextos (a ++ preenc a ponteiro 0) (ponteiro+1) max
	| otherwise =  todosOsContextos (a ++ preenc a ponteiro tam) (ponteiro+1) max


	where
		tam = length a
		preenc:: [Contexto] -> Int -> Int -> [Contexto]
		preenc lista ponteiroAux tamAux
			| tamAux == 0 =  [troca contx ponteiro]
			| tamAux == 1 =  [troca contx ponteiro]
			| otherwise = addContx ++ preenc resto ponteiro (tamAux -1)

			where
				
				addContx = [troca contx ponteiro]
				contx = head lista
				resto = tail lista
				troca :: Contexto -> Int -> Contexto
				troca listaAux ponteiro = trocaNzimoValorDeContexto (ponteiro-1) (termo, False) listaAux
					where
						aux = listaAux!! (ponteiro-1)  -- pega o nZimo elemento, como começa no indice 0 e o ponteiro começa em 1 = ponteiro - 0
						termo = fst aux  --pega o primeiro elemento da tupla, ou seja o nome da variavel




mapeaVariaveis :: Formula -> [String]
mapeaVariaveis (Var a) = [a]
mapeaVariaveis (Lit True) = ["true"]
mapeaVariaveis (Lit False) = ["false"]
mapeaVariaveis (Ou a b) = mapeaVariaveis a ++ mapeaVariaveis b
mapeaVariaveis (E a b) = mapeaVariaveis a ++ mapeaVariaveis b
mapeaVariaveis (Nao a) = mapeaVariaveis a


formulaAnalysis :: Formula -> Bool
formulaAnalysis (Var a) = True
formulaAnalysis (Lit True) = True
formulaAnalysis (Lit False) = False
formulaAnalysis (Ou a b) = (formulaAnalysis a || formulaAnalysis b)
formulaAnalysis (E a b) = formulaAnalysis a && formulaAnalysis b
formulaAnalysis (Nao a) = not (formulaAnalysis a)




truthTable :: Formula -> [Contexto]
truthTable f = todosOsContextos [b] 1 max
	where
		a = mapeaVariaveis f
		max = length a
		b = primeiroContexto a



-- tautologia :: Formula -> Bool


-- contradicao :: Formula -> Bool