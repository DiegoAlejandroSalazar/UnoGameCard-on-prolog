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
    directory_file_path(Risultato, '/Immagini/background.jpg', NuovoPercorso),
    new(@imagefile, image(NuovoPercorso)),
    new(Bitmap, bitmap(@imagefile)),
    send(@device, display, Bitmap),
    send(Bitmap, center, @device?center),

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

rimuovi_file_da_percorso(PercorsoCompleto, PercorsoSenzaFile) :-
    file_directory_name(PercorsoCompleto, PercorsoSenzaFile).

start_the_game :-
    send(@dialog, background, white),
    free(@playbutton),
    free(@rulesbutton),

    campo_inizio,
    inizializza_gioco,

    writeln('Il gioco � iniziato!').


setta_mano_giocatore:-
    mano_giocatore1(ManoGiocatore1),

    length(ManoGiocatore1, IndiceMax),
    writeln('pisello'),
    writeln(ManoGiocatore1),
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


libera_tutte_le_carte :-
    forall(boxes_giocatore(Box, _Valore, _Colore), free(Box)),
    retractall(boxes_giocatore(_,_,_)).






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


crea_carta_giocata :-
    X is 345-73,
    Y is 350-105/2,

    carte_giocate([card(Valore,Colore) | _ ]),

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


gestisci_click(Carta) :-
    boxes_giocatore(Carta,Valore,Colore),
    carte_giocate([PrimaCarta|_]),
    % carte_giocate(CarteGiocate),
    % mano_giocatore1(ManoGiocatore1),
    % writeln(PrimaCarta),

    (
        carta_valida(card(Valore,Colore),PrimaCarta)
          -> gioca_carta(Valore,Colore),
          %send(Carta, displayed, @off),
          %setta_mano_giocatore,
          %writeln('heehee'),
          crea_carta_giocata,
          %free(Carta),
          %writeln('yeet'),
          raccolta_carte(ListaCarte),
          writeln(ListaCarte),
          retract(boxes_giocatore(Carta,Valore,Colore))
    ;
    writeln('carta non valida'))
    .


%    boxes_giocatore(Carta,Valore,Colore),
%    valida(Valida),

%    gioca_carta(Valore,Colore),
%    writeln(Valida),
%    (   Valida = true
%     -> retract(valida(_)),
%       assertz(valida(false)),
%       writeln(Valida),
%       free(Carta),
%       retract(boxes_giocatore(Carta,Valore,Colore))).

raccolta_carte(ListaCarte) :-
    findall(boxes_giocatore(Carta, Valore, Colore),
            boxes_giocatore(Carta, Valore, Colore),
            ListaCarte).
