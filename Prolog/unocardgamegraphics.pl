:- use_module(library(pce)).
:- [regole].
start_game :-
    free(@dialog), % @ prende indirizzo di memoria
    % creo finestra
    new(@dialog, dialog('Uno e mezzo')),
    send(@dialog, size, size(700,700)),
    send(@dialog, done_message, message(@prolog, esci_dal_gioco)),
   % send(@dialog, background, white),


    %inserisco l'immagine come sfondo
    %source_file(start_app, File),
    %rimuovi_file_da_percorso(File, Risultato),
    %directory_file_path(Risultato, '/Immagini/background.jpg', NuovoPercorso),
    new(Background, image('C:/Users/diego/Desktop/Prolog/UnoGameCard-on-prolog/Prolog/immagini/background.jpeg')),
    new(BitmapBackground, bitmap(Background)),
    send(@dialog, display, BitmapBackground),
    send(BitmapBackground, center, @dialog?center),


    % immagine titolo
    get(@dialog,size, size(W, _)),
    new(Imagefile, image('C:/Users/diego/Desktop/Prolog/UnoGameCard-on-prolog/Prolog/immagini/Title_Image.jpg')),
    new(BitmapTitle, bitmap(Imagefile)),
    send(@dialog, display, BitmapTitle),
    send(BitmapTitle, center, @dialog?center),
    get(BitmapTitle,size,size(Iw,_)),
    Ximage is (W-Iw)/2, % per centrare
    send(@dialog, display, BitmapTitle, point(Ximage,10)),
    % new(Label, text('UNO E MEZZO')),
    %send(Label, font, font(helvetica, bold, 20)),


    %bottone play
    free(@playbutton),
    new(@playbutton, button('Inizia Gioco', message(@prolog, start_the_game))),
    send(@playbutton, size, size(450, 100)), % Imposta la dimensione del bottone
    send(@playbutton, font, font(helvetica, bold, 30)), % Modifica il font del bottone
    get(@playbutton,size,size(Pbw,_)),
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
    writeln('Il gioco è iniziato!').

%rimuovi_file_da_percorso(PercorsoCompleto, PercorsoSenzaFile) :-
%   file_directory_name(PercorsoCompleto, PercorsoSenzaFile).

esci_dal_gioco :-
    free(@dialog).
