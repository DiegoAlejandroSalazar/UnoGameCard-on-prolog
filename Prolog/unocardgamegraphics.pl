:- use_module(library(pce)).
start_game :-
    free(@dialog), % @ prende indirizzo di memoria
    new(@dialog, dialog('Uno e mezzo')),
    send(@dialog, size, size(700,700)),
    send(@dialog, background, white),
    get(@dialog,size, size(W, _)),
    new(Imagefile, image('C:/Users/diego/Desktop/Prolog/UnoGameCard-on-prolog/Prolog/Title_Image.jpg')),
    new(Bitmap, bitmap(Imagefile)),
    send(@dialog, display, Bitmap),
    send(Bitmap, center, @dialog?center),
   % new(Label, text('UNO E MEZZO')),
   %send(Label, font, font(helvetica, bold, 20)),
    new(Button, button('Inizia Gioco', message(@prolog, start_the_game))),
    send(Button, size, size(450, 100)), % Imposta la dimensione del bottone
    send(Button, font, font(helvetica, bold, 30)), % Modifica il font del bottone
    % Gestisci il cambiamento di colore quando il bottone è selezionato
   % send(Button, message(Button, change_button_color, green)), % Colore quando selezionato
   % send(Button, message(Button, change_button_color, grey), up), % Colore quando non selezionato
    get(Bitmap,size,size(Iw,_)),
    get(Button,size,size(Bw,_)),
    Ximage is (W-Iw)/2, % per centrare
    Xbutton is (W-Bw)/2,
    send(@dialog, display, Bitmap, point(Ximage,10)),
    send(@dialog, display, Button, point(Xbutton,500)),
    send(@dialog, open).

start_the_game :-
    writeln('Il gioco è iniziato!').
