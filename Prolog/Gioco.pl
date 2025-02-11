:-use_module(library(pce)).
:- [campoinizio].
:- [regole].

start_game :-
    free(@dialog), % @ prende indirizzo di memoria
    % creo finestra

    new(@dialog, dialog('Uno e mezzo')),
    send(@dialog, size, size(700,700)),
    %send(@dialog, done_message, message(@prolog, esci_dal_gioco)),
    send(@dialog, background, white),

     % Device.
    free(@device),
    new(@device, device),
    send(@dialog, display, @device, point(0,0)),

    % inserisco l'immagine come sfondo
    source_file(start_game, File),
    rimuovi_file_da_percorso(File, Risultato),
    directory_file_path(Risultato, '/Immagini/Sfondo.jpg', NuovoPercorso),
    %free(@imagefile),
    new(@imagefile, image(NuovoPercorso)),
    new(Bitmap, bitmap(@imagefile)),
    send(@device, display, Bitmap),
    send(Bitmap, center, @device?center),

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
    send(@device, clear),
    free(@playbutton),
    free(@rulesbutton),

    free(@device),
    new(@device, device),
    send(@dialog, display, @device, point(0,0)),

    source_file(start_the_game, File),
    rimuovi_file_da_percorso(File, Risultato),
    directory_file_path(Risultato, '/Immagini/backgroundGameplay.jpg', NuovoPercorso),
    new(@imagefile2, image(NuovoPercorso)),
    new(Bitmap, bitmap(@imagefile2)),
    send(@device, display, Bitmap),
    send(Bitmap, center, @device?center),

    campo_inizio,
    inizializza_gioco,

    writeln('Il gioco � iniziato!').


setta_mano_giocatore:-
    rimuovi_tutte_carte,
    mano_giocatore1(ManoGiocatore1),
    %writeln(ManoGiocatore1),
    length(ManoGiocatore1, IndiceMax),
    findall(Valori,
             member(card(Valori, _), ManoGiocatore1),
            ListaValori),
    findall(Colori,
             (member(card(_, ColoreConSuff),ManoGiocatore1),
                rimuovi_suffisso_2(ColoreConSuff,Colori)),
            ListaColori),

    lista_X(ListaX),
    lista_Y(ListaY),


    IndiceMaxNuovo is IndiceMax-1,
    forall(
        between(0, IndiceMaxNuovo, Indice),
        (
            nth0(Indice, ListaValori, Valore),
            nth0(Indice, ListaColori, Colore),
            nth0(Indice, ListaX, PosizioneX),
            nth0(Indice, ListaY, PosizioneY),
            (crea_carte(Valore, Colore, PosizioneX, PosizioneY),
             flush_output))
    ).

setta_mano_IA :-
    rimuovi_tutte_carte_ia,
    mano_giocatore2(ManoGiocatore2),
    lista_X(ListaXIA),
    lista_Y_IA(ListaYIA),

    findall(CartaIA,
             (member(card(_, _), ManoGiocatore2)),
            ListaCarteIA),

    forall(
        (
        nth0(Indice, ListaCarteIA, CartaIA),
        nth0(Indice, ListaXIA, PosizioneXIA),
        nth0(Indice, ListaYIA, PosizioneYIA)),

        (carta_generica(black,PosizioneXIA,PosizioneYIA)
        )
    ).



carta_generica(Colore,X,Y) :-
    new(Carta, box(68,100)),
    send(Carta, radius, 7),
    send(Carta, fill_pattern, colour(Colore)),
    send(Carta, colour, white),

    send(@dialog, display, Carta, point(X,Y)),
    flush_output,
    boxes_giocatore2(ListaBox2),
    append([Carta],ListaBox2,NuovaListaBox2),
    retract(boxes_giocatore2(_)),
    assertz(boxes_giocatore2(NuovaListaBox2)).


crea_carte(Valore, Colore, X, Y) :-
    new(Carta, box(68,100)),

    (   Colore = yellow
    ->
    send(Carta, fill_pattern, colour(orange))
    ;
    (
        Colore = cambio
    ->
        send(Carta, fill_pattern, colour(black))
    )
    ;
    send(Carta, fill_pattern, colour(Colore))
    ),

    send(Carta, colour, white),
    send(Carta, radius, 7),
    send(@dialog, display, Carta, point(X,Y)),

    send(Carta, recogniser, click_gesture(left, '', single,
                 message(@prolog, gestisci_click, Carta))),

    term_string(Valore, String),
    new(Testo, text(String)),
    (   String == "cambio"
    ->  send(Testo, string, 'C')
    ;
    true),
    send(Testo, font, font(helvetica, bold, 20)),
    send(Testo, colour, colour(white)),
    get(Testo, width, TestoWidth),
    get(Testo, height, TestoHeight),
    TestoX is X + (68 - TestoWidth) / 2,
    TestoY is Y + (100 - TestoHeight) / 2,
    send(@dialog, display, Testo, point(TestoX, TestoY)),
    boxes_giocatore(ListaBox),
    Box = [Carta,Testo,Valore,Colore],
    append([Box],ListaBox,NuovaListaBox),
    retract(boxes_giocatore(_)),
    assertz(boxes_giocatore(NuovaListaBox)).
    %writeln(''),
    %writeln(NuovaListaBox).


crea_carta_giocata :-
    X is 345-73,
    Y is 350-105/2,

    carte_giocate([card(Valore,Colore) | _ ]),
    new(Carta, box(68,100)),
    rimuovi_suffisso_2(Colore,ColoreEffettivo),
    (   ColoreEffettivo = yellow
    ->
    send(Carta, fill_pattern, colour(orange))
    ;
    send(Carta, fill_pattern, colour(ColoreEffettivo))
    ),

    send(Carta, colour, white),
    send(Carta, radius, 7),
    send(@dialog, display, Carta, point(X,Y)),

    term_string(Valore, StringGiocata),
    new(TestoGiocato, text(StringGiocata)),
    (   StringGiocata == "cambio"
    ->  send(TestoGiocato, string, 'C')
    ;
    true),
    send(TestoGiocato, font, font(helvetica, bold, 20)),
    send(TestoGiocato, colour, colour(white)),
    get(TestoGiocato, width, TestoWidth),
    get(TestoGiocato, height, TestoHeight),
    TestoX is X + (68 - TestoWidth) / 2,
    TestoY is Y + (100 - TestoHeight) / 2,
    send(@dialog, display, TestoGiocato, point(TestoX, TestoY)).


gestisci_click(Carta) :-
    giocatore_attivo(GiocatoreAttivo),
    boxes_giocatore(ListaBox),
    carte_giocate([PrimaCarta|_]),
    cerca_carta(Carta, ListaBox,Valore,Colore),
    (   GiocatoreAttivo = 1
        ->
                         (
                              carta_valida(card(Valore,Colore),PrimaCarta)
                              ->
                              gioca_carta(card(Valore,Colore)),
                              crea_carta_giocata,
                              cerca_e_rimuovi_carta(Carta, ListaBox, NuovaListaBox),
                              retract(boxes_giocatore(_)),
                              assertz(boxes_giocatore(NuovaListaBox)),
                              setta_mano_giocatore,
                              setta_mano_IA,
                              retractall(giocatore_attivo(_)),
                              assertz(giocatore_attivo(2)),
                              gioca_carta_ia
                              ;
                              writeln('carta non valida')
                          )
        ;
        writeln('Non � il tuo turno!')
    ).

% Cerca la carta cliccata all'interno della lista
cerca_carta(CartaCliccata, [[CartaCliccata, _Testo, Valore, Colore]|_],Valore,Colore) :-
    %writeln('Carta trovata: '),
    %format('Carta: ~w, Testo: ~w, Valore: ~w, Colore: ~w~n', [CartaCliccata, Testo, Valore, Colore]),
    !.

cerca_carta(CartaCliccata, [_|Rest],Valore,Colore) :-
    cerca_carta(CartaCliccata, Rest,Valore,Colore).

cerca_e_rimuovi_carta(CartaCliccata, [[CartaCliccata, Testo, _Valore, _Colore]|Rest], Rest) :-
    %writeln('Carta trovata e rimossa: '),
    %format('Carta: ~w, Testo: ~w, Valore: ~w, Colore: ~w~n', [CartaCliccata, Testo, Valore, Colore]),
    % Libera (rimuove) gli elementi grafici
    free(CartaCliccata),
    free(Testo), !.

cerca_e_rimuovi_carta(CartaCliccata, [Altro|Rest], [Altro|NuovoRest]) :-
    cerca_e_rimuovi_carta(CartaCliccata, Rest, NuovoRest).

    % Predicato per rimuovere tutte le carte
rimuovi_tutte_carte :-
    boxes_giocatore(ListaBox),
    %writeln('Rimuovendo tutte le carte...'),
    retract(boxes_giocatore(_)), % Rimuove la lista corrente
    assertz(boxes_giocatore([])), % Imposta una nuova lista vuota
    rimuovi_tutte_carte_lista(ListaBox).

rimuovi_tutte_carte_lista([]) :-
    %writeln('Tutte le carte sono state rimosse.').
    writeln('').


rimuovi_tutte_carte_lista([[Carta, Testo, _, _] | Rest]) :-
    free(Carta), % Libera (rimuove) la carta dalla finestra grafica
    free(Testo), % Libera (rimuove) il testo dalla finestra grafica
    rimuovi_tutte_carte_lista(Rest).

rimuovi_tutte_carte_ia :-
    boxes_giocatore2(ListaBox2),
    %writeln('Rimuovendo tutte le carte...'),
    retract(boxes_giocatore2(_)), % Rimuove la lista corrente
    assertz(boxes_giocatore2([])), % Imposta una nuova lista vuota
    rimuovi_tutte_carte_lista_Ia(ListaBox2).


% Predicato per rimuovere tutte le carte dalla lista

rimuovi_tutte_carte_lista_Ia([]) :-
    %writeln('Tutte le carte ia sono state rimosse.').
    writeln('').


rimuovi_tutte_carte_lista_Ia([Carta| Rest]) :- % per le carte generiche
    free(Carta), % Libera (rimuove) la carta dalla finestra grafica
    rimuovi_tutte_carte_lista_Ia(Rest).
