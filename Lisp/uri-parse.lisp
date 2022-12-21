;;Gruppo: Ceccarelli Matteo 869079,
;;        Milanese Mattia 869161.

;;;; -*-Mode: Lisp -*-

;;identificatori
(defun is-identify (char)
  (and (not (eq char #\/))
       (not (eq char #\?))
       (not (eq char #\#))
       (not (eq char #\@))
       (not (eq char #\:))))

(defun is-identify-host (char)
  (and (not (eq char #\/))
       (not (eq char #\?))
       (not (eq char #\#))
       (not (eq char #\@))
       (not (eq char #\:))
       (not (eq char #\.))))

(defun is-digit (char)
  (or (eq char #\0)
      (eq char #\1)
      (eq char #\2)
      (eq char #\3)
      (eq char #\4)
      (eq char #\5)
      (eq char #\6)
      (eq char #\7)
      (eq char #\8)
      (eq char #\9)))

(defun is-query-char (char)
  (not (eq char #\#)))

;;questa funzione converte una lista di char in stringa
;;ad eccezione che non sia nil, se e' nil vogliamo tenerla nil
(defun conv (l-char)
  (if (characterp (first l-char))
      (coerce l-char 'string)
    nil))

;;questa funzione serve per trasformare una lista di caratteri qualsiasi,
;;in una lista di caratteri minuscoli
(defun dwn-list (l-char)
  (cond ((null l-char) nil)
        (t (cons (char-downcase (first l-char))
                 (dwn-list (rest l-char))))))


;;questa funzione serve per rimuovere un numero di caratteri
;;da una lista
(defun rem-char (list n)
  (if (= 0 n)
      list
    (rem-char (rest list) (- n 1))))


;;questa funzione trova l'ennesimo carattere all'interno di una lista
(defun n-esimo (list n)
  (if (= n 1)
      (first list)
    (n-esimo (rest list) (- n 1))))

;;questa funzione converte una stringa in una lista di char
(defun conv-char-str (stringa)
  (coerce stringa 'list))

;;questa funzione calcola la stringa rimanente tra quella iniziale
;;meno quella finale
(defun remain-str (list-strIn part)
  (cond ((eq part nil) list-strIn)
        ((not (eq (first list-strIn) (first part)))
         list-strIn)
        (t (remain-str (rest list-strIn) (rest part)))))

;;questa funzione controlla se NNN rispetta le condizioni di
;;essere < di 256 e > di 0
(defun control-nnn (l-char)
  (let ((n1 (digit-char-p (first l-char)))
        (n2 (digit-char-p (second l-char)))
        (n3 (digit-char-p (third l-char))))
    (let ((sommadigit (+ (* 100 n1) (* 10 n2) n3)))
      (and (<= sommadigit 255)
           (>= sommadigit 0)))))

;;riconoscitori (ciascuna parte dell'uri ha un riconoscitore)

;;riconoscitore scheme
(defun ric-scheme (l-char)
  (cond ((eq (first l-char) #\:) nil)
        ((or (null l-char)
             (not (is-identify (first l-char))))
         (error "stringa uri non accettata, scheme errato"))
        (t (append (list (first l-char))
                   (ric-scheme (rest l-char))))))

;;riconoscitore userinfo
(defun ric-userinfo (l-char)
  (cond ((null l-char) nil)
        ((eq (first l-char) #\@)
         (cons (first l-char) nil))
        ((not (is-identify (first l-char))) nil)
        (t (append (list (first l-char))
                   (ric-userinfo (rest l-char))))))

;;riconoscitore host
(defun ric-host (l-char)
  (if (and (is-digit (first l-char))
           (is-digit (second l-char))
           (is-digit (third l-char))
           (eq (fourth l-char) #\.))
      (if (and (eq (eighth l-char) #\.)
               (eq (n-esimo l-char 12) #\.)
               (or (eq (n-esimo l-char 16) #\/)
                   (eq (n-esimo l-char 16) #\?)
                   (eq (n-esimo l-char 16) #\#)
                   (null (n-esimo l-char 16))))
          (ric-host-ip l-char)
        (error "ip errato"))
    (ric-host-id l-char)))

(defun ric-host-id (l-char)
  (cond ((or (null l-char)
             (eq (first l-char) #\:)
             (eq (first l-char) #\/)
             (eq (first l-char) #\?)
             (eq (first l-char) #\#))
         nil)
        ((and (eq (first l-char) #\.)
              (not (eq (second l-char) #\.)))
         (append '(#\.) (ric-host-id (rest l-char))))
        ((or (not (is-identify-host (first l-char)))
             (eq (first l-char) #\.))
         (error "stringa uri non accettata, host errato"))
        (t (append (list (first l-char))
                   (ric-host-id (rest l-char))))))

(defun ric-host-ip (l-char)
  (cond ((or (null l-char)
             (eq (first l-char) #\:)
             (eq (first l-char) #\/)
             (eq (first l-char) #\?)
             (eq (first l-char) #\#))
         nil)
        ((and (not (null (first l-char)))
              (not (null (second l-char)))
              (not (null (third l-char)))
              (not (eq (first l-char) #\.))
              (not (eq (second l-char) #\.))
              (not (eq (third l-char) #\.))
              (not (control-nnn l-char)))
         (error "host ip errato"))
        ((eq (first l-char) #\.)
         (append '(#\.) (ric-host-ip (rest l-char))))
        ((not (is-digit (first l-char)))
         (error "stringa uri non accettata, ip errato"))
        (t (append (list (first l-char))
                   (ric-host-ip (rest l-char))))))

;;riconoscitore port
(defun ric-port (l-char)
  (cond ((or (null l-char)
             (eq (first l-char) #\/)
             (eq (first l-char) #\?)
             (eq (first l-char) #\#))
         nil)
        ((not (is-digit (first l-char)))
         (error " stringa uri non accettata"))
        (t (append (list (first l-char))
                   (ric-port (rest l-char))))))

;;riconoscitore path
(defun ric-path (l-char)
  (cond ((or (null l-char)
             (eq (first l-char) #\?)
             (eq (first l-char) #\#))
         nil)
        ((and (eq (first l-char) #\/)
              (not (eq (second l-char) #\/)))
         (append '(#\/) (ric-path (rest l-char))))
        ((or (not (is-identify (first l-char)))
             (eq (first l-char) #\/))
         (error "string uri non accettata, path errato"))
        (t (append (list (first l-char))
                   (ric-path (rest l-char))))))

(defun ric-id8 (l-char n)
  (cond ((or (null l-char)
             (and (= n 8)
                  (not (alpha-char-p (first l-char)))))
         (error "uri non riconosciuta, id 8 errato"))
        ((or (null l-char)
             (eq (first l-char) #\)))
         (cons #\) nil))
        ((= n 0)
         (error "uri non riconosciuta, id 8 errato"))
        ((not (alphanumericp (first l-char)))
         (error "uri non riconosciuta, id8 zos errato"))
        (t (append (list (first l-char))
                   (ric-id8 (rest l-char) (- n 1))))))

;;riconoscitore path zos
(defun ric-path-zos (l-char n)
  (cond ((or (null l-char)
             (eq (first l-char) #\?)
             (eq (first l-char) #\#))
         nil)
        ((and (= n 45)
              (not (alpha-char-p (first l-char))))
         (error "uri non riconosciuto, id 44 errato"))
        ((and (eq (first l-char) #\.)
              (or (null (rest l-char))
                  (eq (second l-char) #\?)
                  (eq (second l-char) #\#)
                  (eq (second l-char) #\()))
         (error "uri non riconosciuta, id44 errata"))
        ((= n 0)
         (error "id44 troppo lungo"))
        ((eq (first l-char) #\()
         (append '(#\() (ric-id8 (rest l-char) 8)))
        ((and (not (alphanumericp (first l-char)))
              (not (eq (first l-char) #\.)))
         (error "uri non riconosciuta, id44 zos errato"))
        (t (append (list (first l-char))
                   (ric-path-zos (rest l-char) (- n 1))))))

;;riconoscitore query
(defun ric-query (l-char)
  (cond ((or (null l-char)
             (eq (first l-char) #\#))
         nil)
        (t (append (list (first l-char))
                   (ric-query (rest l-char))))))

;;riconoscitore frament
(defun ric-fragment (l-char)
  (if (not (null l-char))
      l-char
    nil))

;;questa funzione crea una lista con tutti i componenti della uri.
;;prende una lista di caratteri, riconosce la parte, calcola la stringa
;;rimanente e la manda al riconoscitore successivo tenendo conto
;;degli scheme speciali
(defun ric-linguaggio (l-char)
  (let* ((scheme (ric-scheme l-char))
         (l-rem1 (if(null scheme)
                     (error "scheme mancante")
                   (remain-str l-char scheme)))
         (userinfo (cond ((and (or (equal (dwn-list scheme) 
                                          '(#\t #\e #\l))
                                   (equal (dwn-list scheme) 
                                          '(#\f #\a #\x))
                                   (equal (dwn-list scheme) 
                                          '(#\m #\a #\i #\l #\t #\o))
                                   (equal (dwn-list scheme) 
                                          '(#\n #\e #\w #\s)))
                               (and (equal (first l-rem1) #\:)
                                    (equal (second l-rem1) #\/)
                                    (equal (third l-rem1) #\/)))
                          (error "Uri non accettata, scheme errati"))
                         ((equal (dwn-list scheme) '(#\n #\e #\w #\s))
                          nil)
                         ((equal (dwn-list scheme) '(#\m #\a #\i #\l #\t #\o))
                          (remove #\@ (ric-userinfo (rem-char l-rem1 1))))
                         ((or (equal (dwn-list scheme) '(#\t #\e #\l))
                              (equal (dwn-list scheme) '(#\f #\a #\x)))
                          (remove #\@ (ric-userinfo (rem-char l-rem1 1))))
                         ((and (eq (first l-rem1) #\:)
                               (eq (second l-rem1) #\/)
                               (eq (third l-rem1) #\/))
                          (if (equal (last (ric-userinfo
                                            (rem-char l-rem1 3))) '(#\@))
                              (remove #\@ (ric-userinfo (rem-char l-rem1 3)
                                                        ))))))

         (l-rem2 (cond ((and (or (equal (dwn-list scheme) '(#\t #\e #\l))
                                 (equal (dwn-list scheme) '(#\f #\a #\x))
                                 (equal (dwn-list scheme) 
                                        '(#\m #\a #\i #\l #\t #\o)))
                             (not (eq userinfo nil)))
                        (remain-str (rem-char l-rem1 1) userinfo))
                       ((eq userinfo nil)
                        (rem-char l-rem1 1))
                       (t (remain-str (rem-char l-rem1 3) userinfo))))

         (host (cond ((equal (dwn-list scheme) '(#\t #\e #\l))
                      (if (not (eq nil l-rem2))
                          (error "schema tel errato")))
                     ((equal (dwn-list scheme) '(#\f #\a #\x))
                      (if (not (eq nil l-rem2))
                          (error "schema fax errato")))
                     ((equal (dwn-list scheme) '(#\n #\e #\w #\s))
                      (ric-host l-rem2))
                     ((equal (first l-rem2) #\@)
                      (ric-host (rem-char l-rem2 1)))
                     ((and (eq (first l-rem2) #\/)
                           (eq (second l-rem2) #\/))
                      (ric-host (rem-char l-rem2 2)))))

         (l-rem3 (cond ((or (and (equal (dwn-list scheme) 
                                        '(#\m #\a #\i #\l #\t #\o))
                                 (or (and (eq nil userinfo)
                                          (not (eq nil host)))
                                     (and (eq (first l-rem2) #\@)
                                          (eq host nil))))
                            (and (eq (second l-rem1) #\/)
                                 (eq (third l-rem1) #\/)
                                 (null host)))
                        (error "errore, host mancante"))
                       ((and (not (null host))
                             (or (eq (first host) #\.)
                                 (eq (first (last host)) #\.)))
                        (error "host non puo iniziare o fin con punto"))
                       ((eq (first l-rem2) #\@)
                        (remain-str (rem-char l-rem2 1) host))
                       ((equal (dwn-list scheme) '(#\n #\e #\w #\s))
                        (remain-str l-rem2 host))
                       ((and (eq (first l-rem2) #\/)
                             (eq (second l-rem2) #\/))
                        (remain-str (rem-char l-rem2 2) host))
                       (t l-rem2)))

         (port (cond ((and (equal (dwn-list scheme) 
                                  '(#\m #\a #\i #\l #\t #\o))
                           (not (eq nil l-rem3)))
                      (error "schema mailto non valido"))
                     ((and (equal (dwn-list scheme) '(#\n #\e #\w #\s))
                           (not (eq nil l-rem3)))
                      (error "schema news non valido"))
                     ((eq (first l-rem3) #\:)
                      (ric-port (rest l-rem3)))))

         (l-rem4 (cond ((and (eq (first l-rem3) #\:)
                             (eq nil port))
                        (error "uri errata"))
                       ((not (eq nil port))
                        (remain-str (rem-char l-rem3 1) port))
                       (t (remain-str l-rem3 port))))

         (path (cond ((and (equal (dwn-list scheme) '(#\z #\o #\s))
                           (not (null host))
                           (eq (first l-rem4) #\/))
                      (ric-path-zos (rest l-rem4) 45))
                     ((and (equal (dwn-list scheme) '(#\z #\o #\s))
                           (null host)
                           (eq (first l-rem4) #\/))
                      (ric-path-zos (rest l-rem4) 45))
                     ((and (equal (dwn-list scheme) '(#\z #\o #\s))
                           (null host))
                      (ric-path-zos l-rem4 45))
                     ((and (not (null host))
                           (eq (first l-rem4) #\/))
                      (ric-path (rest l-rem4)))
                     ((and (null host)
                           (eq (first l-rem4) #\/))
                      (ric-path (rest l-rem4)))
                     ((and (null host) 
                           (or (not (eq (first l-rem4) #\?))
                               (not (eq (first l-rem4) #\#))))
                      (ric-path l-rem4))))

         (l-rem5 (cond ((and (not (null path))
                             (eq (first path) #\/))
                        (error "path errato"))
                       ((and (not (eq path nil))
                             (eq (first l-rem4) #\/))
                        (remain-str (rem-char l-rem4 1) path))
                       ((not (eq path nil))
                        (remain-str l-rem4 path))
                       (t l-rem4)))

         (query (cond ((eq (first l-rem5) #\?)
                       (ric-query (rest l-rem5)))
                      ((and (eq (first l-rem5) #\/)
                            (eq (second l-rem5) #\?))
                       (ric-query (rem-char l-rem5 2)))))

         (l-rem6 (cond ((or (and (eq path nil) 
                                 (eq (first l-rem5) #\/)
                                 (eq (second l-rem5) #\?)
                                 (eq query nil))
                            (and (not (eq path nil))
                                 (eq (first l-rem5) #\?)
                                 (eq query nil)))
                        (error "uri non accettata"))
                       ((and (eq path nil)
                             (eq (first l-rem5) #\/)
                             (not (eq query nil)))
                        (remain-str (rem-char l-rem5 2) query))
                       ((not (eq query nil))
                        (remain-str (rest l-rem5) query))
                       (t l-rem5)))

         (fragment (cond ((and (eq (first l-rem6) #\/)
                               (eq (second l-rem6) #\#)
                               (ric-fragment (rem-char l-rem6 2))))
                         ((eq (first l-rem6) #\#)
                          (ric-fragment (rest l-rem6)))))
         
         (l-rem7 (cond ((or (and (eq path nil)
                                 (eq query nil)
                                 (eq (first l-rem6) #\/)
                                 (eq (second l-rem6) #\#)
                                 (eq fragment nil))
                            (and (or (not (eq query nil))
                                     (not (eq path nil)))
                                 (eq (first l-rem6) #\#)
                                 (eq fragment nil))
                            (and (eq (first l-rem6) #\#)
                                 (eq fragment nil)))
                        (error "uri non accettata"))
                       ((eq (first l-rem6) #\/)
                        (remain-str (rem-char l-rem6 2) fragment))
                       ((eq (first l-rem6) #\#)
                        (remain-str (rest l-rem6) fragment))
                       (t l-rem6))))
    
    (if (equal l-rem7 nil)
        (list (conv scheme)
              (conv userinfo)
              (conv host)
              (if (eq port nil)
                  80
                (parse-integer (conv port)))
              (conv path)
              (conv query)
              (conv fragment))
      (error "uri errata"))))

;;uri parse
(defun uri-parse (string)
  (ric-linguaggio (conv-char-str string)))

;;uri-scheme
(defun uri-scheme (uri-structure)
  (first uri-structure))

;;uri userinfo
(defun uri-userinfo (uri-structure)
  (second uri-structure))

;;uri host
(defun uri-host (uri-structure)
  (third uri-structure))

;;uri port
(defun uri-port (uri-structure)
  (fourth uri-structure))

;;uri path
(defun uri-path (uri-structure)
  (fifth uri-structure))

;;uri query
(defun uri-query (uri-structure)
  (sixth uri-structure))

;;uri fragment
(defun uri-fragment (uri-structure)
  (seventh uri-structure))
;;uri display

;;stampa una struttura uri sul listener, se il
;;parametro stream esiste, allora lo stampa sullo stream passato
(defun uri-display (uri-structure &optional stream)
  (let ((out (if (null stream)
		 (format t "SCHEME: ~d~% USERINFO: ~d~% HOST: ~S~% PORT: ~D
 PATH: ~d~% QUERY: ~d~% FRAGMENT: ~d~%"
                         (first uri-structure)
                         (second uri-structure)
                         (third uri-structure)
                         (fourth uri-structure)
                         (fifth uri-structure)
                         (sixth uri-structure)
                         (seventh uri-structure))

               (format stream "SCHEME: ~d~% USERINFO: ~d~% HOST: ~S~% PORT: ~D
 PATH: ~d~% QUERY: ~d~% FRAGMENT: ~d~%"
                       (first uri-structure)
                       (second uri-structure)
                       (third uri-structure)
                       (fourth uri-structure)
                       (fifth uri-structure)
                       (sixth uri-structure)
                       (seventh uri-structure))))) (c-nil-true out)))

;;medoto che restituisce true al posto del nil che prevede
;;il metodo format come da consegna
(defun c-nil-true (x)
  (if (eq x nil)
      t))



;;;; END of file: uri-parse.lisp
