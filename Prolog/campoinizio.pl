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
    LarghezzaCarta is 68,
    AltezzaCarta is 100,
    Yoffset is 105,

    PositionXmazzo is 355,
    PositionYmazzo is 350-Yoffset/2,

    free(@cartamazzo),
    new(@cartamazzo, box(LarghezzaCarta,AltezzaCarta)),

    send(@cartamazzo, fill_pattern, colour(black)),
    send(@cartamazzo, radius, 7),
    send(@cartamazzo, colour, white),

    send(@dialog, display, @cartamazzo, point(PositionXmazzo,PositionYmazzo)),
    send(@cartamazzo, recogniser, click_gesture(left, '', single,
                 message(@prolog, pesca_carte, 1, 1))),


    free(@bottoneUno),
    new(@bottoneUno, box(150, 90)),
    send(@bottoneUno, fill_pattern, colour(yellow)),
    send(@bottoneUno, radius, 20),
    send(@bottoneUno, pen, 3),
    send(@bottoneUno, colour, red),
    send(@dialog, display, @bottoneUno, point(480,350)),

    free(@testoUno),
    new(@testoUno, text('UNO!')),
    send(@testoUno, font, font(helvetica, bold, 36)),
    send(@testoUno, colour, colour(red)),
    get(@testoUno, width, TestoWidth),
    get(@testoUno, height, TestoHeight),
    TestoX is 480 + (150 - TestoWidth) / 2,
    TestoY is 350 + (90 - TestoHeight) / 2,
    send(@dialog, display, @testoUno, point(TestoX, TestoY)),

    send(@bottoneUno, recogniser, click_gesture(left, '', single,
                 message(@prolog, bottone_uno))).


rimuovi_file_da_percorso(PercorsoCompleto, PercorsoSenzaFile) :-
    file_directory_name(PercorsoCompleto, PercorsoSenzaFile).
