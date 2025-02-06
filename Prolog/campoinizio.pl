:- dynamic listaCarteGiocatore/1.
:- dynamic listaPosizioniCarteGiocatore/1.

lista_carte_giocatore( @carta01,
                       @carta02,
                       @carta03,
                       @carta04,
                       @carta05,
                       @carta06,
                       @carta07,
                       @carta08,
                       @carta09,
                       @carta10,
                       @carta11,
                       @carta12,
                       @carta13,
                       @carta14,
                       @carta15,
                       @carta16,
                       @carta17,
                       @carta18
                     ).


lista_posizioni_carte([ point(24,580),
                        point(24+73,580),
                        point(24+2*73,580),
                        point(24+3*73,580),
                        point(24+4*73,580),
                        point(24+5*73,580),
                        point(24+6*73,580),
                        point(24+7*73,580),
                        point(24+8*73,580),
                        point(24,580-105),
                        point(24+73,580-105),
                        point(24+2*73,580-105),
                        point(24+3*73,580-105),
                        point(24+4*73,580-105),
                        point(24+5*73,580-105),
                        point(24+6*73,580-105),
                        point(24+7*73,580-105),
                        point(24+8*73,580-105)
                      ]).
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




campo_inizio :-

    retractall(listaCarteGiocatore(_)),
    retractall(listaPosizioniCarteGiocatore(_)),

    assertz(listaCarteGiocatore(lista_carte_giocatore)),
    assertz(listaPosizioniCarteGiocatore(lista_posizioni_carte)),



    send(@dialog, background, colour(white)),

    %% DA QUI carte giocatore
    free(@carta08),
    free(@carta06),
    free(@carta04),
    free(@carta02),
    free(@carta01),
    free(@carta03),
    free(@carta05),
    free(@carta07),
    free(@carta09),

    free(@carta17),
    free(@carta15),
    free(@carta13),
    free(@carta11),
    free(@carta10),
    free(@carta12),
    free(@carta14),
    free(@carta16),
    free(@carta18),

    new(@carta08, box(68, 100)),
    new(@carta06, box(68, 100)),
    new(@carta04, box(68, 100)),
    new(@carta02, box(68, 100)),
    new(@carta01, box(68, 100)),
    new(@carta03, box(68, 100)),
    new(@carta05, box(68, 100)),
    new(@carta07, box(68, 100)),
    new(@carta09, box(68, 100)),

    new(@carta17, box(68,100)),
    new(@carta15, box(68,100)),
    new(@carta13, box(68,100)),
    new(@carta11, box(68,100)),
    new(@carta10, box(68,100)),
    new(@carta12, box(68,100)),
    new(@carta14, box(68,100)),
    new(@carta16, box(68,100)),
    new(@carta18, box(68,100)),

    get(@carta08, size, size(Wcarta, Hcarta)),
    Xoffset is Wcarta+5,
    Yoffset is Hcarta+5,

    send(@dialog, display, @carta08, point(24, 580.4)),
    send(@dialog, display, @carta06, point(24+Xoffset, 580.4)),
    send(@dialog, display, @carta04, point(24+2*Xoffset, 580.4)),
    send(@dialog, display, @carta02, point(24+3*Xoffset, 580.4)),
    send(@dialog, display, @carta01, point(24+4*Xoffset, 580.4)),
    send(@dialog, display, @carta03, point(24+5*Xoffset, 580.4)),
    send(@dialog, display, @carta05, point(24+6*Xoffset, 580.4)),
    send(@dialog, display, @carta07, point(24+7*Xoffset, 580.4)),
    send(@dialog, display, @carta09, point(24+8*Xoffset, 580.4)),

    send(@carta08, displayed, @off),
    send(@carta06, displayed, @off),
    send(@carta07, displayed, @off),
    send(@carta09, displayed, @off),

    send(@dialog, display, @carta17, point(24, 580.4-Yoffset)),
    send(@dialog, display, @carta15, point(24+Xoffset, 580.4-Yoffset)),
    send(@dialog, display, @carta13, point(24+2*Xoffset, 580.4-Yoffset)),
    send(@dialog, display, @carta11, point(24+3*Xoffset, 580.4-Yoffset)),
    send(@dialog, display, @carta10, point(24+4*Xoffset, 580.4-Yoffset)),
    send(@dialog, display, @carta12, point(24+5*Xoffset, 580.4-Yoffset)),
    send(@dialog, display, @carta14, point(24+6*Xoffset, 580.4-Yoffset)),
    send(@dialog, display, @carta16, point(24+7*Xoffset, 580.4-Yoffset)),
    send(@dialog, display, @carta18, point(24+8*Xoffset, 580.4-Yoffset)),

    send(@carta17, displayed, @off),
    send(@carta15, displayed, @off),
    send(@carta13, displayed, @off),
    send(@carta11, displayed, @off),
    send(@carta10, displayed, @off),
    send(@carta12, displayed, @off),
    send(@carta14, displayed, @off),
    send(@carta16, displayed, @off),
    send(@carta18, displayed, @off),


    %% DA QUI carte IA
    free(@cartaia08),
    free(@cartaia06),
    free(@cartaia04),
    free(@cartaia02),
    free(@cartaia01),
    free(@cartaia03),
    free(@cartaia05),
    free(@cartaia07),
    free(@cartaia09),

    free(@cartaia17),
    free(@cartaia15),
    free(@cartaia13),
    free(@cartaia11),
    free(@cartaia10),
    free(@cartaia12),
    free(@cartaia14),
    free(@cartaia16),
    free(@cartaia18),


    new(@cartaia08, box(68, 100)),
    new(@cartaia06, box(68, 100)),
    new(@cartaia04, box(68, 100)),
    new(@cartaia02, box(68, 100)),
    new(@cartaia01, box(68, 100)),
    new(@cartaia03, box(68, 100)),
    new(@cartaia05, box(68, 100)),
    new(@cartaia07, box(68, 100)),
    new(@cartaia09, box(68, 100)),

    new(@cartaia17, box(68,100)),
    new(@cartaia15, box(68,100)),
    new(@cartaia13, box(68,100)),
    new(@cartaia11, box(68,100)),
    new(@cartaia10, box(68,100)),
    new(@cartaia12, box(68,100)),
    new(@cartaia14, box(68,100)),
    new(@cartaia16, box(68,100)),
    new(@cartaia18, box(68,100)),


    send(@dialog, display, @cartaia08, point(24, 19.6)),
    send(@dialog, display, @cartaia06, point(24+Xoffset, 19.6)),
    send(@dialog, display, @cartaia04, point(24+2*Xoffset, 19.6)),
    send(@dialog, display, @cartaia02, point(24+3*Xoffset, 19.6)),
    send(@dialog, display, @cartaia01, point(24+4*Xoffset, 19.6)),
    send(@dialog, display, @cartaia03, point(24+5*Xoffset, 19.6)),
    send(@dialog, display, @cartaia05, point(24+6*Xoffset, 19.6)),
    send(@dialog, display, @cartaia07, point(24+7*Xoffset, 19.6)),
    send(@dialog, display, @cartaia09, point(24+8*Xoffset, 19.6)),

    send(@cartaia08, displayed, @off),
    send(@cartaia06, displayed, @off),
    send(@cartaia07, displayed, @off),
    send(@cartaia09, displayed, @off),

    send(@dialog, display, @cartaia17, point(24, 19.6+Yoffset)),
    send(@dialog, display, @cartaia15, point(24+Xoffset, 19.6+Yoffset)),
    send(@dialog, display, @cartaia13, point(24+2*Xoffset, 19.6+Yoffset)),
    send(@dialog, display, @cartaia11, point(24+3*Xoffset, 19.6+Yoffset)),
    send(@dialog, display, @cartaia10, point(24+4*Xoffset, 19.6+Yoffset)),
    send(@dialog, display, @cartaia12, point(24+5*Xoffset, 19.6+Yoffset)),
    send(@dialog, display, @cartaia14, point(24+6*Xoffset, 19.6+Yoffset)),
    send(@dialog, display, @cartaia16, point(24+7*Xoffset, 19.6+Yoffset)),
    send(@dialog, display, @cartaia18, point(24+8*Xoffset, 19.6+Yoffset)),

    send(@cartaia17, displayed, @off),
    send(@cartaia15, displayed, @off),
    send(@cartaia13, displayed, @off),
    send(@cartaia11, displayed, @off),
    send(@cartaia10, displayed, @off),
    send(@cartaia12, displayed, @off),
    send(@cartaia14, displayed, @off),
    send(@cartaia16, displayed, @off),
    send(@cartaia18, displayed, @off),


    %% CARTE CENTRALI
    free(@cartamazzo),
    free(@cartagiocata),

    new(@cartamazzo, box(68, 100)),
    new(@cartagiocata, box(68,100)),

    send(@dialog, display, @cartamazzo, point(345-Xoffset, 350-Yoffset/2)),
    send(@dialog, display, @cartagiocata, point(355, 350-Yoffset/2)),


    true.



crea_carte(Numero, Colore, X, Y, Carta) :-
    new(Carta, box(68,100)),
    send(Carta, fill_pattern, colour(Colore)),

    term_string(Numero, String),

    send(@dialog, display, Carta, point(X,Y)),


    new(Testo, text(String)),
    send(Testo, font, font(helvetica, bold, 20)),
    get(Testo, width, TestoWidth),
    get(Testo, height, TestoHeight),
    TestoX is X + (68 - TestoWidth) / 2,
    TestoY is Y + (100 - TestoHeight) / 2,
    send(@dialog, display, Testo, point(TestoX, TestoY)).
