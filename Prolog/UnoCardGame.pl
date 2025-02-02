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

%card(cambio,cambio).
%card(+4,cambio).

% Variabili dinamiche
:-dynamic mazzo/1.
:-dynamic mano_giocatore1/1.
:-dynamic mano_giocatore2/1.
:-dynamic carte_giocate/1.
:-dynamic giocatore_attivo/1.
:-dynamic turno_bloccato/1.
:-dynamic gioco_finito/1.

% Inizializzazione delle variabili dinamiche
inizializza_gioco :-
    % Rettractall svuota tutte le variabili
    retractall(mazzo(_)),
    retractall(mano_giocatore1(_)),
    retractall(mano_giocatore2(_)),
    retractall(carte_giocate(_)),
    retractall(giocatore_attivo(_)),
    retractall(turno_bloccato(_)),
    retractall(gioco_finito(_)),
    lista_carte_randomizzata(Mazzo),
    % Metto dentro mazzo il mazzo randomizzato
    assertz(mazzo(Mazzo)),
    % Richiamo distribuisci carte e modifico le mani e le carte giocati
    distribuisci_carte(ManoGiocatore1,ManoGiocatore2,Carte_Giocate),
    A = [card(+4,cambio)],
    append(A,ManoGiocatore1,ManoGiocatore1f),
    assertz(mano_giocatore1(ManoGiocatore1f)),
    assertz(mano_giocatore2(ManoGiocatore2)),
    assertz(carte_giocate(Carte_Giocate)),
    assertz(giocatore_attivo(1)),
    assertz(turno_bloccato(no)),
    assertz(gioco_finito(no)).


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
    findall(card(Value, Color), (value(Value), color(Color)), NormalCards),
    %lista con 4 +4
    SpecialCards1 = [card(+4, cambio), card(+4, cambio), card(+4, cambio), card(+4, cambio)],
    %lista con 4 cambiocolore
   % SpecialCards2 = [card(cambio, cambio), card(cambio, cambio), card(cambio, cambio), card(cambio, cambio)],
    append(NormalCards,SpecialCards1,CardList).
    %append(CardList1,SpecialCards2,CardList).

% Funzione per ottenere una lista randomizzata di carte
lista_carte_randomizzata(Mazzo) :-
    lista_carte(ListaCarte),
    random_permutation(ListaCarte, Mazzo).


prendi_prime_n_carte(N, Mazzo, PrimeCarte, Rimanenti) :-
    length(PrimeCarte, N),  % Crea una lista di lunghezza N
    append(PrimeCarte, Rimanenti, Mazzo).  % Dividi la lista in PrimeCarte e Rimanenti

% verifica che la carta sia un cambio o un +4 e ricerca una carta che
% non sia tra queste
prendi_carta_valida([Carta | Resto], [Carta], Resto) :-
    Carta \= card(cambio, cambio),
    Carta \= card(+4, cambio).
prendi_carta_valida([Carta | Resto], Carte_Giocate, NuoveRimanenti) :-
    (Carta = card(cambio, cambio); Carta = card(+4, cambio)),
    prendi_carta_valida(Resto, Carte_Giocate, NuoveRimanenti).


% Funzione per distribuire le carte ai giocatori
distribuisci_carte(ManoGiocatore1, ManoGiocatore2,Carte_Giocate) :-
    mazzo(Mazzo),
    % Prendi le prime 5 carte per il Giocatore 1
    prendi_prime_n_carte(5, Mazzo, ManoGiocatore1, Rimanenti),
    % Prendi le prime 5 carte per il Giocatore 2
    prendi_prime_n_carte(5, Rimanenti, ManoGiocatore2,  NuoveRimanenti),
    %metti la prima carta del mazzo nelle carte giocate
    prendi_carta_valida(NuoveRimanenti, Carte_Giocate, RimanentiFinali),
    retract(mazzo(Mazzo)),
    assertz(mazzo(RimanentiFinali)).


% rimuove il suffisso 2 dalle se c'è cosi da fare i confronti
rimuovi_suffisso_2(Colore, ColoreSenzaSuffisso) :-
    atom_concat(ColoreSenzaSuffisso, '2', Colore), !.
rimuovi_suffisso_2(Colore, Colore).


% Controlla se la carta è dello stesso colore o dello stesso valore
% della prima carta giocata
carta_valida(card(ValoreGiocato, ColoreGiocato), card(ValorePrima, ColorePrima)) :-
    rimuovi_suffisso_2(ColoreGiocato, ColoreGiocatoSenzaSuffisso),
    rimuovi_suffisso_2(ColorePrima, ColorePrimaSenzaSuffisso),
    (ValoreGiocato == ValorePrima;
    ColoreGiocatoSenzaSuffisso == ColorePrimaSenzaSuffisso;
    ColoreGiocatoSenzaSuffisso == cambio).

% Funzione per scegliere il colore ( da contrllare se funge la cosa che
% si richiama da sola
scegli_colore(card(_, ColoreScelto),NuovoColore) :-
    scegli_colore_aux(ColoreScelto,NuovoColore).
    %format('Colore scelto: ~w~n', [ColoreScelto]).

% Richiesta effettiva del colore
scegli_colore_aux(_,ColoreScelto) :-
    writeln('Scegli un colore (red, green, blue, yellow):'),
    read(ColoreInserito),
    (color(ColoreInserito)
    ->
    writeln('Colore valido'),
    ColoreScelto = ColoreInserito
    %format('Colore selezionato: ~w~n', [ColoreScelto])
    ;
    writeln('Colore non valido, riprova.'),
     scegli_colore_aux(_,ColoreScelto)
    ).

% Funzione per cambiare il colore della carta
cambia_colore(card(ValoreGiocato, ColoreScelto),CartaNuova) :-
    % Richiama scegli colore
    scegli_colore(card(_, ColoreScelto),NuovoColore),
    carte_giocate(CarteGiocate),
    %crea una lista con solo la nuova carta e la appende alla nuova lista di carte giocate e poi aggiorna la variabile dinamica
    CartaNuova = [card(ValoreGiocato,NuovoColore)],
    CartaVecchia = [card(ValoreGiocato,ColoreScelto)],
    append(CartaVecchia,CarteSenzaCambio,CarteGiocate), % per levare la vecchia cambiocolore
    append(CartaNuova,CarteSenzaCambio,NuoveCarteGiocate),
    retractall(carte_giocate(_)),
    assertz(carte_giocate(NuoveCarteGiocate)),
    writeln('Colore cambiato con successo!').

% Se attiva l'effetto della carta giocata
attiva_effetto(card(ValoreGiocato, ColoreGiocato)) :-
    giocatore_attivo(GiocatoreAttivo),
    (   ValoreGiocato == +2 ->
        (   GiocatoreAttivo = 1 ->
            writeln('IA: +2 carte pescate'),
            writeln(''),
            pesca_carte(2, 2)
        ;
            writeln('+2 carte pescate'),
            writeln(''),
            pesca_carte(2, 1)
        )
    ;   ValoreGiocato == +4 ->
        (   GiocatoreAttivo = 1 ->
            cambia_colore(card(ValoreGiocato, ColoreGiocato),_),
            pesca_carte(4, 2),
            writeln('IA: +4 carte pescate'),
            writeln('')
        ;
            % cambia_colore(card(ValoreGiocato, ColoreGiocato)),
            pesca_carte(4, 1),
            writeln('+4 carte pescate'),
            writeln('')
        )
    ;   ValoreGiocato == stop ->
        (   retractall(turno_bloccato(_)),
            assertz(turno_bloccato(si))
        )
    ;   ValoreGiocato == cambio ->
        (   GiocatoreAttivo = 1 ->
            cambia_colore(card(ValoreGiocato, ColoreGiocato),_),
            writeln('Cambio Colore!'),
            writeln('')
        ;
            % cambia_colore(card(ValoreGiocato, ColoreGiocato)),
            writeln('IA fa cambio colore'),
            writeln('')
        )
    ;   writeln('carta numero giocata'),
        writeln('')
    ).
% Pesca una carta dal mazzo e la mette nella mano N = numero carte da
% pescare, P = player che pescherà le carte
pesca_carte(N,P) :-
    mazzo(Mazzo),
    mano_giocatore1(ManoGiocatore1),
    mano_giocatore2(ManoGiocatore2),

    prendi_prime_n_carte(N, Mazzo, PrimeCarte, Rimanenti),
    (   P = 2
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
    writeln('Carte nella tua mano: '),
    writeln('--------------------------------------------------------------------------'),
    writeln(ManoGiocatore1),
    writeln('--------------------------------------------------------------------------'),
    writeln('Carta al centro :'),
    carte_giocate([PrimaCarta|_]),
    writeln(PrimaCarta),
    writeln('--------------------------------------------------------------------------'),
    writeln('Scegli carta da giocare(tipo card(3,red) oppure scrivi "pesca" per pescare una carta):'),
    read(Carta_Giocata),
    (   Carta_Giocata = pesca
    ->  pesca_carte(1,1),
        writeln('Hai pescato una carta. Turno finito.'),
        writeln('')
    ;
     (
      member(Carta_Giocata, ManoGiocatore1)
      ->  (Carte_Giocate = [PrimaCarta|_]  % Prendi la prima carta delle carte giocate
          ->  (carta_valida(Carta_Giocata, PrimaCarta)
              ->  write('Hai scelto di giocare: '),
               writeln(Carta_Giocata),
               writeln(''),
               select(Carta_Giocata, ManoGiocatore1, NuovaMano1),
               %attiva_effetto(Carta_Giocata),
              % Aggiungi Carta_Giocata a Carte_Giocate
               NuoveCarteGiocate = [Carta_Giocata | Carte_Giocate],
               retract(mano_giocatore1(ManoGiocatore1)),
               assertz(mano_giocatore1(NuovaMano1)),
               retract(carte_giocate(Carte_Giocate)),
               assertz(carte_giocate(NuoveCarteGiocate)),
               attiva_effetto(Carta_Giocata),
               writeln('Carta giocata correttamente. '),
               writeln('--------------------------------------------------------------------------'),
               writeln('Nuova mano: '),
               writeln('--------------------------------------------------------------------------'),
               writeln(NuovaMano1),
               writeln('--------------------------------------------------------------------------')
              ;
              writeln('Carta non valida. Deve essere dello stesso colore o valore.'),
              writeln(''),
               gioca_carta
              )
          ;
          writeln('Nessuna carta giocata per il controllo.'),
          writeln('')
          )
      ;
        writeln('Carta non valida! Riprova.'),
        writeln(''),
      gioca_carta
     )
    ).

% se la mano è vuota allora il predicato fallisce ( impossibile in teoria)
miglior_carta_da_giocare(_, [], _) :- fail.

miglior_carta_da_giocare([PrimaCartaGiocata|_], [Carta|_], Carta) :-
    carta_valida(Carta, PrimaCartaGiocata), !. % l'operatore ( cut ! ) impredisce di trovare altre carte valide
miglior_carta_da_giocare(CarteGiocate, [_|CarteRimanenti], Carta) :-
    miglior_carta_da_giocare(CarteGiocate, CarteRimanenti, Carta).


% Fa giocare l'ia controlla la miglior carta da giocare, modifica la
% mano e le carte giocate, se non puo giocare pesca una carta
gioca_carta_ia :-
    mano_giocatore2(ManoGiocatore2),
    carte_giocate(Carte_Giocate),
    writeln('Carta al centro :'),
    carte_giocate([PrimaCarta|_]),
    writeln(PrimaCarta),
    writeln(''),
    writeln('Mano IA: '),
    writeln('--------------------------------------------------------------------------'),
    writeln(ManoGiocatore2),
        writeln('--------------------------------------------------------------------------'),
    miglior_carta_da_giocare(Carte_Giocate, ManoGiocatore2, CartaGiocata),
    select(CartaGiocata, ManoGiocatore2, NuovaMano2),
    %attiva_effetto(CartaGiocata),
    NuoveCarteGiocate = [CartaGiocata | Carte_Giocate],
    retract(mano_giocatore2(ManoGiocatore2)),
    assertz(mano_giocatore2(NuovaMano2)),
    retract(carte_giocate(Carte_Giocate)),
    assertz(carte_giocate(NuoveCarteGiocate)),
    attiva_effetto(CartaGiocata),
    writeln('IA ha giocato: '),
    writeln(''),
    writeln(CartaGiocata),
    writeln(''),
    writeln('Nuova Mano IA:'),
    writeln('--------------------------------------------------------------------------'),
    writeln(NuovaMano2),
    writeln('--------------------------------------------------------------------------').
gioca_carta_ia :-
    writeln('L\'IA non ha una carta valida da giocare, pesca una carta.'),
    writeln(''),
    pesca_carte(1, 2).


% Mette la variabile giocatore_attivo a 1 e controlla se il gioco è
% finito, altrimenti richiama gioca carta, controllo vittora e fa
% partire il turno dell'ia
turno_giocatore :-
    retractall(giocatore_attivo(_)),
    assertz(giocatore_attivo(1)),
    (   gioco_finito(si)
    ->  true
    ;   turno_bloccato(si)
    ->  writeln('Il tuo turno è bloccato!'),
        retractall(turno_bloccato(_)),
        assertz(turno_bloccato(no)),
        turno_ia
    ;   writeln('Il tuo turno!'),
        gioca_carta,
        controlla_vittoria,
        turno_ia
    ).
% contrario del truno giocatore
 turno_ia :-
    retractall(giocatore_attivo(_)),
    assertz(giocatore_attivo(2)),
    (   gioco_finito(si)
    ->  true
    ;   turno_bloccato(si)
    ->  writeln('Il turno dell\'IA è bloccato!'),
        retractall(turno_bloccato(_)),
        assertz(turno_bloccato(no)),
        turno_giocatore
    ;   writeln('Turno dell\'IA...'),
        gioca_carta_ia,
        controlla_vittoria,
        turno_giocatore
    ).
    % Controlla se le mani sono vuote e cambia la variabile dinamica gioco_finito
controlla_vittoria :-
    mano_giocatore1(ManoGiocatore1),
    mano_giocatore2(ManoGiocatore2),
    (   ManoGiocatore1 = []
    ->  writeln('Giocatore 1 ha vinto!'),
        retractall(gioco_finito(_)),
        assertz(gioco_finito(si))
        %halt
    ;   ManoGiocatore2 = []
    ->  writeln('Giocatore 2 (IA) ha vinto!'),
        retractall(gioco_finito(_)),
        assertz(gioco_finito(si))
        %halt
    ;   true  % Nessun vincitore
    ).

% Predicato che inizializza il gioco e fa iniziare il giocatore ( si puo
% fare che si parte a caso
inizia_gioco :-
    inizializza_gioco,
    writeln('gioco iniziato'),
    random_between(1, 2, Number),
    (
        Number = 1
        ->
        writeln('Inizi tu!'),
        writeln(''),
        turno_giocatore
        ;
        writeln('Inizi ia!'),
        writeln(''),
        turno_ia
    ).
    %turno_ia.


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
%value(+4).
value(stop).
%value(cambio).


%definizione colore delle carte
color(red).
color(red2).
color(green).
color(green2).
color(blue).
color(blue2).
color(yellow).
color(yellow2).
%color(cambio).


