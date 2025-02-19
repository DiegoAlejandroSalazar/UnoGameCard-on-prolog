regole :-
    free(@finestraEsterna),
    free(@finestraregole),

    new(@finestraregole, dialog('Regole del Gioco - Uno e Mezzo')),
    %send(@finestraregole, scrollbars, vertical),
    send(@finestraregole, size, size(700, 700)),

    % Sfondo
    free(@device2),
    new(@device2, device),
    send(@finestraregole, display, @device2, point(0,0)),

    source_file(regole, File2),
    rimuovi_file_da_percorso(File2, Risultato2),
    directory_file_path(Risultato2, '/Immagini/sfondoregole.jpg', NuovoPercorso2),
    new(Imagefile4, image(NuovoPercorso2)),
    new(Bitmap2, bitmap(Imagefile4)),
    send(@device2, display, Bitmap2),
    send(Bitmap2, center, @device2?center),


    % Aggiungi titolo
    new(Testo1, text('')),
    send(@finestraregole, display, Testo1, point(0,0)),
    send(@finestraregole, append, text('Regole del Gioco', center, font(helvetica, bold, 20))),

    % Obiettivo del gioco
    send(@finestraregole, append, text('1. Come vincere:', left, font(helvetica, bold, 14))),
    send(@finestraregole, append, text('   Arriva a zero carte prima del tuo avversario!!', left, font(helvetica, normal, 12))),

    % Flusso del gioco
    send(@finestraregole, append, text('2. Mosse:', left, font(helvetica, bold, 14))),
    send(@finestraregole, append, text('   - In ogni turno puoi scegliere di giocare una carta dalla tua mano se hai una carta dello stesso colore\n      o stesso valore della carta al centro del tavolo;', left, font(helvetica, normal, 12))),
   % send(@finestraregole, append, text('      hai una carta dello stesso colore o stessa valore della carta al centro del tavolo;', left, font(helvetica, normal, 12))),
    send(@finestraregole, append, text('   - Altrimenti se non si ha possibilit� di giocare, � obbligatorio pescare una carta;', left, font(helvetica, normal, 12))),
    send(@finestraregole, append, text('   - Il turno passa poi all\'avversario, che far� la sua mossa;', left, font(helvetica, normal, 12))),
    send(@finestraregole, append, text('   - Il gioco continua alternando i turni tra i giocatori fino a che uno di essi non finisce le carte.', left, font(helvetica, normal, 12))),


    % Carte speciali
     send(@finestraregole, append, text('3. Carte speciali:', left, font(helvetica, bold, 14))),
     send(@finestraregole, append, text('   - Le carte +2 fanno pescare due carte all\'avversario;', left, font(helvetica, normal, 12))),
     send(@finestraregole, append, text('   - Le carte +4-cambio fanno pescare quattro carte all\'avversario e permettono di cambiare colore;', left, font(helvetica, normal, 12))),
     send(@finestraregole, append, text('   - Le carte cambio colore permettono di sceliere il colore della prossima carta che l\'avversario dovr� giocare;', left, font(helvetica, normal, 12))),
     send(@finestraregole, append, text('   - Le carte stop permettono di bloccare il turno dell\'avversario e quindi giocare una carta in pi�.', left, font(helvetica, normal, 12))),

    % bottone UNO!
    send(@finestraregole, append, text('4. Bottone UNO!:', left, font(helvetica, bold, 14))),
    send(@finestraregole, append, text('   - Quando si avr� possibilit� di giocare una carta si potr� cliccare il bottone UNO!;', left, font(helvetica, normal, 12))),
    send(@finestraregole, append, text('   - Se non lo si clicca prima della fine del turno si dovranno pescare due carte;', left, font(helvetica, normal, 12))),
    send(@finestraregole, append, text('   - Se lo si clicca nel momento sbagliato si dovranno pescare due carte.', left, font(helvetica, normal, 12))),

    % Cambio colore
    send(@finestraregole, append, text('5. Cambio colore:', left, font(helvetica, bold, 14))),
    send(@finestraregole, append, text('   - Prima di giocare una carta cambio colore o +4-cambio, bisogna selezionare il colore', left, font(helvetica, normal, 12))),
    send(@finestraregole, append, text('     da uno dei bottoni sulla sinistra del tavolo e, solo successivamente, giocare la carta.', left, font(helvetica, normal, 12))),


    % Pulsante per chiudere
    free(@bottoneChiudi),
    new(@bottoneChiudi, box(200,75)),
    send(@bottoneChiudi, fill_pattern, colour(white)),
    send(@bottoneChiudi, colour, black),
    send(@bottoneChiudi, radius, 10),
    send(@finestraregole, display, @bottoneChiudi, point(250, 575)),
    send(@bottoneChiudi, recogniser, click_gesture(left, '', single,
                 message(@prolog, chiudi_finestra))),

    % Testo chiudi
    free(@testoChiudi),
    new(@testoChiudi, text('Chiudi')),
    send(@testoChiudi, font, font(helvetica, bold, 36)),
    send(@testoChiudi, colour, colour(black)),
    get(@testoChiudi, width, TestoWidthC),
    get(@testoChiudi, height, TestoHeightC),
    TestoCX is 250 + (200 - TestoWidthC) / 2,
    TestoCY is 575 + (75 - TestoHeightC) / 2,
    send(@finestraregole, display, @testoChiudi, point(TestoCX, TestoCY)),




    % Apre finestra
    send(@finestraregole, open).


chiudi_finestra :-
    free(@finestraEsterna),
    free(@finestraregole).
