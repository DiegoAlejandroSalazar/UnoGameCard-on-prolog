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



% Variabili dinamiche.
:-dynamic mazzo/1.
:-dynamic mano_giocatore1/1.
:-dynamic mano_giocatore2/1.
:-dynamic carte_giocabili_ia/1.
:-dynamic carte_giocate/1.
:-dynamic carta_da_giocare_ia/1.
:-dynamic giocatore_attivo/1.
:-dynamic turno_bloccato/1.
:-dynamic detto_uno/1.
:-dynamic gioco_finito/1.
:-dynamic boxes_giocatore/1.
:-dynamic boxes_giocatore2/1.
:-dynamic boxes_colori/1.
:-dynamic colore/1.



% Inizializzazione del gioco
% 1. svuotamento variabili dinamiche,
% 2. creazione e randomizzazione del mazzo,
% 3. assegnazione mani ai giocatori,
% 4. inizializzazione delle variabili dinamiche.
inizializza_gioco :-
    % Rettractall svuota le variabili
    retractall(mazzo(_)),
    retractall(mano_giocatore1(_)),
    retractall(mano_giocatore2(_)),
    retractall(carte_giocabili_ia(_)),
    retractall(carta_da_giocare_ia(_)),
    retractall(carte_giocate(_)),
    retractall(giocatore_attivo(_)),
    retractall(turno_bloccato(_)),
    retractall(detto_uno(_)),
    retractall(gioco_finito(_)),
    retractall(boxes_giocatore(_)),
    retractall(boxes_giocatore2(_)),
    retractall(colore(_)),
    lista_carte_randomizzata(Mazzo),
    % Metto dentro mazzo il mazzo randomizzato
    assertz(mazzo(Mazzo)),
    % Richiamo distribuisci carte e modifico le mani e le carte giocati
    distribuisci_carte(ManoGiocatore1,ManoGiocatore2,Carte_Giocate),
    assertz(mano_giocatore1(ManoGiocatore1)),
    assertz(mano_giocatore2(ManoGiocatore2)),
    assertz(carte_giocate(Carte_Giocate)),
    assertz(carte_giocabili_ia([])),
    assertz(carta_da_giocare_ia([])),
    assertz(giocatore_attivo(1)),
    assertz(turno_bloccato(no)),
    assertz(detto_uno(no)),
    assertz(gioco_finito(no)),
    assertz(boxes_giocatore([])),
    assertz(boxes_giocatore2([])),
    assertz(boxes_colori([])),
    assertz(colore(red)),
    setta_mano_giocatore,
    setta_mano_IA,
    crea_carta_giocata.

% Funzione per ottenere lista di carte.
lista_carte(CardList) :-
    findall(card(Value, Color), (value(Value), color(Color)), NormalCards),
    %lista con i +4
    SpecialCards1 = [card(+4, cambio), card(+4, cambio), card(+4, cambio), card(+4, cambio)],
    %lista con i cambiocolore
    SpecialCards2 = [card(cambio, cambio), card(cambio, cambio), card(cambio, cambio), card(cambio, cambio)],
    append(NormalCards,SpecialCards1,CardList1),
    append(CardList1,SpecialCards2,CardList).

% Funzione per ottenere una lista randomizzata di carte.
lista_carte_randomizzata(Mazzo) :-
    lista_carte(ListaCarte),
    random_permutation(ListaCarte, Mazzo).

% Funzione per prendere le prime N carte dal Mazzo.
prendi_prime_n_carte(N, Mazzo, PrimeCarteSenzaSuffisso, Rimanenti) :-
    length(PrimeCarte, N),  % Crea una lista di lunghezza N
    append(PrimeCarte, Rimanenti, Mazzo),  % Dividi la lista in PrimeCarte e Rimanenti
    maplist(rimuovi_suffisso_carta, PrimeCarte, PrimeCarteSenzaSuffisso).

rimuovi_suffisso_carta(card(Valore, Colore), card(Valore, ColoreSenzaSuffisso)) :-
    rimuovi_suffisso_2(Colore, ColoreSenzaSuffisso).

% Verifica che la carta non sia una cambio altrimenti ne cerca un altra.
prendi_carta_valida([Carta | Resto], [Carta], Resto) :-
    Carta \= card(cambio, cambio),
    Carta \= card(+4, cambio).
prendi_carta_valida([Carta | Resto], Carte_Giocate, NuoveRimanenti) :-
    (Carta = card(cambio, cambio); Carta = card(+4, cambio)),
    prendi_carta_valida(Resto, Carte_Giocate, NuoveRimanenti).


% Funzione per distribuire le carte ai giocatori.
distribuisci_carte(ManoGiocatore1, ManoGiocatore2,Carte_Giocate) :-
    mazzo(Mazzo),
    % Prendi le prime 5 carte per il Giocatore 1
    prendi_prime_n_carte(5, Mazzo, ManoGiocatore1, Rimanenti),
    % Prendi le prime 5 carte per il Giocatore 2
    prendi_prime_n_carte(5, Rimanenti, ManoGiocatore2,  NuoveRimanenti),
    % Metti la prima carta del mazzo nelle carte giocate
    prendi_carta_valida(NuoveRimanenti, Carte_Giocate, RimanentiFinali),
    retract(mazzo(Mazzo)),
    assertz(mazzo(RimanentiFinali)).


% Rimuove il suffisso 2 dalle carte se c'�, cosi da fare i confronti.
rimuovi_suffisso_2(Colore, ColoreSenzaSuffisso) :-
    atom_concat(ColoreSenzaSuffisso, '2', Colore), !.
rimuovi_suffisso_2(Colore, Colore).


% Controlla se la carta � dello stesso colore o dello stesso valore
% della prima carta giocata oppure se � una carta cambio.
carta_valida(card(ValoreGiocato, ColoreGiocato), card(ValorePrima, ColorePrima)) :-
    rimuovi_suffisso_2(ColoreGiocato, ColoreGiocatoSenzaSuffisso),
    rimuovi_suffisso_2(ColorePrima, ColorePrimaSenzaSuffisso),
    (ValoreGiocato == ValorePrima;
    ColoreGiocatoSenzaSuffisso == ColorePrimaSenzaSuffisso;
    ColoreGiocatoSenzaSuffisso == cambio).

% Funzione per scegliere il colore.
scegli_colore(card(_, ColoreScelto),NuovoColore) :-
    scegli_colore_aux(ColoreScelto,NuovoColore).

% Richiesta effettiva del colore.
scegli_colore_aux(_,ColoreScelto) :-
    writeln('Scegli un colore (red, green, blue, yellow):'),
    %read(ColoreInserito),
    (color(ColoreInserito)
    ->
    writeln('Colore valido'),
    ColoreScelto = ColoreInserito
    ;
    writeln('Colore non valido, riprova.'),
     scegli_colore_aux(_,ColoreScelto)
    ).

% Funzione per cambiare il colore della carta.
cambia_colore(card(ValoreGiocato, ColoreScelto)) :-
    giocatore_attivo(Giocatore),
    mano_giocatore2(ManoGiocatore2),
    (
        Giocatore = 1
        ->
        colore(NuovoColore),
        carte_giocate(CarteGiocate),
    % Crea una lista con solo la nuova carta e la appende alla nuova lista di carte giocate e poi aggiorna la variabile dinamica
        CartaNuova = [card(ValoreGiocato,NuovoColore)],
        CartaVecchia = [card(ValoreGiocato,ColoreScelto)], % dovuto mette una variabile perch� prolog va schifo
        append(CartaVecchia,CarteSenzaCambio,CarteGiocate), % per levare la vecchia cambiocolore
        append(CartaNuova,CarteSenzaCambio,NuoveCarteGiocate),
        retractall(carte_giocate(_)),
        assertz(carte_giocate(NuoveCarteGiocate))
        ;
        colore_massimo(ManoGiocatore2,NuovoColore2),
        carte_giocate(CarteGiocate),
    % Crea una lista con solo la nuova carta e la appende alla nuova lista di carte giocate e poi aggiorna la variabile dinamica
        CartaNuova = [card(ValoreGiocato,NuovoColore2)],
        CartaVecchia = [card(ValoreGiocato,ColoreScelto)],
        append(CartaVecchia,CarteSenzaCambio,CarteGiocate), % per levare la vecchia cambiocolore
        append(CartaNuova,CarteSenzaCambio,NuoveCarteGiocate),
        retractall(carte_giocate(_)),
        assertz(carte_giocate(NuoveCarteGiocate))
    ).
    % Funzione che attiva l'effetto della carta giocata.
attiva_effetto(card(ValoreGiocato, ColoreGiocato)) :-
    giocatore_attivo(GiocatoreAttivo),
    (   ValoreGiocato == +2 ->
        (   GiocatoreAttivo = 1 ->
            pesca_carte(2, 2)
        ;
            pesca_carte(2, 1)
        )
    ;   ValoreGiocato == +4 ->
        (   GiocatoreAttivo = 1 ->
            cambia_colore(card(ValoreGiocato, ColoreGiocato)),
            pesca_carte(4, 2)
        ;
            cambia_colore(card(ValoreGiocato, ColoreGiocato)),
            pesca_carte(4, 1)
        )
    ;   ValoreGiocato == stop ->
        (   retractall(turno_bloccato(_)),
            assertz(turno_bloccato(si))
        )
    ;   ValoreGiocato == cambio ->
        (   GiocatoreAttivo = 1 ->
            cambia_colore(card(ValoreGiocato, ColoreGiocato))
        ;
            cambia_colore(card(ValoreGiocato, ColoreGiocato))
        )
    ;
    true
    ).
% Pesca una carta dal mazzo e la mette nella mano N = numero carte da
% pescare, P = player che pescher� le carte.
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
        assertz(mano_giocatore2(NuovaMano)),
        setta_mano_IA
    ;
    append(ManoGiocatore1,PrimeCarte,NuovaMano),
        retract(mazzo(Mazzo)),
        assertz(mazzo(Rimanenti)),
        retract(mano_giocatore1(ManoGiocatore1)),
        assertz(mano_giocatore1(NuovaMano)),
        setta_mano_giocatore
    ).
bottone_pesca :-
    retractall(giocatore_attivo(_)),
    assertz(giocatore_attivo(2)),
    pesca_carte(1,1),
    gioca_carta_ia,
    crea_carta_giocata,
    setta_mano_IA,
    controlla_vittoria.

% Funzione che cambia il valore della variabile dinamica.
bottone_uno :-
    writeln('Hai detto uno'),
    retractall(detto_uno(_)),
    assertz(detto_uno(si)).

% Funzione che controlla le varie casistiche di UNO
controllo_uno:-
    mano_giocatore1(ManoGiocatore1),
    detto_uno(Uno),
    length(ManoGiocatore1,Lunghezza),
    (
     Lunghezza = 1
        ->
        (   Uno = si
        ->
        writeln('UNO!')
        ;
        writeln('NON HAI DETTO UNO!'),
            pesca_carte(2,1)
        )
    ;
        (   Uno = si
        ->
        writeln('HAI DETTO UNO ANCHE SE NON AVEVI UNA SOLA CARTA!'),
            pesca_carte(2,1)
        ;
        writeln('')
        )
    ),
    retractall(detto_uno(_)),
    assertz(detto_uno(no)).

% Funzione che fa fare un'azione al giocatore
gioca_carta(card(Valore,Colore)) :-
    carte_giocate(CarteGiocate),
    mano_giocatore1(ManoGiocatore1),
    Carta = card(Valore,Colore),
    NuoveCarteGiocate = [Carta, CarteGiocate],
    select(Carta, ManoGiocatore1, NuovaMano),
    retract(mano_giocatore1(ManoGiocatore1)),
    assertz(mano_giocatore1(NuovaMano)),
    retract(carte_giocate(CarteGiocate)),
    assertz(carte_giocate(NuoveCarteGiocate)),
    attiva_effetto(Carta),
    crea_carta_giocata.


estrai_elementi([card(Valore, Colore), Peso], Valore, Colore, Peso).
% Cerca la miglior carta da giocare nella mano dell'ia ( per mo vede
% solo la prima carta valida che pu� giocare).
%miglior_carta_da_giocare(_, [], _) :- fail.

% Predicato ausiliare che da true ( perche miglior_carta_da_giocare da
% sempre false)
miglior_carta_da_giocare_aux([PrimaCartaGiocata|_], [card(Valore,Colore)|CarteRimanenti], CartaGiocata):-
 \+ miglior_carta_da_giocare([PrimaCartaGiocata|_], [card(Valore,Colore)|CarteRimanenti], CartaGiocata).

% Controlla la miglior carta da giocare
miglior_carta_da_giocare([PrimaCartaGiocata|_], [card(Valore,Colore)|CarteRimanenti], CartaGiocata) :-
    (
         \+ carta_valida(card(Valore,Colore), PrimaCartaGiocata)
         ->
         miglior_carta_da_giocare(PrimaCartaGiocata, CarteRimanenti, card(Valore,Colore))

         ;
         (   Colore = cambio
         ->
         Carta = [card(Valore,Colore),1]

         ;
         Carta = [card(Valore,Colore),0]
         ),
     CartaLista = [Carta],
     carte_giocabili_ia(CarteGiocabili),
     append(CartaLista,CarteGiocabili,NuoveCarteGiocabili),
     retractall(carte_giocabili_ia([])),
     assertz(carte_giocabili_ia(NuoveCarteGiocabili)),
     sort(2, @=<, NuoveCarteGiocabili, NuoveCarteGiocabiliOrdinata),
     NuoveCarteGiocabiliOrdinata = [PrimaCarta|_],
     estrai_elementi(PrimaCarta, Valore1, Colore1, _),
     CartaGiocata = card(Valore1,Colore1),
     retractall(carta_da_giocare_ia(_)),
     assertz(carta_da_giocare_ia(CartaGiocata)),
     miglior_carta_da_giocare(PrimaCartaGiocata, CarteRimanenti, card(Valore,Colore)),
     true
    ). % l'operatore ( cut ! ) impredisce di trovare altre carte valide

 miglior_carta_da_giocare(CarteGiocate, [_|CarteRimanenti], card(Valore,Colore)) :-
    miglior_carta_da_giocare(CarteGiocate, CarteRimanenti, card(Valore,Colore)).

% Conta il numero di carte per ogni colore nella mano del giocatore2.
conta_carte_colore([], _, 0).

conta_carte_colore([card(_, Colore)|Resto], Colore, Conteggio) :-
    conta_carte_colore(Resto, Colore, Conteggio1),
    Conteggio is Conteggio1 + 1.

conta_carte_colore([card(_, AltroColore)|Resto], Colore, Conteggio) :-
    AltroColore \= Colore,
    conta_carte_colore(Resto, Colore, Conteggio).

% Se la lista contiente un solo elemento, quello � il massimo,
% se ce ne sono di pi� confronta il conteggio corrente con quello
% massimo e lo modifica se � maggiore.
max_colore([Colore-Conteggio], Colore-Conteggio).
max_colore([Colore-Conteggio|Resto], MaxColore-ConteggioMax) :-
    max_colore(Resto, TempColore-ConteggioTemp),
    (Conteggio > ConteggioTemp ->
        MaxColore = Colore,
        ConteggioMax = Conteggio
    ;
        MaxColore = TempColore,
        ConteggioMax = ConteggioTemp
    ).

% Usata per divide i colori in variabili diverse.
dividi_conteggi([], [], [], [], [], [], [], [],[]).
dividi_conteggi([red-RedConteggio|Resto], [RedConteggio|RedT], Red2, Green, Green2, Blue, Blue2, Yellow, Yellow2) :-
    dividi_conteggi(Resto, RedT, Red2, Green, Green2, Blue, Blue2, Yellow, Yellow2).

dividi_conteggi([red2-Red2Conteggio|Resto], Red, [Red2Conteggio|Red2T], Green, Green2, Blue, Blue2, Yellow, Yellow2) :-
    dividi_conteggi(Resto, Red, Red2T, Green, Green2, Blue, Blue2, Yellow, Yellow2).

dividi_conteggi([green-GreenConteggio|Resto], Red, Red2, [GreenConteggio|GreenT], Green2, Blue, Blue2, Yellow, Yellow2) :-
    dividi_conteggi(Resto, Red, Red2, GreenT, Green2, Blue, Blue2, Yellow, Yellow2).

dividi_conteggi([green2-Green2Conteggio|Resto], Red, Red2, Green, [Green2Conteggio|Green2T], Blue, Blue2, Yellow, Yellow2) :-
    dividi_conteggi(Resto, Red, Red2, Green, Green2T, Blue, Blue2, Yellow, Yellow2).

dividi_conteggi([blue-BlueConteggio|Resto], Red, Red2, Green, Green2, [BlueConteggio|BlueT], Blue2, Yellow, Yellow2) :-
    dividi_conteggi(Resto, Red, Red2, Green, Green2, BlueT, Blue2, Yellow, Yellow2).

dividi_conteggi([blue2-Blue2Conteggio|Resto], Red, Red2, Green, Green2, Blue, [Blue2Conteggio|Blue2T], Yellow, Yellow2) :-
    dividi_conteggi(Resto, Red, Red2, Green, Green2, Blue, Blue2T, Yellow, Yellow2).

dividi_conteggi([yellow-YellowConteggio|Resto], Red, Red2, Green, Green2, Blue, Blue2, [YellowConteggio|YellowT], Yellow2) :-
    dividi_conteggi(Resto, Red, Red2, Green, Green2, Blue, Blue2, YellowT, Yellow2).

dividi_conteggi([yellow2-Yellow2Conteggio|Resto], Red, Red2, Green, Green2, Blue, Blue2, Yellow, [Yellow2Conteggio|Yellow2T]) :-
    dividi_conteggi(Resto, Red, Red2, Green, Green2, Blue, Blue2, Yellow, Yellow2T).

% Funzione per trovare il colore con il massimo numero di carte.
colore_massimo(Mano, ColoreMassimo) :-
    findall(Colore, color(Colore), Colori),
    mappa_carte_colore(Mano, Colori, Conteggi),
    dividi_conteggi(Conteggi, Red, Red2, Green, Green2, Blue, Blue2, Yellow,Yellow2),
    Rossi is Red+Red2,
    Verdi is Green+Green2,
    Blu is Blue+Blue2,
    Gialli is Yellow+Yellow2,
    ConteggiFinali = [red-Rossi,green-Verdi,blue-Blu,yellow-Gialli],
    max_colore(ConteggiFinali,ColoreMassimo-_).
% Crea una lista di coppie Colore-Conteggio.
mappa_carte_colore(_, [], []).
mappa_carte_colore(Mano, [Colore|Resto], [Colore-Conteggio|Mappa]) :-
    conta_carte_colore(Mano, Colore, Conteggio),
    mappa_carte_colore(Mano, Resto, Mappa).

% Fa giocare l'ia:
% 1. controlla la miglior carta da giocare,
% 2. modifica la mano e le carte giocate,
% 3. se non puo giocare pesca una carta.
gioca_carta_ia :-
    non_mio_turno,
    controllo_uno,
    mano_giocatore2(ManoGiocatore2),
    carte_giocate(Carte_Giocate),
    carte_giocate([PrimaCarta|_]),
        miglior_carta_da_giocare_aux(Carte_Giocate, ManoGiocatore2, _),
        carta_da_giocare_ia(CartaGiocata),
        nonvar(CartaGiocata), % controllo che la carta esite altrimenti esce
        carta_valida(CartaGiocata,PrimaCarta),
        select(CartaGiocata, ManoGiocatore2, NuovaMano2),
        NuoveCarteGiocate = [CartaGiocata | Carte_Giocate],
        retract(mano_giocatore2(ManoGiocatore2)),
        assertz(mano_giocatore2(NuovaMano2)),
        retract(carte_giocate(Carte_Giocate)),
        assertz(carte_giocate(NuoveCarteGiocate)),
        sleep(1),
        attiva_effetto(CartaGiocata),
        retractall(carte_giocabili_ia(_)),
        assertz(carte_giocabili_ia([])),
        retract(carta_da_giocare_ia(CartaGiocata)),
        assertz(carta_da_giocare_ia(_)),
        crea_carta_giocata,
        setta_mano_IA,
        controlla_vittoria,
        turno_bloccato(ControlloBloccoTurno),
        (    ControlloBloccoTurno = si
        ->
        retractall(turno_bloccato(_)),
        assertz(turno_bloccato(no)),
             gioca_carta_ia
        ;
        true
        ),
        retractall(giocatore_attivo(_)),
        assertz(giocatore_attivo(1)),
        mio_turno.

gioca_carta_ia :-
    pesca_carte(1, 2),
    retractall(giocatore_attivo(_)),
    assertz(giocatore_attivo(1)),
    mio_turno.


% Mette la variabile giocatore_attivo a 1 e controlla se il gioco �
% finito, altrimenti richiama gioca carta, controllo vittora e fa
% partire il turno dell'ia.
turno_giocatore :-
    retractall(giocatore_attivo(_)),
    assertz(giocatore_attivo(1)),
    (   gioco_finito(si)
    ->  true
    ;   turno_bloccato(si)
    ->
        retractall(turno_bloccato(_)),
        assertz(turno_bloccato(no)),
        turno_ia
    ;
        controlla_vittoria,
        controllo_mazzo,
        turno_ia
    ).
% contrario del truno giocatore.
 turno_ia :-
    retractall(giocatore_attivo(_)),
    assertz(giocatore_attivo(2)),
    (   gioco_finito(si)
    ->  true
    ;   turno_bloccato(si)
    ->  writeln('Il turno dell\'IA � bloccato!'),
        retractall(turno_bloccato(_)),
        assertz(turno_bloccato(no)),
        turno_giocatore
    ;   writeln('Turno dell\'IA...'),
        gioca_carta_ia,
        controlla_vittoria,
        controllo_mazzo,
        turno_giocatore
    ).

controllo_mazzo :-
    mazzo(Mazzo),
    length(Mazzo,LunghezzaMazzo),
    (   LunghezzaMazzo < 1
    ->
    lista_carte_randomizzata(NuovoMazzo),
        retract(mazzo(Mazzo)),
        assertz(mazzo(NuovoMazzo))
    ;
    true
    ).

% Controlla se le mani sono vuote e cambia la variabile dinamica
% gioco_finito.
controlla_vittoria :-
    mano_giocatore1(ManoGiocatore1),
    mano_giocatore2(ManoGiocatore2),
    (   ManoGiocatore1 = []
    ->  writeln('Giocatore 1 ha vinto!'),
        retractall(gioco_finito(_)),
        assertz(gioco_finito(si)),
        win_condition
    ;   ManoGiocatore2 = []
    ->  writeln('Giocatore 2 (IA) ha vinto!'),
        retractall(gioco_finito(_)),
        assertz(gioco_finito(si)),
        loss_condition
    ;   true  % Nessun vincitore
    ).


% Predicato che inizializza il gioco e fa partire un giocatore a caso.
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


% Definizione valori delle carte.
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


%definizione colore delle carte.
color(red).
color(red2).
color(green).
color(green2).
color(blue).
color(blue2).
color(yellow).
color(yellow2).



