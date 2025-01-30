:- use_module(library(pce)).
load_image(Path):-
    (   exists_file(Path) -> % Controlla se il file esiste
        new(ImageObject, picture(Path)), % Carica l'immagine
        send(@dialog, display, ImageObject)
    ;   format('Errore: il file ~w non esiste.~n', [Path]) % Messaggio di errore
    ).
start_game :-
    free(@dialog), % @ prende indirizzo di memoria
    new(@dialog, dialog('Uno e mezzo')),
    send(@dialog, size, size(700,700)),
    send(@dialog, background, green),
    get(@dialog,size, size(W, H)),
    load_image('C:/Users/diego/Documents/Prolog/Title_Image.jpeg'),
    new(Label, text('UNO E MEZZO')),
    send(Label, font, font(helvetica, bold, 20)),
    new(Button, button('Inizia Gioco', message(@prolog, start_the_game))),
    get(Label, size, size(Pw,Ph)),
    X is (W-Pw)/2, % per centrare
    Y is (H-Ph)/2,
    send(@dialog, display, Label, point(X,10)),
    send(@dialog, display, Button, point(X,60)),
    send(@dialog, open).

start_the_game :-
    writeln('Il gioco è iniziato!').
