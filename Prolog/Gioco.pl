:-use_module(library(pce)).
:- [unocardgame].
:- [campoinizio].
:- [regole].

start_game :-
    free(@dialog), % @ prende indirizzo di memoria
    % creo finestra
    new(@dialog, dialog('Uno e mezzo')),
    send(@dialog, size, size(700,700)),
    %send(@dialog, done_message, message(@prolog, esci_dal_gioco)),
    send(@dialog, background, white),


    %inserisco l'immagine come sfondo
    %source_file(start_app, File),
    %rimuovi_file_da_percorso(File, Risultato),
    %directory_file_path(Risultato, '/Immagini/background.jpg', NuovoPercorso),
    %new(Background, image('C:/Users/diego/Desktop/Prolog/UnoGameCard-on-prolog/Prolog/immagini/background.jpeg')),
    %new(BitmapBackground, bitmap(Background)),
    %send(@dialog, display, BitmapBackground),
    %send(BitmapBackground, center, @dialog?center),


    % immagine titolo
    %get(@dialog,size, size(W, _)),
    %new(Imagefile, image('C:/Users/diego/Desktop/Prolog/UnoGameCard-on-prolog/Prolog/immagini/Title_Image.jpg')),
    %new(BitmapTitle, bitmap(Imagefile)),
    %send(@dialog, display, BitmapTitle),
    %send(BitmapTitle, center, @dialog?center),
    %get(BitmapTitle,size,size(Iw,_)),
    %Ximage is (W-Iw)/2, % per centrare
    %send(@dialog, display, BitmapTitle, point(Ximage,10)),
    % new(Label, text('UNO E MEZZO')),
    %send(Label, font, font(helvetica, bold, 20)),


    %bottone play
    free(@playbutton),
    new(@playbutton, button('Inizia Gioco', message(@prolog, start_the_game))),
    send(@playbutton, size, size(450, 100)), % Imposta la dimensione del bottone
    send(@playbutton, font, font(helvetica, bold, 30)), % Modifica il font del bottone
    get(@playbutton, size,size(Pbw,_)),
    get(@dialog, size, size(W,_)),
    XPlaybutton is (W-Pbw)/2,
    send(@dialog, display, @playbutton, point(XPlaybutton,500)),


    %bottone regole
    free(@rulesbutton),
    new(@rulesbutton, button('Regole', message(@prolog, regole))),
    send(@rulesbutton, size, size(200, 100)), % Imposta la dimensione del bottone
    send(@rulesbutton, font, font(helvetica, bold, 30)), % Modifica il font del bottone
    get(@rulesbutton,size,size(Rbw,_)),
    XRulesbutton is (W-Rbw)/2,
    send(@dialog, display, @rulesbutton, point(XRulesbutton,600)),
    send(@dialog, open).


start_the_game :-
    send(@dialog, background, white),
    free(@playbutton),
    free(@rulesbutton),

    campo_inizio,

    writeln('Il gioco � iniziato!').


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
    lista_carte_randomizzata(Mazzo),
    % Metto dentro mazzo il mazzo randomizzato
    assertz(mazzo(Mazzo)),
    % Richiamo distribuisci carte e modifico le mani e le carte giocati
    distribuisci_carte(ManoGiocatore1,ManoGiocatore2,Carte_Giocate),
    setta_mano_giocatore(ManoGiocatore1),
    assertz(mano_giocatore1(ManoGiocatore1)),
    %Carta = [card(+4,cambio)],
    %append(Carta,ManoGiocatore2,ManoGiocatore21),
    assertz(mano_giocatore2(ManoGiocatore2)),
    assertz(carte_giocate(Carte_Giocate)),
    assertz(carte_giocabili_ia([])),
    assertz(carta_da_giocare_ia([])),
    assertz(giocatore_attivo(1)),
    assertz(turno_bloccato(no)),
    assertz(detto_uno(no)),
    assertz(gioco_finito(no)).


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

prendi_prime_n_carte(N, Mazzo, PrimeCarte, Rimanenti) :-
    length(PrimeCarte, N),  % Crea una lista di lunghezza N
    append(PrimeCarte, Rimanenti, Mazzo).  % Dividi la lista in PrimeCarte e Rimanenti

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



setta_mano_giocatore(ManoGiocatore1):-
    findall(Valori,
             (member(card(Valori, _), ManoGiocatore1)),
            ListaValori),
    findall(Colori,
             (member(card(_, ColoreConSuff),ManoGiocatore1),
                rimuovi_suffisso_2(ColoreConSuff,Colori)),
            ListaColori),

    lista_X(ListaX),
    lista_Y(ListaY),

    forall(
        (
        nth0(Indice, ListaValori, Valore),
        nth0(Indice, ListaColori, Colore),
        nth0(Indice, ListaX, PosizioneX),
        nth0(Indice, ListaY, PosizioneY)),
        (crea_carte(Valore, Colore, PosizioneX, PosizioneY),
         writeln(Valore),
         writeln(Colore),
         writeln(PosizioneX),
         writeln(PosizioneY),
         flush_output)
    ).


distruggi_carte :-
    lista_X(ListaX),
    lista_Y(ListaY),

    forall(
        (
        nth0(Indice, ListaX, PosizioneX),
        nth0(Indice, ListaY, PosizioneY)),
        (carta_bianca(PosizioneX, PosizioneY)
        )).

carta_bianca(X,Y) :-
    new(Carta, box(68,100)),
    send(Carta, fill_pattern, colour(white)),

    send(@dialog, display, Carta, point(X,Y)).
