lista_X([ 24+4*73,
          24+3*73,
          24+5*73,
          24+2*73,
          24+6*73,
          24+1*73,
          24+7*73,
          24,
          24+8*73,
          24+4*73,
          24+3*73,
          24+5*73,
          24+2*73,
          24+6*73,
          24+1*73,
          24+7*73,
          24,
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
    send(@dialog, background, colour(white)),

    LarghezzaCarta is 68,
    AltezzaCarta is 100,
    Xoffset is 73,
    Yoffset is 105,

    PositionXgiocata is 345-Xoffset,
    PositionYgiocata is 350-Yoffset/2,

    PositionXmazzo is 355,
    PositionYmazzo is 350-Yoffset/2,

    free(@cartamazzo),
    free(@cartagiocata),

    new(@cartagiocata,box(LarghezzaCarta,AltezzaCarta)),
    new(@cartamazzo, box(LarghezzaCarta,AltezzaCarta)),

    send(@cartagiocata, fill_pattern, colour(white)),
    send(@cartamazzo, fill_pattern, colour(black)),

    send(@dialog, display, @cartagiocata,point(PositionXgiocata,PositionYgiocata)),
    send(@dialog, display, @cartamazzo, point(PositionXmazzo,PositionYmazzo)),





    %%%%%%%%% cose per l'input con il clic, chiedere a laura %%%%%%%%%
   %% forall(casella_punteggio_g1(C),
          % (
               %send(C, recogniser, click_gesture(left, '', single, message(@prolog, click_assegna_punteggio, C)))
          % )
         % ),
   % forall(casella_punteggio_g2(C),
          % (
             %  send(C, recogniser, click_gesture(left, '', single, message(@prolog, click_blocca_categoria, C)))
       %    )
       %   ),


    true.




crea_carte(Valore, Colore, X, Y) :-
    new(Carta, box(68,100)),
    send(Carta, fill_pattern, colour(Colore)),
    send(@dialog, display, Carta, point(X,Y)),

    term_string(Valore, String),
    new(Testo, text(String)),
    send(Testo, font, font(helvetica, bold, 20)),
    get(Testo, width, TestoWidth),
    get(Testo, height, TestoHeight),
    TestoX is X + (68 - TestoWidth) / 2,
    TestoY is Y + (100 - TestoHeight) / 2,
    send(@dialog, display, Testo, point(TestoX, TestoY)).

crea_carta_giocata(Valore,Colore) :-
    X is 345-73,
    Y is 350-105/2,

    new(Carta, box(68,100)),
    send(Carta, fill_pattern, colour(Colore)),
    send(@dialog, display, Carta, point(X,Y)),

    term_string(Valore, String),
    new(Testo, text(String)),
    send(Testo, font, font(helvetica, bold, 20)),
    get(Testo, width, TestoWidth),
    get(Testo, height, TestoHeight),
    TestoX is X + (68 - TestoWidth) / 2,
    TestoY is Y + (100 - TestoHeight) / 2,
    send(@dialog, display, Testo, point(TestoX, TestoY)).


