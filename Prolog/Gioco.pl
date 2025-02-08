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

    writeln('Il gioco è iniziato!').



setta_mano_giocatore:-
    mano_giocatore1(ManoGiocatore1),
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
         flush_output)
    ).

setta_mano_IA :-
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


distruggi_carte_giocatore :-
    lista_X(ListaX),
    lista_Y(ListaY),

    forall(
        (
        nth0(Indice, ListaX, PosizioneX),
        nth0(Indice, ListaY, PosizioneY)),
        (carta_generica(white, PosizioneX, PosizioneY)
        )).

distruggi_carte_IA :-
    lista_X(ListaX),
    lista_Y_IA(ListaY),

    forall(
        (
        nth0(Indice, ListaX, PosizioneX),
        nth0(Indice, ListaY, PosizioneY)),
        (carta_generica(white, PosizioneX, PosizioneY)
        )).

carta_generica(Colore,X,Y) :-
    new(Carta, box(68,100)),
    send(Carta, pen, 0),
    send(Carta, radius, 7),
    send(Carta, fill_pattern, colour(Colore)),

    send(@dialog, display, Carta, point(X,Y)),
    flush_output.


crea_carte(Valore, Colore, X, Y) :-
    new(Carta, box(68,100)),

    (   Colore = yellow
    ->
    send(Carta, fill_pattern, colour(orange))
    ;
    send(Carta, fill_pattern, colour(Colore))
    ),

    send(Carta, pen, 0),
    send(Carta, radius, 7),
    send(@dialog, display, Carta, point(X,Y)),

    send(Carta, recogniser, click_gesture(left, '', single,
                 message(@prolog, gestisci_click, Carta))),

    term_string(Valore, String),
    new(Testo, text(String)),
    send(Testo, font, font(helvetica, bold, 20)),
    send(Testo, colour, colour(white)),
    get(Testo, width, TestoWidth),
    get(Testo, height, TestoHeight),
    TestoX is X + (68 - TestoWidth) / 2,
    TestoY is Y + (100 - TestoHeight) / 2,
    send(@dialog, display, Testo, point(TestoX, TestoY)),

    assert(boxes_giocatore(Carta,Valore,Colore)).
    %boxes_giocatore(CarteGiocabili),
    %CartaLista = [Carta,Valore,Colore],
    %CartaNuova = [CartaLista],
    %append(CartaNuova, CarteGiocabili, NuoveCarteGiocabili),
    %retractall(boxes_giocatore([])),
    %assertz(boxes_giocatore(NuoveCarteGiocabili)),
    %writeln(NuoveCarteGiocabili).

crea_carta_giocata(Valore,Colore) :-
    X is 345-73,
    Y is 350-105/2,

    new(Carta, box(68,100)),

    (   Colore = yellow
    ->
    send(Carta, fill_pattern, colour(orange))
    ;
    send(Carta, fill_pattern, colour(Colore))
    ),

    send(Carta, pen, 0),
    send(Carta, radius, 7),
    send(@dialog, display, Carta, point(X,Y)),

    term_string(Valore, String),
    new(Testo, text(String)),
    send(Testo, font, font(helvetica, bold, 20)),
    send(Testo, colour, colour(white)),
    get(Testo, width, TestoWidth),
    get(Testo, height, TestoHeight),
    TestoX is X + (68 - TestoWidth) / 2,
    TestoY is Y + (100 - TestoHeight) / 2,
    send(@dialog, display, Testo, point(TestoX, TestoY)).


crea_box(Valore, Colore) :-
    new(Box, box(200, 100)),
    send(Box, fill_pattern, colour(Colore)),
    assert(mia_variabile_box(Box, Valore, Colore)),
    send(@dialog, display, Box, point(50, 50)),
    send(Box, recogniser, click_gesture(left, '', single,
                    message(@prolog, gestisci_click, Box))),
    Box.



gestisci_click(Carta) :-
    boxes_giocatore(Carta,Valore,Colore),
    writeln(Valore),
    writeln(Colore).
