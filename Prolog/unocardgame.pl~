% Definizione carte
card(1,red).
card(2, red).
card(3, red).
card(4, red).
card(5, red).
card(6, red).
card(7, red).
card(8, red).
card(9, red).
card(0, red).
card(+2, red).
card(stop, red).
card(revers, red).

card(1,green).
card(2, green).
card(3, green).
card(4, green).
card(5, green).
card(6, green).
card(7, green).
card(8, green).
card(9, green).
card(0, green).
card(+2, green).
card(stop, green).
card(revers, green).

card(1,blue).
card(2, blue).
card(3, blue).
card(4, blue).
card(5, blue).
card(6, blue).
card(7, blue).
card(8, blue).
card(9, blue).
card(0, blue).
card(+2, blue).
card(stop, blue).
card(revers, blue).

card(1,yellow).
card(2, yellow).
card(3, yellow).
card(4, yellow).
card(5, yellow).
card(6, yellow).
card(7, yellow).
card(8, yellow).
card(9, yellow).
card(0, yellow).
card(+2, yellow).
card(stop, yellow).
card(revers, yellow).

% Funzione per ottenere lista di carte
lista_carte(CardList) :-
    findall(card(Value, Color), (value(Value), color(Color)), CardList).

% Funzione per ottenere una lista randomizzata di carte
lista_carte_randomizzata(Mazzo) :-
    lista_carte(ListaCarte),
    random_permutation(ListaCarte, Mazzo).

prendi_prime_n_carte(N, Mazzo, PrimeCarte, Rimanenti) :-
    length(PrimeCarte, N),  % Crea una lista di lunghezza N
    append(PrimeCarte, Rimanenti, Mazzo).  % Dividi la lista in PrimeCarte e Rimanenti

% Funzione per distribuire le carte ai giocatori
distribuisci_carte(ManoGiocatore1, ManoGiocatore2,Carte_Giocate) :-
    lista_carte_randomizzata(Mazzo),
    % Prendi le prime 5 carte per il Giocatore 1
    prendi_prime_n_carte(5, Mazzo, ManoGiocatore1, Rimanenti),
    % Prendi le prime 5 carte per il Giocatore 2
    prendi_prime_n_carte(5, Rimanenti, ManoGiocatore2,  NuoveRimanenti),
    %metti la prima carta del mazzo nelle carte giocate
    prendi_prime_n_carte(1, NuoveRimanenti, Carte_Giocate,  _).
    % append(ManoGiocatore1, ManoGiocatore2, CarteNelleMani).  % Unisci le mani dei giocatori

gioca_carta(ManoGiocatore1,Carta_Giocata) :-
  distribuisci_carte(ManoGiocatore1,_,Carte_Giocate),
  write('Carte nella tua mano: '),nl,write(ManoGiocatore1),nl, write('Scegli carta da giocare  ( tipo card(3,red))'),nl,
  read(Carta_Giocata),
  (
      member(Carta_Giocata, ManoGiocatore1) % if da levare che tanto inutile se si usa la grafica
      -> write('Hai scelto di giocare: '), write(Carta_Giocata), nl
      ;  write('Carta non valida! Riprova.'), nl,
      gioca_carta(ManoGiocatore1, Carta_Giocata)
  ),
  append(Carte_Giocate,Carta_Giocata,ManoGiocatore1),
  write(ManoGiocatore1),nl,write(Carte_Giocate).
% Definizione valori delle carte
value(1).
value(2).
value(3).
value(4).
value(5).
value(6).
value(7).
value(8).
value(9).
value(0).
value(+2).
value(stop).
value(reverse).

%definizione colore delle carte
color(red).
color(green).
color(blue).
color(yellow).


