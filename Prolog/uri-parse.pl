%%Gruppo:
    %%Milanese Mattia 869161
    %%Ceccarelli Matteo 869079

    %%%% -*- Mode: Prolog -*-


    %%DCG che riconoscono la grammatica


    identify --> [D0], {D0 \= '/', D0 \= '?',
			    D0 \= '#', D0 \= '@', D0 \= ':'}.

    identifyhost --> [D0], {D0 \= '/', D0 \= '?',  D0 \= '#',
				D0 \= '@', D0 \= ':', D0 \= '.'}.

    idquery --> [D0], {D0 \= '#'}.

    alphanumerichar --> [D0], {char_type(D0, alnum)}.
    alphachar --> [D0], {char_type(D0, alpha)}.

    scheme --> identify.
    scheme --> identify, scheme.

    authority --> ['/'], ['/'], userinfo, ['@'], host.
    authority --> ['/'], ['/'], host.
    authority --> ['/'], ['/'], userinfo, ['@'], host, [':'], port.
    authority --> ['/'], ['/'], host, [':'], port.

    userinfo --> identify.
    userinfo --> identify, userinfo.

    host --> identifyhost.
    host --> identifyhost, host.
    host --> identifyhost, ['.'], host.
    host --> ip.

    port --> digit.
    port --> digit, port.


    ip --> digit1, digit2, digit3, ['.'], digit1, digit2, digit3,
    ['.'], digit1, digit2, digit3, ['.'], digit1, digit2,
    digit3.

    path --> identify.
    path --> identify, path.
    path --> identify, ['/'], path.
    path --> identify, ['/'].

    query --> idquery.
    query --> idquery, query.


    fragment --> [_].
    fragment --> [_], fragment.


    scheme_syntax --> (['m'] | ['M']), (['a'] | ['A']), (['i'] | ['I']),
    (['l'] | ['L']),(['t'] | ['T']), (['o'] | ['O']), [':'].
    scheme_syntax --> (['m'] | ['M']), (['a'] | ['A']), (['i'] | ['I']),
    (['l'] | ['L']),(['t'] | ['T']), (['o'] | ['O']), [':'], mailto.

    scheme_syntax --> (['t'] | ['T']), (['e'] | ['E']),
    (['l'] | ['L']), [':'].
    scheme_syntax --> (['t'] | ['T']), (['e'] | ['E']),
    (['l'] | ['L']),
    [':'], tel_fax.

    scheme_syntax --> (['f'] | ['F']), (['a'] | ['A']),
    (['x'] | ['X']), [':'].
    scheme_syntax --> (['f'] | ['F']), (['a'] | ['A']),
    (['x'] | ['X']), [':'], tel_fax.

    scheme_syntax --> (['n'] | ['N']), (['e'] | ['E']),
    (['w'] | ['W']),
    (['s'] | ['S']),[':'].
    scheme_syntax --> (['n'] | ['N']), (['e'] | ['E']),
    (['w'] | ['W']),
    (['s'] | ['S']),[':'], news.

    scheme_syntax --> (['z'] | ['Z']), (['o'] | ['O']),
    (['S'] | ['s']), [':'].
    scheme_syntax --> (['z'] | ['Z']), (['o'] | ['O']),
    (['S'] | ['s']), [':'], zos.

    scs --> (['m'] | ['M']), (['a'] | ['A']), (['i'] | ['I']),
    (['l'] | ['L']),(['t'] | ['T']), (['o'] | ['O']).
    scs --> (['t'] | ['T']), (['e'] | ['E']),
    (['l'] | ['L']).
    scs --> (['f'] | ['F']), (['a'] | ['A']),
    (['x'] | ['X']).
    scs --> (['n'] | ['N']), (['e'] | ['E']),
    (['w'] | ['W']), (['s'] | ['S']).
    scs --> (['z'] | ['Z']), (['o'] | ['O']),
    (['S'] | ['s']).


    mailto --> userinfo.
    mailto --> userinfo, ['@'], host.

    tel_fax --> userinfo.

    news --> host.

    id8 --> alphanumerichar.
    id8 --> alphanumerichar, id8.

    id44 --> alphanumerichar.
    id44 --> alphanumerichar, id44.
    id44 --> alphanumerichar, ['.'], id44.

    pathzos --> alphachar.
    pathzos --> alphachar, id44.
    pathzos --> alphachar, id44, ['('], alphachar, id8, [')'].

    zos --> pathzos.
    zos --> ['/'], pathzos.
    zos --> pathzos, ['#'], fragment.
    zos --> pathzos, ['?'], query.
    zos --> pathzos, ['?'], query, ['#'], fragment.
    zos --> ['/'], pathzos, ['#'], fragment.
    zos --> ['/'], pathzos, ['?'], query.
    zos --> ['/'], pathzos, ['?'], query, ['#'], fragment.
    zos --> ['/'], ['#'], fragment.
    zos --> ['/'], ['?'], query.
    zos --> ['/'], ['?'], query, ['#'], fragment.
    zos --> authority.
    zos --> authority, ['/'], pathzos.
    zos --> authority, ['/'], pathzos, ['?'], query.
    zos --> authority, ['/'], pathzos, ['#'], fragment.
    zos --> authority, ['/'], pathzos, ['?'], query, ['#'], fragment.
    zos --> authority, ['/'], ['?'], query.
    zos --> authority, ['/'], ['#'], fragment.
    zos --> authority, ['/'], ['?'], query, ['#'], fragment.
    zos --> ['/'].
    zos --> ['?'], query.
    zos --> ['?'], query, ['#'].
    zos --> ['#'], fragment.

    digit --> ['0'] | ['1'] | ['2'] | ['3'] | ['4'] | ['5']
    | ['6'] | ['7'] | ['8'] | ['9'].
    digit1 --> ['1'] | ['2'].
    digit2 --> digit1 | ['3'] | ['4'] | ['5'].
    digit3 --> digit2 | ['6'].



    uri --> scheme_syntax.

    uri --> \+ scs, scheme, [':'].
    uri --> \+ scs, scheme, [':'], authority.
    uri --> \+ scs, scheme, [':'], authority, ['/'].
    uri --> \+ scs, scheme, [':'], authority, ['/'], path.
    uri --> \+ scs, scheme, [':'], authority, ['/'], ['?'], query.
    uri --> \+ scs, scheme, [':'], authority, ['?'], query.
    uri --> \+ scs, scheme, [':'], authority, ['/'], ['#'], fragment.
    uri --> \+ scs, scheme, [':'], authority, ['#'], fragment.
    uri --> \+ scs, scheme, [':'], authority, ['/'], ['?'],
    query, ['#'], fragment.
    uri --> \+ scs, scheme, [':'], authority, ['?'], query, ['#'], fragment.
    uri --> \+ scs, scheme, [':'], authority, ['/'], path, ['?'], query.
    uri --> \+ scs, scheme, [':'], authority, ['/'], path, ['#'], fragment.
    uri --> \+ scs, scheme, [':'], authority, ['/'], path,
    ['?'], query,['#'], fragment.
    uri --> \+ scs, scheme, [':'], ['/'], path.
    uri --> \+ scs, scheme, [':'], ['/'], path, ['?'], query.
    uri --> \+ scs, scheme, [':'], ['/'], path, ['#'], fragment.
    uri --> \+ scs, scheme, [':'], ['/'], path, ['?'], query, ['#'], fragment.
    uri --> \+ scs, scheme, [':'], ['/'], ['?'], query.
    uri --> \+ scs, scheme, [':'], ['/'], ['?'], query, ['#'], fragment.
    uri --> \+ scs, scheme, [':'], ['/'], ['#'], fragment.
    uri --> \+ scs, scheme, [':'], path.
    uri --> \+scs, scheme, [':'], path, ['?'], query.
    uri --> \+ scs, scheme, [':'], path, ['#'], fragment.
    uri --> \+ scs, scheme, [':'], path, ['?'], query, ['#'], fragment.
    uri --> \+ scs,  scheme, [':'], ['?'], query, ['#'], fragment.
    uri --> \+ scs, scheme, [':'], ['?'], query.
    uri --> \+ scs, scheme, [':'], ['#'], fragment.
    uri --> \+ scs, scheme, [':'], ['/'].


    %rem_char/3: e' vero se il terzo argomento sara' il primo argomento
    %con n caratteri indicati dal secondo argomento rimossi

    rem_char(X, 0, X) :- !.
    rem_char([_ | Xs], N, Zs) :-
    N1 is N - 1,
    rem_char(Xs, N1, Zs).

    %new_list/3: e' vero se il terzo argomento e' una lista
    %formata dal secondo argomento meno il primo
    %argomento.

    new_list([],[],[]) :- !.
    new_list(Xs, [], Xs) :- !.
    new_list([X | Xs],[Y | _], [X | Xs]) :-
    X \= Y, !.
    new_list([X | Xs], [Y | Ys], Zs) :-
    X = Y,
    !,
    new_list(Xs, Ys, Zs).

    %code_to_char/2: e' vero se il secondo argomento e' una lista di char
    %convertiti dai codici nella lista del primo argomento.

    code_to_char([], []).
    code_to_char([X | Xs], [Y | Ys]) :-
    char_code(Y, X),
    code_to_char(Xs, Ys).

    %list_to_number/3: e' vero se il secondo argomento e' un numero
    %che deriva dalla conversione della lista nel primo
    %argomento

    list_to_number(L1, Number) :-
    atomic_list_concat(L1, Num_prov),
    atom_number(Num_prov, Number).

    %list_to_atom/2
    %e' vero se il secondo argomento e' un atomo dato dalla
    %conversione della lista di char nel primo
    %argomento.


    list_to_atom([], []) :- !.
    list_to_atom(L1, L3) :-
    atomic_list_concat(L1, L3).

    %%questo predicato serve a creare l'userinfo
    %%mantentendo la @ alla fine

    create_userinfo([],[]) :- fail, !.
    create_userinfo([X | _], [X]) :-
    X = '@', !.
    create_userinfo([X | Xs], [X | Ys]) :-
    X \= '@', !,
    create_userinfo(Xs,Ys).


    %%e' vero quando il primo argomento e' una lista di caratteri
    %%e il secondo è una lista di caratteri minuscoli
    dwncaselist([], []) :- !.
    dwncaselist([X | Xs], [Y | Ys]) :-
    downcase_atom(X, Y),
    dwncaselist(Xs, Ys).



    % check_length_zos/1 e' vero se Zos rispetta
    % la lunghezza delle sue parti.



    check_length_zos(Zos, Scheme) :-
    dwncaselist(Scheme, Scheme_min),
    Scheme_min = [z, o, s],
    create_right_str(Zos, ['('], Id44),
    length(Id44, Length44),
    Length44 < 45,
    new_list(Zos, Id44, Id8),
    length(Id8, Length8),
    Length8 < 11.

    check_length_zos(_, Scheme) :-
    dwncaselist(Scheme, Scheme_min),
    Scheme_min \= [z, o, s], !.



    %check_operator/2
    %e' vero se X non fa parte di Y.

    check_operator(X, [Y]) :-
    X \= Y, !.
    check_operator(X, [Y | Ys]) :-
    X \= Y,
    check_operator(X, Ys).

    %not_check_operator/2
    %e' vero se X fa parte di Y

    not_check_operator(X, X) :- !.
    not_check_operator(X, [X | _]) :- !.
    not_check_operator(X, [Y | Ys]) :-
    X \= Y,
    not_check_operator(X, Ys).

    % create_right_str/3
    % e' vero se il terzo argomento e' una lista formata
    % dalla lista del primo argomento fino al primo
    % carattere della lista del secondo argomento che trova


    create_right_str([], _, []) :- !.
    create_right_str([X | _], Y, []) :-
    not_check_operator(X, Y).
    create_right_str([X | Xs], Y, [X | Zs]) :-
    check_operator(X, Y),
    create_right_str(Xs, Y, Zs).




    %uri_parse /2
    %e' vero se URIString può essere scomposto nel termine:
    %uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment).

    %fragment e' riportato come frag per non uscire dal limite di 80 colonne.

    uri_parse(URIString, uri(Scheme, Userinfo, Host, Port, Path, Query, Frag))
    :-
    string_to_list(URIString, L_code),
    code_to_char(L_code, L_char),
    phrase(uri, L_char), !,
    ric_scheme(L_char, Scheme1, List1),
    ric_userinfo(List1, Userinfo1, List2, Scheme1),
    ric_host(List2, Host1, List3, Scheme1),
    ric_port(List3, Port1, List4), !,
    ric_path(List4, Path1, List5, Scheme1, Host1), !,
    check_length_zos(Path1,Scheme1),
    ric_query(List5, Query1, List6),
    ric_fragment(List6, Fragment1),
    list_to_atom(Scheme1, Scheme),
    list_to_atom(Userinfo1, Userinfo),
    list_to_atom(Host1, Host),
    list_to_number(Port1, Port),
    list_to_atom(Path1, Path),
    list_to_atom(Query1, Query),
    list_to_atom(Fragment1, Frag), !.

    %ric_scheme /3
    %e' vero se il primo argomento e' una lista di char,
    %il secondo e' lo scheme,
    %il terzo e' la lista rimanente.

    ric_scheme(L_char, Scprove, L_rest) :-
    create_right_str(L_char, [':'], Scprove),
    new_list(L_char, Scprove, L_rest1),
    rem_char(L_rest1, 1, L_rest),
    phrase(scheme, Scprove).

    %ric_userinfo/4
    %e' vero se il primo argomento e' una lista di char,
    %il secondo e' lo userinfo,
    %il terzo e' la lista rimanente,
    %il quarto e' lo scheme.


    ric_userinfo(L_char1, L_char1, [], Scheme) :-
    dwncaselist(Scheme,Scheme_min),
    Scheme_min = [t, e, l].
    ric_userinfo(L_char1, L_char1, [], Scheme) :-
    dwncaselist(Scheme,Scheme_min),
    Scheme_min = [f, a, x].
    ric_userinfo(L_char1, Us_inf_prove, L_rest, Scheme) :-
    dwncaselist(Scheme,Scheme_min),
    Scheme_min = [m, a, i, l, t, o],
    create_right_str(L_char1, ['@'], Us_inf_prove),
    phrase(userinfo,Us_inf_prove),
    new_list(L_char1, Us_inf_prove, L_rest).

    ric_userinfo(L_char1, Userinfo, L_rest, _) :-
    rem_char(L_char1, 1, [X | Xs]),
    X = '/',
    create_userinfo(Xs,Us_inf_prove),
    delete(Us_inf_prove,'@',Userinfo),
    phrase(userinfo,Userinfo),
    new_list(Xs, Userinfo, L_rest).

    ric_userinfo(L_char, [], L_char, _) :- !.


    %ric_host/4
    %e' vero se il primo argomento e' una lista di char,
    %il secondo e' l' host,
    %il terzo e' la lista rimanente,
    %il quarto e' lo scheme.


    ric_host(L_char1, L_char1 , [], Scheme) :-
    dwncaselist(Scheme,Scheme_min),
    Scheme_min = [n, e, w, s].

    ric_host([_ | Xs], Xs, [], Scheme) :-
    dwncaselist(Scheme,Scheme_min),
    Scheme_min = [m, a, i, l, t, o].

    ric_host(L_char1, Host_prove, L_rest, _) :-
    rem_char(L_char1, 1, [X | Xs]),
    X = '/',
    create_right_str(Xs, [':', '/', '?', '#'], Host_prove),
    phrase(host, Host_prove),
    new_list(Xs, Host_prove, L_rest).

    ric_host([X | Xs], Host_prove, L_rest, _) :-
    X = '@',
    create_right_str(Xs, [':', '/', '?', '#'], Host_prove),
    phrase(host, Host_prove),
    new_list(Xs, Host_prove, L_rest).

    ric_host(L_char, [], L_char, _) :- !.


    %ric_port/3
    %e' vero se il primo argomento e' una lista di char,
    %il secondo e' la Port,
    %il terzo e' la lista rimanente.


    ric_port([X | Xs], Port_prove, L_rest) :-
    X = ':',
    create_right_str(Xs, ['/', '?', '#'], Port_prove),
    phrase(port, Port_prove),
    new_list(Xs, Port_prove, L_rest).

    ric_port(L_char, [80], L_char) :- !.


    %ric_path/5
    %e' vero se il primo argomento e' una lista di char,
    %il secondo e' il path,
    %il terzo e' la lista rimanente,
    %il quarto e' lo scheme.
    %il quinto e' l'host, lo usiamo per vedere se l'authority
    %e' presente.

    ric_path([X | Xs], Path_zos, L_rest, Scheme, Host) :-
    Host \= [],
    X = '/',
    dwncaselist(Scheme,Scheme_min),
    Scheme_min = [z, o, s],
    create_right_str(Xs, ['?', '#'], Path_zos),
    phrase(pathzos, Path_zos),
    new_list(Xs, Path_zos, L_rest).

    ric_path([X | Xs], Path_prove, L_rest, Scheme, Host) :-
    Host \= [],
    X = '/',
    dwncaselist(Scheme,Scheme_min),
    Scheme_min \= [z, o, s],
    create_right_str(Xs, ['?', '#'], Path_prove),
    phrase(path, Path_prove),
    new_list(Xs, Path_prove, L_rest).


    ric_path([X | Xs], Path_zos, L_rest, Scheme, Host) :-
    Host = [],
    X = '/',
    dwncaselist(Scheme, Scheme_min),
    Scheme_min = [z, o, s],
    create_right_str(Xs, ['?', '#'], Path_zos),
    phrase(pathzos, Path_zos),
    new_list(Xs, Path_zos, L_rest).

    ric_path([X | Xs], Path_prove, L_rest, Scheme, Host) :-
    Host = [],
    X = '/',
    dwncaselist(Scheme,Scheme_min),
    Scheme_min \= [z, o, s],
    create_right_str(Xs, ['?', '#'], Path_prove),
    phrase(path, Path_prove),
    new_list(Xs, Path_prove, L_rest).


    ric_path([X | Xs], Path_zos, L_rest, Scheme, Host) :-
    Host = [],
    check_operator(X, ['?', '#']),
    dwncaselist(Scheme,Scheme_min),
    Scheme_min = [z, o, s],
    create_right_str([X | Xs], ['?', '#'], Path_zos),
    phrase(pathzos, Path_zos),
    new_list([X | Xs], Path_zos, L_rest).

    ric_path([X | Xs], Path_prove, L_rest, Scheme, Host) :-
    Host = [],
    check_operator(X, ['?', '#']),
    dwncaselist(Scheme,Scheme_min),
    Scheme_min \= [z, o, s],
    create_right_str([X | Xs], ['?', '#'], Path_prove),
    phrase(path, Path_prove),
    new_list([X | Xs], Path_prove, L_rest).



    ric_path(L_char, [], L_char, _, _) :- !.




    %ric_port/3
    %e' vero se il primo argomento e' una lista di char,
    %il secondo e' la Query,
    %il terzo e' la lista rimanente,


    ric_query([X | Xs], Query_prove, L_rest) :-
    X = '?',
    create_right_str(Xs, ['#'], Query_prove),
    phrase(query, Query_prove),
    new_list(Xs, Query_prove, L_rest).

    ric_query([X | Xs], Query_prove, L_rest) :-
    X = '/',
    rem_char(Xs, 0, [Y | Str]),
    Y = '?',
    create_right_str(Str, ['#'], Query_prove),
    phrase(query, Query_prove),
    new_list(Str, Query_prove, L_rest).

    ric_query(L_char, [], L_char) :- !.


    %ric_port/3
    %e' vero se il primo argomento e' una lista di char,
    %il secondo e' il fragment.




    ric_fragment([X | Xs], Xs) :-
    X = '#',
    phrase(fragment, Xs).

    ric_fragment([X | Xs], Str) :-
    X = '/',
    rem_char(Xs, 0, [Y | Str]),
    Y = '#',
    phrase(fragment, Str), !.
    ric_fragment(_, []) :- !.

    %uri_display/1
    %e' vero se il primo argomento, e' un uri con i suoi 7 campi
    %e li stampa.

    uri_display(uri(Scheme, Userinfo, Host, Port, Path, Query, Fragment)) :-
    write('Scheme: '),
    write(Scheme),
    nl,
    write('Userinfo: '),
    write(Userinfo),
    nl,
    write('Host: '),
    write(Host),
    nl,
    write('Port: '),
    write(Port),
    nl,
    write('Path: '),
    write(Path),
    nl,
    write('Query: '),
    write(Query),
    nl,
    write('Fragment: '),
    write(Fragment).





    %uridisplay/2
    %e' vero se il primo argomento e' uno stream e
    %se il secondo argomento, e' un uri con i suoi 7 campi
    %e li stampa sullo stream.






    uri_display(Stream, uri(Scheme, Userinfo, Host, Port, Path, Query, Frag))
    :-
    write(Stream, 'Scheme: '),
    write(Stream, Scheme),
    nl(Stream),
    write(Stream, 'Userinfo: '),
    write(Stream, Userinfo),
    nl(Stream),
    write(Stream, 'Host: '),
    write(Stream, Host),
    nl(Stream),
    write(Stream, 'Port: '),
    write(Stream, Port),
    nl(Stream),
    write(Stream, 'Path: '),
    write(Stream, Path),
    nl(Stream),
    write(Stream, 'Query: '),
    write(Stream, Query),
    nl(Stream),
    write(Stream, 'Fragment: '),
    write(Stream, Frag).


    %%%% End of file uri-parse.pl

