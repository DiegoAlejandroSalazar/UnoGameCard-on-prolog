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

card(1,red2).
card(2, red2).
card(3, red2).
card(4, red2).
card(5, red2).
card(6, red2).
card(7, red2).
card(8, red2).
card(9, red2).
card(0, red2).
card(+2, red2).
card(stop, red2).


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

card(1,green2).
card(2, green2).
card(3, green2).
card(4, green2).
card(5, green2).
card(6, green2).
card(7, green2).
card(8, green2).
card(9, green2).
card(0, green2).
card(+2, green2).
card(stop, green2).


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

card(1,blue2).
card(2, blue2).
card(3, blue2).
card(4, blue2).
card(5, blue2).
card(6, blue2).
card(7, blue2).
card(8, blue2).
card(9, blue2).
card(0, blue2).
card(+2, blue2).
card(stop, blue2).

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

card(1,yellow2).
card(2, yellow2).
card(3, yellow2).
card(4, yellow2).
card(5, yellow2).
card(6, yellow2).
card(7, yellow2).
card(8, yellow2).
card(9, yellow2).
card(0, yellow2).
card(+2, yellow2).
card(stop, yellow2).


% Variabili dinamiche
:-dynamic mazzo/1.
:-dynamic mano_giocatore1/1.
:-dynamic mano_giocatore2/1.
:-dynamic carte_giocate/1.

% Inizializzazione delle variabili dinamiche
inizializza_gioco :-
    % Rettractall svuota tutte le variabili
    retractall(mazzo(_)),
    retractall(mano_giocatore1(_)),
    retractall(mano_giocatore2(_)),
    retractall(carte_giocate(_)),
    lista_carte_randomizzata(Mazzo),
    % Metto dentro mazzo il mazzo randomizzato
    assertz(mazzo(Mazzo)),
    % Richiamo distribuisci carte e modifico le mani e le carte giocati
    distribuisci_carte(ManoGiocatore1,ManoGiocatore2,Carte_Giocate),
    assertz(mano_giocatore1(ManoGiocatore1)),
    assertz(mano_giocatore2(ManoGiocatore2)),
    assertz(carte_giocate(Carte_Giocate)).


% Stampa il mazzo le mani, la grandezza del mazzo e le carte giocate
stampa :-
    mazzo(Mazzo),
    mano_giocatore1(ManoGiocatore1),
    mano_giocatore2(ManoGiocatore2),
    carte_giocate(Carte_Giocate),
    length(Mazzo,Lunghezza),
    writeln('mazzo : '), writeln(Mazzo),
    writeln('mazzo lunghezza : '), writeln(Lunghezza),
    writeln('mano1 : '), writeln(ManoGiocatore1),
    writeln('mano2 : '), writeln(ManoGiocatore2),
    writeln('carte : '), writeln(Carte_Giocate).


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
    mazzo(Mazzo),
    % Prendi le prime 5 carte per il Giocatore 1
    prendi_prime_n_carte(5, Mazzo, ManoGiocatore1, Rimanenti),
    % Prendi le prime 5 carte per il Giocatore 2
    prendi_prime_n_carte(5, Rimanenti, ManoGiocatore2,  NuoveRimanenti),
    %metti la prima carta del mazzo nelle carte giocate
    prendi_prime_n_carte(1, NuoveRimanenti, Carte_Giocate,  RimanentiFinali),
    retract(mazzo(Mazzo)),
    assertz(mazzo(RimanentiFinali)).

% Controlla se la carta è dello stesso colore o dello stesso valore
% della prima carta giocata
carta_valida(card(ValoreGiocato, ColoreGiocato), card(ValorePrima, ColorePrima)) :-
    (ValoreGiocato == ValorePrima; ColoreGiocato == ColorePrima).


% Se è una carta blocco o + 2 attiva l'effetto
attiva_effetto(card(ValoreGiocato, _)):-
    (   ValoreGiocato == +2
    ->  write('+2 carte pescate'),
        pesca_carte(2)
    ;
        (   ValoreGiocato == stop
        ->  write('stop turno')
        ;
        write('carta numero giocata')
        )
    ).

% Pesca una carta dal mazzo e la mette nella mano
pesca_carte(N) :-
    mazzo(Mazzo),
    mano_giocatore1(ManoGiocatore1),
    mano_giocatore2(ManoGiocatore2),

    prendi_prime_n_carte(N, Mazzo, PrimeCarte, Rimanenti),
    (   N = 2
    ->  append(ManoGiocatore2,PrimeCarte,NuovaMano),
        retract(mazzo(Mazzo)),
        assertz(mazzo(Rimanenti)),
        retract(mano_giocatore2(ManoGiocatore2)),
        assertz(mano_giocatore2(NuovaMano))
    ;
    append(ManoGiocatore1,PrimeCarte,NuovaMano),
        retract(mazzo(Mazzo)),
        assertz(mazzo(Rimanenti)),
        retract(mano_giocatore1(ManoGiocatore1)),
        assertz(mano_giocatore1(NuovaMano))
    ).

% Controlla se la carta che si vuole giocare si puo giocare e attiva
% l'effetto
gioca_carta :-
    mano_giocatore1(ManoGiocatore1),
    carte_giocate(Carte_Giocate),
    write('Carte nella tua mano: '),
    writeln(ManoGiocatore1),
    writeln('Scegli carta da giocare(tipo card(3,red)):'),
    writeln('Carta al centro :'),
    writeln(Carte_Giocate),
    read(Carta_Giocata),
   (
      member(Carta_Giocata, ManoGiocatore1)
      ->  (Carte_Giocate = [PrimaCarta|_]  % Prendi la prima carta delle carte giocate
          ->  (carta_valida(Carta_Giocata, PrimaCarta)
              ->  write('Hai scelto di giocare: '),
                  writeln(Carta_Giocata),
                  select(Carta_Giocata, ManoGiocatore1, NuovaMano1),
                  attiva_effetto(Carta_Giocata),
              % Aggiungi Carta_Giocata a Carte_Giocate
               NuoveCarteGiocate = [Carta_Giocata | Carte_Giocate],
               retract(mano_giocatore1(ManoGiocatore1)),
               assertz(mano_giocatore1(NuovaMano1)),
               retract(carte_giocate(Carte_Giocate)),
               assertz(carte_giocate(NuoveCarteGiocate)),
               writeln('Carta giocata correttamente: '),
               writeln('Nuova mano: '),
               writeln(NuovaMano1),
               writeln('Carte giocate: '),
               writeln(NuoveCarteGiocate)
              ;
              writeln('Carta non valida. Deve essere dello stesso colore o valore.'),
               gioca_carta
              )
          ;
          writeln('Nessuna carta giocata per il controllo.')
          )
      ;
        writeln('Carta non valida! Riprova.'),
      gioca_carta
   ).

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


%definizione colore delle carte
color(red).
color(red2).
color(green).
color(green2).
color(blue).
color(blue2).
color(yellow).
color(yellow2).


