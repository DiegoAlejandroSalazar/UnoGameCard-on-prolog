regole :-
    free(@finestraEsterna),
    free(@finestraregole),

    new(@finestraregole, dialog('Regole del Gioco - un mezzo')),
    %send(@finestraregole, scrollbars, vertical),
    send(@finestraregole, size, size(650, 400)),

    % Aggiungi titolo
    send(@finestraregole, append, text('Regole del Gioco', center, font(courier, bold, 20))),

    % Obiettivo del gioco
    send(@finestraregole, append, text('1. Come vincere:', left, font(courier, bold, 14))),
    send(@finestraregole, append, text('   Arriva a 0 carte prima del tuo avversario!!', left, font(times, roman, 12))),

    % Flusso del gioco
    send(@finestraregole, append, text('2. Gioco in se:', left, font(courier, bold, 14))),
    send(@finestraregole, append, text('   - In ogni turno puoi scegliere di giocare una carta dalla tua mano se :', left, font(times, roman, 12))),
    send(@finestraregole, append, text('   - se hai una carta dello stesso colore o stessa forma del mazzo delle carte giocate', left, font(times, roman, 12))),
    send(@finestraregole, append, text('   - se non hai possibilità di giocare pesca una carta.', left, font(times, roman, 12))),
    send(@finestraregole, append, text('   - Il turno passa poi all\'avversario.', left, font(times, roman, 12))),
    send(@finestraregole, append, text('   - Il gioco continua alternando i turni tra i giocatori fino a che un giocatore non vince.', left, font(times, roman, 12))),

    % bottone UNO!
    send(@finestraregole, append, text('3. Bottone UNO!:', left, font(courier, bold, 14))),
    send(@finestraregole, append, text('   - Quando si avrà possibilità di giocare una carta si potrà cliccare il bottone UNO!.', left, font(times, roman, 12))),
    send(@finestraregole, append, text('   - se non lo si clicca prima della fine del turno si dovranno pescare 2 carte.', left, font(times, roman, 12))),
    % Aggiungi un pulsante per chiudere
    send(@finestraregole, append, button('Chiudi', message(@finestraregole, destroy))),
    send(@finestraregole, open).
