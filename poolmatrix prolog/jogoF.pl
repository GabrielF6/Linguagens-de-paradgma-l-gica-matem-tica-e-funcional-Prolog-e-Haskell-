%Casos Base
verifica_travado(Matriz,Pl,Pc,MaxI,MaxJ,NovaMatriz):-
   (SOMA1 is Pl-1,(SOMA1<0;vIJ(Matriz,SOMA1,Pc,-1))),                          % verifica se pode ir para a linha de cima (se o valor é -1 ou se esta na borda)
   (SOMA2 is Pc+1,Aux1 is MaxJ-1,(SOMA2>Aux1;vIJ(Matriz,Pl,SOMA2,-1))),        
   (SOMA3 is Pl+1,Aux2 is MaxI-1,(SOMA3>Aux2;vIJ(Matriz,SOMA3,Pc,-1))),
   (SOMA4 is Pc-1,(SOMA4<0;vIJ(Matriz,Pl,SOMA4,-1))),
   vIJ(Matriz,Pl,Pc,X),Decremento is X - 1,                                    %pega o valor da posição atual, Decrementoa e atualiza
   alterarCelula(Matriz,Pl,Pc,Decremento,NovaMatriz),!.                        %depois que é verificado que nao pode ir para uma certa direção nao é preciso verificar outro motivo por qual ele nao pode ir naquela direção



fim(_,-1,_,[i|Res],Matriz):-                                                                       %quando tiver verificado que todas as linhas tem todas as celulas escrever os resultados
   open('/home/desktop16/Dropbox/19.1/Linguagens/Trabalhos/TP1/gitMatrix/saida.txt',append,H),    %adiciona duas linhas no final do arquivo
   write(H,Res),writeln(H,.),                                                                     %escreve a lista de movimentos
   write(H,Matriz),writeln(H,.),                                                                   %escreve a matriz atual final
   close(H),!.                                                                        
fim(Matriz,N,M,Res,Matriz):- %true se fim                  %percorre toda a matriz e verifica se todas as celulas sao -1
   nth0(N, Matriz, Row),                                  %seleciona a linha
   percorrelinha(Row,Ret), Ret == -1,                     %verifica se todos os valores da linha sao -1
   Naux is N-1,fim(Matriz,Naux,M,Res,Matriz).              %verifica a proxima linha




percorrelinha([-1|[]],Ret):- Ret is -1,!.
percorrelinha([-1|XS],Ret):- percorrelinha(XS,Ret).


alteraElementoColunaOuLinha(N,I,V,O) :-                    % reescreve o valor da coluna na linha I, N = coluna, V = valor novo, O valor novo
    nth0(N,I,_,T),                                         % a variavel indefinida retorna o valor antigo, o T retorna o resto da linha
    nth0(N,O,V,T).                                         % insere V na posição N da lista T e retorna em O

alterarCelula(M,Row,Col,Cell,N) :-                          % reescreve valor da celula, row=linha, col = coluna, cell = novo valor, N = nova matriz
    nth0(Row,M,Old),                                        % seleciona a linha desejada, old = linha (lista) (retorno de nth0)
    alteraElementoColunaOuLinha(Col,Old,Cell,Upd),                 % reescreve valor da culuna na linha "Old" e retorna na variavel "Upd"
    alteraElementoColunaOuLinha(Row,M,Upd,N).                      % substitui a linha pela nova linha 

vIJ(Matriz,I, J,Valor) :-                         %verifica se "Valor" esta contido na Matriz
    nth0(I, Matriz, Row),                         %copia a linha desejada
    nth0(J, Row, Valor).                          % retorna o valor da posição da coluna na linha selecionada



movesq(Matriz,PosL,PosC,N,M,Res):-                                                                   
   Aux is PosC - 1, Aux > -1, vIJ(Matriz,PosL,Aux,Valor),Valor \= -1,                              %se a posição a esquerda nao esta fora e nem é o valor -1
   NovaPL is PosL, NovaPC is Aux,vIJ(Matriz,PosL,PosC,X),Decremento is X - 1,                      %copiamos os novos valores de M e N, pegamos o valor da posição atual e decrementoamos em 1
   alterarCelula(Matriz,PosL,PosC,Decremento,NovaMatriz),                                          %reescrevemos o valor da posição atual e retornamos a nova matriz
  
   append(Res,[e],NovaRes),                                                                         % concatenamos a na lista de movimentos a letra "e" de moviemtno a esquerda
   jogo(NovaMatriz,NovaPL,NovaPC,N,M,NovaRes).                                                      %chamamos novamente o predicado principal, porem agora com a nova matriz e com os novos valores de M e N

movedir(Matriz,PosL,PosC,N,M,Res):-
   Aux is PosC + 1, Aux < M, vIJ(Matriz,PosL,Aux,Valor),Valor \= -1,
   NovaPL is PosL, NovaPC is Aux,vIJ(Matriz,PosL,PosC,X),Decremento is X - 1,
   alterarCelula(Matriz,PosL,PosC,Decremento,NovaMatriz),
   append(Res,[d],NovaRes),
   jogo(NovaMatriz,NovaPL,NovaPC,N,M,NovaRes).

movecima(Matriz,PosL,PosC,N,M,Res):-
   Aux is PosL - 1, Aux > -1, vIJ(Matriz,Aux,PosC,Valor),Valor \= -1,
   NovaPL is Aux, NovaPC is PosC,vIJ(Matriz,PosL,PosC,X),Decremento is X - 1,
   alterarCelula(Matriz,PosL,PosC,Decremento,NovaMatriz),
   append(Res,[c],NovaRes),
   jogo(NovaMatriz,NovaPL,NovaPC,N,M,NovaRes).

movebaixo(Matriz,PosL,PosC,N,M,Res):-
   Aux is PosL + 1, Aux < N, vIJ(Matriz,Aux,PosC,Valor),Valor \= -1,
   NovaPL is Aux, NovaPC is PosC,vIJ(Matriz,PosL,PosC,X),Decremento is X - 1,
   %write(PosL),write(PosC),write('->'),write(NovaPL),write(NovaPC),nl,
   alterarCelula(Matriz,PosL,PosC,Decremento,NovaMatriz),
   append(Res,[b],NovaRes),
   jogo(NovaMatriz,NovaPL,NovaPC,N,M,NovaRes).


jogo(Matriz,PosiL,PosiC,N,M,Res):-                                    %verifica se ele esta travado, RETORNA VERDADEIRO QUANDO ACHA UMA SOLUÇÃO
    verifica_travado(Matriz,PosiL,PosiC,N,M,NovaMatriz),              %retorna true se o elemento esta travado
    Newn is N-1,NewM is M-1,fim(NovaMatriz,Newn,NewM,Res,Matriz).     %se o elemento esta travado então passamos a matriz atualizada, e o tamanho M X N no formato a partir de zero (porque será usado o predicado nth0), o vetor de direções e a matriz original

jogo(Matriz,PosiL,PosiC,N,M,Res):-                                    %caso o elemento nao esteja travado tentamos movimentos para as 4 direções
   movesq(Matriz,PosiL,PosiC,N,M,Res).
jogo(Matriz,PosiL,PosiC,N,M,Res):-
   movecima(Matriz,PosiL,PosiC,N,M,Res).
jogo(Matriz,PosiL,PosiC,N,M,Res):-
   movedir(Matriz,PosiL,PosiC,N,M,Res).
jogo(Matriz,PosiL,PosiC,N,M,Res):-
   movebaixo(Matriz,PosiL,PosiC,N,M,Res).



inicio(Matriz, PosL, PosC) :- 
    tamanhoMatrix(Matriz, A, B),N is A, M is B,
    findall(true,jogo(Matriz,PosL,PosC,N,M,[i]),_).  % retorna todas as chamadas de jogo que retorna verdadeiro
    


tamanhoLinha(N, Ls) :-
   length(Ls, N).                                % retorna tamanho da lista (linha)

tamanhoMatrix(Matriz, N, M) :-
   length(Matriz, N),                            % N é o numero de linhas da matriz
   maplist(tamanhoLinha(M), Matriz).             % verifica se é possivel ter o mesmo numero de colunas para todas as linhas, caso verdadeiro retorna a quantidade de elementos





tamlinha([],0).
tamlinha([_|T],J):- tamlinha(T,X),J is X+1.

tammat([],0,_).
tammat([H|T],I,J):-
    tamlinha(H,A), J is A,
    tammat(T,X,J), I is X + 1.

principal(Matriz,Pi,Pj):-
   tammat(Matriz,A,B), I is A, J is B,
   findall(true,jogo(Matriz,Pi,Pj,I,J,[i]),_).




verifica_solucao(Matriz,[],_,_,_,_,Matriz):-
   open('C:/Users/marco/Documents/GitHub/PrologGame/solucoes.txt', append, Stream2),
   writeln(Stream2,'Solução Válida'),
   close(Stream2),!.
verifica_solucao(Matriz,[i|Xs],PosL,PosC,N,M,MatrizR):-
verifica_solucao(Matriz,Xs,PosL,PosC,N,M,MatrizR).
verifica_solucao(Matriz,[H|Xs],PosL,PosC,N,M,MatrizR):-
   H == e, Aux is PosC - 1,NewPL is PosL, NewPC is Aux,
   vIJ(Matriz,PosL,PosC,X),Decrement is X - 1,
   replace_row_col(Matriz,PosL,PosC,Decrement,NewMatriz),
   verifica_solucao(NewMatriz,Xs,NewPL,NewPC,N,M,MatrizR).
verifica_solucao(Matriz,[H|Xs],PosL,PosC,N,M,MatrizR):-
   H == d, Aux is PosC + 1,NewPL is PosL, NewPC is Aux,
   vIJ(Matriz,PosL,PosC,X),Decrement is X - 1,
   replace_row_col(Matriz,PosL,PosC,Decrement,NewMatriz),
   verifica_solucao(NewMatriz,Xs,NewPL,NewPC,N,M,MatrizR).
verifica_solucao(Matriz,[H|Xs],PosL,PosC,N,M,MatrizR):-
   H == c, Aux is PosL - 1,NewPL is Aux, NewPC is PosC,
   vIJ(Matriz,PosL,PosC,X),Decrement is X - 1,
   replace_row_col(Matriz,PosL,PosC,Decrement,NewMatriz),
   verifica_solucao(NewMatriz,Xs,NewPL,NewPC,N,M,MatrizR).
verifica_solucao(Matriz,[H|Xs],PosL,PosC,N,M,MatrizR):-
   H == b, Aux is PosL + 1,NewPL is Aux, NewPC is PosC,
   vIJ(Matriz,PosL,PosC,X),Decrement is X - 1,
   replace_row_col(Matriz,PosL,PosC,Decrement,NewMatriz),
   verifica_solucao(NewMatriz,Xs,NewPL,NewPC,N,M,MatrizR).


mainsds(Path,Matriz,PosL,PosC,N,M) :-
    open(Path, read, Str),
    read_line2(Str,Matriz,PosL,PosC,N,M),
    close(Str).
read_line2(Stream,Matriz,PosL,PosC,N,M) :-
   open('C:/Users/marco/Documents/GitHub/PrologGame/solucoes.txt', append, Stream2),
   read(Stream,X),
   read(Stream,Y),
   Y\=end_of_file,
   writeln(Stream2,X),
   writeln(Stream2,Y),
   close(Stream2),
   verifica_solucao(Matriz,X,PosL,PosC,N,M,Y),
   read_line2(Stream,Matriz,PosL,PosC,N,M).
