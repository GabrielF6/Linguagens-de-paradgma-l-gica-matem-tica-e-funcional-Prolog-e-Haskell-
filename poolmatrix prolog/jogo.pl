%Casos Base
verifica_travado(Matriz,Pl,Pc,MaxI,MaxJ,NewMatriz):-
   (SUM1 is Pl-1,(SUM1<0;vIJ(Matriz,SUM1,Pc,-1))),
   (SUM2 is Pc+1,Aux1 is MaxJ-1,(SUM2>Aux1;vIJ(Matriz,Pl,SUM2,-1))),
   (SUM3 is Pl+1,Aux2 is MaxI-1,(SUM3>Aux2;vIJ(Matriz,SUM3,Pc,-1))),
   (SUM4 is Pc-1,(SUM4<0;vIJ(Matriz,Pl,SUM4,-1))),
   vIJ(Matriz,Pl,Pc,X),Decrement is X - 1,
   replace_row_col(Matriz,Pl,Pc,Decrement,NewMatriz),!.

fim(_,-1,_,[i|Res],Print):-
   open('/home/desktop16/Dropbox/19.1/Linguagens/Trabalhos/TP1/gitMatrix/saida.txt',append,H),
   write(H,Res),writeln(H,.),
   write(H,Print),writeln(H,.),
   close(H),!.
fim(Matrix,N,M,Res,Print):- %true se fim
   nth0(N, Matrix, Row),
   percorrelinha(Row,Ret), Ret == -1,
   Naux is N-1,fim(Matrix,Naux,M,Res,Print).

percorrelinha([-1|[]],Ret):- Ret is -1,!.
percorrelinha([-1|XS],Ret):- percorrelinha(XS,Ret).


replace_nth(N,I,V,O) :-
    nth0(N,I,_,T),
    nth0(N,O,V,T).
replace_row_col(M,Row,Col,Cell,N) :-
    nth0(Row,M,Old),
    replace_nth(Col,Old,Cell,Upd),
    replace_nth(Row,M,Upd,N).

vIJ(Matriz,I, J,Value) :-
    nth0(I, Matriz, Row),
    nth0(J, Row, Value).


movesq(Matriz,PosL,PosC,N,M,Res):-
   Aux is PosC - 1, Aux > -1, vIJ(Matriz,PosL,Aux,Value),Value \= -1,
   NewPL is PosL, NewPC is Aux,vIJ(Matriz,PosL,PosC,X),Decrement is X - 1,
   replace_row_col(Matriz,PosL,PosC,Decrement,NewMatriz),
   %write(PosL),write(PosC),write('->'),write(NewPL),write(NewPC),nl,
   %maplist(writeln,NewMatriz),nl,
   %open('/home/desktop16/Dropbox/19.1/Linguagens/Trabalhos/TP1/gitMatrix/saida.txt',append,H),
   %writeln(H,Matriz),
   %close(H),
   append(Res,[e],NewRes),
   jogo(NewMatriz,NewPL,NewPC,N,M,NewRes).


movedir(Matriz,PosL,PosC,N,M,Res):-
   Aux is PosC + 1, Aux < M, vIJ(Matriz,PosL,Aux,Value),Value \= -1,
   NewPL is PosL, NewPC is Aux,vIJ(Matriz,PosL,PosC,X),Decrement is X - 1,
   replace_row_col(Matriz,PosL,PosC,Decrement,NewMatriz),
   %write(PosL),write(PosC),write('->'),write(NewPL),write(NewPC),nl,
   %maplist(writeln,NewMatriz),nl,
   %open('/home/desktop16/Dropbox/19.1/Linguagens/Trabalhos/TP1/gitMatrix/saida.txt',append,H),
   %writeln(H,Matriz),
   %close(H),
   append(Res,[d],NewRes),
   jogo(NewMatriz,NewPL,NewPC,N,M,NewRes).


movecima(Matriz,PosL,PosC,N,M,Res):-
   Aux is PosL - 1, Aux > -1, vIJ(Matriz,Aux,PosC,Value),Value \= -1,
   NewPL is Aux, NewPC is PosC,vIJ(Matriz,PosL,PosC,X),Decrement is X - 1,
   replace_row_col(Matriz,PosL,PosC,Decrement,NewMatriz),
   %write(PosL),write(PosC),write('->'),write(NewPL),write(NewPC),nl,
   %maplist(writeln,NewMatriz),nl,
   %open('/home/desktop16/Dropbox/19.1/Linguagens/Trabalhos/TP1/gitMatrix/saida.txt',append,H),
   %writeln(H,Matriz),
   %close(H),
   append(Res,[c],NewRes),
   jogo(NewMatriz,NewPL,NewPC,N,M,NewRes).

movebaixo(Matriz,PosL,PosC,N,M,Res):-
   Aux is PosL + 1, Aux < N, vIJ(Matriz,Aux,PosC,Value),Value \= -1,
   NewPL is Aux, NewPC is PosC,vIJ(Matriz,PosL,PosC,X),Decrement is X - 1,
   %write(PosL),write(PosC),write('->'),write(NewPL),write(NewPC),nl,
   replace_row_col(Matriz,PosL,PosC,Decrement,NewMatriz),
   %maplist(writeln,NewMatriz),nl,
   %open('/home/desktop16/Dropbox/19.1/Linguagens/Trabalhos/TP1/gitMatrix/saida.txt',append,H),
   %writeln(H,Matriz),
   %close(H),
   append(Res,[b],NewRes),
   jogo(NewMatriz,NewPL,NewPC,N,M,NewRes).


jogo(Matriz,PosiL,PosiC,N,M,Res):-
    verifica_travado(Matriz,PosiL,PosiC,N,M,NewMatriz),
    Newn is N-1,NewM is M-1,fim(NewMatriz,Newn,NewM,Res,Matriz).

jogo(Matriz,PosiL,PosiC,N,M,Res):-
   movesq(Matriz,PosiL,PosiC,N,M,Res).
jogo(Matriz,PosiL,PosiC,N,M,Res):-
   movecima(Matriz,PosiL,PosiC,N,M,Res).
jogo(Matriz,PosiL,PosiC,N,M,Res):-
   movedir(Matriz,PosiL,PosiC,N,M,Res).
jogo(Matriz,PosiL,PosiC,N,M,Res):-
   movebaixo(Matriz,PosiL,PosiC,N,M,Res).



tamlinha([],0).
tamlinha([_|T],J):- tamlinha(T,X),J is X+1.

tammat([],0,_).
tammat([H|T],I,J):-
    tamlinha(H,A), J is A,
    tammat(T,X,J), I is X + 1.

principal(Matriz,Pi,Pj):-
   tammat(Matriz,I,J),
   findall(true,jogo(Matriz,Pi,Pj,I,J,[i]),X).








   

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