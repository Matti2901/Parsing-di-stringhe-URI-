Questo progetto è stato svolto da:
Ceccarelli Matteo 869079, 
Milanese Mattia 869161.

Il progetto è una libreria che riconosce una stringa URI
e ne crea una struttura rappresentativa.

L'editor usato è stato Emacs di swi-prolog.
L'idea di base è stata quella realizzata mediante
l'implementazione di una grammatica tramite DCG prolog,
il riconoscimento iniziale viene svolto da questa grammatica tramite
il predicato phrase/2.
Successivamente viene creata una lista di caratteri dalla stringa uri 
passata in input al predicato uri_parse/2.
attraverso un altra serie di predicati abbiamo raccolto le parti della
lista di caratteri che corrispondevano alle parte di una uri, e riconvertite poi in atomi.
sono presenti dei predicati di supporto per svolgere semplici azioni utili allo
scopo finale.

Nella grammatica abbiamo interpretato il carattere '/' obbligatorio solo nel 
caso in cui sia presente la coppia authority-path, per distinguere l'uno
dall'altro, come indicato sul forum nelle testuali parole:

"Lo slash è obbligatorio per distinguere la parte "authority" dal path.".

In tutti gli altri casi l'abbiamo considerato opzionale.

uri_display1 e uri_display2 prendono come input iniziale una struttura uri.
inoltre uri_display2 prende anche uno stream su cui stampare.

