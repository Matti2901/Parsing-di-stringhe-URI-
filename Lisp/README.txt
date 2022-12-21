Questo progetto è stato svolto da:
Ceccarelli Matteo 869079, 
Milanese Mattia 869161.

Il progetto è una libreria che riconosce una stringa URI
e ne crea una struttura rappresentativa.

La libreria è composta da una serie di funzioni ricorsive 
che ci permettono di riconoscere e creare la struttura,infine sono
presenti altre funzioni ricorsive di supporto.

Per l'identazione abbiamo usato il comando atl-x+indent-region
dell'editor di Emacs.
Alcune righe sono ulteriormente mandate a capo, per evitare il superamento 
delle 80 colonne.

L'idea alla base di base è rappresentata dalla funzione ric-linguaggio che
prende una lista di caratteri creata a partire dalla stringa Uri,e tramite
l'utilizzo della funzione let* e funzioni ricorsive, la lista viene analizzata carattere
per carattere e indirizzata alla varie parti dell'uri che poi verranno ricorvertite
in stringhe.

se la stringa passata non rispetta la grammatica iniziale, allora viene lanciato un errore.

Nella grammatica abbiamo interpretato il carattere '/' obbligatorio solo nel 
caso in cui sia presente la coppia authority-path, per distinguere l'uno
dall'altro, come indicato sul forum nelle testuali parole:

"Lo slash è obbligatorio per distinguere la parte "authority" dal path.".

In tutti gli altri casi l'abbiamo considerato opzionale.

