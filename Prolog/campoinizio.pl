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
    Yoffset is 105,

    PositionXmazzo is 355,
    PositionYmazzo is 350-Yoffset/2,

    free(@cartamazzo),

    new(@cartamazzo, box(LarghezzaCarta,AltezzaCarta)),

    send(@cartamazzo, fill_pattern, colour(black)),
    send(@cartamazzo, pen, 0),
    send(@cartamazzo, radius, 7),

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







%predicato bottone pesca
