lista_X([ 24,
          24+73,
          24+2*73,
          24+3*73,
          24+4*73,
          24+5*73,
          24+6*73,
          24+7*73,
          24+8*73,
          24,
          24+73,
          24+2*73,
          24+3*73,
          24+4*73,
          24+5*73,
          24+6*73,
          24+7*73,
          24+8*73
        ]).

lista_Y([ 580,
          580,
          580,
          580,
          580,
          580,
          580,
          580,
          580,
          580-105,
          580-105,
          580-105,
          580-105,
          580-105,
          580-105,
          580-105,
          580-105,
          580-105
        ]).

%lista_X_IA � uguale a lista_X
lista_Y_IA([ 20,
             20,
             20,
             20,
             20,
             20,
             20,
             20,
             20,
             20+105,
             20+105,
             20+105,
             20+105,
             20+105,
             20+105,
             20+105,
             20+105,
             20+105
           ]).


campo_inizio :-
    Yoffset is 105,

    PositionXmazzo is 355,
    PositionYmazzo is 350-Yoffset/2,

    % Carta Mazzo
    free(@cartamazzo),
    new(@cartamazzo, box(68,100)),
    send(@cartamazzo, fill_pattern, colour(black)),
    send(@cartamazzo, radius, 7),
    send(@cartamazzo, colour, white),

    send(@dialog, display, @cartamazzo, point(PositionXmazzo,PositionYmazzo)),
    send(@cartamazzo, recogniser, click_gesture(left, '', single,
                 message(@prolog, bottone_pesca))),

    % Testo Carta Mazzo
    free(@testoMazzo),
    new(@testoMazzo, text('UNO')),
    send(@testoMazzo, font, font(helvetica, bold, 20)),
    send(@testoMazzo, colour, colour(yellow)),
    get(@testoMazzo, width, TestoMazzoWidth),
    get(@testoMazzo, height, TestoMazzoHeight),
    TestoMazzoX is PositionXmazzo + (68 - TestoMazzoWidth) / 2,
    TestoMazzoY is PositionYmazzo + (100 - TestoMazzoHeight) / 2,
    send(@dialog, display, @testoMazzo, point(TestoMazzoX, TestoMazzoY)),


    % Bottone Uno!
    free(@bottoneUno),
    new(@bottoneUno, box(150, 90)),
    send(@bottoneUno, fill_pattern, colour(yellow)),
    send(@bottoneUno, radius, 20),
    send(@bottoneUno, pen, 3),
    send(@bottoneUno, colour, red),
    send(@dialog, display, @bottoneUno, point(480,350)),
    send(@bottoneUno, recogniser, click_gesture(left, '', single,
                 message(@prolog, bottone_uno))),

    % Testo bottone Uno!
    free(@testoUno),
    new(@testoUno, text('UNO!')),
    send(@testoUno, font, font(helvetica, bold, 36)),
    send(@testoUno, colour, colour(red)),
    get(@testoUno, width, TestoWidth),
    get(@testoUno, height, TestoHeight),
    TestoX is 480 + (150 - TestoWidth) / 2,
    TestoY is 350 + (90 - TestoHeight) / 2,
    send(@dialog, display, @testoUno, point(TestoX, TestoY)),


    free(@bottoneRosso),
    new(@bottoneRosso, box(70,40)),
    send(@bottoneRosso, fill_pattern, colour(red)),
    send(@bottoneRosso, radius, 10),
    send(@bottoneRosso, colour, white),
    send(@dialog, display, @bottoneRosso, point(70,350)),
    send(@bottoneRosso, recogniser, click_gesture(left, '', single,
                 message(@prolog,  colore_selezionato,@bottoneRosso, red))),

    %bottone blu
    free(@bottoneBlu),
    new(@bottoneBlu, box(70,40)),
    send(@bottoneBlu, fill_pattern, colour(blue)),
    send(@bottoneBlu, radius, 10),
    send(@bottoneBlu, colour, white),
    send(@bottoneBlu, pen, 0),
    send(@dialog, display, @bottoneBlu, point(150,350)),
    send(@bottoneBlu, recogniser, click_gesture(left, '', single,
                 message(@prolog,  colore_selezionato,@bottoneBlu, blue))),

    %bottone giallo
    free(@bottoneGiallo),
    new(@bottoneGiallo, box(70,40)),
    send(@bottoneGiallo, fill_pattern, colour(orange)),
    send(@bottoneGiallo, radius, 10),
    send(@bottoneGiallo, colour, white),
    send(@bottoneGiallo, pen, 0),
    send(@dialog, display, @bottoneGiallo, point(70,400)),
    send(@bottoneGiallo, recogniser, click_gesture(left, '', single,
                 message(@prolog,  colore_selezionato,@bottoneGiallo, yellow))),

    %bottone verde
    free(@bottoneVerde),
    new(@bottoneVerde, box(70,40)),
    send(@bottoneVerde, fill_pattern, colour(green)),
    send(@bottoneVerde, radius, 10),
    send(@bottoneVerde, colour, white),
    send(@bottoneVerde, pen, 0),
    send(@dialog, display, @bottoneVerde, point(150,400)),
    send(@bottoneVerde, recogniser, click_gesture(left, '', single,
                 message(@prolog, colore_selezionato,@bottoneVerde, green))),

    Lista = [[@bottoneRosso, red],[@bottoneBlu, blue], [@bottoneVerde, green], [@bottoneGiallo, yellow]],
    retractall(boxes_colori(_)),
    assertz(boxes_colori(Lista)).

colore_selezionato(BoxColorato,NuovoColore) :-
    send(BoxColorato, pen, 1),
    retractall(turno_bloccato(_)),
    assertz(turno_bloccato(no)),
    retractall(colore(_)),
    assertz(colore(NuovoColore)),
    boxes_colori(Lista),
    elimina_bottoni_non_selezionati(Lista, NuovoColore).

% Predicato per eliminare i bottoni non selezionati
elimina_bottoni_non_selezionati([], _).
elimina_bottoni_non_selezionati([[BoxColorato, Colore] | Rest], NuovoColore) :-
    (
     Colore \= NuovoColore
     -> send(BoxColorato, pen, 0)
     ;
     true
    ),
    elimina_bottoni_non_selezionati(Rest, NuovoColore).




win_condition :-
    send(@device, clear),
    free(@device),
    new(@device, device),
    send(@dialog, display, @device, point(0,0)),

    %sfondo
    source_file(win_condition, File1),
    rimuovi_file_da_percorso(File1, Risultato1),
    directory_file_path(Risultato1, '/Immagini/win.jpg', NuovoPercorso1),
    new(Imagefile3, image(NuovoPercorso1)),
    new(Bitmap1, bitmap(Imagefile3)),
    send(@device, display, Bitmap1),
    send(Bitmap1, center, @device?center),

    %box replay
    free(@bottoneReplay),
    new(@bottoneReplay, box(300,75)),
    send(@bottoneReplay, fill_pattern, colour(black)),
    send(@bottoneReplay, radius, 10),
    send(@bottoneReplay, colour, white),
    send(@dialog, display, @bottoneReplay, point(200,400)),
    send(@bottoneReplay, recogniser, click_gesture(left, '', single,
                 message(@prolog, start_the_game))),

    %testo replay
    free(@testoReplay),
    new(@testoReplay, text('Replay')),
    send(@testoReplay, font, font(helvetica, bold, 30)),
    send(@testoReplay, colour, colour(white)),
    get(@testoReplay, width, TestoWidth),
    get(@testoReplay, height, TestoHeight),
    TestoX is 200 + (300 - TestoWidth) / 2,
    TestoY is 400 + (75 - TestoHeight) / 2,
    send(@dialog, display, @testoReplay, point(TestoX, TestoY)),

    false.


loss_condition :-
    send(@device, clear),
    free(@device),
    new(@device, device),
    send(@dialog, display, @device, point(0,0)),

    %sfondo
    source_file(win_condition, File1),
    rimuovi_file_da_percorso(File1, Risultato1),
    directory_file_path(Risultato1, '/Immagini/loss.jpg', NuovoPercorso1),
    new(Imagefile3, image(NuovoPercorso1)),
    new(Bitmap1, bitmap(Imagefile3)),
    send(@device, display, Bitmap1),
    send(Bitmap1, center, @device?center),

    %box replay
    free(@bottoneReplay),
    new(@bottoneReplay, box(300,75)),
    send(@bottoneReplay, fill_pattern, colour(black)),
    send(@bottoneReplay, radius, 10),
    send(@bottoneReplay, colour, white),
    send(@dialog, display, @bottoneReplay, point(200,400)),
    send(@bottoneReplay, recogniser, click_gesture(left, '', single,
                 message(@prolog, start_the_game))),

    %testo replay
    free(@testoReplay),
    new(@testoReplay, text('Replay')),
    send(@testoReplay, font, font(helvetica, bold, 30)),
    send(@testoReplay, colour, colour(white)),
    get(@testoReplay, width, TestoWidth),
    get(@testoReplay, height, TestoHeight),
    TestoX is 200 + (300 - TestoWidth) / 2,
    TestoY is 400 + (75 - TestoHeight) / 2,
    send(@dialog, display, @testoReplay, point(TestoX, TestoY)),

    false.


rimuovi_file_da_percorso(PercorsoCompleto, PercorsoSenzaFile) :-
    file_directory_name(PercorsoCompleto, PercorsoSenzaFile).


mio_turno :-
    free(@testoTurnoIA),
    free(@testoTurnoPL),
    new(@testoTurnoPL, text('E\' il tuo turno!')),
    send(@testoTurnoPL, font, font(helvetica, bold, 14)),
    send(@testoTurnoPL, colour, white),
    send(@dialog, display, @testoTurnoPL, point(296, 420)).
non_mio_turno :-
    free(@testoTurnoIA),
    free(@testoTurnoPL),
    new(@testoTurnoIA, text('Turno avversario!')),
    send(@testoTurnoIA, font, font(helvetica, bold, 14)),
    send(@testoTurnoIA, colour, white),
    send(@dialog, display, @testoTurnoIA, point(284, 420)).

