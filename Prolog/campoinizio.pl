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
                 message(@prolog, pesca_carte, 1, 1))),

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




    %bottone rosso
    free(@bottoneRosso),
    new(@bottoneRosso, box(70,40)),
    send(@bottoneRosso, fill_pattern, colour(red)),
    send(@bottoneRosso, radius, 10),
    send(@bottoneRosso, colour, white),
    send(@dialog, display, @bottoneRosso, point(70,350)),
    send(@bottoneRosso, recogniser, click_gesture(left, '', single,
                 message(@prolog, cambio_colore, @bottoneRosso))),

    %bottone blu
    free(@bottoneBlu),
    new(@bottoneBlu, box(70,40)),
    send(@bottoneBlu, fill_pattern, colour(blue)),
    send(@bottoneBlu, radius, 10),
    send(@bottoneBlu, colour, white),
    send(@dialog, display, @bottoneBlu, point(150,350)),
    send(@bottoneBlu, recogniser, click_gesture(left, '', single,
                 message(@prolog, cambio_colore, @bottoneBlu))),

    %bottone giallo
    free(@bottoneGiallo),
    new(@bottoneGiallo, box(70,40)),
    send(@bottoneGiallo, fill_pattern, colour(orange)),
    send(@bottoneGiallo, radius, 10),
    send(@bottoneGiallo, colour, white),
    send(@dialog, display, @bottoneGiallo, point(70,400)),
    send(@bottoneGiallo, recogniser, click_gesture(left, '', single,
                 message(@prolog, cambio_colore, @bottoneGiallo))),

    %bottone verde
    free(@bottoneVerde),
    new(@bottoneVerde, box(70,40)),
    send(@bottoneVerde, fill_pattern, colour(green)),
    send(@bottoneVerde, radius, 10),
    send(@bottoneVerde, colour, white),
    send(@dialog, display, @bottoneVerde, point(150,400)),
    send(@bottoneVerde, recogniser, click_gesture(left, '', single,
                 message(@prolog, cambio_colore, @bottoneVerde))),

        term_to_atom(@bottoneRosso, BottoneRosso),
        term_to_atom(@bottoneBlu, BottoneBlu),
        term_to_atom(@bottoneGiallo, BottoneGiallo),
        term_to_atom(@bottoneVerde, BottoneVerde),


    Lista = [[BottoneRosso, 'red'],[BottoneBlu, 'blue'], [BottoneVerde, 'green'], [BottoneGiallo, 'orange']],
    retractall(boxes_colori(_)),
    assertz(boxes_colori(Lista)),
    writeln(Lista).


cambio_colore(Bottone) :-
    writeln('HAI CLICCATO:'),
    boxes_colori(Lista),
    cerca_colore(Bottone,Lista,Colore),
    retractall(colore(_)),
    assertz(colore(Colore)),
    writeln(Colore).

% Cerca la carta cliccata all'interno della lista
cerca_colore(BottoneCliccato, [[BottoneCliccato,Colore]|_],Colore) :-
    writeln('Colore trovato: '),
    writeln(Colore),
    %format('Carta: ~w, Testo: ~w, Valore: ~w, Colore: ~w~n', [CartaCliccata, Testo, Valore, Colore]),
    !.

cerca_colore(BottoneCliccato, [_|Rest], Colore) :-
    cerca_colore(BottoneCliccato, Rest, Colore).



rimuovi_file_da_percorso(PercorsoCompleto, PercorsoSenzaFile) :-
    file_directory_name(PercorsoCompleto, PercorsoSenzaFile).
