val _ = new_fun "o" (mk_sort "ar" [mk_var("A",mk_sort "ob" []),mk_var("C",mk_sort "ob" [])],[("f",mk_sort "ar" [mk_var("B",mk_sort "ob" []),mk_var("C",mk_sort "ob" [])]),("g",mk_sort "ar" [mk_var("A",mk_sort "ob" []),mk_var("B",mk_sort "ob" [])])])


val _ = new_fun "id" 
       (mk_sort "ar" [mk_var("A",mk_sort "ob" []),mk_var("A",mk_sort "ob" [])],
        [("A",mk_sort "ob" [])])

val idL = store_ax("idL", “!B A f:B->A. id(A) o f = f”);

val idR = store_ax("idR",“!A B f:A->B. f o id(A) = f”);

val o_assoc = store_ax("o_assoc",“!A.!B.!f: A -> B.!C.!g:B -> C.!D.!h: C -> D.(h o g) o f = h o g o f”);


val is1_def = qdefine_psym("is1",[‘ONE’])
‘!X.?!f:X->ONE.T’ |> gen_all |> store_as "is1_def";



val _ = new_fun "1" (ob_sort,[])                     

val ONE_def = store_ax("ONE_def",“is1(1)”);


val ONE_prop = ONE_def |> rewr_rule [is1_def]
                       |> store_as "ONE_prop";

val ONE_prop' = proved_th $
e0
(rw[ONE_prop])
(form_goal “?!f:X->1.f = f”)

val To1_def0 = ONE_prop' |> spec_all |> qsimple_uex_spec "To1" [‘X’]

val To1_def = prove_store("To1_def",
e0
(rpt strip_tac >>
 (strip_assume_tac o uex_expand) ONE_prop' >>
 qsuff_tac
 ‘f' = f & To1(X) = f’
 >-- (strip_tac >> arw[]) >>
 rpt strip_tac >> first_x_assum irule >> rw[])
(form_goal “∀X f':X->1. f' = To1(X)”));

val is0_def = qdefine_psym("is0",[‘ZERO’])
‘!X.?!f:ZERO -> X.T’ |> gen_all |> store_as "is0_def";



val _ = new_fun "0" (ob_sort,[])                                         

val ZERO_def = store_ax("ZERO_def",“is0(0)”);


val ZERO_prop = ZERO_def |> rewr_rule [is0_def]
                       |> store_as "ZERO_prop"

val ZERO_prop' = proved_th $
e0
(rw[ZERO_prop])
(form_goal “?!f:0->X.f = f”)

val From0_def0 = 
    ZERO_prop' |> spec_all 
               |> qsimple_uex_spec "From0" [‘X’] |> gen_all


val From0_def = proved_th $
e0
(rpt strip_tac >>
 (strip_assume_tac o uex_expand) ZERO_prop' >>
 qsuff_tac
 ‘f' = f & From0(X) = f’
 >-- (strip_tac >> arw[]) >>
 rpt strip_tac >> first_x_assum irule >> rw[])
(form_goal “∀X f':0->X. f' = From0(X)”)



val isPr_def = qdefine_psym("isPr",[‘p1:AB->A’,‘p2:AB->B’])
‘!X f:X->A g:X->B.?!fg:X->AB. p1 o fg = f & p2 o fg = g’
|> qgenl [‘A’,‘B’,‘AB’,‘p1’,‘p2’]
|> store_as "isPr_def";

val _ = new_fun "*" (ob_sort,[("A",ob_sort),("B",ob_sort)])
val _ = new_fun "p1" (ar_sort (rastt "A * B") (rastt "A"),[("A",ob_sort),("B",ob_sort)])

val _ = new_fun "p2" (ar_sort (rastt "A * B") (rastt "B"),[("A",ob_sort),("B",ob_sort)])


val p2_def = 
    store_ax("p2_def",
             “!A B.isPr(p1(A,B),p2(A,B))”)


val Pa_def0 = p2_def |> rewr_rule[isPr_def] |> spec_all
                     |> qsimple_uex_spec "Pa" [‘f’,‘g’]
                     |> gen_all
                     |> store_as "Pa_def0"

val Pa_def = proved_th $
e0
(rpt gen_tac >>
 qsspecl_then [‘f’,‘g’] assume_tac Pa_def0 >> arw[] >>
 qspecl_then [‘A’,‘B’] assume_tac p2_def >>
 fs[isPr_def] >>
 first_x_assum (qsspecl_then [‘f’,‘g’] assume_tac) >>
 pop_assum (strip_assume_tac o uex_expand) >>
 qsuff_tac ‘Pa(f,g)= fg’ >-- (strip_tac >> arw[]) >>
 first_x_assum irule >> arw[])
(form_goal
 “∀A B X f:X->A g:X->B.
 (p1(A, B) o Pa(f, g) = f & p2(A, B) o Pa(f, g) = g) &
 !(fg' : ar(X, A * B)).
 p1(A, B) o fg' = f & p2(A, B) o fg' = g ==>
 fg' = Pa(f, g)”)


val iscoPr_def = qdefine_psym("iscoPr",[‘i1:A->AB’,‘i2:B->AB’])
‘!X f:A->X g:B->X.?!fg:AB->X.fg o i1 = f & fg o i2 = g’
|> qgenl [‘A’,‘B’,‘AB’,‘i1’,‘i2’]
|> store_as "iscoPr_def";


val _ = new_fun "+" (ob_sort,[("A",ob_sort),("B",ob_sort)])
val _ = new_fun "i1" (ar_sort (rastt "A") (rastt "A + B"),[("A",ob_sort),("B",ob_sort)])

val _ = new_fun "i2" (ar_sort (rastt "B") (rastt "A + B"),[("A",ob_sort),("B",ob_sort)])


val i2_def = 
    store_ax("i2_def",
             “!A B.iscoPr(i1(A,B),i2(A,B))”)


val coPa_def0 = i2_def 
                    |> rewr_rule[iscoPr_def] |> spec_all
                    |> qsimple_uex_spec "coPa" [‘f’,‘g’]
                    |> gen_all
                    |> store_as "coPa_def0"

val coPa_def = proved_th $
e0
(rpt gen_tac >>
 qsspecl_then [‘f’,‘g’] assume_tac coPa_def0 >> arw[] >>
 qspecl_then [‘A’,‘B’] assume_tac i2_def >>
 fs[iscoPr_def] >>
 first_x_assum (qsspecl_then [‘f’,‘g’] assume_tac) >>
 pop_assum (strip_assume_tac o uex_expand) >>
 qsuff_tac ‘coPa(f,g)= fg’ >-- (strip_tac >> arw[]) >>
 first_x_assum irule >> arw[])
(form_goal
 “∀A B X f:A->X g:B->X.
 (coPa(f, g) o i1(A, B) = f & coPa(f, g) o i2(A, B) = g) &
 !(fg' : ar(A + B, X)).
 fg' o i1(A, B) = f & fg' o i2(A, B) = g ==>
 fg' = coPa(f, g)”)


val isEq_def = qdefine_psym("isEq",[‘f:A->B’,‘g:A->B’,‘e:E->A’])
‘f o e = g o e & 
      !X a:X->A. f o a = g o a ==>
      ?!a0:X->E. a = e o a0’
|> qgenl [‘A’,‘B’,‘f’,‘g’,‘E’,‘e’] 
|> store_as "isEq_def";


val isEq_ex = store_ax("isEq_ex",“!A B f:A->B g:A->B.?E e:E->A.isEq(f,g,e)”);



val iscoEq_def = qdefine_psym("iscoEq",[‘f:A->B’,‘g:A->B’,‘ce:B->cE’])
‘ce o f = ce o g & 
      !X x:B->X. x o f = x o g ==>
      ?!x0:cE->X. x = x0 o ce’
|> qgenl [‘A’,‘B’,‘f’,‘g’,‘cE’,‘ce’]
|> store_as "iscoEq_def";
 
val iscoEq_ex = store_ax("iscoEq_ex",“!A B f:A->B g:A->B.?cE ce:B->cE.iscoEq(f,g,ce)”);

val isExp_def = qdefine_psym("isExp",[‘ev:A * A2B ->B’])
‘!X f:A * X->B. ?!h:X->A2B. ev o Pa(p1(A,X), h o p2(A,X)) = f’
|> qgenl [‘A’,‘B’,‘A2B’,‘ev:A * A2B -> B’]
|> store_as "isExp_def";



val _ = new_fun "Exp" (ob_sort,[("A",ob_sort),("B",ob_sort)])
val _ = new_fun "Ev" (ar_sort (rastt "A * Exp(A,B)") (rastt "B"),[("A",ob_sort),("B",ob_sort)])

val Ev_def0 = store_ax("Ev_def0",“!A B. isExp(Ev(A,B))”);

val Ev_def = Ev_def0 |> rewr_rule[isExp_def]

val Tp_def0 = Ev_def |> spec_all 
                     |> qsimple_uex_spec "Tp" [‘f’] 

val Tp_def = proved_th $
e0
(rw[Tp_def0] >> rpt gen_tac >>
 qsspecl_then [‘f’] (strip_assume_tac o uex_expand) Ev_def >>
 qsuff_tac
 ‘Tp(f) = h’
 >-- (strip_tac >> arw[]) >>
 first_x_assum irule >> rw[Tp_def0])
(form_goal
 “∀A B X f:A * X -> B.
 Ev(A, B) o Pa(p1(A, X), Tp(f) o p2(A, X)) = f &
 !h':X -> Exp(A,B).
          Ev(A, B) o Pa(p1(A, X), h' o p2(A, X)) = f ==> h' = Tp(f)”)

val _ = new_fun "N" (ob_sort,[]) 
val _ = new_fun "O" (ar_sort (rastt "1") (rastt "N"),[]) 
val _ = new_fun "SUC" (ar_sort (rastt "N") (rastt "N"),[]) 


val SUC_def = store_ax("SUC_def",“
 !X x0:1->X t:X->X.?!x:N->X. x o O = x0 & x o SUC = t o x”);

val Nrec_def0 = SUC_def |> spec_all 
                        |> qsimple_uex_spec "Nrec" [‘x0’,‘t’]
                        |> gen_all

val Nrec_def = proved_th $
e0
(rw[Nrec_def0] >> rpt gen_tac >>
 qsspecl_then [‘x0’,‘t’] (strip_assume_tac o uex_expand) SUC_def >>
 qsuff_tac ‘Nrec(x0,t) = x’ 
 >-- (strip_tac >> arw[]) >>
 first_x_assum irule >> rw[Nrec_def0])
(form_goal
 “∀X t:X->X x0:1->X.
  (Nrec(x0, t) o O = x0 & Nrec(x0, t) o SUC = t o Nrec(x0, t)) &
        !x' : N -> X.
          x' o O = x0 & x' o SUC = t o x' ==> x' = Nrec(x0, t)”)

val WP = store_ax("WP",“!A B f:A->B g.~(f = g) ==> ?a:1->A. ~(f o a = g o a)”);


val Mono_def = qdefine_psym("Mono",[‘f:A->B’])
‘!X g:X->A h. f o g = f o h ==> g = h’
|> qgenl[‘A’,‘B’,‘f’] |> store_as "Mono_def";

val Epi_def = qdefine_psym("Epi",[‘f:A->B’])
‘!X g:B->X h. g o f = h o f ==> g = h’
|> qgenl [‘A’,‘B’,‘f’] |> store_as "Epi_def";

val NONZERO_EL = store_ax("NONZERO_EL",“!X.~(is0(X)) ==>?x:1->X.T”);

val AC = store_ax("AC",“!A B a:1->A f:A->B. ?g:B->A. f o g o f = f”);

val INC_FAC = store_ax("INC_FAC",“!A B f:1->A + B. (?f0:1->A.i1(A,B) o f0 = f) |(?f0:1->B.i2(A,B) o f0 = f)”);

val DISTI_EL = store_ax("DISTI_EL",“?X x1:1->X x2. ~(x1 = x2)”);

val AX8 = DISTI_EL;


val FALSE_def = qdefine_fsym("FALSE",[]) ‘i1(1,1)’ |> store_as "FALSE_def";

val TRUE_def = qdefine_fsym("TRUE",[]) ‘i2(1,1)’ |> store_as "TRUE_def";

val ONE = mk_fun "1" [];



val _ = new_fun "2" (ob_sort,[])

val _ = new_abbr ("+",[ONE,ONE])  ("2",[]) 

(* the correct order of abbrev*)


val Tp1_def = qdefine_fsym("Tp1",[‘f:A->B’]) ‘Tp(f o p1(A,1))’
                          |> gen_all
                          |> store_as "Tp1_def";

val Ev_of_Tp = prove_store("Ev_of_Tp",
e0
(rpt strip_tac >> rw[Tp_def])
(form_goal
 “!A B X f:A * X ->B. 
  Ev(A,B) o Pa(p1(A,X),Tp(f) o p2(A,X)) = f”));

val Tp_eq = prove_store("Tp_eq",
e0
(rpt strip_tac >> dimp_tac >> strip_tac (* 2 *)
 >-- (once_rw[GSYM Ev_of_Tp] >> arw[]) >> arw[])
(form_goal
 “!A B X f:A * X ->B g:A * X ->B.Tp(f) = Tp(g) <=> f = g”));

val is_Tp = prove_store("is_Tp",
e0
(rpt strip_tac >> 
 qspecl_then [‘A’,‘B’,‘X’,‘f’] (assume_tac o conjE2) Tp_def>>
 first_x_assum irule >> arw[])
(form_goal
 “!A B X f:A * X ->B h:X-> Exp(A,B). 
  Ev(A,B) o Pa(p1(A,X),h o p2(A,X)) = f ==> h = Tp(f)”));

val Ev_eq_eq = prove_store("Ev_eq_eq",
e0
(rpt strip_tac >> 
 qsuff_tac ‘f = Tp(Ev(A,B) o Pa(p1(A,X),g o p2(A,X))) & 
  g = Tp(Ev(A,B) o Pa(p1(A,X),g o p2(A,X)))’
 >-- (rpt strip_tac >> once_arw[] >> rw[]) >>
 strip_tac (* 2 *) >--
 (irule is_Tp >> first_x_assum accept_tac) >>
 irule is_Tp >> rw[])
(form_goal
 “!A B X f g. Ev(A,B) o Pa(p1(A,X),f o p2(A,X)) = 
              Ev(A,B) o Pa(p1(A,X),g o p2(A,X)) ==> f = g”));

val is_Pa = Pa_def |> spec_all |> conjE2 |> gen_all
                   |> store_as "is_Pa";

val to_P_component = prove_store("to_Pr_component",
e0
(rpt strip_tac >> irule is_Pa >> rw[])
(form_goal
 “!A B X f:X->A * B.  f = Pa(p1(A,B) o f,p2(A,B) o f)”));

val to_P_eq = prove_store("to_P_eq",
e0
(rpt strip_tac >>
 qsuff_tac ‘f = Pa(p1(A,B) o g,p2(A,B) o g) &
            g = Pa(p1(A,B) o g,p2(A,B) o g)’ >--
 (strip_tac >> once_arw[] >> rw[]) >>
 strip_tac (* 2 *) >--
 (irule is_Pa >> arw[]) >> rw[GSYM to_P_component])
(form_goal
 “!A B X f:X->A * B g:X->A * B. p1(A,B) o f = p1(A,B) o g &
 p2(A,B) o f = p2(A,B) o g ==> f = g”));

val is_coPa = coPa_def |> spec_all |> conjE2
                       |> gen_all
                       |> store_as "is_coPa";

val from_coP_component = prove_store("from_coP_component",
 e0
(rpt strip_tac >> irule is_coPa >> rw[])
(form_goal
 “!A B X f:A + B ->X g:A + B->X. f = coPa(f o i1(A,B),f o i2(A,B))”));


val from_coP_eq = prove_store("from_coP_eq",
e0
(rpt strip_tac >>
 qsuff_tac ‘f = coPa(g o i1(A,B),g o i2(A,B)) &
            g = coPa(g o i1(A,B),g o i2(A,B))’ >--
 (strip_tac >> once_arw[] >> rw[]) >>
 strip_tac (* 2 *) >--
 (irule is_coPa >> arw[]) >> rw[GSYM from_coP_component])
(form_goal
 “!A B X f:A + B-> X g:A + B->X. f o i1(A,B) = g o i1(A,B) & f o i2(A,B) = g o i2(A,B) ==> f = g”));


val i12_of_coPa = coPa_def |> spec_all |> conjE1
                           |> gen_all 
                           |> store_as "i12_of_coPa";

val i1_of_coPa = i12_of_coPa |> spec_all |> conjE1
                             |> gen_all 
                             |> store_as "i1_of_coPa";


val i2_of_coPa = i12_of_coPa |> spec_all |> conjE2
                             |> gen_all 
                             |> store_as "i2_of_coPa";
 
val p12_of_Pa = Pa_def |> spec_all |> conjE1
                       |> gen_all
                       |> store_as "p12_of_Pa";

                       
val p1_of_Pa = p12_of_Pa |> spec_all |> conjE1
                         |> gen_all 
                         |> store_as "p1_of_Pa";

val p2_of_Pa = p12_of_Pa |> spec_all |> conjE2
                         |> gen_all 
                         |> store_as "p2_of_Pa";

 

val i1_ne_i2_1 = prove_store ("i1_ne_i2",
e0
(ccontra_tac >> 
 x_choosel_then ["X","x1","x2"] assume_tac DISTI_EL >>
 qsuff_tac ‘x1 = x2’ >-- arw[] >>
 qby_tac ‘coPa(x1,x2) o i1(1,1) = x1 &
          coPa(x1,x2) o i2(1,1) = x2’ >--
 rw[i12_of_coPa] >>
 pop_assum (assume_tac o GSYM) >> 
 qpick_x_assum ‘~(x1 = x2)’ (K all_tac) >> 
 once_arw[] >> pop_assum (K all_tac) >> arw[])
(form_goal
 “~(i1(1,1) = i2(1,1))”)
)

val to1_unique = prove_store("to1_unique",
e0
(rpt strip_tac >>
 qspecl_then [‘X’,‘f’] assume_tac To1_def >>
 qspecl_then [‘X’,‘g’] assume_tac To1_def >> 
 arw[])
(form_goal
 “!X f:X->1 g:X->1. f = g”));

val one_to_one_id = prove_store("one_to_one_id",
e0
(strip_tac >>
 qspecl_then [‘1’,‘f’,‘id(1)’] assume_tac to1_unique >>
 first_x_assum accept_tac)
(form_goal
 “!f:1->1. f = id(1)”))

val prop_5_lemma = prove_store("prop_5_lemma",
e0
(rpt strip_tac >> 
 ccontra_tac >> 
 qsuff_tac ‘i1(1,1) = i2(1,1)’ >-- rw[i1_ne_i2_1] >>
 qby_tac
 ‘coPa(i1(1,1) o To1(A),i2(1,1) o To1(B)) o i1(A, B) o x0 =   coPa(i1(1,1) o To1(A), i2(1,1) o To1(B)) o i2(A, B) o x0'’
 >-- arw[] >> 
 fs[GSYM o_assoc,i12_of_coPa] >>
 fs[o_assoc] >> pop_assum mp_tac >>
 once_rw[one_to_one_id] >> rw[idR])
(form_goal
 “!A B x0:1->A x0':1->B. ~(i1(A,B) o x0 = i2(A,B) o x0')”));

val i1_i2_disjoint = prove_store("i1_i2_disjoint",
e0
(rw[prop_5_lemma])
(form_goal
 “!X t:1->X. ~(i1(X,X) o t = i2(X,X) o t)”));


val is0_expand = 
  iff_trans (is0_def |> spec_all) (uex_def “?!f:ZERO->X.T” |> rewr_rule [] |> forall_iff ("X",ob_sort)) |> gen_all

val from_zero_unique = prove_store("from_zero_unique",
e0
(rpt strip_tac >> fs[is0_expand] >>
 first_x_assum $ qspecl_then [‘X’] strip_assume_tac >>
 first_assum $ qspecl_then [‘f’] strip_assume_tac >>
 first_assum $ qspecl_then [‘g’] strip_assume_tac >>
 arw[])
(form_goal
 “!ZERO. is0(ZERO) ==> !X f:ZERO->X g. f = g”));

val no_Epi_from_zero = prove_store("no_Epi_from_zero",
e0
(rpt strip_tac >>
 ccontra_tac >> 
 qsuff_tac ‘i1(1,1) = i2(1,1)’ >-- rw[i1_ne_i2_1] >>
 qsuff_tac ‘i1(1,1) o To1(B) = i2(1,1) o To1(B)’ >--
 (strip_tac >> 
  qby_tac ‘?b:1->B.T’ >-- 
  (irule NONZERO_EL >> arw[]) >> 
  pop_assum strip_assume_tac >>
  qby_tac ‘i1(1, 1) o To1(B) o b = i2(1, 1) o To1(B) o b’ 
  >-- arw[GSYM o_assoc] >>
  pop_assum mp_tac >> once_rw[one_to_one_id] >> 
  rw[idR]) >>
 fs[Epi_def] >> first_x_assum irule >>
 irule from_zero_unique >> arw[])
(form_goal
“!A B f:A->B. Epi(f) ==>
 ~is0(B) ==> ~is0(A)”));

val ZERO_no_MEM = prove_store("ZERO_no_MEM",
 e0
(ccontra_tac >> pop_assum strip_assume_tac >>
 strip_assume_tac DISTI_EL >>
 qsuff_tac ‘x1 = x2’ >-- arw[] >>
 qby_tac ‘x1 = x1 o To1(0) o f & 
          x2 = x2 o To1(0) o f’
 >-- (once_rw[one_to_one_id] >> rw[idR]) >>
 qpick_x_assum ‘~(x1 = x2)’ (K all_tac) >>
 once_arw[] >> 
 rw[GSYM o_assoc] >>
 qsuff_tac ‘x1 o To1(0) = x2 o To1(0)’
 >-- (pop_assum (K all_tac) >> strip_tac >> arw[]) >>
 irule from_zero_unique >> rw[ZERO_def]
 )
(form_goal
 “~(?f:1->0.T)”));

val not_to_zero = prove_store("not_to_ZERO",
e0
(rpt strip_tac >> ccontra_tac >> drule NONZERO_EL >>
 pop_assum strip_assume_tac >> 
 suffices_tac ``?f:1->0.T``
 >-- (disch_tac >> fs[ZERO_no_MEM]) >>
 qexists_tac ‘f o x’ >> rw[])
(form_goal
 “!A f:A->0.is0(A)”));


val to_zero_zero = prove_store("to_ZERO_ZERO",
e0
(rpt strip_tac >> 
 qsuff_tac ‘?g:A->0.T’ >-- 
 (strip_tac >> 
  qspecl_then [‘A’,‘g’] accept_tac not_to_zero) >>
  fs[is0_expand] >> 
 first_x_assum (qspecl_then [‘0’] strip_assume_tac) >>
 qexists_tac ‘f' o f’ >> rw[]
 )
(form_goal
 “!A B f:A->B.is0(B) ==>is0(A)”));

fun try_done tac (G,fl,l) = 
    case tac (G,fl,l) of 
        ([],pf) => ([],pf)
       | _ => ([(G,fl,l):goal],sing I)

val non_zero_pinv = prove_store("non_zero_pinv",
e0
(rpt strip_tac >> 
 drule NONZERO_EL >> pop_assum strip_assume_tac >>
 qspecl_then [‘A’,‘B’,‘x’,‘f’] accept_tac AC)
(form_goal
 “!A.~is0(A) ==>!B f:A->B.?g:B->A. f o g o f = f”));

val Mono_pinv_post_inv = prove_store("Mono_pinv_post_inv",
e0
(rpt strip_tac >> fs[Mono_def] >> first_x_assum irule >>
 arw[idR])
(form_goal
 “!A B f:A->B. Mono(f) ==> !g:B->A. 
 f o g o f = f ==> g o f = id(A)”));

 
val Epi_pinv_pre_inv = prove_store("Epi_pinv_pre_inv",
e0
(rpt strip_tac >> fs[Epi_def] >> first_x_assum irule >>
 arw[idL,o_assoc])
(form_goal
 “!A B f:A->B. Epi(f) ==> !g:B->A. 
 f o g o f = f ==> f o g = id(B)”));

val Mono_no_zero_post_inv = prove_store("Mono_no_zero_post_inv",
e0
(rpt strip_tac >> drule non_zero_pinv >>
 drule Mono_pinv_post_inv >>
 first_x_assum (qspecl_then [‘B’,‘f’] strip_assume_tac) >>
 first_x_assum drule >>
 qexists_tac ‘g’ >> arw[]
 )
(form_goal
 “!A B f:A->B. Mono(f) ==> ~is0(A) ==>
  ?g:B->A. g o f = id(A)”));


val Epi_no_zero_pre_inv = prove_store("Epi_no_zero_pre_inv",
e0
(rpt strip_tac >> drule non_zero_pinv >>
 drule Epi_pinv_pre_inv >>
 first_x_assum (qspecl_then [‘B’,‘f’] strip_assume_tac) >>
 first_x_assum drule >>
 qexists_tac ‘g’ >> arw[]
 )
(form_goal
 “!A B f:A->B. Epi(f) ==> ~is0(A) ==>
  ?g:B->A. f o g = id(B)”));

val inc_inc_iso = prove_store("inc_inc_iso",
e0
(strip_tac >> strip_tac >> strip_tac >> strip_tac >> 
 strip_tac >> strip_tac >> strip_tac >> strip_tac >> 
 cases_on “is0(X)” >> cases_on “is0(Y)” >>
 strip_tac >>
 try_done (irule from_zero_unique >> arw[]) (* 4 *)
 >-- (qspecl_then [‘Y’,‘X’,‘h2’] assume_tac to_zero_zero >>
      first_x_assum drule >> fs[])
 >-- (qspecl_then [‘X’,‘Y’,‘h1’] assume_tac to_zero_zero >>
      first_x_assum drule >> fs[])
 >-- (qby_tac ‘?b'. b' o b = id(Y)’ >--
      (irule Mono_no_zero_post_inv >> arw[]) >>
      pop_assum strip_assume_tac >> 
      qsuff_tac ‘b' o (b o h1) o h2 = id(Y)’ >--
      arw[GSYM o_assoc,idL] >>
      arw[]) >>
 qby_tac ‘?a'. a' o a = id(X)’ >--
 (irule Mono_no_zero_post_inv >> arw[]) >>
 pop_assum strip_assume_tac >> 
 qsuff_tac ‘a' o (a o h2) o h1 = id(X)’ >--
 arw[GSYM o_assoc,idL] >>
 arw[]
 )
(form_goal
 “!X A a:X->A Y b:Y->A h1:X->Y h2:Y->X. 
  Mono(a)& Mono(b) & b o h1 = a & a o h2 = b ==> 
  h1 o h2 = id(Y) & h2 o h1 = id(X)”));

val zero_no_MEM = prove_store("zero_no_MEM",
e0
(rpt strip_tac >> ccontra_tac >>
 pop_assum strip_assume_tac >>
 fs[is0_expand] >> assume_tac ZERO_no_MEM >>
 qsuff_tac ‘?f0:1->0.T’ >-- fs[] >>
 first_x_assum (qspecl_then [‘0’] strip_assume_tac) >>
 qexists_tac ‘f' o f’ >> rw[])
(form_goal
 “!zero. is0(zero) ==> ~(?f:1->zero.T)”));



val FUN_EXT = prove_store("FUN_EXT",
e0
(repeat strip_tac >> ccontra_tac >> drule WP >> 
 pop_assum strip_assume_tac >> 
 first_x_assum (qspecl_then [‘a’] assume_tac) >> 
 fs[])
(form_goal
 “!A B f:A->B g. (!a:1->A. f o a = g o a) ==> f = g”));

val FUN_EXT_iff =prove_store("FUN_EXT_iff",
e0
(rpt strip_tac >> dimp_tac >> rpt strip_tac >> arw[] >>
 drule FUN_EXT >> arw[])
(form_goal
 “!A B f:A->B g. (!a:1->A. f o a = g o a) <=> f = g”));

val prop_2_half2 = prove_store("prop_2_half2",
e0
(rpt strip_tac >> cases_on “is0(Y)” (* 2 *) >--
 (qby_tac ‘is0(X)’ >--
  (ccontra_tac >> 
   qsuff_tac ‘?y:1->Y.T’ >-- 
   (rw[] >> irule zero_no_MEM >> arw[]) >>
   drule NONZERO_EL >>
   pop_assum strip_assume_tac >>
   first_x_assum (qspecl_then [‘a o x’,‘x’] assume_tac) >>
   fs[] >> qexists_tac ‘xb'’ >> rw[]) >>
  fs[is0_expand] >>
  first_assum (qspecl_then [‘Y’] strip_assume_tac) >>
  qexists_tac ‘f’ >> 
  first_assum (qspecl_then [‘A’] strip_assume_tac) >>
  first_assum (qspecl_then [‘b o f’] strip_assume_tac) >>
  first_assum (qspecl_then [‘a’] strip_assume_tac) >>
  fs[]) >>
 drule Mono_no_zero_post_inv >> first_assum drule >>
 pop_assum strip_assume_tac >>
 qexists_tac ‘g o a’ >> irule FUN_EXT >>
 strip_tac >> 
 first_assum (qspecl_then [‘a o a'’,‘a'’] assume_tac) >>
 fs[] >> pop_assum (assume_tac o GSYM) >> arw[o_assoc] >>
 qby_tac ‘b o g o b o xb' = b o (g o b) o xb'’
 >-- rw[o_assoc] >>
 arw[idL])
(form_goal
 “!X A a:X->A. Mono(a) ==> !Y b:Y->A. Mono(b) ==>
  (!x:1->A xb:1->X. a o xb = x ==> ?xb':1->Y. b o xb' = x)
  ==> ?h:X->Y. b o h = a”));

val prop_2_coro_subo = prove_store("prop_2_coro_subo",
e0
(rpt strip_tac >>
 qby_tac ‘?h1. b o h1 = a’ 
 >-- (irule prop_2_half2 >> arw[] >> rpt strip_tac >>
      first_assum (qspecl_then [‘xb’] strip_assume_tac) >>
      qexists_tac ‘y’ >> fs[]) >>
 qby_tac ‘?h2. a o h2 = b’ 
 >-- (irule prop_2_half2 >> arw[] >> rpt strip_tac >>
      first_assum (qspecl_then [‘xb’] strip_assume_tac) >>
      qexists_tac ‘x'’ >> fs[]) >>
 pop_assum_list (map_every strip_assume_tac) >>
 qexistsl_tac [‘h1’,‘h2’] >> arw[] >>
 irule inc_inc_iso >> qexistsl_tac [‘A’,‘a’,‘b’] >> arw[])
(form_goal
 “!X A a:X->A.Mono(a) ==> 
  !Y b:Y->A. Mono(b) & 
             (!y:1->Y. ?x:1->X.a o x = b o y) & 
             (!x:1->X. ?y:1->Y.a o x = b o y) ==> 
  ?h1:X->Y h2:Y->X. 
    b o h1 = a & a o h2 = b & 
    h1 o h2 = id(Y) & h2 o h1 = id(X)”));

val areiso_def = qdefine_psym("areiso",[‘A’,‘B’])
‘?f:A->B g:B->A. f o g = id(B) & g o f = id(A)’ 
|> gen_all 
|> store_as "areiso_def"; 

val prop_2_coro = prove_store("prop_2_coro",
e0
(repeat strip_tac >> rw[areiso_def] >>
 rev_drule prop_2_coro_subo >>
 first_x_assum (qspecl_then [‘Y’,‘b’] assume_tac) >>
 rev_full_simp_tac[] >>
 qexistsl_tac [‘h1’,‘h2’] >> arw[])
(form_goal
 “!X A a:X->A. Mono(a) ==>
  !Y b:Y->A. Mono(b) & 
  (!y:1->Y. ?x:1->X.a o x = b o y) & 
  (!x:1->X.?y:1->Y.a o x = b o y) ==> areiso(X,Y)”));

val Epi_has_section = prove_store("Epi_has_section",
e0
(rpt strip_tac >> cases_on “is0(B)” 
 >-- (fs[is0_expand] >> 
      first_assum (qspecl_then [‘B’] strip_assume_tac) >>
      first_assum (qspecl_then [‘A’] strip_assume_tac) >>
      qexists_tac ‘f'’ >>
      arw[]) >>
 drule no_Epi_from_zero >> first_assum drule >>
 drule NONZERO_EL >> pop_assum strip_assume_tac >>
 qspecl_then [‘A’,‘B’,‘x’,‘e’] strip_assume_tac AC >>
 drule Epi_pinv_pre_inv >> first_assum drule >>
 qexists_tac ‘g’ >> arw[])
(form_goal
 “!A B e:A->B. Epi(e) ==>?s0:B->A. e o s0 = id(B)”));

val Eq_equality = isEq_def |> iffLR |> strip_all_and_imp
                           |> conjE1 |> disch_all
                           |> gen_all
                           |> store_as "Eq_equality";


val coEq_equality = iscoEq_def |> iffLR |> strip_all_and_imp
                               |> conjE1 |> disch_all
                               |> gen_all
                               |> store_as "coEq_equality";

val isEq_expand = 
    isEq_def 
        |> rewr_rule[uex_def “?!a0:X->E.a = (e:E->A) o a0”]
        |> store_as "isEq_expand";


val iscoEq_expand = 
    iscoEq_def 
        |> rewr_rule[uex_def “?!x0:cE->X.x = x0 o (ce:B->cE)”]
        |> store_as "iscoEq_expand";

val coEq_of_equal = prove_store("coEq_of_equal",
e0
(rpt strip_tac >> rw[iscoEq_expand,idR] >> rpt strip_tac >>
 qexists_tac ‘x’ >> rw[] >> rpt strip_tac >> arw[])
(form_goal
 “!A B f:A->B.iscoEq(f,f,id(B))”));


val Eqa_Mono = prove_store("Eqa_Mono",
e0
(rpt strip_tac >> rw[Mono_def] >> rpt strip_tac >>
 drule $ iffLR isEq_def >> pop_assum strip_assume_tac >>
 first_x_assum (qsspecl_then [‘e o h’] assume_tac) >>
 rfs[GSYM o_assoc] >>
 pop_assum (strip_assume_tac o uex_expand) >>
 qsuff_tac
 ‘h = a0 & g' = a0’
 >-- (strip_tac >> once_arw[] >> rw[]) >> 
 strip_tac (* 2 *) >> first_x_assum irule >> arw[])
(form_goal
 “!A B f:A->B g:A->B E e:E->A.isEq(f,g,e) ==> Mono(e)”));


val coEqa_Epi = prove_store("coEqa_Epi",
e0
(rpt strip_tac >> rw[Epi_def] >> rpt strip_tac >>
 drule $ iffLR iscoEq_def >> pop_assum strip_assume_tac >>
 first_x_assum (qsspecl_then [‘h o ce’] assume_tac) >>
 rfs[o_assoc] >>
 pop_assum (strip_assume_tac o uex_expand) >> 
 qsuff_tac
 ‘h = x0 & g' = x0’
 >-- (strip_tac >> once_arw[] >> rw[]) >> 
 strip_tac (* 2 *) >> first_x_assum irule >> arw[])
(form_goal
 “!A B f:A->B g:A->B cE ce:B->cE.
   iscoEq(f,g,ce) ==> Epi(ce)”));

val via_Eq = prove_store("via_Eq",
e0
(rpt strip_tac >> pop_assum (assume_tac o GSYM) >> arw[] >>
 drule Eq_equality >> arw[GSYM o_assoc])
(form_goal
 “!A B f:A->B g:A->B E e:E->A. isEq(f,g,e) ==>!X h:X->A h0. e o h0 = h ==>
  f o h = g o h”));


val via_coEq = prove_store("via_coEq",
e0
(rpt strip_tac >> pop_assum (assume_tac o GSYM) >> arw[] >>
 drule coEq_equality >> arw[o_assoc])
(form_goal
 “!A B f:A->B g:A->B cE ce:B->cE. iscoEq(f,g,ce) ==>
  !X h:B->X h0. h0 o ce = h ==>
  h o f = h o g”));

val via_Eq_iff = prove_store("via_Eq_iff",
e0
(rpt strip_tac >> dimp_tac >> rpt strip_tac (* 2 *)
 >-- (irule via_Eq >> qexistsl_tac [‘E’,‘e’,‘h0’] >> arw[])>>
 drule $ iffLR isEq_def >>
 pop_assum strip_assume_tac >>
 first_x_assum rev_drule >> pop_assum (strip_assume_tac o uex2ex_rule) >> 
 qexists_tac ‘a0’ >> arw[])
(form_goal
 “!A B f:A->B g:A->B E e:E->A. isEq(f,g,e) ==>
  !X h:X->A.(?h0. e o h0 = h) <=>
  f o h = g o h”));


val via_coEq_iff = prove_store("via_coEq_iff",
e0
(rpt strip_tac >> dimp_tac >> rpt strip_tac (* 2 *)
 >-- (irule via_coEq >> 
      qexistsl_tac [‘cE’,‘ce’,‘h0’] >> arw[])>>
 drule $ iffLR iscoEq_def >>
 pop_assum strip_assume_tac >>
 first_x_assum rev_drule >> pop_assum (strip_assume_tac o uex2ex_rule) >> 
 qexists_tac ‘x0’ >> arw[])
(form_goal
 “!A B f:A->B g:A->B cE ce:B->cE. iscoEq(f,g,ce) ==>
  !X h.(?h0:cE->X. h0 o ce = h) <=>
  h o f = h o g”));


val Pa_distr = proved_th $
e0
(rpt strip_tac >> irule is_Pa >>
 rw[GSYM o_assoc,p12_of_Pa])
(form_goal
“!A B X a1:X ->A a2:X->B X0 x:X0->X. Pa(a1,a2) o x = 
Pa(a1 o x,a2 o x) ”)

val Pa_eq_eq = prove_store("Pa_eq_eq",
e0
(rpt strip_tac >> dimp_tac >> strip_tac >> arw[] >>
 qby_tac ‘p1(A,B) o Pa(f1, g1) = p1(A,B) o Pa(f2, g2) &
          p2(A,B) o Pa(f1, g1) = p2(A,B) o Pa(f2, g2)’
 >-- arw[] >>
 fs[p12_of_Pa])
(form_goal
 “!A X f1:X->A f2:X->A B g1:X->B g2:X->B. 
  Pa(f1,g1) = Pa(f2,g2) <=> f1 = f2 & g1 = g2”));


val coPa_eq_eq = prove_store("coPa_eq_eq",
e0
(rpt strip_tac >> dimp_tac >> strip_tac >> arw[] >>
 qby_tac ‘coPa(f1, g1) o i1(A,B) = coPa(f2, g2) o i1(A,B) &
          coPa(f1, g1) o i2(A,B) = coPa(f2, g2) o i2(A,B)’
 >-- arw[] >>
 fs[i12_of_coPa])
(form_goal
 “!A X f1:A ->X f2:A ->X B g1:B ->X  g2:B->X. 
  coPa(f1,g1) = coPa(f2,g2) <=> f1 = f2 & g1 = g2”));

val Thm1_case1_comm_condition_left = prove_store(
"Thm1_case1_comm_condition_left",
e0
(rpt strip_tac >> rw[Pa_distr,idL] >> dimp_tac >> strip_tac
 >-- arw[] >>
 fs[Pa_eq_eq])
(form_goal
 “!B f:N->B g:1->B. Pa(id(N),f) o O = Pa(O,g) <=> f o O = g”));
 
val Thm1_case1_comm_condition_right = prove_store(
"Thm1_case1_comm_condition_right",
e0
(rpt strip_tac >> 
 rw[Pa_distr,o_assoc,p1_of_Pa,idL,idR,Pa_eq_eq])
(form_goal
 “!B f:N->B h:N * B ->B.
 Pa(SUC o p1(N,B),h) o Pa(id(N),f) = Pa(id(N),f) o SUC <=>
 h o Pa(id(N),f) = f o SUC”));

val Thm1_case1_comm_condition = prove_store(
"Thm1_case1_comm_condition",
e0
(rpt strip_tac >> 
 rw[Thm1_case1_comm_condition_left,
 Thm1_case1_comm_condition_right] >> dimp_tac >> strip_tac >> arw[])
(form_goal
 “!B f0:N->B g:1->B h:N * B -> B. f0 o O = g & f0 o SUC = h o Pa(id(N),f0) <=>
 Pa(id(N),f0) o O = Pa(O,g) &
 Pa(SUC o p1(N,B),h) o Pa(id(N),f0) = Pa(id(N),f0) o SUC”));

val uex_tac:tactic = fn (ct,asl,w) =>
    let val th = uex_def w
        val w' = snd $ dest_dimp $ concl th
    in ([(ct,asl,w')],(sing (dimp_mp_r2l th)))
    end

val comm_with_SUC_id = prove_store("comm_with_SUC_id",
e0
(qspecl_then [‘N’,‘SUC’,‘O’] strip_assume_tac Nrec_def >>
 rpt strip_tac >>
 qsuff_tac ‘f = Nrec(O,SUC) & id(N) = Nrec(O,SUC)’
 >-- (strip_tac >> arw[]) >>
 strip_tac >> first_x_assum irule >> arw[idL,idR])
(form_goal
 “!f:N->N. f o O = O & f o SUC = SUC o f ==> f = id(N)”));

val is_Nrec = Nrec_def |> spec_all |> conjE2
                       |> gen_all
                       |> store_as "is_Nrec"

val Thm1_case_1 = prove_store("Thm1_case_1",
e0
(rpt strip_tac >> uex_tac >> 
 abbrev_tac “Nrec(Pa(O,g:1->B),Pa(SUC o p1(N,B),h:N * B->B)) = f'” >>
 abbrev_tac “p2(N,B) o f':N->N * B = f” >>
 qby_tac ‘p1(N,B) o f' = id(N)’ >--
 (irule comm_with_SUC_id >> 
  qpick_x_assum ‘Nrec(Pa(O, g), Pa(SUC o p1(N, B), h)) = f'’
  (assume_tac o GSYM) >> arw[] >>
  rw[o_assoc,Nrec_def,p1_of_Pa] >> 
  rw[GSYM o_assoc,p1_of_Pa]) >>
 qby_tac ‘f' = Pa(id(N),f)’ >--
 (once_rw[to_P_component] >> rw[p12_of_Pa] >> arw[]) >>
 qexists_tac ‘f’ >>
 qby_tac ‘f' o O = Pa(O,g) & 
  f' o SUC = Pa(SUC o p1(N, B), h) o f'’ 
 >-- (qpick_x_assum 
     ‘Nrec(Pa(O, g), Pa(SUC o p1(N, B), h)) = f'’
     (assume_tac o GSYM) >> once_arw[] >>
     rw[Nrec_def]) >>
 qby_tac ‘f o O = g & f o SUC = h o Pa(id(N), f)’
 >-- (qpick_x_assum ‘p2(N, B) o f' = f’ (assume_tac o GSYM)>>
      once_arw[] >> rw[o_assoc] >> once_arw[] >>
      rw[GSYM o_assoc,p2_of_Pa] >>
      pop_assum (K all_tac) >>
      pop_assum (K all_tac) >> arw[]) >>
 once_arw[] >> rw[] >>
 rpt strip_tac >> 
 qsuff_tac ‘Pa(id(N), f'') = Pa(id(N), f)’ 
 >-- rw[Pa_eq_eq] >>
 qsuff_tac ‘Pa(id(N), f'') = f'’ >-- arw[] >>
 qsuff_tac ‘Pa(id(N), f'') = 
  Nrec(Pa(O, g), Pa(SUC o p1(N, B), h))’ >-- arw[] >>
 irule is_Nrec >> 
 rw[Pa_distr,p1_of_Pa,o_assoc,idL,idR] >> once_arw[] >>
 rw[])
(form_goal
 “!B g:1->B h:N * B -> B. ?!f:N->B. f o O = g & f o SUC = h o Pa(id(N),f)”));

fun Tp1 f = mk_fun "Tp1" [f] 


val Tp0_ex = prove_store("Tp0_ex",
e0
(rpt strip_tac >> qexists_tac ‘Ev(X,Y) o Pa(id(X),f o To1(X))’ >>
 rw[])
(form_goal
 “!X Y f:1->Exp(X,Y).?tp0:X->Y. Ev(X,Y) o Pa(id(X),f o To1(X)) = tp0”));

val Tp0_def = qdefine_fsym("Tp0",[‘f:1 -> Exp(X,Y)’])
‘Ev(X,Y) o Pa(id(X),f o To1(X))’

val Tp1_Tp0_inv = prove_store("Tp1_Tp0_inv",
e0
(rpt strip_tac >> rw[Tp1_def,Tp0_def] >>
 fconv_tac (rewr_fconv (eq_sym "ar")) >> irule is_Tp >>
 rw[o_assoc,Pa_distr,idL] >>
 once_rw[To1_def] >> rw[])
(form_goal
 “!X Y f:1-> Exp(X,Y). Tp1(Tp0(f)) = f”));



val Ev_of_Tp_el = prove_store("Ev_of_Tp_el",
e0
(rpt strip_tac >>
 assume_tac Ev_of_Tp >> 
 first_x_assum (qspecl_then [‘A’,‘B’,‘X’,‘f’] assume_tac) >>
 qby_tac 
 ‘Pa(a, Tp(f) o x) = Pa(p1(A, X), Tp(f) o p2(A, X)) o Pa(a,x)’ >--
 (irule to_P_eq >> rw[p12_of_Pa] >> 
  rw[p12_of_Pa,GSYM o_assoc] >> rw[o_assoc,p12_of_Pa]) >>
 arw[GSYM o_assoc])
(form_goal
 “!A B X f:A * X ->B P a:P->A x: P ->X. 
  Ev(A,B) o Pa(a, Tp(f) o x) = f o Pa(a,x)”));

val Tp0_Tp1_inv = prove_store("Tp0_Tp1_inv",
e0
(rpt strip_tac >> rw[Tp1_def,Tp0_def] >>
 rw[Ev_of_Tp_el,o_assoc,p1_of_Pa,idR])
(form_goal
 “!X Y f:X->Y. Tp0(Tp1(f)) = f”));

val Thm1_comm_eq_left = prove_store(
"Thm1_comm_eq_left",
e0
(rpt strip_tac >> 
 qby_tac ‘Pa(p1(A,1), Tp(f) o O o p2(A,1)) = 
 Pa(p1(A,N),Tp(f) o p2(A,N)) o Pa(p1(A,1),O o p2(A,1))’
 >-- rw[Pa_distr,o_assoc,p12_of_Pa] >>
 dimp_tac >> strip_tac (* 2 *) >--
 (qsuff_tac ‘f o Pa(p1(A, 1), O o p2(A, 1)) = 
                 Ev(A,B) o Pa(p1(A,1),(Tp(f) o O) o p2(A,1)) &
             g o p1(A, 1) = 
                 Ev(A,B) o Pa(p1(A,1),Tp1(g) o p2(A,1))’
 >-- (strip_tac >> fs[]) >>
 strip_tac (* 2 *)
 >-- (rw[o_assoc] >> arw[] >>
      rw[GSYM o_assoc,Ev_of_Tp]) >>
 rw[Tp1_def,Ev_of_Tp]) >>
 rw[Tp1_def] >> irule is_Tp >> 
 rw[o_assoc] >> arw[GSYM o_assoc,Ev_of_Tp])
(form_goal
 “!A B f: A * N ->B g:A->B. 
  Tp(f) o O = Tp1(g) <=> f o Pa(p1(A,1),O o p2(A,1)) = g o p1(A,1)”));

val Pa_p1_p2 = prove_store("Pa_p1_p2",
e0
(rpt strip_tac >>
 fconv_tac (rewr_fconv (eq_sym "ar")) >>
 irule is_Pa >> rw[idR])
(form_goal
 “!A B. Pa(p1(A,B),p2(A,B)) = id(A * B)”));

val Thm1_comm_eq_right = prove_store("Thm1_comm_eq_right",
e0
(rpt strip_tac >>
 qsuff_tac
 ‘Tp(h o l) o Pa(id(N),Tp(f)) = Tp(h o Pa(id(A * N),f)) & 
  Tp(f o Pa(p1(A,N), SUC o p2(A,N))) = Tp(f) o SUC’
 >-- (strip_tac >> dimp_tac >> strip_tac (* 2 *)
      >-- arw[] >>
      irule $ iffLR Tp_eq >> arw[] >>
      qpick_x_assum
      ‘Tp((h o l)) o Pa(id(N), Tp(f)) =
       Tp(h o Pa(id(A * N), f))’
      (assume_tac o GSYM) >> arw[]) >>
 strip_tac (* 2 *) >--
 (irule is_Tp >> 
  qby_tac
  ‘Pa(p1(A, N), (Tp((h o l)) o Pa(id(N), Tp(f))) o p2(A, N))=
   Pa(p1(A,N * Exp(A,B)), Tp(h o l) o p2(A,N * Exp(A,B))) o 
   Pa(p1(A,N),Pa(id(N),Tp(f)) o p2(A,N))’ >-- 
  (irule to_P_eq >> 
   rw[p12_of_Pa,o_assoc] >> rw[GSYM o_assoc,p12_of_Pa] >>
   rw[p12_of_Pa,o_assoc]) >>
  once_arw[] >> rw[GSYM o_assoc,Ev_of_Tp] >>
  rw[o_assoc] >>
  qsuff_tac
  ‘l o Pa(p1(A, N), Pa(id(N), Tp(f)) o p2(A, N)) = 
   Pa(id(A * N), f)’ >--
  (strip_tac >> arw[]) >>
  irule to_P_eq >> rw[p12_of_Pa] >>
  pop_assum (K all_tac) >>
  pop_assum (assume_tac o GSYM) >> arw[] >>
  rw[p12_of_Pa,GSYM o_assoc] >>
  rw[o_assoc,p12_of_Pa,Pa_distr,Ev_of_Tp,idL,idR] >>
  rw[Pa_p1_p2]) >>
 flip_tac >> irule is_Tp >>
 qby_tac
 ‘Pa(p1(A, N), (Tp(f) o SUC) o p2(A, N)) = 
  Pa(p1(A, N), Tp(f) o p2(A,N)) o Pa(p1(A,N),SUC o p2(A,N))’
 >-- (irule to_P_eq >> rw[GSYM o_assoc,p12_of_Pa] >>
      rw[o_assoc,p12_of_Pa]) >>
 arw[GSYM o_assoc,Ev_of_Tp]
 )
(form_goal
 “!A B f:A * N ->B h: (A * N) * B ->B l . 
Pa(
 Pa(p1(A,N * Exp(A,B)), p1(N,Exp(A,B)) o p2(A,N * Exp(A,B))),
 Ev(A,B) o 
 Pa(p1(A,N * Exp(A,B)), p2(N,Exp(A,B)) o p2(A,N * Exp(A,B)))) = l
 ==>
 (h o Pa(id(A * N),f) = f o Pa(p1(A,N), SUC o p2(A,N)) <=>
 Tp(h o l) o Pa(id(N),Tp(f)) = Tp(f) o SUC)”));

val Thm1_comm_eq_condition = prove_store(
"Thm1_comm_eq_condition",
e0
(rpt strip_tac >> drule Thm1_comm_eq_right >>
 once_arw[] >> rw[GSYM Thm1_comm_eq_left])
(form_goal
 “!A B f: A * N ->B g:A->B h: (A * N) * B -> B l.
 Pa(
 Pa(p1(A,N * Exp(A,B)), p1(N,Exp(A,B)) o p2(A,N * Exp(A,B))),
 Ev(A,B) o 
 Pa(p1(A,N * Exp(A,B)), p2(N,Exp(A,B)) o p2(A,N * Exp(A,B)))) = l ==>
 (f o Pa(p1(A,1),O o p2(A,1)) = g o p1(A,1) & 
  h o Pa(id(A * N),f) = f o Pa(p1(A,N), SUC o p2(A,N)) <=>
  Tp(f) o O = Tp1(g) & Tp(h o l) o Pa(id(N),Tp(f)) = Tp(f) o SUC)
  ”));


val Thm1 = prove_store("Thm1",
e0
(rpt strip_tac >>
 uex_tac >>
 abbrev_tac “Tp(g:A->B o p1(A,1)) = g'” >>
 abbrev_tac “Pa(
 Pa(p1(A,N * Exp(A,B)), p1(N,Exp(A,B)) o p2(A,N * Exp(A,B))),
 Ev(A,B) o 
 Pa(p1(A,N * Exp(A,B)), p2(N,Exp(A,B)) o p2(A,N * Exp(A,B)))) = l” >>
 abbrev_tac “Tp(h:(A * N) * B->B o l:A * N * Exp(A,B) -> (A * N) * B) = h'” >>
 qspecl_then [‘Exp(A,B)’,‘g'’,‘h'’] (assume_tac o uex_expand) Thm1_case_1 >>
 pop_assum (x_choose_then "fb" strip_assume_tac) >>
 qabbrev_tac ‘Ev(A,B) o Pa(p1(A,N),fb o p2(A,N)) = f’ >>
 qby_tac ‘Tp(f) = fb’ >--
 (flip_tac >> irule is_Tp >> arw[]) >>
 qexists_tac ‘f’ >>
 qspecl_then [‘A’,‘B’,‘f’,‘g’] assume_tac
 Thm1_comm_eq_condition >>
 first_x_assum drule >> once_arw[] >>
 qby_tac
 ‘Tp(f) o O = Tp1(g) & 
  Tp((h o l)) o Pa(id(N), Tp(f)) = Tp(f) o SUC’
 >-- arw[Tp1_def] >>
 arw[] >> strip_tac >>
 qspecl_then [‘A’,‘B’,‘f'’,‘g’] assume_tac
 Thm1_comm_eq_condition >>
 first_x_assum drule >> once_arw[] >>
 rpt strip_tac >>
 irule $ iffLR Tp_eq >> arw[] >> first_x_assum irule >>
 pop_assum (assume_tac o GSYM) >> arw[] >>
 qpick_x_assum ‘Tp(f') o O = Tp1(g)’ 
 (assume_tac o GSYM) >> arw[] >> fs[Tp1_def])
(form_goal
 “!A B g:A->B h:(A * N) * B ->B. 
 ?!f:A * N ->B.
   f o Pa(p1(A,1),O o p2(A,1)) = g o p1(A,1) & 
  h o Pa(id(A * N),f) = f o Pa(p1(A,N), SUC o p2(A,N))”));


val post_inv_Mono = prove_store("post_inv_Mono",
e0
(rpt strip_tac >> rw[Mono_def] >> rpt strip_tac >>
 qby_tac
 ‘i o m o g = i o m o h’ >-- arw[] >>
 rfs[GSYM o_assoc] >> fs[idL])
(form_goal
 “!A B m:A->B i:B->A. i o m = id(A) ==> Mono(m)”));


val pre_inv_Epi = prove_store("pre_inv_Epi",
e0
(rpt strip_tac >> rw[Epi_def] >> rpt strip_tac >>
 qby_tac
 ‘g o e o i = h o e o i’ >-- arw[GSYM o_assoc] >>
 rfs[idR])
(form_goal
 “!A B e:A->B i:B->A. e o i = id(B) ==> Epi(e)”));

(*val _ = new_pred "Iso" [("f",ar_sort (mk_ob "A") (mk_ob "B"))] *)

val Iso_def = qdefine_psym("Iso",[‘f:A->B’])
‘?f':B->A. f' o f = id(A) & f o f' = id(B)’
|> gen_all |> store_as "Iso_def";


val to_zero_Iso = prove_store("to_zero_Iso",
e0
(rpt strip_tac >> rw[Iso_def] >>
 drule to_zero_zero >> fs[is0_def] >> 
 first_assum 
  (qspecl_then [‘X’] $ strip_assume_tac o uex_expand)>>
 first_assum 
  (qspecl_then [‘A’] $ strip_assume_tac o uex_expand) >>
 last_assum 
  (qspecl_then [‘X’] $ strip_assume_tac o uex_expand) >>
 last_assum 
  (qspecl_then [‘A’] $ strip_assume_tac o uex_expand) >>
 qexists_tac ‘f''''’ >> fs[] >>
 once_arw[] >> rw[])
(form_goal
 “!X. is0(X) ==> !A f:A->X. Iso(f)”));

val Mono_Epi_Iso = prove_store("Mono_Epi_Iso",
e0
(rpt strip_tac >> 
 cases_on “is0(B)” >--
 (drule to_zero_Iso >> arw[]) >>
 drule no_Epi_from_zero >> first_x_assum drule >>
 drule NONZERO_EL >> pop_assum strip_assume_tac >>
 qspecl_then [‘A’,‘B’,‘x’,‘a’] strip_assume_tac AC >>
 rw[Iso_def] >> drule Mono_pinv_post_inv >>
 first_x_assum drule >>
 drule Epi_pinv_pre_inv >> first_x_assum drule >>
 qexists_tac ‘g’ >> arw[])
(form_goal
 “!A B a:A->B. Mono(a) & Epi(a) ==> Iso(a)”));

val DISTI_endo_2 = prove_store("DISTI_endo_2",
e0
(ccontra_tac >> fs[coPa_eq_eq] >>
 fs[i1_ne_i2_1])
(form_goal
 “~(coPa(i1(1,1),i2(1,1)) = coPa(i2(1,1),i1(1,1)))”))

val PRE_def = 
Thm1_case_1 |> specl (List.map rastt ["N","O","p1(N,N)"])
            |> qsimple_uex_spec "PRE" []
            |> rewr_rule[p1_of_Pa]
            |> store_as "PRE_def";

val Pre_def = qdefine_fsym("Pre",[‘n:1->N’]) ‘PRE o n’
|> gen_all |> store_as "Pre_def";

val Thm2_1 = prove_store("Thm2_1",
e0
(strip_tac >> ccontra_tac >>
 qsuff_tac ‘!X t:X->X. t = id(X)’
 >-- (strip_tac >> 
      first_assum 
      (qspecl_then [‘1+1’,‘coPa(i1(1,1),i2(1,1))’] 
      assume_tac) >>
      first_x_assum 
      (qspecl_then [‘1+1’,‘coPa(i2(1,1),i1(1,1))’] 
      assume_tac) >> 
      qby_tac
      ‘coPa(i1(1,1),i2(1,1)) = coPa(i2(1,1),i1(1,1))’
      >-- arw[] >>
      fs[DISTI_endo_2]) >>
 rpt strip_tac >> irule FUN_EXT >> strip_tac >> 
 qby_tac ‘SUC o O = O’ >--
 (qby_tac ‘PRE o SUC o n = PRE o O’ >-- arw[] >>
  assume_tac PRE_def >> 
  fs[GSYM o_assoc] >> fs[idL]) >>
 qspecl_then [‘X’,‘t’,‘a’] (strip_assume_tac o conjE1) 
 Nrec_def >>
 rw[idL] >>
 qby_tac ‘t o a = t o Nrec(a, t) o O’ 
 >-- arw[] >>
 fs[GSYM o_assoc] >> 
 qpick_x_assum ‘Nrec(a, t) o SUC = t o Nrec(a, t)’
 (assume_tac o GSYM) >> arw[] >>
 rw[o_assoc] >> arw[])
(form_goal
 “!n:1->N. ~(SUC o n = O)”));


val Thm2_2 = prove_store("Thm2_2",
e0
(irule post_inv_Mono >>
 qexists_tac ‘PRE’ >> rw[PRE_def])
(form_goal
 “Mono(SUC)”));

val Thm2_3_alt' = prove_store("Thm2_3_alt'",
e0
(rpt strip_tac >> irule Mono_Epi_Iso >>
 arw[] >> irule pre_inv_Epi >>
 qexists_tac ‘Nrec(z,s)’ >> irule comm_with_SUC_id >>
 rw[o_assoc,Nrec_def] >> arw[GSYM o_assoc])
(form_goal
 “!A a:A->N. Mono(a) ==>
  !s:A->A z:1->A.a o s = SUC o a & a o z = O ==>
  Iso(a)”));

val isPb_def = qdefine_psym("isPb",[‘f:X->Z’,‘g:Y->Z’,‘p: P ->X’,‘q: P -> Y’])
‘ f o p = g o q &
 !A u : A -> X v : A -> Y. 
    f o u = g o v ==> 
    ?!a : A -> P. p o a = u & q o a = v’
|> qgenl [‘X’,‘Z’,‘f:X->Z’,‘Y’,‘g:Y->Z’,‘P’,‘p:P ->X’,‘q: P ->Y’]
|> store_as "isPb_def";

val isPb_expand = isPb_def
                      |> conv_rule $ once_depth_fconv no_conv (rewr_fconv $ uex_def “?!a : A -> P. p:P->X o a = u & q:P->Y o a = v”) |> store_as "isPb_expand";

val isPb_ex = prove_store("isPb_ex",
e0
(rpt strip_tac >> rw[isPb_expand] >>
 qspecl_then [‘X * Y’,‘Z’,‘f o p1(X,Y)’,‘g o p2(X,Y)’] (x_choosel_then ["E","e"] assume_tac) isEq_ex >>
 qexistsl_tac [‘E’,‘p1(X,Y) o e’,‘p2(X,Y) o e’] >>
 qby_tac
 ‘f o p1(X, Y) o e = g o p2(X, Y) o e’
 >-- (rw[GSYM o_assoc] >> irule Eq_equality >> arw[]) >>
 arw[] >> rpt strip_tac >>
 drule $ iffLR isEq_def >> rfs[o_assoc] >>
 first_x_assum (qsspecl_then [‘Pa(u,v)’] assume_tac) >>
 rfs[p12_of_Pa] >> pop_assum (strip_assume_tac o GSYM o uex_expand) >>
 qexists_tac ‘a0’ >>  arw[o_assoc,p12_of_Pa] >>
 pop_assum (assume_tac o GSYM) >>
 rpt strip_tac >> first_x_assum irule >>
 irule to_P_eq >> arw[p12_of_Pa])
(form_goal
 “!X Z f:X->Z Y g:Y->Z. ?P p:P->X q. isPb(f,g,p,q)”));

val Pb_Mono_Mono = prove_store("Pb_Mono_Mono",
e0
(rpt strip_tac >> rw[Mono_def] >> rpt strip_tac >>
 drule $ iffLR isPb_expand >>
 pop_assum strip_assume_tac >>
 qsuff_tac
 ‘f o p o h = g o q o h’ >--
 (strip_tac >> first_x_assum drule >>
 pop_assum strip_assume_tac >>
 qsuff_tac ‘g' = a & h = a’ >-- 
 (strip_tac >> arw[]) >> strip_tac >> 
 first_x_assum irule >> arw[] >>
 fs[Mono_def] >> first_x_assum irule >> 
 qpick_x_assum ‘f o p = g o q’ (assume_tac o GSYM) >>
 arw[GSYM o_assoc] >> arw[o_assoc]) >>
 arw[GSYM o_assoc])
(form_goal
 “!X Z f:X->Z Y g:Y->Z P p:P->X q:P->Y. 
  isPb(f,g,p,q) ==> Mono(g) ==> Mono(p)”));

val surj_Epi = prove_store("surj_Epi",
e0
(rpt strip_tac >> rw[Epi_def] >> rpt strip_tac >>
 irule FUN_EXT >> strip_tac >>
 first_x_assum (qspecl_then [‘a’] strip_assume_tac) >>
 pop_assum (assume_tac o GSYM) >> arw[GSYM o_assoc])
(form_goal
 “!A B f:A->B. (!b:1->B.?b0:1->A. f o b0 = b) ==> Epi(f)”));


val isPb_equality = 
    isPb_expand |> spec_all |> iffLR
                |> undisch |> conjE1
                |> disch_all 
                |> qgenl [‘X’,‘Z’,‘f’,‘Y’,‘g’,‘P’,‘p’,‘q’]
                |> store_as "isPb_equality"

val ind_fac = prove_store("ind_fac",
e0
(rpt strip_tac >> 
 qspecl_then [‘A’,‘N’,‘SUC o a’,‘A’,‘a’] strip_assume_tac 
 isPb_ex>> 
 drule isPb_equality >> 
 qsuff_tac ‘Iso(p)’ 
 >-- (rw[Iso_def] >> strip_tac >> qexists_tac ‘q o f'’ >>
      qpick_x_assum ‘(SUC o a) o p = a o q’ 
       (assume_tac o GSYM) >>
      arw[GSYM o_assoc] >> arw[o_assoc,idR]) >>
 irule Mono_Epi_Iso >> strip_tac (* 2 *)
 >-- (irule Pb_Mono_Mono >>
 qexistsl_tac [‘A’,‘q’,‘N’,‘SUC o a’,‘a’] >> arw[]) >>
 irule surj_Epi >> strip_tac >>
 qby_tac ‘?sn0. SUC o a o b = a o sn0’
 >-- (first_x_assum irule >> qexists_tac ‘b’ >> rw[]) >>
 drule $ iffLR isPb_expand >> 
 pop_assum strip_assume_tac >>
 fs[GSYM o_assoc] >> first_x_assum drule >>
 pop_assum strip_assume_tac >>
 qexists_tac ‘a'’ >> arw[]
 )
(form_goal
 “!A a:A->N. Mono(a) & 
  (!n:1->N. (?n0:1->A. n = a o n0) ==> (?sn0. SUC o n = a o sn0)) ==> ?t:A->A. a o t = SUC o a”));

val Thm2_3' = prove_store("Thm2_3'",
e0
(rpt strip_tac >> irule Thm2_3_alt' >>
 arw[] >> strip_tac (* 2 *) 
 >-- (irule ind_fac >> arw[]) >>
 qexists_tac ‘O0’ >> rw[]
)
(form_goal
 “!A a:A->N. (Mono(a) & (!n:1->N. (?n0:1->A. n = a o n0) ==>
 ?sn0. SUC o n = a o sn0) & ?O0:1->A. O = a o O0) ==> Iso(a)”));

val coEq_of_equal_post_inv = prove_store(
"coEq_of_equal_post_inv",
e0
(rpt strip_tac >> drule $ iffLR iscoEq_def >>
 pop_assum strip_assume_tac >>
 first_x_assum (qsspecl_then [‘id(B)’] assume_tac) >> fs[] >>
 pop_assum (strip_assume_tac o uex_expand) >>
 qexists_tac ‘x0’ >> arw[])
(form_goal
 “!A B f:A->B cE e:B->cE. iscoEq(f,f,e) ==>
  ?e':cE->B. e' o e = id(B)”));

val Thm3_A_zero_I_zero = prove_store(
"Thm3_A_zero_I_zero",
e0
(rpt strip_tac >> 
 qsuff_tac ‘~(?t:1->I0.T)’ >--
 (strip_tac >> ccontra_tac >> drule NONZERO_EL >> rfs[]) >>
 ccontra_tac >> 
 pop_assum strip_assume_tac >>
 qsuff_tac ‘i1(B,B) o q' o t = i2(B,B) o q' o t’ >--
 rw[i1_i2_disjoint] >>
 drule Eq_equality >>
 qby_tac ‘i1(B, B) o f = i2(B, B) o f’ >--
 (fs[is0_expand] >>
 first_x_assum (qspecl_then [‘B +B’] strip_assume_tac) >>
 fs[]) >> fs[] >>
 drule coEq_of_equal_post_inv >> 
 pop_assum strip_assume_tac >>
 qby_tac ‘e' o (k' o i1(B, B)) o q' =
          e' o (k' o i2(B, B)) o q'’ >-- arw[] >>
 rfs[GSYM o_assoc,idL])
(form_goal
 “!A. is0(A) ==>
  !B f:A->B R' k':B + B -> R'.
  iscoEq(i1(B,B) o f,i2(B,B) o f,k') ==>
  !I0 q':I0->B. isEq(k' o i1(B,B),k' o i2(B,B),q') ==>
  is0(I0)”));

val Thm3_case_zero = prove_store("Thm3_case_zero",
e0
(rpt strip_tac >>
 irule to_zero_Iso >> irule Thm3_A_zero_I_zero >>
 qexistsl_tac [‘A’,‘B’,‘f’,‘q'’,‘R'’,‘k'’] >> arw[])
(form_goal
 “!A B f:A->B. is0(A) ==>
 !R' k':B + B ->R'. iscoEq(i1(B,B) o f, i2(B,B) o f,k') ==>
 !I0 q':I0->B. isEq(k' o i1(B,B), k' o i2(B,B),q') ==> 
 !R k:R->A * A. isEq(f o p1(A,A),f o p2(A,A),k) ==>
 !I' q:A->I'.iscoEq(p1(A,A) o k, p2(A,A) o k,q) ==>
 !h:I'->I0. q' o h o q = f ==> Iso(h)”));


val o_Mono_imp_Mono = prove_store("o_Mono_imp_Mono",
e0
(rpt strip_tac >> fs[Mono_def] >> rpt strip_tac >> 
 first_x_assum irule >> arw[o_assoc])
(form_goal “!A B f:A->B C m:B->C. Mono(m o f) ==> Mono(f)”)
);
 

val o_Epi_imp_Epi = prove_store("o_Epi_imp_Epi",
e0
(rpt strip_tac >> fs[Epi_def] >> rpt strip_tac >> 
 first_x_assum irule >> arw[GSYM o_assoc])
(form_goal “!A B f:A->B C e:C->A. Epi(f o e) ==> Epi(f)”)
);

val Thm3_case_non_zero = prove_store("Thm3_case_non_zero",
e0
(rpt strip_tac >> irule Mono_Epi_Iso >> 
 drule Eqa_Mono >> rev_drule Eqa_Mono >>
 drule coEqa_Epi >> rev_drule coEqa_Epi >>
 qby_tac ‘~(is0(I0))’ >--
 (ccontra_tac >> 
  qsuff_tac ‘is0(A)’ >-- fs[] >>
  match_mp_tac to_zero_zero  >>
  qexistsl_tac [‘I0’,‘h o q’] >> arw[]) >>
 strip_tac (* 2 *) >--
 (qsuff_tac ‘Mono(q' o h)’
 >-- (strip_tac >> match_mp_tac o_Mono_imp_Mono >>
      qexistsl_tac [‘B’,‘q'’] >> arw[]) >>
 qby_tac ‘?t.q o t = id(I')’ >--
 (irule Epi_no_zero_pre_inv >> arw[]) >>
 pop_assum strip_assume_tac >> 
 rw[Mono_def] >> rpt strip_tac >>
 qby_tac ‘?w.k o w = Pa(t o h',t o g)’ >--
 (irule $ iffRL via_Eq_iff >> 
  qexistsl_tac [‘B’,‘f o p1(A, A)’,‘f o p2(A, A)’] >>
  arw[o_assoc,p12_of_Pa] >> 
  qby_tac
  ‘(q' o h o q) o t o h' = q' o h o (q o t) o h' & 
   (q' o h o q) o t o g = q' o h o (q o t) o g’ >--
  rw[o_assoc] >>
  qpick_x_assum ‘q' o h o q = f’ (assume_tac o GSYM) >>
  arw[] >> fs[idR,idL,o_assoc]) >>
 pop_assum strip_assume_tac >> 
 qsuff_tac ‘q o p1(A,A) o Pa(t o h', t o g) = h' &
            q o p2(A,A) o Pa(t o h', t o g) = g &
            q o p1(A,A) o Pa(t o h', t o g) = 
            q o p2(A,A) o Pa(t o h', t o g)’ >--
 (rpt strip_tac >> rfs[]) >> rpt strip_tac (* 3 *)
 >-- (arw[p1_of_Pa] >> arw[GSYM o_assoc,idL])
 >-- (arw[p2_of_Pa] >> arw[GSYM o_assoc,idL]) >>
 pop_assum (assume_tac o GSYM) >> arw[] >>
 drule coEq_equality >> fs[GSYM o_assoc]) >>
(qsuff_tac ‘Epi(h o q)’ >-- 
  (strip_tac >> drule o_Epi_imp_Epi >> arw[]) >>
  rw[Epi_def] >> rpt strip_tac >>
 drule Mono_no_zero_post_inv >> first_x_assum drule >>
 pop_assum (x_choose_then "qi" assume_tac) >>
 qby_tac ‘?w.w o k' = coPa(h' o qi,g o qi)’ >--
 (irule $ iffRL via_coEq_iff >>
  qexistsl_tac [‘A’,‘i1(B, B) o f’,‘i2(B, B) o f’] >>
  arw[i12_of_coPa,GSYM o_assoc] >> 
  qsuff_tac
  ‘(h' o qi) o q' o h o q = h' o (qi o q') o h o q &
   (g o qi) o q' o h o q = g o (qi o q') o h o q’
  >--(strip_tac >> rfs[idL]) >>
  rw[o_assoc]) >>
 pop_assum strip_assume_tac >>
 qsuff_tac
 ‘coPa(h' o qi,g o qi) o i1(B,B) o q' = h' &
 coPa(h' o qi,g o qi) o i2(B,B) o q' = g &
 coPa(h' o qi,g o qi) o i1(B,B) o q' = 
 coPa(h' o qi,g o qi) o i2(B,B) o q'’ >--
 (strip_tac >> rfs[]) >> rpt strip_tac (* 3 *) >--
 (arw[i1_of_coPa,GSYM o_assoc] >> arw[o_assoc,idR]) >--
 (arw[i2_of_coPa,GSYM o_assoc] >> arw[o_assoc,idR]) >>
 pop_assum (assume_tac o GSYM) >> once_arw[] >>
 rw[o_assoc] >> rev_drule Eq_equality >>
 fs[o_assoc]))
(form_goal
 “!A B f:A->B. ~(is0(A)) ==>
 !R' k':B + B ->R'. iscoEq(i1(B,B) o f, i2(B,B) o f,k') ==>
 !I0 q':I0->B. isEq(k' o i1(B,B), k' o i2(B,B),q') ==> 
 !R k:R->A * A. isEq(f o p1(A,A),f o p2(A,A),k) ==>
 !I' q:A->I'.iscoEq(p1(A,A) o k, p2(A,A) o k,q) ==>
 !h:I'->I0. q' o h o q = f ==> Iso(h)”));


val unique_h_lemma = prove_store("unique_h_lemma",
e0
(rpt strip_tac >> qexists_tac ‘h’ >> strip_tac >>
 dimp_tac >> strip_tac >> rfs[])
(form_goal 
“!A B f:A->B C q:A->C D g:D->B k:A->D h:C->D.
 (!k'. g o k' = f <=> k' = k) &
 (!h'. h' o q = k <=> h' = h) ==>
 (?h:C->D. !h0. g o h0 o q = f <=> h0 = h)”));


val Eqa_def_alt = prove_store("Eqa_def_alt",
e0
(rpt strip_tac >> drule $ iffLR isEq_def >>
 pop_assum strip_assume_tac >>
 first_x_assum rev_drule >> pop_assum (strip_assume_tac o uex_expand) >> 
 qexists_tac ‘a0’ >> arw[] >>
 strip_tac >> dimp_tac >> strip_tac (* 2 *)
 >-- (first_x_assum irule >> arw[]) >>
 arw[])
(form_goal
 “!A B f:A->B g:A->B E e:E->A.
 isEq(f,g,e) ==>
 !X a:X->A. f o a = g o a ==> ?eqa.
 !a0:X->E. e o a0 = a <=> a0 = eqa ”));


val coEqa_def_alt = prove_store("coEqa_def_alt",
e0
(rpt strip_tac >> drule $ iffLR iscoEq_def >>
 pop_assum strip_assume_tac >>
 first_x_assum rev_drule >> pop_assum (strip_assume_tac o uex_expand) >> 
 qexists_tac ‘x0’ >> arw[] >>
 strip_tac >> dimp_tac >> strip_tac (* 2 *)
 >-- (first_x_assum irule >> arw[]) >>
 arw[])
(form_goal
 “!A B f:A->B g:A->B cE ce:B->cE.
 iscoEq(f,g,ce) ==>
 !X x:B->X. x o f = x o g ==> ?cea.
 !x0:cE->X. x0 o ce = x <=> x0 = cea ”));

val Thm3_h_exists = prove_store("Thm3_h_exists",
e0
(rpt strip_tac >> match_mp_tac unique_h_lemma >>
 rev_drule Eqa_def_alt >>
 rev_drule coEq_equality >> fs[o_assoc] >>
 first_x_assum drule >> pop_assum strip_assume_tac >>
 drule coEqa_def_alt >> drule Eq_equality >>
 fs[o_assoc] >> 
 first_x_assum (qsspecl_then [‘eqa’] assume_tac) >>
 qby_tac ‘eqa o p1(A, A) o k = eqa o p2(A, A) o k’
 >-- (rev_drule Eqa_Mono >> fs[Mono_def] >>
     last_x_assum (qspecl_then [‘eqa’] assume_tac) >> fs[] >>
     first_x_assum irule >> arw[GSYM o_assoc] >> arw[o_assoc]) >>
 first_x_assum drule >> pop_assum strip_assume_tac >>
 qexistsl_tac [‘eqa’,‘cea’]  >> arw[])
(form_goal 
“!A B f:A->B.
 !R' k':B + B->R'. iscoEq(i1(B,B) o f,i2(B,B) o f,k') ==>
 !I0 q':I0->B. isEq(k' o i1(B,B), k' o i2(B,B),q') ==>
 !R k:R->A * A. isEq(f o p1(A,A),f o p2(A,A),k) ==>
 !I' q:A->I'.iscoEq(p1(A,A) o k, p2(A,A) o k,q) ==>
 ?h:I' ->I0.!h0. q' o h0 o q = f <=> h0 = h”));

val Thm3_without_assume_exists = prove_store(
"Thm3_without_assume_exists",
e0
(rpt strip_tac >>
 drule Thm3_h_exists >>
 first_x_assum drule >> first_x_assum drule >>
 first_x_assum drule >>
 pop_assum strip_assume_tac >>
 qexists_tac ‘h’ >>
 qby_tac ‘q' o h o q = f’ >-- arw[] >>
 cases_on “is0(A)” (* 3 *) >-- 
 (qspecl_then [‘A’,‘B’,‘f’] assume_tac Thm3_case_zero >>
  first_x_assum drule >> strip_tac >> 
  first_x_assum drule >> first_x_assum drule >>
  first_x_assum drule >> first_x_assum drule >>
  dimp_tac >> strip_tac >> rfs[] >> 
  first_x_assum irule >> 
  first_x_assum (qspecl_then [‘h’] assume_tac) >>
  fs[]) >>
 qspecl_then [‘A’,‘B’,‘f’] assume_tac Thm3_case_non_zero >>
  first_x_assum drule >> strip_tac >> 
  first_x_assum drule >> first_x_assum drule >>
  first_x_assum drule >> first_x_assum drule >>
  dimp_tac >> strip_tac >> rfs[] >> 
  first_x_assum irule >> 
  first_x_assum (qspecl_then [‘h’] assume_tac) >>
  fs[])
(form_goal
 “!A B f:A->B.
 !R' k':B + B->R'. iscoEq(i1(B,B) o f,i2(B,B) o f,k') ==>
 !I0 q':I0->B. isEq(k' o i1(B,B), k' o i2(B,B),q') ==>
 !R k:R->A * A. isEq(f o p1(A,A),f o p2(A,A),k) ==>
 !I' q:A->I'.iscoEq(p1(A,A) o k, p2(A,A) o k,q) ==>
 ?h:I' ->I0.!h0. q' o h0 o q = f & Iso(h) <=> h0 = h”));

val Iso_Mono = prove_store("Iso_Mono",
e0
(rw[Iso_def,Mono_def] >> rpt strip_tac >> 
 qsuff_tac ‘f' o f o g = f' o f o h’ 
 >-- (arw[GSYM o_assoc,idL]) >> arw[])
(form_goal “!A B f:A->B.Iso(f) ==> Mono(f)”));


val o_Mono_Mono = prove_store("o_Mono_Mono",
e0
(rpt strip_tac >> rw[Mono_def] >> rpt strip_tac >>
 fs[o_assoc,Mono_def] >>
 first_x_assum drule >> first_x_assum drule >>
 first_x_assum accept_tac)
(form_goal 
“!A B f:A->B. Mono(f) ==> !C g:B->C. Mono(g) ==>
 Mono(g o f)”));

val Mono_o_Iso_Mono = prove_store("Mono_o_Iso_Mono",
e0
(rpt strip_tac >> irule o_Mono_Mono >> 
 drule Iso_Mono >> arw_tac[])
(form_goal “!X A i:X->A.Iso(i) ==> !B f:A->B. Mono(f) ==> Mono(f o i)”));

val Mono_Epi_fac = prove_store("Mono_Epi_fac",
e0
(rpt strip_tac >> 
 qspecl_then [‘A’,‘B + B’,‘i1(B,B) o f’,‘i2(B,B) o f’]
 (x_choosel_then ["R'","k'"] assume_tac) iscoEq_ex >>
 qspecl_then [‘B’,‘R'’,‘k' o i1(B,B)’,‘k' o i2(B,B)’]
 (x_choosel_then ["I0","q'"] assume_tac) isEq_ex >> 
 qspecl_then [‘A * A’,‘B’,‘f o p1(A,A)’,‘f o p2(A,A)’]
 (x_choosel_then ["R","k"] assume_tac) isEq_ex >>
 qspecl_then [‘R’,‘A’,‘p1(A,A) o k’,‘p2(A,A) o k’]
 (x_choosel_then ["I'","q"] assume_tac) iscoEq_ex >> 
 drule Thm3_without_assume_exists >>
 first_x_assum drule >> first_x_assum drule >>
 first_x_assum drule >>
 pop_assum strip_assume_tac >>
 qby_tac ‘q' o h o q = f & Iso(h)’ >-- arw[] >>
 rev_drule Eqa_Mono >> drule coEqa_Epi >>
 qexistsl_tac [‘I'’,‘q' o h’,‘q’] >> arw[o_assoc] >>
 irule Mono_o_Iso_Mono >> arw[])
(form_goal
 “!A B f:A->B. ?X m:X->B e:A->X. Epi(e) & Mono(m) & f = m o e”)); 

val Epi_surj = prove_store("Epi_surj",
e0
(rpt strip_tac >>
 drule Epi_has_section >>
 pop_assum strip_assume_tac >>
 qexists_tac ‘s0 o b’ >> fs[GSYM o_assoc,idL])
(form_goal “!A B f:A->B. Epi(f) ==> (!b:1->B. ?b0:1->A. f o b0 = b)”));

val Thm4 = prove_store("Thm4",
e0
(rpt strip_tac >> 
 abbrev_tac 
 “Ev(X,1+1) o Pa(p1(X,J),ss:J->Exp(X,1+1) o p2(X,J)) = s0” >>
 abbrev_tac “i2(1,1) o To1(X * J) = i2t” >>
 qspecl_then [‘X * J’,‘1 + 1’,‘s0’,‘i2t’]
 (x_choosel_then ["E","k"] assume_tac) isEq_ex >>
 qspecl_then [‘E’,‘X’,‘p1(X,J) o k’]
 (x_choosel_then ["U","a","q"] strip_assume_tac)
 Mono_Epi_fac >> qexistsl_tac [‘U’,‘a’] >> arw[] >> 
 strip_tac >> 
 qby_tac ‘!j:1->J. Ev(X,1+1) o Pa(x,ss o j) = i2(1,1) <=>
 s0 o Pa(x,j) = i2(1,1)’ >--
 (strip_tac >>
  qsuff_tac ‘Ev(X,1+1) o Pa(x,ss o j) = s0 o Pa(x,j)’
  >-- (strip_tac >> arw[]) >>
  last_x_assum (assume_tac o GSYM) >> arw[o_assoc] >>
  qsuff_tac 
  ‘Pa(x, ss o j) = Pa(p1(X, J), (ss o p2(X, J))) o Pa(x, j)’
  >-- (strip_tac >> arw[]) >>
  irule to_P_eq >> rw[p12_of_Pa] >>
  rw[GSYM o_assoc,p12_of_Pa] >> rw[o_assoc, p12_of_Pa]) >>
 arw[] >> dimp_tac >> strip_tac (* 2 *) >--
 (drule Epi_surj >> 
 first_x_assum 
 (qspecl_then [‘x0’] $ x_choose_then "xb" assume_tac) >>
 qexists_tac ‘p2(X,J) o k o xb’ >>
 qby_tac ‘Pa(x,p2(X,J) o k o xb) = k o xb’ >--
 (irule to_P_eq >> rw[p12_of_Pa] >> arw[GSYM o_assoc] >>
  arw[o_assoc]) >>
 drule Eq_equality >>
 qby_tac ‘i2t o k o xb = i2(1,1)’ >--
 (qpick_x_assum ‘i2(1, 1) o To1(X * J) = i2t’
  (assume_tac o GSYM) >> once_arw[] >>
  rw[o_assoc] >> once_rw[one_to_one_id] >> rw[idR]) >>
 arw[]>> arw[GSYM o_assoc] >> arw[o_assoc]) >>
 drule $ iffLR isEq_def >>
 pop_assum strip_assume_tac >> 
 first_x_assum (qsspecl_then [‘Pa(x,j)’] assume_tac) >>
 qby_tac ‘s0 o Pa(x, j) = i2t o Pa(x, j)’
 >-- (fs[] >>
     qpick_x_assum ‘i2(1, 1) o To1(X * J) = i2t’ 
     (assume_tac o GSYM) >> arw[o_assoc,one_to_one_id,idR]) >>
 first_x_assum drule >>
 pop_assum (strip_assume_tac o uex_expand) >>
 qexists_tac ‘q o a0’ >>
 qpick_x_assum ‘p1(X, J) o k = a o q’ (assume_tac o GSYM) >>
 arw[GSYM o_assoc] >> 
 qpick_x_assum ‘Pa(x, j) = k o a0’ (assume_tac o GSYM) >>
 arw[o_assoc,p1_of_Pa])
(form_goal
 “!J X ss:J-> Exp(X,1+1).
  ?U a:U->X. Mono(a) & 
   !x:1->X.
   (?x0. x = a o x0) <=>
   ?j:1->J. Ev(X,1+1) o Pa(x,ss o j) = i2(1,1)”));


val from_one_Mono = prove_store("from_one_Mono",
e0
(rpt strip_tac >> rw[Mono_def] >> rpt strip_tac >>
 qspecl_then [‘X'’] strip_assume_tac To1_def >> arw[])
(form_goal
 “!X f:1->X.Mono(f)”));

val Mono_disjoint_coPa_Mono = prove_store
("Mono_disjoint_coPa_Mono",
e0
(rpt strip_tac >> rw[Mono_def] >> rpt strip_tac >>
 irule FUN_EXT >> strip_tac >>
 qspecl_then [‘A’,‘B’,‘g o a'’] assume_tac INC_FAC >>
 qspecl_then [‘A’,‘B’,‘h o a'’] assume_tac INC_FAC >>
 pop_assum_list (map_every strip_assume_tac) (* 4 *)
 >-- (*case 1, use a is mono, both via a*)
 (qsuff_tac ‘f0 = f0'’ >-- (strip_tac >> fs[]) >>
  fs[Mono_def] >> first_x_assum irule >>
  qsuff_tac ‘coPa(a,b) o i1(A,B) o f0 = 
             coPa(a,b) o i1(A,B) o f0'’
  >-- rw[GSYM o_assoc,i1_of_coPa] >>
  arw[] >> arw[GSYM o_assoc])
 >-- (*case 2, h via a, g via b, contradiction*)
 (qsuff_tac ‘a o f0 = b o f0'’ >-- arw[] >>
  qsuff_tac ‘coPa(a,b) o i1(A,B) o f0 = 
             coPa(a,b) o i2(A,B) o f0'’
  >-- rw[GSYM o_assoc,i12_of_coPa] >>
  arw[] >> rw[GSYM o_assoc] >> arw[])
 >-- (*case 3, h via b, g via a, contradiction*)
 (qsuff_tac ‘a o f0' = b o f0’ >-- arw[] >>
  qsuff_tac ‘coPa(a,b) o i1(A,B) o f0' = 
             coPa(a,b) o i2(A,B) o f0’
  >-- rw[GSYM o_assoc,i12_of_coPa] >>
  arw[] >> rw[GSYM o_assoc] >> arw[]) >>
 (*case 4, both via b, use b mono*)
 qsuff_tac ‘f0 = f0'’ >-- (strip_tac >> fs[]) >>
 fs[Mono_def] >> last_x_assum irule >>
 qsuff_tac ‘coPa(a,b) o i2(A,B) o f0 = 
            coPa(a,b) o i2(A,B) o f0'’
 >-- rw[GSYM o_assoc,i2_of_coPa] >>
 arw[] >> arw[GSYM o_assoc])
(form_goal
 “!A X a:A->X.Mono(a) ==>
  !B b:B->X. Mono(b) ==>
  (!a0:1->A b0:1->B. ~(a o a0 = b o b0)) ==>
  Mono(coPa(a,b))”));

val Thm5_lemma_1 = prove_store("Thm5_lemma_1",
e0
(rpt strip_tac >> 
 qby_tac ‘~(is0(A + 1))’ 
 >-- (ccontra_tac >> drule zero_no_MEM >>
      qby_tac ‘?f:1->A +1 . T’ 
      >-- (qexists_tac ‘i2(A,1)’ >> rw[]) >> fs[]) >>
 qby_tac ‘Mono(coPa(a,x))’
 >-- (irule Mono_disjoint_coPa_Mono >>
      arw[from_one_Mono] >> rpt strip_tac >>
      once_rw[one_to_one_id] >> arw[idR]) >>
 drule Mono_no_zero_post_inv >> first_x_assum drule >>
 pop_assum (x_choose_then "u" assume_tac) >>
 qexists_tac ‘coPa(i1(1,1) o To1(A),i2(1,1)) o u’ >>
 rw[o_assoc] >>
 qby_tac ‘u o coPa(a, x) o i2(A,1) = id(A + 1) o i2(A,1)’
 >-- arw[GSYM o_assoc] >>
 qby_tac ‘u o coPa(a, x) o i1(A,1) = id(A + 1) o i1(A,1)’
 >-- arw[GSYM o_assoc] >>
 fs[i12_of_coPa,idL,idR])
(form_goal
 “!A X a:A->X.Mono(a) ==>
  !x:1->X. (!x0:1->A. ~(a o x0 = x)) ==>
  ?phi:X->1+1. phi o x = i2(1,1) & phi o a = i1(1,1) o To1(A)”));


val Thm5_constructions = prove_store("Thm5_constructions",
e0
(rpt strip_tac >>
 qexists_tac ‘Tp(i1(1,1) o To1(A * 1))’ >> rw[] >> 
 qexists_tac 
 ‘Tp(Ev(X, 1 + 1) o
  Pa(a o p1(A, Exp(X, 1 + 1)), p2(A, Exp(X, 1 + 1))))’ >>
 rw[] >> rpt strip_tac >>
 qexists_tac 
 ‘Ev(X, 1 + 1) o Pa(p1(X, L), u o p2(X, L))’ >>
 rw[] >> rpt strip_tac >>
 qspecl_then [‘E’,‘X’,‘p1(X,L) o k’] 
 assume_tac Mono_Epi_fac >>
 first_x_assum accept_tac)
(form_goal 
“!A X a:A->X.Mono(a) ==> 
 ?j0:1->Exp(A,1 + 1). Tp(i1(1,1) o To1(A * 1)) = j0 &
 ?a2:Exp(X,1+1)->Exp(A,1+1).
 Tp(Ev(X,1+1) o Pa(a o p1(A,Exp(X,1+1)),p2(A,Exp(X,1+1)))) = a2 &
 !L u:L-> Exp(X,1+1). isEq(a2,j0 o To1(Exp(X,1+1)),u) ==>
 ?ub:X * L-> 1 + 1. 
 Ev(X,1+1) o Pa(p1(X,L),u o p2(X,L)) = ub & 
 !E k:E->X * L.isEq(ub,i2(1,1) o To1(X * L),k) ==>
 ?A' a':A'->X q:E->A'.Epi(q) & Mono(a') & p1(X,L) o k = a' o q”));

val Thm5_Mono = prove_store("Thm5_Mono",
e0
(rpt strip_tac >> 
 qby_tac
 ‘(j0 o To1 (Exp(X,1+1))) o u = a2 o u’
 >-- (rev_drule Eq_equality >> arw[]) >>
 qby_tac
 ‘Ev(X,1+1) o Pa(a o p1(A,Exp(X,1+1)),p2(A,Exp(X,1+1))) =
  Ev(A,1+1) o Pa(p1(A,Exp(X,1+1)), a2 o p2(A,Exp(X,1+1)))’
 >-- (qpick_x_assum
      ‘Tp(Ev(X, 1 + 1) o Pa(a o p1(A, Exp(X, 1 + 1)), p2(A, Exp(X, 1 + 1)))) = a2’ (assume_tac o GSYM) >>
     arw[] >> rw[Ev_of_Tp]) >>
 qby_tac
 ‘Pa(p1(A, Exp(X, 1 + 1)),a2 o p2(A, Exp(X, 1 + 1))) o 
  Pa(p1(A,L),u o p2(A,L)) =
  Pa(p1(A,L), a2 o u o p2(A,L))’
 >-- (irule to_P_eq >> rw[p12_of_Pa] >>
      rw[GSYM o_assoc,p12_of_Pa] >> rw[o_assoc,p12_of_Pa]) >>
 qby_tac
 ‘!x:1->X.(?x0: 1-> A.a o x0 = x) ==>
  !t: 1 -> Exp(X,1+1).
   (?t0:1 -> L. u o t0 = t) ==>
   Ev(X,1+1) o Pa(x,t) = i1(1,1)’
 >-- (rpt strip_tac >>
      qby_tac 
      ‘Pa(a o x0,u o t0) = 
       Pa(a o p1(A, Exp(X, 1 + 1)), p2(A, Exp(X, 1 + 1))) o
       Pa(p1(A,L), u o p2(A,L)) o Pa(x0,t0)’ >--
      (irule to_P_eq >> rw[p12_of_Pa] >>
       rw[GSYM o_assoc,p12_of_Pa] >> rw[o_assoc,p12_of_Pa] >>
       qby_tac
       ‘a o p1(A, Exp(X, 1 + 1)) o Pa(p1(A, L), (u o p2(A, L))) o Pa(x0, t0) =  a o (p1(A, Exp(X, 1 + 1)) o Pa(p1(A, L), (u o p2(A, L)))) o Pa(x0, t0)’ >-- rw[o_assoc] >>
       arw[p12_of_Pa]) >>
      qpick_x_assum ‘a o x0 = x’
      (assume_tac o GSYM) >> 
      qpick_x_assum ‘u o t0 = t’
      (assume_tac o GSYM) >> once_arw[] >> 
      once_arw[] >> rw[GSYM o_assoc] >> once_arw[] >>
      qby_tac
      ‘(Ev(A, 1 + 1) o Pa(p1(A, Exp(X, 1 + 1)), a2 o p2(A, Exp(X, 1 + 1)))) o Pa(p1(A, L), u o p2(A, L)) =
       Ev(A, 1 + 1) o Pa(p1(A, Exp(X, 1 + 1)), a2 o p2(A, Exp(X, 1 + 1))) o Pa(p1(A, L), u o p2(A, L))’ >-- rw[o_assoc]>>
      arw[] >>
      qpick_x_assum ‘(j0 o To1(Exp(X, 1 + 1))) o u = a2 o u’
      (assume_tac o GSYM)  >>
      arw[GSYM o_assoc] >> 
      qby_tac
      ‘Pa(p1(A, L), ((j0 o To1(Exp(X, 1 + 1))) o u) o p2(A, L)) = Pa(p1(A,1),j0 o p2(A,1)) o Pa(p1(A,L),(To1(Exp(X,1+1)) o u) o p2(A,L))’ 
      >-- (irule to_P_eq >> rw[p12_of_Pa] >>
           rw[GSYM o_assoc,p12_of_Pa] >>
           rw[o_assoc,p12_of_Pa]) >>
      fs[o_assoc] >>
      qpick_x_assum ‘Tp(i1(1, 1) o To1(A * 1)) = j0’
      (assume_tac o GSYM) >> arw[GSYM o_assoc,Ev_of_Tp] >>
      rw[o_assoc]>> once_rw[one_to_one_id] >> rw[idR]) >>
qby_tac 
 ‘!x:1 -> X. 
  (?xb: 1 -> A'. a' o xb = x) ==>
  ?t: 1-> Exp(X,1+1). (?t0:1-> L.u o t0 = t) &
  Ev(X,1+1) o Pa(x,t) = i2(1,1)’
>-- (rpt strip_tac >> 
     qby_tac ‘?x0:1 -> E. q o x0 = xb’
     >-- (drule Epi_surj >> 
          first_x_assum $ qspecl_then [‘xb’] accept_tac) >>
     pop_assum strip_assume_tac >>
     qexists_tac ‘u o p2(X,L) o k o x0’ >>
     strip_tac (* 2 *) >--
     (qexists_tac ‘p2(X,L) o k o x0’ >> rw[]) >>
     qby_tac 
     ‘Pa(x, u o p2(X,L) o k o x0) = 
      Pa(p1(X,L), u o p2(X,L)) o
      Pa(x:1->X,p2(X,L) o k o x0)’
     >-- (irule to_P_eq >> rw[p12_of_Pa] >>
          rw[GSYM o_assoc,p12_of_Pa] >> 
          rw[o_assoc,p12_of_Pa]) >>
     once_arw[] >> drule Eq_equality >> 
     rw[GSYM o_assoc] >> once_arw[] >>
     qby_tac ‘x = p1(X,L) o k o x0’ 
     >-- (rw[GSYM o_assoc] >> arw[] >> arw[o_assoc]) >>
     once_arw[] >> rw[o_assoc,GSYM to_P_component] >>
     arw[GSYM o_assoc] >>
     rw[o_assoc] >> once_rw[one_to_one_id] >>
     rw[idR]) >>
qby_tac 
 ‘!x:1->X. (~((?x0:1->A. a o x0 = x) &
             ?x0:1->A'. a' o x0 = x))’ 
>-- (rpt strip_tac >> ccontra_tac >>
     pop_assum strip_assume_tac >>
     qsuff_tac ‘i1(1,1) = i2(1,1)’ >-- rw[i1_ne_i2_1] >>
     qby_tac ‘?xb : 1 -> A'. a' o xb = x’ 
     >-- (qexists_tac ‘x0'’ >> arw[]) >>
     first_x_assum drule >> 
     pop_assum strip_assume_tac >> 
     qby_tac ‘?x0 : 1 -> A. a o x0 = x’ 
     >-- (qexists_tac ‘x0’ >> arw[]) >>
     first_x_assum drule >> 
     pop_assum strip_assume_tac >> 
     first_x_assum $ qspecl_then [‘t’] assume_tac >>
     qby_tac ‘?(t0 : 1 -> L). u o t0 = t’ 
     >-- (qexists_tac ‘t0’ >> arw[]) >>
     first_x_assum drule >> fs[]) >> 
irule Mono_disjoint_coPa_Mono >> arw[] >>
rpt strip_tac >> ccontra_tac >>
qsuff_tac
‘((?x0 :1->A. a o x0 = a' o b0) &
   ?(x0 :1->A'). a' o x0 = a' o b0)’ >-- arw[] >>
strip_tac (* 2 *)
>-- (qexists_tac ‘a0’ >> arw[]) >>
qexists_tac ‘b0’ >> arw[] )
(form_goal
“!A X a:A->X.Mono(a) ==> 
 !j0:1->Exp(A,1 + 1). Tp(i1(1,1) o To1(A * 1)) = j0 ==>
 !a2:Exp(X,1+1)->Exp(A,1+1).
 Tp(Ev(X,1+1) o Pa(a o p1(A,Exp(X,1+1)),p2(A,Exp(X,1+1)))) = a2 ==> 
 !L u:L-> Exp(X,1+1). isEq(a2,j0 o To1(Exp(X,1+1)),u) ==>
 !ub:X * L-> 1 + 1. 
 Ev(X,1+1) o Pa(p1(X,L),u o p2(X,L)) = ub ==>
 !E k:E->X * L.isEq(ub,i2(1,1) o To1(X * L),k) ==>
 !A' a':A'->X q:E->A'.Epi(q) & Mono(a') & p1(X,L) o k = a' o q ==> Mono(coPa(a,a'))”));


val Thm5_Epi_ex_xp_a2phi0 = prove_store(
"Thm5_Epi_ex_xp_a2phi0",
e0
(rpt strip_tac >> irule Ev_eq_eq >>
 rw[o_assoc] >> 
 qby_tac
 ‘j0 o To1(Exp(X, 1 + 1)) o phi0 o p2(A, 1) = 
  j0 o (To1(Exp(X, 1 + 1)) o phi0) o p2(A, 1)’ >-- 
 rw[o_assoc] >>
 once_arw[] >> once_rw[one_to_one_id] >> rw[idL] >>
 qby_tac
 ‘Pa(p1(A, 1), a2 o phi0 o p2(A, 1)) = 
  Pa(p1(A,Exp(X,1+1)), a2 o p2(A,Exp(X,1+1))) o 
  Pa(p1(A,1),phi0 o p2(A,1))’
 >-- (irule to_P_eq >> rw[p12_of_Pa] >>
      rw[GSYM o_assoc,p12_of_Pa] >> rw[o_assoc,p12_of_Pa]) >>
 once_arw[] >> rw[GSYM o_assoc] >> 
 qpick_x_assum ‘Tp(Ev(X, 1 + 1) o Pa(a o p1(A, Exp(X, 1 + 1)), p2(A, Exp(X, 1 + 1)))) = a2’ (assume_tac o GSYM) >>
 once_arw[] >> rw[Ev_of_Tp] >> 
 qpick_x_assum ‘Tp(i1(1, 1) o To1(A * 1)) = j0’
 (assume_tac o GSYM) >> once_arw[] >> rw[Ev_of_Tp] >>
 qpick_x_assum ‘Tp(phi o p1(X, 1)) = phi0’
 (assume_tac o GSYM) >> once_arw[] >>
 rw[Pa_distr,o_assoc,p12_of_Pa] >>
 qby_tac 
 ‘Pa(a o p1(A, 1), Tp((phi o p1(X, 1))) o p2(A, 1)) = 
  Pa(p1(X,1), phi0 o p2(X,1)) o Pa(a o p1(A,1), p2(A,1))’
 >-- (irule to_P_eq >> rw[p12_of_Pa] >>
      rw[GSYM o_assoc,p12_of_Pa] >> 
      rw[o_assoc,p12_of_Pa] >> arw[]) >>
 arw[] >> rw[GSYM o_assoc,Ev_of_Tp] >>
 rw[o_assoc,p12_of_Pa] >> arw[GSYM o_assoc] >>
 rw[o_assoc] >> once_rw[To1_def]>> rw[]
 )
(form_goal
“!A X a:A->X.Mono(a) ==> 
 !j0:1->Exp(A,1 + 1). Tp(i1(1,1) o To1(A * 1)) = j0 ==>
 !a2:Exp(X,1+1)->Exp(A,1+1).
 Tp(Ev(X,1+1) o Pa(a o p1(A,Exp(X,1+1)),p2(A,Exp(X,1+1)))) = a2 ==> 
 !L u:L-> Exp(X,1+1). isEq(a2,j0 o To1(Exp(X,1+1)),u) ==>
 !ub:X * L-> 1 + 1. 
 Ev(X,1+1) o Pa(p1(X,L),u o p2(X,L)) = ub ==>
 !E k:E->X * L.isEq(ub,i2(1,1) o To1(X * L),k) ==>
 !A' a':A'->X q:E->A'.Epi(q) ==> Mono(a') ==>
  p1(X,L) o k = a' o q ==> 
 !b:1->X.(~(?b0:1 -> A. a o b0 = b)) ==> 
 !phi. phi o a = i1(1,1) o To1(A) ==> phi o b = i2(1,1) ==>
 !phi0.Tp(phi o p1(X,1)) = phi0 ==>
   a2 o phi0 = (j0 o To1 (Exp(X,1+1))) o phi0”));



val Thm5_Epi_ex_xp = prove_store(
"Thm5_Epi_ex_xp",
e0
(rpt strip_tac >> 
 assume_tac (Thm5_Epi_ex_xp_a2phi0 |> strip_all_and_imp) >>
 qby_tac
 ‘?phi0':1->L. u o phi0' = Tp(phi o p1(X,1))’
 >-- (irule (isEq_def |> iffLR |> strip_all_and_imp 
                      |> conjE2 |> strip_all_and_imp
                      |> uex2ex_rule |> GSYM
                      |> gen_disch_all) >>
     qexistsl_tac [‘Exp(A,2)’,‘a2’,‘j0 o To1(Exp(X, 2))’] >> arw[]) >>
 pop_assum strip_assume_tac >>
 qby_tac
 ‘ub o Pa(b, phi0') = 
  (i2(1,1) o To1 (X * L)) o Pa(b, phi0')’
 >-- (qby_tac ‘Pa(p1(X,L),u o p2(X,L)) o Pa(b, phi0') = 
               Pa(b, u o phi0')’
      >-- (irule to_P_eq >> rw[p12_of_Pa] >>
           rw[GSYM o_assoc,p12_of_Pa] >> 
           rw[o_assoc,p12_of_Pa]) >>
      qsuff_tac ‘Ev(X,1+1) o Pa(b,phi0) = phi o b’
      >-- (strip_tac >> rw[o_assoc] >>
           once_rw[one_to_one_id] >> rw[idR] >>
           qpick_x_assum 
           ‘Ev(X, 1 + 1) o Pa(p1(X, L), u o p2(X, L)) = ub’
           (assume_tac o GSYM) >>
           arw[o_assoc]) >> 
      qpick_x_assum 
      ‘Tp(phi o p1(X, 1)) = phi0’ (assume_tac o GSYM) >>
      arw[] >> 
      qby_tac ‘Tp(phi o p1(X, 1)) = 
      Tp(phi o p1(X, 1)) o id(1)’ >-- rw[idR] >>
      once_arw[] >> rw[Ev_of_Tp_el,o_assoc,p1_of_Pa]>>
      first_x_assum accept_tac) >>
 qby_tac
 ‘?bp0:1->E.k o bp0 = Pa(b,phi0')’ 
 >-- (irule (isEq_def |> iffLR |> strip_all_and_imp 
                      |> conjE2 |> strip_all_and_imp
                      |> uex2ex_rule |> GSYM
                      |> gen_disch_all) >>
      qexistsl_tac [‘2’,‘ub’,‘i2(1, 1) o To1(X * L)’] >> arw[]) >> 
 pop_assum strip_assume_tac >>
 qexists_tac ‘bp0’ >> irule to_P_eq >>
 rw[p12_of_Pa] >> rw[GSYM o_assoc,p12_of_Pa] >>
 arw[o_assoc,p12_of_Pa])
(form_goal
“!A X a:A->X.Mono(a) ==> 
 !j0:1->Exp(A,1 + 1). Tp(i1(1,1) o To1(A * 1)) = j0 ==>
 !a2:Exp(X,1+1)->Exp(A,1+1).
 Tp(Ev(X,1+1) o Pa(a o p1(A,Exp(X,1+1)),p2(A,Exp(X,1+1)))) = a2 ==> 
 !L u:L-> Exp(X,1+1). isEq(a2,j0 o To1(Exp(X,1+1)),u) ==>
 !ub:X * L-> 1 + 1. 
 Ev(X,1+1) o Pa(p1(X,L),u o p2(X,L)) = ub ==>
 !E k:E->X * L.isEq(ub,i2(1,1) o To1(X * L),k) ==>
 !A' a':A'->X q:E->A'.Epi(q) ==> Mono(a') ==>
  p1(X,L) o k = a' o q ==> 
 !b:1->X.(~(?b0:1 -> A. a o b0 = b)) ==> 
 !phi. phi o a = i1(1,1) o To1(A) ==> phi o b = i2(1,1) ==>
 !phi0.Tp(phi o p1(X,1)) = phi0 ==>
   ?xp:1->E. Pa(p1(X,L),u o p2(X,L)) o k o xp = 
  Pa(b,phi0)”));


val Thm5_Epi = prove_store("Thm5_Epi",
e0
(rpt strip_tac >> irule surj_Epi >> strip_tac >>
 cases_on “?b0:1->A. a:A->X o b0 = b” >--
 (pop_assum strip_assume_tac >> 
  qexists_tac ‘i1(A,A') o b0’ >> 
  arw[GSYM o_assoc,i1_of_coPa]) >>
 qsuff_tac ‘?b0':1->A'. a' o b0' = b’ >--
 (strip_tac >> qexists_tac ‘i2(A,A') o b0'’ >>
  arw[GSYM o_assoc,i2_of_coPa]) >>
 rev_drule Thm5_lemma_1 >> 
 qby_tac ‘!x0:1->A. ~(a o x0 = b)’
 >-- (strip_tac >> ccontra_tac >>
      qby_tac ‘?b0.a o b0 = b’ 
      >-- (qexists_tac ‘x0’ >> arw[]) >>
      fs[]) >>
 first_x_assum drule >> pop_assum strip_assume_tac >>
 abbrev_tac “Tp(phi:X->1+1 o p1(X,1)) = phi0” >>
 assume_tac (strip_all_and_imp Thm5_Epi_ex_xp) >>
 pop_assum strip_assume_tac >> 
 qexists_tac ‘q o xp’ >> 
 qby_tac ‘p1(X,Exp(X,1+1)) o Pa(b,phi0) = b’
 >-- rw[p1_of_Pa] >>
 pop_assum (assume_tac o GSYM) >> once_arw[] >>
 pop_assum (K all_tac) >>
 pop_assum (assume_tac o GSYM) >> once_arw[] >>
 rw[GSYM o_assoc,p1_of_Pa] >> once_arw[] >> rw[])
(form_goal
“!A X a:A->X.Mono(a) ==> 
 !j0:1->Exp(A,1 + 1). Tp(i1(1,1) o To1(A * 1)) = j0 ==>
 !a2:Exp(X,1+1)->Exp(A,1+1).
 Tp(Ev(X,1+1) o Pa(a o p1(A,Exp(X,1+1)),p2(A,Exp(X,1+1)))) = a2 ==> 
 !L u:L-> Exp(X,1+1). isEq(a2,j0 o To1(Exp(X,1+1)),u) ==>
 !ub:X * L-> 1 + 1. 
 Ev(X,1+1) o Pa(p1(X,L),u o p2(X,L)) = ub ==>
 !E k:E->X * L.isEq(ub,i2(1,1) o To1(X * L),k) ==>
 !A' a':A'->X q:E->A'.Epi(q) & Mono(a') & p1(X,L) o k = a' o q ==> Epi(coPa(a,a'))”));

val Thm5_Iso = prove_store("Thm5_Iso",
e0
(rpt strip_tac >> irule Mono_Epi_Iso >>
 rev_drule Thm5_Mono >> 
 first_x_assum drule >> first_x_assum drule >>
 first_x_assum drule >> first_x_assum drule >>
 first_x_assum drule >> 
 qby_tac ‘Mono(coPa(a, a'))’ >--
 (first_x_assum irule >> arw[] >>
  qexists_tac ‘q’ >> arw[]) >> arw[] >>
 rev_drule Thm5_Epi >> 
 first_x_assum drule >> first_x_assum drule >>
 first_x_assum drule >> first_x_assum drule >>
 first_x_assum drule >> 
 first_x_assum irule >> arw[] >>
 qexists_tac ‘q’ >> arw[])
(form_goal
“!A X a:A->X.Mono(a) ==> 
 !j0:1->Exp(A,1 + 1). Tp(i1(1,1) o To1(A * 1)) = j0 ==>
 !a2:Exp(X,1+1)->Exp(A,1+1).
 Tp(Ev(X,1+1) o Pa(a o p1(A,Exp(X,1+1)),p2(A,Exp(X,1+1)))) = a2 ==> 
 !L u:L-> Exp(X,1+1). isEq(a2,j0 o To1(Exp(X,1+1)),u) ==>
 !ub:X * L-> 1 + 1. 
 Ev(X,1+1) o Pa(p1(X,L),u o p2(X,L)) = ub ==>
 !E k:E->X * L.isEq(ub,i2(1,1) o To1(X * L),k) ==>
 !A' a':A'->X q:E->A'.Epi(q) & Mono(a') & p1(X,L) o k = a' o q ==> Iso(coPa(a,a'))”));


val Thm5 = prove_store("Thm5",
e0
(rpt strip_tac >> drule Thm5_constructions >>
 pop_assum strip_assume_tac >>
 qspecl_then 
 [‘Exp(X,1+1)’,‘Exp(A,1+1)’,‘a2’,‘j0 o To1(Exp(X,1+1))’] 
 (x_choosel_then ["L","u"] assume_tac) isEq_ex >>
 first_x_assum drule >>
 pop_assum strip_assume_tac >>
 qspecl_then [‘X * L’,‘1+1’,‘ub’,‘i2(1,1) o To1(X * L)’]
 (x_choosel_then ["E","k"] assume_tac) isEq_ex >>
 first_x_assum drule >>
 pop_assum (x_choosel_then ["A'","a'","q"] assume_tac) >>
 qexistsl_tac [‘A'’,‘a'’] >> 
 drule Thm5_Iso >>
 first_x_assum drule >> first_x_assum drule >>
 first_x_assum drule >> first_x_assum drule >>
 first_x_assum drule >> first_x_assum drule >>
 arw[])
(form_goal
 “!A X a:A->X.Mono(a) ==> 
  ?A' a':A'->X. Mono(a') & Iso(coPa(a,a'))”));

val Trans_def = qdefine_psym("Trans",[‘f0:R->A’,‘f1:R->A’])
‘!X h0:X->R h1:X->R. f1 o h0 = f0 o h1 ==> ?u:X->R. f0 o u = f0 o h0 & f1 o u = f1 o h1’ |> gen_all |> store_as "Trans_def";
 
val Refl_def = qdefine_psym("Refl",[‘f0:R->A’,‘f1:R->A’])
‘?d:A->R. f0 o d = id(A) & f1 o d = id(A)’
|> store_as "Refl_def"; 

val Sym_def = qdefine_psym("Sym",[‘f0:R->A’,‘f1:R->A’])
‘?t:R->R. f0 o t = f1 & f1 o t = f0’ |> gen_all |> store_as "Sym_def";


val Thm6_first_sentence = prove_store(
"Thm6_first_sentence",
 e0
(rpt strip_tac >> irule prop_2_coro >>
 qexistsl_tac [‘A * A’,‘Pa(f0,f1)’,‘e’] >>
 drule Eqa_Mono >> arw[] >> rpt strip_tac (* 2 *)
 >-- (irule (isEq_def |> iffLR |> strip_all_and_imp 
                      |> conjE2 |> strip_all_and_imp
                      |> uex2ex_rule 
                      |> gen_disch_all) >>
      qexistsl_tac [‘cE’,‘ce o p1(A, A)’,‘ce o p2(A, A)’] >> arw[] >> 
      qby_tac
      ‘(ce o p1(A, A)) o Pa(f0, f1) o x = 
       ce o (p1(A, A) o Pa(f0, f1)) o x &
       (ce o p2(A, A)) o Pa(f0, f1) o x =
       ce o (p2(A, A) o Pa(f0, f1)) o x’
      >-- rw[o_assoc] >> arw[p12_of_Pa] >> 
      drule coEq_equality >> arw[GSYM o_assoc]) >>
 first_x_assum 
 (qspecl_then [‘p1(A,A) o e o y’,‘p2(A,A) o e o y’]
  assume_tac) >>
 drule Eq_equality >>
 fs[GSYM o_assoc] >> qexists_tac ‘r’ >> 
 irule to_P_eq >> arw[GSYM o_assoc,p12_of_Pa])
(form_goal
“!R A f0:R->A f1. Refl(f0,f1) & Sym(f0,f1) & Trans(f0,f1) ==> Mono(Pa(f0,f1)) ==> 
!cE ce:A->cE.iscoEq(f0,f1,ce) ==>
(!a0:1->A a1:1->A. ce o a0 = ce o a1 ==> ?r:1->R. f0 o r = a0 & f1 o r = a1) ==> !E e:E->A * A. isEq(ce o p1(A,A),ce o p2(A,A),e) ==> areiso(R,E)”));


val Mem_of_name_Eqa = prove_store("Mem_of_name_Eqa",
e0
(rpt strip_tac >> drule via_Eq_iff >> arw[] >>
rw[o_assoc] >> once_arw[one_to_one_id] >> rw[idR] >>
qby_tac ‘Tp(psi o p1(R, 1)) = Tp(psi o p1(R, 1)) o id(1)’
>-- rw[idR] >>
once_arw[] >> rw[Ev_of_Tp_el] >> rw[o_assoc,p12_of_Pa])
(form_goal 
“!R psi:R-> 1+1 r:1 -> R. 
  !E e. isEq(Ev(R,1+1),i2(1,1) o To1(R * Exp(R,1+1)),e)==>
 (psi o r = i2(1,1) <=> 
  ?r':1->E. e o r' = Pa(r,Tp(psi o p1(R,1))))”));



val Char_ex = prove_store("Char_ex",
e0
(rpt strip_tac >> drule Thm5 >> pop_assum strip_assume_tac >>
 fs[Iso_def] >>
 qexists_tac ‘coPa(i2(1,1) o To1(A),i1(1,1) o To1(A')) o f'’
 >> strip_tac >> dimp_tac >> strip_tac (* 2 *)
 >-- (qby_tac 
      ‘(coPa(i2(1,1) o To1(A), i1(1,1) o To1(A')) o f') o a o x0 =  coPa(i2(1,1) o To1(A), i1(1,1) o To1(A')) o (f' o a) o x0’ 
     >-- rw[o_assoc] >>
     qpick_x_assum ‘a o x0 = x’ 
     (assume_tac o GSYM) >> arw[] >>
     qby_tac ‘f' o a = i1(A,A')’
     >-- (qby_tac 
         ‘f' o coPa(a, a') o i1(A,A') = id(A+A') o i1(A,A')’
         >-- (rw[GSYM o_assoc] >> arw[]) >>
         pop_assum mp_tac >> rw[i12_of_coPa,idL]) >>
     once_arw[] >> rw[GSYM o_assoc,i1_of_coPa] >>
     rw[o_assoc] >> once_rw[one_to_one_id] >> rw[idR]) >>
qspecl_then [‘A’,‘A'’,‘f' o x’] strip_assume_tac INC_FAC
>-- (qexists_tac ‘f0’ >>
     qby_tac ‘coPa(a,a') o i1(A, A') o f0 = 
              coPa(a,a') o f' o x’ >-- arw[] >>
     rfs[GSYM o_assoc,i1_of_coPa,idL]) >>
fs[o_assoc] >> pop_assum (assume_tac o GSYM) >> 
fs[] >> fs[GSYM o_assoc,i12_of_coPa] >>
fs[o_assoc] >> 
qpick_x_assum ‘i1(1, 1) o To1(A') o f0 = i2(1, 1)’ mp_tac >>
once_rw[one_to_one_id] >> rw[idR,i1_ne_i2_1])
(form_goal 
“!A X a:A->X. Mono(a) ==> 
 ?phi:X->1 + 1. (!x:1->X.(?x0:1->A.a o x0 = x) <=> phi o x = i2(1,1))”));


val INC_FAC_xor = prove_store("INC_FAC_xor",
e0
(rpt strip_tac >>
 qcases ‘?x0. x = i1(A,B) o x0’ >> arw[] (* 2 *)
 >-- (pop_assum strip_assume_tac >> ccontra_tac >> pop_assum strip_assume_tac >>
     qsspecl_then [‘x0’,‘x0'’] assume_tac prop_5_lemma >>
     qpick_x_assum ‘x = i1(A, B) o x0’ (assume_tac o GSYM) >> fs[]) >>
 pop_assum (assume_tac o GSYM) >>
 qsspecl_then [‘x’] assume_tac INC_FAC >> rfs[] >>
 qexists_tac ‘f0’ >> arw[])
(form_goal 
 “!A B x:1->A+B. (~(?x0:1->A. x = i1(A,B) o x0)) <=> (?x0:1->B. x = i2(A,B) o x0)”));





val iscoPa_def = 
    qdefine_psym("iscoPa",[‘iA:A->AB’,‘iB:B->AB’,‘f:A->X’,‘g:B->X’,‘fg:AB->X’])
                ‘iscoPr(iA,iB) & fg o iA = f & fg o iB = g’
   |> gen_all |> store_as "iscoPa_def";

val iscoPa_ex = prove_store("iscoPa_ex",
e0
(rpt strip_tac >> drule $ iffLR iscoPr_def >> rpt strip_tac >>
 rw[iscoPa_def] >> arw[])
(form_goal
 “!A AB iA:A->AB B iB:B->AB. iscoPr(iA,iB) ==>
  !X f:A->X g:B->X.?!fg:AB->X.iscoPa(iA,iB,f,g,fg)”));

val coPr_resp = prove_store("coPr_resp",
e0
(rpt strip_tac (* 2 *)
 >-- arw[iscoPa_def,i2_def,o_assoc,i12_of_coPa] >> 
 arw[iscoPa_def,i2_def,o_assoc,i12_of_coPa]>> fs[iscoPa_def] )
(form_goal
 “iscoPr(iA:A->AB,iB) ==>
  (!X f:A->X g:B->X fg. iscoPa(iA,iB,f,g,fg) <=> 
  iscoPa(i1(A,B),i2(A,B),f,g,fg o coPa(iA,iB))) & 
  !j:AB -> A + B. iscoPa(iA,iB,i1(A,B),i2(A,B), j) ==>
  (!X f:A->X g:B->X fg. iscoPa(i1(A,B),i2(A,B),f,g,fg) <=> 
  iscoPa(iA,iB,f,g,fg o j))”));






val iscoPr_expand = iscoPr_def |> conv_rule $ once_depth_fconv no_conv (rewr_fconv $ uex_def “?!fg : AB->X. fg o i1 = f & fg o i2 = g”) |> store_as "iscoPr_expand";



val coPr_Iso = prove_store("coPr_Iso",
e0
(rpt strip_tac >> rw[Iso_def] >> 
 drule $ iffLR iscoPr_def >>
 first_x_assum (qsspecl_then [‘i1(A,B)’,‘i2(A,B)’] assume_tac) >>
 pop_assum (strip_assume_tac o uex_expand) >>
 qexists_tac ‘fg’ >> strip_tac 
 >-- (irule from_coP_eq >> arw[o_assoc,i12_of_coPa,idL]) >>
 drule $ iffLR iscoPr_def >>
 first_x_assum (qsspecl_then [‘iA’,‘iB’] assume_tac) >>
 pop_assum (strip_assume_tac o uex_expand) >>
 qsuff_tac ‘coPa(iA, iB) o fg = fg' & id(AB) = fg'’  
 >-- (strip_tac >> arw[]) >>
 strip_tac >> first_x_assum irule >> arw[o_assoc,i12_of_coPa,idL])
(form_goal
 “!A B AB iA:A->AB iB:B->AB. 
  iscoPr(iA,iB) ==> Iso(coPa(iA,iB))”)); 




val iscoPa_coPa_inc = prove_store("iscoPa_coPa_inc",
e0
(rpt strip_tac >> rw[iscoPa_def,i2_def,i12_of_coPa])
(form_goal
 “!A AB iA:A->AB B iB:B->AB. iscoPr(iA,iB) ==> 
  iscoPa(i1(A, B), i2(A, B), iA, iB, coPa(iA, iB))”))

val iscoPa_i12 = prove_store("iscoPa_i12",
e0
(rpt strip_tac >> qspecl_then [‘A’,‘B’] assume_tac i2_def >>
 drule iscoPa_coPa_inc >> fs[] >> 
 qby_tac ‘coPa(i1(A, B), i2(A, B)) = id(A + B)’ 
 >-- (irule from_coP_eq >> rw[idL,i12_of_coPa]) >> fs[] >>
 dimp_tac >> strip_tac (* 2 *) >> arw[] >>
 drule iscoPa_ex >>
 first_x_assum (qsspecl_then [‘i1(A,B)’,‘i2(A,B)’] assume_tac) >>
 pop_assum (strip_assume_tac o uex_expand) >>
 qsuff_tac ‘f = fg & id(A + B) = fg’ 
 >-- (strip_tac >> arw[]) >> strip_tac >> first_x_assum irule >> arw[])
(form_goal
 “!A B f.iscoPa(i1(A, B), i2(A, B), i1(A, B), i2(A, B), f) <=> 
  f = id(A+B)”))


val from_coP_eq_iff = prove_store("from_coP_eq_iff",
e0
(rpt strip_tac >> dimp_tac >> disch_tac 
 >-- (drule from_coP_eq >> arw[]) >> arw[])
(form_goal
 “!A B X f:A + B-> X g:A + B->X. f o i1(A,B) = g o i1(A,B) & f o i2(A,B) = g o i2(A,B) <=> f = g”));


val iscoPa_inc = prove_store("iscoPa_inc",
e0
(rpt strip_tac >> drule coPr_resp >> fs[] >>
 rw[iscoPa_def] >> rw[i2_def,o_assoc,i12_of_coPa] >>
 drule $ iffLR iscoPr_def >>
 first_x_assum (qsspecl_then [‘iA’,‘iB’] assume_tac) >>
 pop_assum (strip_assume_tac o uex_expand) >> 
 dimp_tac >> strip_tac >> arw[idL] >>
 qsuff_tac ‘f = fg & id(AB) = fg’ 
 >-- (strip_tac >> arw[]) >> strip_tac >> first_x_assum irule >> arw[idL])
(form_goal
 “!A AB iA:A->AB B iB:B->AB. iscoPr(iA,iB) ==> !f.iscoPa(iA,iB,iA,iB, f) <=> 
  f = id(AB)”))

val coPr_iso_ex = prove_store("coPr_iso_ex",
e0
(rpt strip_tac >> drule iscoPa_ex >>
 first_x_assum 
 (qsspecl_then [‘i1(A,B)’,‘i2(A,B)’] (strip_assume_tac o uex2ex_rule)) >>
 qexists_tac ‘fg’ >> drule coPr_resp >> rfs[] >>
 last_x_assum (drule o iffLR) >>
 drule $ iffLR iscoPa_i12 >> arw[] >>
 drule $ iffRL from_coP_eq_iff >>
 pop_assum mp_tac >> rw[o_assoc,i12_of_coPa,idL] >> strip_tac >> arw[] >>
 irule $ iffLR iscoPa_inc >>
 qexistsl_tac [‘A’,‘iA’,‘B’,‘iB’] >> arw[] >>
 first_x_assum (irule o iffLR) >> arw[] >>
 drule iscoPa_coPa_inc >> arw[])
(form_goal
 “!A B AB iA:A->AB iB:B->AB. 
  iscoPr(iA,iB) ==> ?iso:AB->A + B. 
  iso o coPa(iA,iB) = id(A+B) & coPa(iA,iB) o iso = id(AB) & 
  iso o iA = i1(A,B) & iso o iB = i2(A,B)”));

val iscoPr_Iso = prove_store("iscoPr_Iso",
e0
(rpt gen_tac >> disch_tac >> drule coPr_iso_ex >>
 pop_assum strip_assume_tac >>
 drule iscoPa_ex >>
 first_x_assum 
 (qsspecl_then [‘i1(A,B)’,‘i2(A,B)’] (strip_assume_tac o uex_expand)) >>
 gen_tac >> disch_tac >>
 qsuff_tac ‘f = iso’ >-- (strip_tac >> arw[]) >>
 qsuff_tac ‘f = fg & iso = fg’ >-- (strip_tac >> arw[]) >> 
 strip_tac >> first_x_assum irule >> arw[] >>
 rw[iscoPa_def] >> arw[]
 )
(form_goal
 “!A B AB iA:A->AB iB:B->AB. 
  iscoPr(iA,iB) ==> !f.iscoPa(iA,iB,i1(A,B),i2(A,B),f) ==>
  coPa(iA,iB) o f = id(AB) & f o coPa(iA,iB) = id(A+B)”)); 

val copr_disjoint = prove_store("copr_disjoint",
e0
(rpt strip_tac >>
 qsuff_tac
 ‘!x:1->A+B. (~(?x0:1->A. x = i1(A,B) o x0)) <=> (?x0:1->B. x = i2(A,B) o x0)’ 
 >-- (strip_tac >>
     qby_tac ‘?iso:AB-> A+B. i1(A,B) = iso o iA & i2(A,B) = iso o iB &
              Iso(iso)’ 
     >-- (drule coPr_resp >>
          qsuff_tac ‘?iso:AB-> A+B. i1(A,B) = iso o iA & i2(A,B) = iso o iB’ 
          >-- (strip_tac >> qexists_tac ‘iso’ >>
              arw[Iso_def] >> qexists_tac ‘coPa(iA,iB)’ >>
              irule iscoPr_Iso >> rw[iscoPa_def] >>
              arw[i2_def]) >>
         qsuff_tac ‘?iso. iscoPa(iA,iB,i1(A,B),i2(A,B),iso)’ 
         >-- (strip_tac >> rfs[] >> 
             qby_tac ‘iso o coPa(iA, iB) = coPa(i1(A,B),i2(A,B))’ 
             >-- (irule from_coP_eq >> rw[o_assoc,i12_of_coPa] >>
                 drule $ iffLR iscoPa_def >> fs[o_assoc,i12_of_coPa]) >>
             qexists_tac ‘iso’ >> 
             drule $ iffRL from_coP_eq_iff >> fs[o_assoc,i12_of_coPa]) >>
         drule iscoPa_ex >>
         first_x_assum (qsspecl_then [‘i1(A,B)’,‘i2(A,B)’]
                                     (assume_tac o uex2ex_rule)) >>
         arw[]) >>
     qcases ‘?x0. x = iA o x0’ 
     >-- (arw[] >> ccontra_tac >> fs[] >>
         qsuff_tac ‘i1(A,B) o x0 = i2(A,B) o x0'’ 
         >-- rw[prop_5_lemma] >>
         qsuff_tac ‘?iso:AB-> A+B. i1(A,B) = iso o iA & i2(A,B) = iso o iB’ 
         >-- (strip_tac >> arw[o_assoc] >>
             qpick_x_assum ‘x = iA o x0’ (assume_tac o GSYM) >> arw[]) >>
         qexists_tac ‘iso’ >> arw[]) >> arw[] >>
     fs[] >>
     qby_tac ‘~(?x0. iso o  x = i1(A,B) o x0)’
     >-- (ccontra_tac >> pop_assum strip_assume_tac >>
         qsuff_tac ‘?x0:1->A. x = iA o x0’ 
         >-- arw[] >> 
         qexists_tac ‘x0’ >>    
        irule $iffLR Mono_def >> qexistsl_tac [‘A + B’,‘iso’] >>
        arw[o_assoc] >> irule Iso_Mono >>
        arw[]) >>
     qsspecl_then [‘iso o x’] assume_tac (GSYM INC_FAC) >> rfs[] >>
     qexists_tac ‘x0’ >> fs[o_assoc] >>
     irule $ iffLR Mono_def >>
      qexistsl_tac [‘A + B’,‘iso’] >>
        arw[o_assoc] >> irule Iso_Mono >>
        arw[]) >>
 rw[INC_FAC_xor])
(form_goal “!A B AB iA:A->AB iB:B->AB. iscoPr(iA,iB) ==>
!x:1->AB. (~(?x0:1->A. x = iA o x0)) <=> (?x0:1->B. x = iB o x0)”));

val i1_xor_i2_1 = prove_store("i1_xor_i2_1",
e0
(strip_tac >>
 qspecl_then [‘1’,‘1’] assume_tac i2_def >>
 drule copr_disjoint >>
 fs[one_to_one_id,idR] >> 
 first_x_assum (qspecl_then [‘x’] assume_tac) >>
 qsuff_tac ‘((?x0:1->1.x = i1(1,1)) <=> x = i1(1,1)) & 
            ((?x0:1->1.x = i2(1,1)) <=> x = i2(1,1))’ 
 >-- (strip_tac >> fs[] >> qcases ‘x = i1(1, 1)’ 
     >-- fs[] >> fs[]) >>
 strip_tac >> dimp_tac >> strip_tac >> qexists_tac ‘id(1)’ >> arw[])
(form_goal 
 “!x:1->1+1. x = i1(1,1) <=> ~(x = i2(1,1))”));


val i1_xor_i2' = prove_store("i1_xor_i2",
e0
(rw[i1_xor_i2_1])
(form_goal
 “∀x:1->1+1. ~(x = i1(1,1)) ⇔ x = i2(1,1)”));

val to_2_eq = prove_store("to_2_eq",
e0
(rpt strip_tac >> dimp_tac >> strip_tac >> arw[] >>
 irule FUN_EXT >> strip_tac >>
 first_x_assum (qspecl_then [‘a’] assume_tac) >>
 qcases ‘f1 o a = i1(1,1)’ 
 >-- (arw[] >> flip_tac >> rw[i1_xor_i2_1] >> 
     fs[i1_xor_i2_1]) >>
 fs[i1_xor_i2'])
(form_goal
 “∀X f1:X->1+1 f2. f1 = f2 ⇔ 
     (∀x. f1 o x = i2(1,1) ⇔ f2 o x = i2(1,1))”));

val Char_uex = prove_store("Char_uex",
e0
(rpt strip_tac >>
 qsuff_tac
 ‘?phi:X->1 + 1. (!x:1->X.(?x0:1->A.a o x0 = x) <=> phi o x = i2(1,1))’
 >-- (strip_tac >> uex_tac >> qexists_tac ‘phi’ >> arw[] >>
     rpt strip_tac >>
     irule $ iffRL to_2_eq >> arw[]) >>
 drule Char_ex >> arw[])
(form_goal 
“!A X a:A->X. Mono(a) ==> 
 ?!phi:X->1 + 1. (!x:1->X.(?x0:1->A.a o x0 = x) <=> phi o x = i2(1,1))”));


val Refl_equiv_to_itself  = prove_store("Refl_equiv_to_itself",
 e0
(rpt strip_tac >> fs[Refl_def] >> 
 qexists_tac ‘d o a’ >> rw[GSYM o_assoc] >> arw[idL])
(form_goal “!R A f0:R->A f1:R->A.Refl(f0:R->A,f1) ==> !a:1->A. ?r:1->R. f0 o r = a & f1 o r = a”));


val equiv_to_same_element = prove_store("equiv_to_same_element",
e0
(rpt strip_tac >> drule Refl_equiv_to_itself >> 
 first_x_assum (qspecl_then [‘a1’] assume_tac) >>
 first_x_assum (qspecl_then [‘a1’] assume_tac) >> rfs[] >>
 qexistsl_tac [‘r'’] >> arw[])
(form_goal 
“!R A f0:R->A f1.Refl(f0,f1) ==> 
 !a0 a1.
(!a':1->A.(?r:1->R.f0 o r = a1 & f1 o r = a') <=> (?r.f0 o r = a0 & f1 o r = a')) ==>
?r:1->R. f0 o r = a0 & f1 o r = a1”));

val Sym_Trans_rel_lemma = prove_store(
"Sym_Trans_rel_lemma",
e0
(rpt strip_tac >> dimp_tac >> rpt strip_tac >-- 
 (fs[Sym_def,Trans_def] >> 
  first_x_assum 
   (qspecl_then [‘1’,‘t o r'’,‘r’] assume_tac) >>
  qby_tac ‘f1 o t o r' = f0 o r’
  >-- (rw[GSYM o_assoc] >> arw[]) >>
  first_x_assum drule >> pop_assum strip_assume_tac >>
  qexists_tac ‘t o u’ >> rw[GSYM o_assoc] >> once_arw[] >>
  once_arw[] >> rw[GSYM o_assoc] >> once_arw[] >> 
  once_arw[] >> rw[]) >> 
 fs[Trans_def] >>
 qpick_x_assum ‘f0 o r'' = f1 o r’
 (assume_tac o GSYM) >>
 first_x_assum drule >> pop_assum strip_assume_tac >> 
 qexists_tac ‘u’ >> arw[])
(form_goal 
“!R A f0:R->A f1.Sym(f0:R->A,f1) & Trans(f0,f1) ==> 
!a:1->A r:1->R. 
((?r':1->R. f0 o r' = f0 o r & f1 o r' = a) <=> 
 (?r'':1->R. f0 o r'' = f1 o r & f1 o r'' = a))”));


local val l = proved_th $ 
e0
(strip_tac >> qexists_tac ‘i1(1,1) o To1(X)’ >> rw[])
(form_goal “!X. ?t2:X->2. T”)
in
val Char_def =  
Char_uex |> spec_all
         |> undisch
         |> quex_spec "Char" [‘a:A->X’]
         (spec_all l)
         |> disch_all |> gen_all
         |> store_as "Char_def";
end


val fac_Char = prove_store("fac_Char",
e0
(rpt strip_tac >> drule Char_def >>
irule FUN_EXT >> strip_tac >> rw[o_assoc] >>
once_rw[one_to_one_id] >> rw[idR] >> 
pop_assum (assume_tac o iffLR) >> first_x_assum irule >>
qexists_tac ‘f o a’ >> rw[GSYM o_assoc] >> once_arw[] >> rw[])
(form_goal 
“!A X m:A->X.Mono(m)==>!P p:P->X f:P->A. m o f = p ==>
Char(m) o p = i2(1,1) o To1(P)”));


val fac_Char_via_any_map = prove_store(
"fac_Char_via_any_map",
e0
(rpt strip_tac >> drule Epi_has_section >> 
 drule Char_def >> 
 first_x_assum (qspecl_then [‘b’] assume_tac) >>
 rfs[] >> qexists_tac ‘s0 o x0’ >>
 qby_tac ‘(m o e) o s0 o x0 = m o (e o s0) o x0’
 >-- rw[o_assoc] >> arw[idL])
(form_goal 
“!A M e:A->M. Epi(e) ==> !B m:M->B.Mono(m) ==>
 !f:A->B. f = m o e ==> 
 !b:1->B.Char(m) o b = i2(1,1) ==>
 ?a:1->A. f o a = b”));

val Pa_o_split = prove_store("Pa_o_split",
e0
(rpt strip_tac >> irule to_P_eq >>
 rw[p12_of_Pa] >> rw[GSYM o_assoc,p12_of_Pa] >>
 rw[o_assoc,p12_of_Pa])
(form_goal
 “!B X f:B->X Y g:X->Y A.Pa(p1(A,B),g:X->Y o f o p2(A,B)) = 
  Pa(p1(A,X), g o p2(A,X)) o Pa(p1(A,B),f o p2(A,B))”));

val o_partial_Ev = prove_store("o_partial_Ev",
e0
(rpt strip_tac >> 
 qby_tac 
 ‘Pa(id(A),To1(A)) o x = Pa(x,id(1))’ 
 >-- (irule to_P_eq >> rw[GSYM o_assoc,p12_of_Pa,idL] >>
      once_rw[one_to_one_id]) >>
 rw[Pa_o_split,GSYM o_assoc,Ev_of_Tp] >>
 rw[o_assoc,Pa_distr,p12_of_Pa,idL] >> 
 once_rw[one_to_one_id] >> rw[idR])
(form_goal 
“!A x:1->A X Y psi:X->Y phi. 
 phi o Pa(x,Tp1(psi)) = 
 Ev(A,1+1) o Pa(p1(A,1),Tp(phi) o Tp1(psi) o p2(A,1)) o 
 Pa(id(A),To1(A)) o x”));


val Thm6_lemma_3 = prove_store("Thm6_lemma_3",
 e0
(rpt strip_tac >> 
abbrev_tac “i2(1,1) o To1(R * Exp(R,1+1)) = t” >>
qspecl_then [‘R * Exp(R,1+1)’,‘1+1’,‘Ev(R,1+1)’,‘t’] assume_tac isEq_ex >>
pop_assum (x_choosel_then ["R'","Psi"] assume_tac) >>
abbrev_tac 
“Pa(h:R->A o p1(R,Exp(R,1+1)),p2(R,Exp(R,1+1))) = h2R” >>
qspecl_then [‘R'’,‘A * Exp(R,1+1)’,‘h2R o Psi’] (x_choosel_then ["M","m","e"] strip_assume_tac) Mono_Epi_fac >>
abbrev_tac “Char(m:M -> A * Exp(R,1+1)) = phi” >> 
qby_tac ‘!x:1->A * Exp(R,1+1). 
         (?x0:1->M. m o x0 = x) <=> phi o x = i2(1,1)’
>-- (drule Char_def >> arw[]) >>
qexists_tac ‘Tp(phi)’ >> strip_tac >> 
qby_tac
‘!r:1->R.
 psi o r = i2(1,1) <=> 
 ?r':1->R'. Psi o r' = Pa(r,Tp1(psi))’
>-- (strip_tac >> rw[Tp1_def] >> 
     irule Mem_of_name_Eqa >> fs[]) >>
strip_tac >> dimp_tac >> strip_tac (* 2 *) >-- 
(qby_tac 
 ‘phi o Pa(x,Tp1(psi)) = 
  Ev(A,1+1) o Pa(p1(A,1),Tp(phi) o Tp1(psi) o p2(A,1)) o 
  Pa(id(A),To1(A)) o x’ 
 >-- rw[o_partial_Ev] >>
 rfs[] >>
 drule fac_Char_via_any_map >> first_x_assum drule >>
 first_x_assum drule >> rfs[] >> first_x_assum drule >>
 first_x_assum (qspecl_then [‘Pa(x,Tp1(psi))’] assume_tac)>>
 rfs[] >> qexists_tac ‘p1(R,Exp(R,1+1)) o Psi o a’ >>
 strip_tac (* 2 *)
 >-- (qexists_tac ‘a’ >> irule to_P_eq >>
      rw[p12_of_Pa] >> 
      qby_tac 
      ‘p2(R, Exp(R, 1 + 1)) = p2(A, Exp(R, 1 + 1)) o h2R’
      >-- (qpick_x_assum 
           ‘Pa(h o p1(R, Exp(R, 1 + 1)), p2(R, Exp(R, 1 + 1))) = h2R’ 
           (assume_tac o GSYM) >> arw[p2_of_Pa]) >>
      once_arw[] >>
      qby_tac ‘(p2(A, Exp(R, 1 + 1)) o h2R) o Psi o a = 
      p2(A, Exp(R, 1 + 1)) o (h2R o Psi) o a’
      >-- rw[o_assoc] >> arw[p2_of_Pa]) >>
 qby_tac
 ‘h o p1(R, Exp(R, 1 + 1)) = p1(A, Exp(R, 1 + 1)) o h2R’
 >-- (qpick_x_assum 
      ‘Pa(h o p1(R, Exp(R, 1 + 1)), p2(R, Exp(R, 1 + 1))) = h2R’
      (assume_tac o GSYM) >> once_arw[] >> 
      rw[p1_of_Pa]) >>
 rw[GSYM o_assoc] >> once_arw[] >> 
 qby_tac ‘((p1(A, Exp(R, 1 + 1)) o h2R) o Psi) o a =
 p1(A, Exp(R, 1 + 1)) o (h2R o Psi) o a’ >-- rw[o_assoc] >>
 arw[p1_of_Pa]) >>
rfs[] >> 
qby_tac ‘m o e o r' = h2R o Pa(r, Tp1(psi))’
>-- (rw[GSYM o_assoc] >> 
     qpick_x_assum ‘h2R o Psi = m o e’ (assume_tac o GSYM) >>
     arw[] >> arw[o_assoc]) >>
qby_tac ‘h2R o Pa(r, Tp1(psi)) = Pa(x, Tp1(psi))’
>-- (irule to_P_eq >> rw[GSYM o_assoc,p12_of_Pa] >>
     qpick_x_assum 
     ‘Pa(h o p1(R, Exp(R, 1 + 1)), p2(R, Exp(R, 1 + 1))) = h2R’ (assume_tac o GSYM) >> arw[p12_of_Pa] >>
     arw[o_assoc,p12_of_Pa]) >>
qby_tac ‘phi o h2R o Pa(r, Tp1(psi)) = i2(1,1)’
>-- (qpick_x_assum ‘Char(m) = phi’ (assume_tac o GSYM) >>
     once_arw[] >> drule fac_Char >>
     first_x_assum 
     (qspecl_then [‘1’,‘Pa(x, Tp1(psi))’] assume_tac) >>
     qby_tac ‘To1(1) = id(1)’ 
     >-- (once_rw[one_to_one_id] >> rw[]) >> 
     qsuff_tac ‘Char(m) o Pa(x, Tp1(psi)) = i2(1,1) o To1(1)’
     >-- (once_arw[] >> rw[idR]) >>
     first_x_assum irule >>
     qexists_tac ‘e o r'’>> arw[]) >>
rw[Pa_distr,p12_of_Pa,idL,o_assoc] >> 
once_rw[one_to_one_id] >> rw[idR] >> 
qby_tac 
‘phi o Pa(x,Tp1(psi)) = 
 Ev(A,1+1) o Pa(p1(A,1),Tp(phi) o Tp1(psi) o p2(A,1)) o 
 Pa(id(A),To1(A)) o x’ 
>-- (rw[o_partial_Ev]) >> 
qby_tac ‘(h2R o Psi) o r' =
 h2R o Pa(r, Tp1(psi))’ >-- (arw[o_assoc]) >>
qby_tac 
‘Pa(x, Tp(phi) o Tp1(psi)) = 
 Pa(p1(A, 1), (Tp(phi) o Tp1(psi) o p2(A, 1))) o
               Pa(id(A), To1(A)) o x’
>-- (irule to_P_eq >> rw[p12_of_Pa] >>
     rw[GSYM o_assoc,p12_of_Pa] >> rw[o_assoc,p12_of_Pa] >>
     once_rw[one_to_one_id] >> rw[idL,idR]) >>
arw[] >> 
qpick_x_assum ‘phi o Pa(x, Tp1(psi)) = Ev(A, 1 + 1) o
               Pa(p1(A, 1), (Tp(phi) o Tp1(psi) o p2(A, 1))) o
               Pa(id(A), To1(A)) o x’
(assume_tac o GSYM) >> arw[] >>
qpick_x_assum ‘h2R o Pa(r, Tp1(psi)) = Pa(x, Tp1(psi))’
(assume_tac o GSYM) >> arw[]
)
(form_goal 
“!R A h:R->A.?hb:Exp(R,1+1)-> Exp(A,1+1). 
!psi:R-> 1+1 x:1->A.
 (Ev(A,1+1) o Pa(p1(A,1),hb o Tp1(psi) o p2(A,1)) o
  Pa(id(A),To1(A)) o x = i2(1,1) <=> 
  ?r:1->R. psi o r = i2(1,1) & h o r = x)”));



val has_components = prove_store("has_components",
e0
(rpt strip_tac >>
 qexistsl_tac [‘p1(A,B) o ab’,‘p2(A,B) o ab’] >>
 rw[GSYM to_P_component])
(form_goal
 “!X A B ab:X->A * B.
  ?a b. ab = Pa(a,b)”));

val Pair_has_comp = has_components |> qspecl [‘1’]


val Thm6_lemma_3_lemma = proved_th $
e0
(rpt strip_tac >>
 irule Ev_eq_eq >>
 irule FUN_EXT >>
 strip_tac >>
 qsspecl_then [‘a’] (x_choosel_then ["x","psi"] assume_tac)
 Pair_has_comp >> arw[] >>
 rw[o_assoc] >>
 first_x_assum (qspecl_then [‘Tp0(psi)’,‘x’] assume_tac) >>
 qsuff_tac
 ‘Pa(p1(A, 1), (hb1 o Tp1(Tp0(psi)) o p2(A, 1))) o
               Pa(id(A), To1(A)) o x = 
 Pa(p1(A, Exp(R, 1+1)), (hb1 o p2(A, Exp(R, 1+1)))) o Pa(x, psi) &
 Pa(p1(A, 1), (hb2 o Tp1(Tp0(psi)) o p2(A, 1))) o
               Pa(id(A), To1(A)) o x = 
 Pa(p1(A, Exp(R, 1+1)), (hb2 o p2(A, Exp(R, 1+1)))) o
               Pa(x, psi)’
 >-- (strip_tac >> fs[]) >>
 rpt strip_tac (* 2 *) >>
 rw[Pa_distr,Pa_eq_eq] >>
 rw[p12_of_Pa,idL,one_to_one_id,o_assoc,Tp1_Tp0_inv,idR])
(form_goal
 “∀hb1:Exp(R,1+1)-> Exp(A,1+1) hb2.
  (!psi:R-> 1+1 x:1->A.
  Ev(A,1+1) o Pa(p1(A,1),hb1 o Tp1(psi) o p2(A,1)) o
  Pa(id(A),To1(A)) o x = 
  Ev(A,1+1) o Pa(p1(A,1),hb2 o Tp1(psi) o p2(A,1)) o
  Pa(id(A),To1(A)) o x) ⇒
 hb1 = hb2”)

val tv_eq = proved_th $
e0
(rpt strip_tac >>
 dimp_tac >> rpt strip_tac >> arw[] >>
 qcases ‘tv1 = i2(1, 1)’ >> fs[] >>
 fs[GSYM i1_xor_i2_1] )
(form_goal “∀tv1 tv2:1->1+1. tv1 = tv2 ⇔ 
 (tv1 = i2(1,1) ⇔ tv2 = i2(1,1))”)


val Thm6_lemma_3_uex = prove_store("Thm6_lemma_3_uex",
 e0
(rpt strip_tac >>
 qsuff_tac
 ‘?hb:Exp(R,1+1)-> Exp(A,1+1). 
!psi:R-> 1+1 x:1->A.
 (Ev(A,1+1) o Pa(p1(A,1),hb o Tp1(psi) o p2(A,1)) o
  Pa(id(A),To1(A)) o x = i2(1,1) <=> 
  ?r:1->R. psi o r = i2(1,1) & h o r = x)’
 >-- (rpt strip_tac >> uex_tac >> qexists_tac ‘hb’ >>
     arw[] >> rpt strip_tac >>
     irule Thm6_lemma_3_lemma >> 
     once_rw[tv_eq] >> arw[]) >>
 rw[Thm6_lemma_3]
)
(form_goal 
“!R A h:R->A.?!hb:Exp(R,1+1)-> Exp(A,1+1). 
!psi:R-> 1+1 x:1->A.
 (Ev(A,1+1) o Pa(p1(A,1),hb o Tp1(psi) o p2(A,1)) o
  Pa(id(A),To1(A)) o x = i2(1,1) <=> 
  ?r:1->R. psi o r = i2(1,1) & h o r = x)”));

val Diag_def = qdefine_fsym("Diag",[‘X’]) ‘Pa(id(X),id(X))’ 
                           |> gen_all |> store_as "Diag_def";

val Diag_Mono = prove_store("Diag_Mono",
e0
(strip_tac >> rw[Mono_def,Diag_def] >> 
 rpt strip_tac >> 
 qby_tac ‘p1(A,A) o Pa(id(A), id(A)) o g = 
          p1(A,A) o Pa(id(A), id(A)) o h’ 
 >-- arw[] >> 
 fs[p1_of_Pa,GSYM o_assoc,idL])
(form_goal
 “!A.Mono(Diag(A))”));

val Eq_def = qdefine_fsym("Eq",[‘X’]) ‘Char(Diag(X))’ 
                         |> gen_all |> store_as "Eq_def"; 

val True_def = qdefine_fsym("True",[‘X’]) ‘TRUE o To1(X)’
|> gen_all |> store_as "True_def";

val False_def = qdefine_fsym("False",[‘X’]) ‘FALSE o To1(X)’
|> gen_all |> store_as "False_def";



val fac_Diag_eq = prove_store("fac_Diag_eq",
e0
(rpt strip_tac >> 
 fs[Pa_distr,Pa_eq_eq,idL] >>
 pop_assum_list (map_every (assume_tac o GSYM)) >> fs[])
(form_goal 
“!A x:1->A y:1->A x0:1->A.Pa(id(A),id(A)) o x0 = Pa(y,x) ==> 
 y = x”)); 

val fac_Diag_eq_iff = prove_store("fac_Diag_eq_iff",
e0
(rpt strip_tac >> 
 dimp_tac >> strip_tac (* 2 *)
 >-- (irule fac_Diag_eq >> qexists_tac ‘a0’  >>
      arw[Pa_distr,p12_of_Pa]) >>
 qexists_tac ‘p1(A,A) o aa’ >> 
 irule to_P_eq >> arw[Pa_distr,p12_of_Pa,GSYM o_assoc,idL])
(form_goal
 “!A aa:1->A * A.
  (?a0:1->A. aa = Pa(id(A),id(A)) o a0) <=>
  p1(A,A) o aa = p2(A,A) o aa”));

val Char_Diag = prove_store("Char_Diag",
e0
(rpt strip_tac >> 
 qspecl_then [‘A’,‘Pa(a1,a2)’] assume_tac fac_Diag_eq_iff>>
 fs[p12_of_Pa] >>
 pop_assum (assume_tac o GSYM) >> arw[] >> 
 qspecl_then [‘A’] assume_tac Diag_Mono >>
 drule Char_def >> pop_assum (assume_tac o GSYM) >>
 arw[Diag_def] >> 
 fconv_tac 
 (rand_fconv no_conv 
 $ basic_once_fconv no_conv (rewr_fconv (eq_sym "ar")))  >>
 rw[])
(form_goal
“!A a1:1->A a2:1->A. Char(Diag(A)) o Pa(a1,a2) = i2(1,1) <=> a1 = a2”));

(*Eq_property same as char_diag_gen*)
val Eq_property = prove_store("Eq_property",
e0
(rpt strip_tac >> rw[Eq_def] >>
 assume_tac TRUE_def >> 
 qspecl_then [‘X’] assume_tac Diag_Mono >>
 drule Char_def >> dimp_tac >> strip_tac (* 2 *)
 >-- (irule FUN_EXT >> strip_tac >> 
     fs[True_def,o_assoc,TRUE_def] >>
     once_rw[one_to_one_id] >> rw[idR,Pa_distr,Char_Diag])>>
 irule FUN_EXT >> strip_tac >> once_rw[GSYM Char_Diag] >>
 qby_tac ‘Char(Diag(X)) o Pa(f, g) o a = True(A) o a’
 >-- arw[GSYM o_assoc] >>
 fs[TRUE_def,True_def,Pa_distr] >>
 rw[o_assoc] >> once_rw[one_to_one_id] >> rw[idR])
(form_goal
“!X A f:A->X g:A->X. 
f = g <=> Eq(X) o Pa(f,g) = True(A)”));

val Thm6_lemma_2 = prove_store("Thm6_lemma_2",
e0
(rpt strip_tac >> 
 rw[Pa_o_split,GSYM o_assoc,Ev_of_Tp] >>
 rw[o_assoc,Pa_distr,idL] >> once_rw[one_to_one_id] >>
 rw[idR,p1_of_Pa] >> rw[Char_Diag])
(form_goal
“!A x:1->A y:1->A. Ev(A,1+1) o 
Pa(p1(A,1),Tp(Char(Diag(A))) o x o p2(A,1))  o Pa(id(A),To1(A)) o y = i2(1,1) <=> y = x”));

val Pa_o_split' = Pa_o_split |> spec_all |> gen_all
                             |> store_as "Pa_o_split'";


val Thm6_g_ev_lemma = prove_store("Thm6_g_ev_lemma",
e0
(rpt strip_tac >> irule Ev_eq_eq >>
 pop_assum (assume_tac o GSYM) >> rw[o_assoc] >>
 qspecl_then [‘R’,‘1’,‘A’,‘a’,‘Exp(R, 1+1)’,
‘Tp((Ev(A, 1 + 1) o
                 Pa(f0 o p1(R, Exp(A, 1 + 1)), p2(R, Exp(A, 1 + 1))))) o
                Tp(Char(Diag(A)))’] assume_tac Pa_o_split' >>
fs[o_assoc] >> rw[Pa_o_split'] >>
rw[GSYM o_assoc,Ev_of_Tp] >> 
rw[o_assoc,Pa_distr,p12_of_Pa] >>
last_x_assum (assume_tac o GSYM) >>
once_arw[] >> rw[Tp1_def,Ev_of_Tp] >>
rw[o_assoc,Pa_distr,p12_of_Pa]  >>
rw[idL] >>
qsuff_tac ‘p2(R, 1) = To1(A) o f0 o p1(R, 1)’
>-- (strip_tac >> arw[]) >>
once_rw[To1_def] >> rw[])
(form_goal 
“!A a:1->A a':1->A R f0:R->A f1:R->A.
!psi:R->1+1.psi = 
Ev(A,1+1) o Pa(p1(A,1),Tp(Char(Diag(A))) o a o p2(A,1)) o 
Pa(id(A),To1(A)) o f0 ==>
Tp(Ev(A,1+1) o Pa(f0 o p1(R,Exp(A,1+1)),p2(R,Exp(A,1+1)))) o Tp(Char(Diag(A))) o a = 
Tp1(psi)”));



val Bar_def = Thm6_lemma_3_uex |> spec_all 
                           |> qsimple_uex_spec "Bar" [‘h’]
                           |> gen_all
                           |> store_as "Bar_def"



val Sing_ex = prove_store("Sing_ex",
e0
(strip_tac >> qexists_tac ‘Tp(Char(Diag(A)))’ >> rw[])
(form_goal “!A.?sg. Tp(Char(Diag(A))) = sg”));


val Sing_def = 
qdefine_fsym("Sing",[‘A’]) ‘Tp(Char(Diag(A)))’
(*|> GSYM *) |> gen_all


(*Thm6_lemma_2 is sg_def*)
val Thm6_g_ev = prove_store("Thm6_g_ev",
e0
(rpt strip_tac >> 
 abbrev_tac 
 “Ev(A,1+1) o Pa(p1(A,1),Sing(A) o a o p2(A,1)) o Pa(id(A),To1(A)) o f0:R->A = psi” >>
 pop_assum (assume_tac o GSYM) >>
 assume_tac Thm6_g_ev_lemma >> fs[GSYM Sing_def] >>
 first_x_assum drule >> 
 qby_tac
 ‘Tp((Ev(A, 1 + 1) o
                 Pa(f0 o p1(R, Exp(A, 1 + 1)), p2(R, Exp(A, 1 + 1))))) o
                Sing(A) o a o p2(A, 1) = 
 (Tp((Ev(A, 1 + 1) o
                 Pa(f0 o p1(R, Exp(A, 1 + 1)), p2(R, Exp(A, 1 + 1))))) o
                Sing(A) o a) o p2(A, 1)’ 
 >-- rw[o_assoc] >>
 last_x_assum (assume_tac o GSYM) >>
 arw[] >>
 qspecl_then [‘A’,‘R’,‘f1’] assume_tac Bar_def >>
 arw[] >>
qsuff_tac ‘!r:1->R. f0 o r = a <=> psi o r = i2(1,1)’
>-- (strip_tac >> arw[]) >>
qpick_x_assum
 ‘Ev(A, 1 + 1) o Pa(p1(A, 1), (Sing(A) o a o p2(A, 1))) o
  Pa(id(A), To1(A)) o f0 = psi’
(assume_tac o GSYM) >>
once_arw[] >> assume_tac Thm6_lemma_2 >>
fs[GSYM Sing_def,o_assoc])
(form_goal 
“!R A f0:R->A f1:R->A a:1->A a':1->A. Ev(A,1+1) o 
Pa(p1(A,1),Bar(f1) o 
Tp(Ev(A,1+1) o Pa(f0 o p1(R,Exp(A,1+1)),p2(R,Exp(A,1+1)))) o 
Sing(A) o a o p2(A,1)) o Pa(id(A),To1(A)) o a' = i2(1,1) <=> ?r:1->R. f0 o r = a & f1 o r = a'”));


val Thm6_g_ev' = prove_store("Thm6_g_ev'",
e0
(rpt strip_tac >> 
 assume_tac Thm6_g_ev >> 
 qby_tac
 ‘Pa(a', id(1)) = Pa(id(A), To1(A)) o a'’
 >-- (rw[Pa_distr] >> once_rw[one_to_one_id] >>
     rw[idL]) >>
 arw[])
(form_goal 
“!R A f0:R->A f1:R->A a':1->A a:1->A. Ev(A,1+1) o 
Pa(p1(A,1),
   Bar(f1) o 
   Tp(Ev(A,1+1) o
      Pa(f0 o p1(R,Exp(A,1+1)), p2(R,Exp(A,1+1)))) o 
   Sing(A) o a o p2(A,1)) o Pa(a',id(1)) = 
i2(1,1) <=>
?r:1->R.f0 o r = a & f1 o r = a'”));


val one_to_two_cases = prove_store("one_to_two_cases",
 e0
(rpt strip_tac >> 
 qspecl_then [‘1’,‘1’,‘f’] strip_assume_tac INC_FAC >>(* 2 *)
 pop_assum mp_tac >> once_rw[one_to_one_id] >> rw[idR] >>
 strip_tac >> arw[])
(form_goal 
“!f:1->1+1. f = i1(1,1) | f = i2(1,1)”));

val one_to_two_eq = prove_store("one_to_two_eq",
e0
(rpt strip_tac >> cases_on “f = i2(1,1)”
 >-- fs[] >>
 fs[] >> 
 qspecl_then [‘f’] strip_assume_tac one_to_two_cases >>
 qspecl_then [‘g’] strip_assume_tac one_to_two_cases >>
 arw[])
(form_goal 
“!f:1->1+1 g:1->1+1. (f = i2(1,1) <=> g = i2(1,1)) ==> f = g”))



val f0g_eq_f1g = prove_store("f0g_eq_f1g",
 e0
(rpt strip_tac >> irule FUN_EXT >> strip_tac >> 
 irule Ev_eq_eq >> irule FUN_EXT >> strip_tac >> 
 irule one_to_two_eq >>
 assume_tac Thm6_g_ev' >>
 qby_tac ‘a' = Pa(p1(A,1) o a',p2(A,1) o a')’ 
 >-- rw[GSYM to_P_component] >>
 pop_assum mp_tac >> once_rw[one_to_one_id] >> strip_tac >>
 once_arw[] >> pop_assum (K all_tac) >>
 fs[o_assoc] >>
 first_assum (qspecl_then [‘R’,‘A’,‘f0’,‘f1’,‘p1(A, 1) o a'’,‘f0 o a’] assume_tac) >> fs[o_assoc]>>
 first_assum (qspecl_then [‘R’,‘A’,‘f0’,‘f1’,‘p1(A, 1) o a'’,‘f1 o a’] assume_tac) >> fs[o_assoc] >> 
 irule Sym_Trans_rel_lemma >> arw[])
(form_goal
“!R A f0:R->A f1:R->A. Sym(f0,f1) & Trans(f0,f1) ==> 
 Bar(f1) o Tp(Ev(A,1+1) o Pa(f0 o p1(R,Exp(A,1+1)), p2(R,Exp(A,1+1)))) o Sing(A) o f0 = 
  Bar(f1) o Tp(Ev(A,1+1) o Pa(f0 o p1(R,Exp(A,1+1)), p2(R,Exp(A,1+1)))) o Sing(A) o f1”));


val Thm6_page29_means_just_that = prove_store
("Thm6_page29_means_just_that",
e0
(rpt strip_tac >> 
 qspecl_then [‘R’,‘A’,‘f0’,‘f1’,‘a'’,‘a0’] 
 (assume_tac o GSYM) Thm6_g_ev' >>
 qspecl_then [‘R’,‘A’,‘f0’,‘f1’,‘a'’,‘a1’] 
 (assume_tac o GSYM) Thm6_g_ev' >>
 once_arw[] >>  pop_assum (K all_tac) >>
 pop_assum (K all_tac) >> 
 fs[GSYM o_assoc])
(form_goal
“!A a0:1->A a1:1->A R f0:R->A f1:R->A.
 Bar(f1) o 
 Tp(Ev(A,1+1) o Pa(f0 o p1(R,Exp(A,1+1)),p2(R,Exp(A,1+1)))) o
 Sing(A) o a0 = 
 Bar(f1) o 
 Tp(Ev(A,1+1) o Pa(f0 o p1(R,Exp(A,1+1)),p2(R,Exp(A,1+1)))) o
 Sing(A) o a1 ==>
 !a':1->A.(?r:1->R. f0 o r = a0 & f1 o r = a') <=>
          (?r:1->R. f0 o r = a1 & f1 o r = a')”));



val compose_with_g_eq_equiv = prove_store
("compose_with_g_eq_equiv",
e0
(rpt strip_tac >>
 drule Thm6_page29_means_just_that >>
 irule equiv_to_same_element >> arw[])
(form_goal
“!A a0:1->A a1:1->A R f0:R->A f1:R->A.
 Bar(f1) o 
 Tp(Ev(A,1+1) o Pa(f0 o p1(R,Exp(A,1+1)),p2(R,Exp(A,1+1)))) o
 Sing(A) o a0 = 
  Bar(f1) o 
 Tp(Ev(A,1+1) o Pa(f0 o p1(R,Exp(A,1+1)),p2(R,Exp(A,1+1)))) o
 Sing(A) o a1 ==>
 Refl(f0,f1) ==>
 ?r:1->R. f0 o r = a0 & f1 o r = a1”));



val Thm6_page29_picture = prove_store(
"Thm6_page29_picture",
e0
(rpt strip_tac >>
 qby_tac ‘Sym(f0, f1) & Trans(f0, f1)’ >-- arw[] >> 
 drule f0g_eq_f1g >> 
 abbrev_tac
 “Bar(f1:R->A) o Tp((Ev(A, 1 + 1) o
                Pa(f0 o p1(R, Exp(A, 1 + 1)), p2(R, Exp(A, 1 + 1))))) o
               Sing(A) = l” >>
 fs[GSYM o_assoc] >>  
 qsuff_tac ‘?u. u o ce = l’
 >-- (strip_tac >> pop_assum (assume_tac o GSYM) >> fs[] >>
      arw[o_assoc]) >>
 irule (iscoEq_def |> iffLR |> strip_all_and_imp 
                      |> conjE2 |> strip_all_and_imp
                      |> uex2ex_rule |> GSYM
                      |> gen_disch_all) >>
 qexistsl_tac [‘R’,‘f0’,‘f1’] >> arw[])
(form_goal
“!R A f0:R->A f1:R->A. Sym(f0,f1) ==> Trans(f0,f1) ==> 
 !cE ce:A->cE. iscoEq(f0,f1,ce) ==>
 !a0:1->A a1:1->A.
 ce o a0 = ce o a1 ==>
  Bar(f1) o 
 Tp(Ev(A,1+1) o Pa(f0 o p1(R,Exp(A,1+1)),p2(R,Exp(A,1+1)))) o
 Sing(A) o a0 = 
  Bar(f1) o 
 Tp(Ev(A,1+1) o Pa(f0 o p1(R,Exp(A,1+1)),p2(R,Exp(A,1+1)))) o
 Sing(A) o a1”));


val Thm6 = prove_store("Thm6",
e0
(rpt strip_tac >> irule Thm6_first_sentence >> 
 qexistsl_tac [‘A’,‘e’,‘f0’,‘f1’,‘cE’,‘ce’] >>
 arw[] >> rpt strip_tac >> irule equiv_to_same_element >>
 arw[] >> irule Thm6_page29_means_just_that >>
 irule Thm6_page29_picture >> arw[] >>
 qexistsl_tac [‘cE’,‘ce’] >> arw[])
(form_goal
“!R A f0:R->A f1:R->A. Mono(Pa(f0,f1)) ==>
 Refl(f0,f1) & Sym(f0,f1) & Trans(f0,f1) ==> 
 !cE ce:A->cE. iscoEq(f0,f1,ce) ==>
 !E e:E->A * A. isEq(ce o p1(A,A),ce o p2(A,A),e) ==>
 areiso(R,E)”));








val Thm6_first_sentence' = prove_store(
"Thm6_first_sentence",
 e0
(rpt strip_tac >> irule prop_2_coro_subo>>
(* qexistsl_tac [‘A * A’,‘Pa(f0,f1)’,‘e’] >> *)
 drule Eqa_Mono >> arw[] >> rpt strip_tac (* 2 *) >--
 (first_x_assum 
 (qspecl_then [‘p1(A,A) o e o y’,‘p2(A,A) o e o y’]
  assume_tac) >>
 drule Eq_equality >>
 fs[GSYM o_assoc] >> qexists_tac ‘r’ >> 
 irule to_P_eq >> arw[GSYM o_assoc,p12_of_Pa]) >>
 irule (isEq_def |> iffLR |> strip_all_and_imp 
                      |> conjE2 |> strip_all_and_imp
                      |> uex2ex_rule 
                      |> gen_disch_all) >>
      qexistsl_tac [‘cE’,‘ce o p1(A, A)’,‘ce o p2(A, A)’] >> arw[] >>
      qby_tac
      ‘(ce o p1(A, A)) o Pa(f0, f1) o x = 
       ce o (p1(A, A) o Pa(f0, f1)) o x &
       (ce o p2(A, A)) o Pa(f0, f1) o x =
       ce o (p2(A, A) o Pa(f0, f1)) o x’
      >-- rw[o_assoc] >> arw[p12_of_Pa] >> 
      drule coEq_equality >> arw[GSYM o_assoc]
 )
(form_goal
“!R A f0:R->A f1. Refl(f0,f1) & Sym(f0,f1) & Trans(f0,f1) ==> Mono(Pa(f0,f1)) ==> 
!cE ce:A->cE.iscoEq(f0,f1,ce) ==>
(!a0:1->A a1:1->A. ce o a0 = ce o a1 ==> ?r:1->R. f0 o r = a0 & f1 o r = a1) ==> !E e:E->A * A. isEq(ce o p1(A,A),ce o p2(A,A),e) ==> 
 ?h1 h2. e o h1 = Pa(f0,f1) & Pa(f0,f1) o h2 = e & h1 o h2 = id(E) & h2 o h1 = id(R)”));



val Thm6' = prove_store("Thm6",
e0
(rpt strip_tac >> irule Thm6_first_sentence' >> arw[] >>
 qexistsl_tac [‘cE’,‘ce’] >>
 arw[] >> rpt strip_tac >> irule equiv_to_same_element >>
 arw[] >> irule Thm6_page29_means_just_that >>
 irule Thm6_page29_picture >> arw[] >>
 qexistsl_tac [‘cE’,‘ce’] >> arw[])
(form_goal
“!R A f0:R->A f1:R->A. Mono(Pa(f0,f1)) ==>
 Refl(f0,f1) & Sym(f0,f1) & Trans(f0,f1) ==> 
 !cE ce:A->cE. iscoEq(f0,f1,ce) ==>
 !E e:E->A * A. isEq(ce o p1(A,A),ce o p2(A,A),e) ==>
 ?h1 h2. e o h1 = Pa(f0,f1) & Pa(f0,f1) o h2 = e & h1 o h2 = id(E) & h2 o h1 = id(R)”));


val iso_isEq_isEq = prove_store("iso_isEq_isEq",
e0
(rpt strip_tac >> rw[isEq_def] >> 
 drule $ iffLR isEq_def >> 
 qby_tac
 ‘f o e o h1 = g o e o h1’ >-- arw[GSYM o_assoc] >>
 rfs[] >> rpt strip_tac >> first_x_assum drule >>
 pop_assum (assume_tac o uex_expand) >>
 pop_assum strip_assume_tac >> uex_tac >>
 qexists_tac ‘h2 o a0’ >>
 arw[GSYM o_assoc] >> rpt strip_tac >>
 qby_tac 
 ‘a = e o h1 o a0'’
 >-- arw[GSYM o_assoc] >>
 first_x_assum drule >> arw[] >>
 pop_assum (assume_tac o GSYM) >> arw[GSYM o_assoc,idL])
(form_goal
 “!A B f:A->B g:A->B E e:E->A. isEq(f,g,e) ==>
  !E' e':E'->A h1:E' ->E h2:E ->E'. e o h1 = e' & 
 e' o h2 = e & h1 o h2 = id(E) & h2 o h1 = id(E') ==>
 isEq(f,g,e')”));

val Thm6_isEq = prove_store("Thm6_isEq",
e0
(rpt strip_tac >> drule Thm6' >>
 rfs[] >> first_x_assum drule >>
 qsspecl_then [‘ce o p1(A, A)’,‘ce o p2(A, A)’] 
 strip_assume_tac isEq_ex >>
 first_x_assum drule >>
 pop_assum strip_assume_tac >>
 drule iso_isEq_isEq >> first_x_assum irule >>
 qexistsl_tac [‘h1’,‘h2’] >> arw[])
(form_goal
 “!R A f0:R->A f1:R->A. Mono(Pa(f0,f1)) ==>
 Refl(f0,f1) & Sym(f0,f1) & Trans(f0,f1) ==> 
 !cE ce:A->cE. iscoEq(f0,f1,ce) ==>
 isEq(ce o p1(A,A),ce o p2(A,A),Pa(f0,f1))”));



val Pb_fac_iff = prove_store("Pb_fac_iff",
e0
(rpt strip_tac >> drule $ iffLR isPb_def >>
 pop_assum strip_assume_tac >>
 dimp_tac >> strip_tac >--
 (pop_assum mp_tac >> pop_assum (assume_tac o GSYM) >>
 strip_tac >> pop_assum (assume_tac o GSYM) >>
 arw[GSYM o_assoc]) >>
 first_x_assum drule >> pop_assum strip_assume_tac >>
 pop_assum (strip_assume_tac o uex_expand) >>
 qexists_tac ‘a’ >> arw[])
(form_goal 
“!X Z f:X->Z Y g:Y->Z P p:P->X q.
 isPb(f,g,p,q) ==>
 !A u:A->X v:A->Y. 
 (?a:A->P. p o a = u & q o a = v) <=> f o u = g o v”));



val Pb_fac_iff_1 = prove_store("Pb_fac_iff_1",
e0
(rpt strip_tac >> drule Pb_fac_iff >>
 first_x_assum 
 (qspecl_then [‘1’,‘u’,‘id(1)’] assume_tac) >>
 fs[idR] >> pop_assum (assume_tac o GSYM) >>
 arw[] >> dimp_tac >> strip_tac (* 2 *)
 >-- (qexists_tac ‘a’ >> arw[] >> rw[one_to_one_id]) >>
 qexists_tac ‘a’ >> arw[])
(form_goal 
“!X Z f:X->Z g:1->Z P p0:P->X q.
 isPb(f,g,p0,q) ==>
 !u:1->X. 
 (?a:1->P. p0 o a = u) <=> f o u = g”));



val Pb_reorder = prove_store("Pb_reorder",
e0
(rw[isPb_def] >> rpt strip_tac 
 >-- (pop_assum (K all_tac) >> once_arw[] >> rw[]) >>
 first_x_assum (qspecl_then [‘A’,‘v’,‘u’] assume_tac) >>
 qpick_x_assum ‘g:Y->Z o u:A->Y = f:X->Z o v’
 (assume_tac o GSYM) >>
 first_x_assum drule >> pop_assum strip_assume_tac >>
 uex_tac >>
 pop_assum (strip_assume_tac o uex_expand) >>
 qexists_tac ‘a’ >> strip_tac >> arw[] >>
 rpt strip_tac >> first_x_assum irule >> arw[]
)
(form_goal
“!X Z f:X->Z Y g:Y->Z P p0:P->X q0:P->Y.isPb(f,g,p0,q0) ==>
 isPb(g,f,q0,p0)”));


val pb_fac_exists' = proved_th $
e0
(rpt strip_tac >> 
assume_tac Pb_fac_iff >> 
 first_x_assum $ irule o iffRL >>
 qexistsl_tac [‘Z’,‘f’,‘g’] >> arw[])
(form_goal “!X Z f:X->Z Y g:Y->Z Pb p:Pb->X q:Pb->Y.isPb(f:X->Z,g:Y->Z,p,q) ==> 
 !A u v. f o u = g o v ==> ?a:A->Pb. p o a = u & q o a = v”);


val char_pb = proved_th $
e0
(rpt strip_tac >> irule prop_2_coro_subo >> arw[]>>
 drule Pb_Mono_Mono >> 
 qspecl_then [‘1+1’,‘i2(1,1)’] assume_tac from_one_Mono >>
 first_x_assum drule >> arw[] >>
 rpt strip_tac (* 2 *) >--
 (rev_drule Char_def >> 
 drule $ iffLR isPb_def  >> pop_assum strip_assume_tac >> arw[] >>
 qby_tac ‘Char(a) o pb1 o y  = i2(1,1) o pb2 o y’
 >-- (rw[GSYM o_assoc] >> arw[]) >>
 pop_assum mp_tac >> once_rw[one_to_one_id] >> rw[idR]) >>
 qby_tac
  ‘?y:1->Pb. pb1:Pb->X o y = a:A->X o x:1->A & pb2:Pb->1 o y = id(1)’
  >-- (drule pb_fac_exists' >>
  first_x_assum (qspecl_then [‘1’,‘a o x’,‘id(1)’] assume_tac) >>
  rev_drule Char_def >> first_x_assum (qspecl_then [‘a o x’] assume_tac) >>
  qsuff_tac ‘Char(a) o a o x = i2(1,1)’
  >-- (strip_tac >> fs[idR]  >> qexistsl_tac [‘a'’] >> arw[]) >>
  pop_assum (assume_tac o GSYM) >> arw[] >>
  qexistsl_tac [‘x’] >> arw[]) >>
  pop_assum strip_assume_tac >> qexistsl_tac [‘y’] >> arw[])
(form_goal
“!A X a.Mono(a:A->X) ==> 
 !Pb pb1 pb2. isPb(Char(a),i2(1,1),pb1,pb2) ==> 
    ?h1 h2.pb1 o h1 = a & a o h2 = pb1 & h1 o h2 = id(Pb) & h2 o h1 = id(A)”);

val char_square = proved_th $
e0
(rpt strip_tac >> irule FUN_EXT >> rpt strip_tac >> 
 drule Char_def >>
 first_x_assum (qspecl_then [‘a o a'’] assume_tac) >> rw[o_assoc] >> 
 once_rw[one_to_one_id] >> rw[idR] >> 
 pop_assum (assume_tac o GSYM) >>
 arw[] >> qexistsl_tac [‘a'’] >> rw[])
(form_goal
“!A X a:A->X. Mono(a) ==> Char(a) o a = i2(1,1) o To1(A)”);

val Pb_ex = isPb_ex

val char_is_pb = proved_th $
e0
(rpt strip_tac >> drule char_pb >> 
 qspecl_then [‘X’,‘1+1’,‘Char(a)’,‘1’,‘i2(1,1)’] assume_tac Pb_ex >>
 pop_assum (x_choosel_then ["Pb","pb1","pb2"] assume_tac) >>
 first_x_assum drule  >> pop_assum strip_assume_tac >> 
 drule (isPb_def |> iffLR) >> pop_assum strip_assume_tac >>
 first_x_assum (qspecl_then [‘A’,‘a’,‘To1(A)’] assume_tac) >>
 rw[isPb_def] >>
 qby_tac ‘Char(a) o a = i2(1,1) o To1(A)’
 >-- (qby_tac ‘Char(a) o pb1 o h1 = i2(1,1) o pb2 o h1’
      >-- (arw[GSYM o_assoc]) >> rfs[] >> 
      pop_assum mp_tac >> once_rw[To1_def] >> rw[]) >>
 arw[] >> rpt strip_tac >> uex_tac >>
 (*here the goal is ?(a' : A' -> A). !(a' : A' -> A). a o a'# = u & to1(A, 1) o a'# = v <=>
                 a'# = a'# ... same name*) 
 suffices_tac (rapf "?a':A'->A. a:A->X o a' = u")
 >-- (strip_tac >> qexistsl_tac [‘a'’] >> strip_tac (* 2 *) >--
      (arw[] >> once_rw[To1_def] >> rw[]) >>
      rpt strip_tac >> irule $ iffLR Mono_def >>
      qexistsl_tac [‘X’,‘a’] >> arw[]) >>
 drule $ iffLR isPb_def >> pop_assum strip_assume_tac >>
 last_x_assum drule >> pop_assum (K all_tac) >>
 first_x_assum (qspecl_then [‘A'’,‘u’,‘v’] assume_tac)>>
 first_x_assum drule >> pop_assum (assume_tac o uex_expand) >>
 pop_assum strip_assume_tac >>
 qexistsl_tac [‘h2 o a'’] >>
 first_x_assum (qspecl_then [‘a'’] assume_tac) >> fs[] >>
 arw[GSYM o_assoc])
(form_goal 
“!A X a.Mono(a:A->X) ==> isPb(Char(a),i2(1,1),a,To1(A))”);





val inc_Mono = prove_store("inc_Mono",
e0
(rpt strip_tac (* 2 *) >--
 (rw[Mono_def] >> rpt strip_tac >>
 irule FUN_EXT >> strip_tac >>
 drule $ iffLR iscoPr_def >>
 first_x_assum (qsspecl_then [‘id(A)’,‘g o a o To1(B)’] assume_tac) >>
 pop_assum (strip_assume_tac o uex_expand) >>
 qby_tac ‘fg o iA o g = fg o iA o h’
 >-- arw[] >> pop_assum mp_tac >>
 arw[GSYM o_assoc,idL] >> strip_tac >> arw[]) >>
 rw[Mono_def] >> rpt strip_tac >>
 irule FUN_EXT >> strip_tac >>
 drule $ iffLR iscoPr_def >>
 first_x_assum (qsspecl_then [‘g o a o To1(A)’,‘id(B)’] assume_tac) >>
 pop_assum (strip_assume_tac o uex_expand) >>
 qby_tac ‘fg o iB o g = fg o iB o h’
 >-- arw[] >> pop_assum mp_tac >>
 arw[GSYM o_assoc,idL] >> strip_tac >> arw[])
(form_goal 
“!A B AB iA:A->AB iB:B->AB. iscoPr(iA,iB) ==>
 Mono(iA) & Mono(iB)”));


val Char_Diag' = Char_Diag |> rewr_rule[GSYM TRUE_def]
                           |> store_as "Char_Diag'";






val Iso_Epi = prove_store("Iso_Epi",
e0
(rw[Iso_def,Epi_def] >> rpt strip_tac >>
 qsuff_tac ‘h o f o f' = g o f o f'’ 
 >-- (arw[idR] >> strip_tac >> arw[]) >> 
 arw[GSYM o_assoc])
(form_goal “!A B f:A->B. Iso(f) ==> Epi(f)”));



val TRUE2FALSE = prove_store("TRUE2FALSE",
e0
(strip_tac >> rw[TRUE_def,FALSE_def,i1_xor_i2_1])
(form_goal
“!f. ~(f = TRUE) <=> f = FALSE”));




(*IMP is the subobject consists of
  (0,1) (1,1) (0,0), which is complement f (1,0)
 complement obtained from Thm5*)


val TRUE_xor_FALSE = i1_xor_i2_1 |> rewr_rule[GSYM FALSE_def,GSYM TRUE_def]
                                |> store_as "TRUE_xor_FALSE";



val NEG_ex = prove_store("NEG_ex",
e0
(qexists_tac ‘coPa(i2(1,1),i1(1,1))’ >>
 strip_tac >>  
 qspecl_then [‘pred’] assume_tac TRUE_xor_FALSE >>
 qcases ‘pred = TRUE’ 
 >-- (fs[GSYM TRUE_xor_FALSE] >> rw[TRUE_def,FALSE_def,i12_of_coPa] >>
      lflip_tac >> rw[]) >>
 fs[] >> rw[FALSE_def,TRUE_def,i12_of_coPa]
)
(form_goal
“?neg: 1+1 -> 1+1.
 !pred:1->1+1. neg o pred = TRUE <=> pred = FALSE”));


val NEG_uex = prove_store("NEG_uex",
e0
(qsuff_tac
 ‘?neg: 1+1 -> 1+1.
 !pred:1->1+1. neg o pred = TRUE <=> pred = FALSE’
 >-- (strip_tac>> uex_tac >>
     qexists_tac ‘neg’ >> arw[] >>
     rpt strip_tac >>
     irule FUN_EXT >> once_rw[tv_eq] >> 
     arw[GSYM TRUE_def]) >>
 rw[NEG_ex])
(form_goal
“?!neg: 1+1 -> 1+1.
 !pred:1->1+1. neg o pred = TRUE <=> pred = FALSE”));


val NEG_def = NEG_uex |> qsimple_uex_spec "NEG" [] |> store_as "NEG_def";


val NEG_def' = prove_store("NEG_def'",
e0
(rw[NEG_def,TRUE2FALSE])
(form_goal “!pred. NEG o pred = TRUE <=> ~(pred = TRUE)”));



val NEG_alt = prove_store("NEG_alt",
e0
(strip_tac >> rw[TRUE_xor_FALSE,NEG_def'])
(form_goal “!p. NEG o p = FALSE <=> p = TRUE”));



val TRUE_ne_FALSE = i1_ne_i2_1 |> rewr_rule[GSYM FALSE_def,GSYM TRUE_def]
                               |> store_as "TRUE_ne_FALSE";

val IMP_ex = prove_store("IMP_ex",
e0
(qsuff_tac
 ‘?imp:(1+1) * (1 + 1)->1+1.
   imp o Pa(TRUE,TRUE) = TRUE & 
   imp o Pa(FALSE,TRUE) = TRUE & 
   imp o Pa(FALSE,FALSE) = TRUE &
   imp o Pa(TRUE,FALSE) = FALSE’ 
 >-- (strip_tac >> qexists_tac ‘imp’ >> rpt strip_tac >>
     qspecl_then [‘p1’] strip_assume_tac TRUE_xor_FALSE >>
     qspecl_then [‘p2’] strip_assume_tac TRUE_xor_FALSE >>
     qcases ‘p1 = TRUE’ >> qcases ‘p2 = TRUE’ >> fs[TRUE_ne_FALSE]) >>
 qexists_tac ‘NEG o Char(Pa(TRUE,FALSE))’ >> 
 rw[NEG_def',o_assoc] >> rw[NEG_alt] >>
 qsspecl_then [‘Pa(TRUE,FALSE)’] assume_tac from_one_Mono >>
 drule Char_def >> fs[GSYM TRUE_def] >> 
 pop_assum (assume_tac o GSYM) >> arw[] >>rw[one_to_one_id,idR] >>
 rw[Pa_eq_eq,TRUE_ne_FALSE] >> rw[GSYM TRUE_ne_FALSE] >>
 rpt strip_tac (* 4 *)
 >-- (ccontra_tac >> pop_assum strip_assume_tac)
 >-- (ccontra_tac >> pop_assum strip_assume_tac)
 >-- (ccontra_tac >> pop_assum strip_assume_tac) >>
 qexists_tac ‘id(1)’ >> rw[]) 
(form_goal 
“?imp:(1+1) * (1 + 1)->1+1. 
 !p1 p2. imp o Pa(p1,p2) = TRUE <=> (p1 = TRUE ==> p2 = TRUE)”));



val IMP_uex = prove_store("IMP_uex",
e0
(qsuff_tac
 ‘?imp:(1+1) * (1 + 1)->1+1. 
 !p1 p2. imp o Pa(p1,p2) = TRUE <=> (p1 = TRUE ==> p2 = TRUE)’
 >-- (strip_tac >>
     uex_tac >> qexists_tac ‘imp’ >> arw[] >>
     rpt strip_tac >>
     irule FUN_EXT >> once_rw[tv_eq] >>
     rw[GSYM TRUE_def] >> strip_tac >>
     qsspecl_then [‘a’] strip_assume_tac Pair_has_comp >>
     arw[]) >>
 rw[IMP_ex]) 
(form_goal 
“?!imp:(1+1) * (1 + 1)->1+1. 
 !p1 p2. imp o Pa(p1,p2) = TRUE <=> (p1 = TRUE ==> p2 = TRUE)”));


val IMP_def = 
 IMP_uex |> qsimple_uex_spec "IMP" [] |> store_as "IMP_def";


val CONJ_ex = prove_store("CONJ_ex",
e0
(rpt strip_tac >> 
 qexists_tac ‘Char(Pa(TRUE,TRUE))’ >> 
 qby_tac ‘Mono(Pa(TRUE,TRUE))’ >-- rw[from_one_Mono] >> 
 drule Char_def >> fs[TRUE_def] >> pop_assum (assume_tac o GSYM) >>
 once_arw[] >> rw[Pa_distr,Pa_eq_eq] >> once_rw[one_to_one_id] >> rw[idR] >>
 rpt strip_tac >> dimp_tac >> rpt strip_tac (*  3 *)
 >-- (pop_assum (K all_tac) >> arw[])  
 >-- (once_arw[] >> rw[]) >>
 qexists_tac ‘id(1)’ >> arw[])
(form_goal 
“?conj:(1+1) * (1+1)->1+1. 
 !p1 p2. conj o Pa(p1,p2) = TRUE <=>
 (p1 = TRUE & p2 = TRUE)”));


val CONJ_uex = prove_store("CONJ_uex",
e0
(qsuff_tac
 ‘?conj:(1+1) * (1+1)->1+1. 
 !p1 p2. conj o Pa(p1,p2) = TRUE <=>
 (p1 = TRUE & p2 = TRUE)’
 >--  (strip_tac >>
     uex_tac >> qexists_tac ‘conj’ >> arw[] >>
     rpt strip_tac >>
     irule FUN_EXT >> once_rw[tv_eq] >>
     rw[GSYM TRUE_def] >> strip_tac >>
     qsspecl_then [‘a’] strip_assume_tac Pair_has_comp >>
     arw[]) >>
 rw[CONJ_ex])
(form_goal 
“?!conj:(1+1) * (1+1)->1+1. 
 !p1 p2. conj o Pa(p1,p2) = TRUE <=>
 (p1 = TRUE & p2 = TRUE)”));



val CONJ_def = CONJ_uex |> qsimple_uex_spec "CONJ" [] |> store_as "CONJ_def";

val IFF_ex = prove_store("IFF_ex",
e0
(rpt strip_tac >>
 qexists_tac ‘CONJ o Pa(IMP,IMP o Pa(p2(1+1,1+1),p1(1+1,1+1)))’ >> 
 rpt strip_tac >> rw[o_assoc,Pa_distr,CONJ_def] >> 
 rw[IMP_def,p12_of_Pa] >> dimp_tac >> rpt strip_tac (*  3*)
 >-- (dimp_tac >> strip_tac (* 2 *) >> first_x_assum drule >> arw[]) 
 >-- fs[] >-- fs[])
(form_goal 
“?iff:(1+1) * (1+1)->1+1. 
 !p1 p2. iff o Pa(p1,p2) = TRUE <=>
 (p1 = TRUE <=> p2 = TRUE)”));


val IFF_uex = prove_store("IFF_uex",
e0
(qsuff_tac
 ‘?iff:(1+1) * (1+1)->1+1. 
 !p1 p2. iff o Pa(p1,p2) = TRUE <=>
 (p1 = TRUE <=> p2 = TRUE)’
  >-- (strip_tac >>
     uex_tac >> qexists_tac ‘iff’ >> arw[] >>
     rpt strip_tac >>
     irule FUN_EXT >> once_rw[tv_eq] >>
     rw[GSYM TRUE_def] >> strip_tac >>
     qsspecl_then [‘a’] strip_assume_tac Pair_has_comp >>
     arw[]) >>
 rw[IFF_ex])
(form_goal 
“?!iff:(1+1) * (1+1)->1+1. 
 !p1 p2. iff o Pa(p1,p2) = TRUE <=>
 (p1 = TRUE <=> p2 = TRUE)”));

val IFF_def = IFF_uex |> qsimple_uex_spec "IFF" [] |> store_as "IFF_def";

val True1TRUE = prove_store("True1TRUE",
e0
(rw[True_def] >> once_rw[one_to_one_id] >> rw[idR])
(form_goal “True(1) = TRUE”));



val DISJ_ex = prove_store("DISJ_ex",
e0
(qsuff_tac
 ‘?disj:(1+1) * (1 + 1)->1+1.
   disj o Pa(TRUE,TRUE) = TRUE & 
   disj o Pa(FALSE,TRUE) = TRUE & 
   disj o Pa(FALSE,FALSE) = FALSE &
   disj o Pa(TRUE,FALSE) = TRUE’ 
 >-- (strip_tac >> qexists_tac ‘disj’ >> rpt strip_tac >>
     qspecl_then [‘p1’] strip_assume_tac TRUE_xor_FALSE >>
     qspecl_then [‘p2’] strip_assume_tac TRUE_xor_FALSE >>
     qcases ‘p1 = TRUE’ >> qcases ‘p2 = TRUE’ >> fs[TRUE_ne_FALSE]) >>
 qexists_tac ‘NEG o Char(Pa(FALSE,FALSE))’ >> 
 rw[NEG_def',o_assoc] >> rw[NEG_alt] >>
 qsspecl_then [‘Pa(FALSE,FALSE)’] assume_tac from_one_Mono >>
 drule Char_def >> fs[GSYM TRUE_def] >> 
 pop_assum (assume_tac o GSYM) >> arw[] >>rw[one_to_one_id,idR] >>
 rw[Pa_eq_eq,TRUE_ne_FALSE] >> rw[GSYM TRUE_ne_FALSE] >>
 rpt strip_tac (* 4 *)
 >-- (ccontra_tac >> pop_assum strip_assume_tac)
 >-- (ccontra_tac >> pop_assum strip_assume_tac)
 >-- (qexists_tac ‘id(1)’ >> rw[])
 >-- (ccontra_tac >> pop_assum strip_assume_tac)
 )
(form_goal
“?or:(1+1) * (1 +1)->1+1. 
 !p1:1->1+1 p2. or o Pa(p1,p2) = TRUE <=> 
  (p1 = TRUE | p2 = TRUE)”));



val DISJ_uex = prove_store("DISJ_uex",
e0
(qsuff_tac
 ‘?or:(1+1) * (1 +1)->1+1. 
 !p1:1->1+1 p2. or o Pa(p1,p2) = TRUE <=> 
  (p1 = TRUE | p2 = TRUE)’
 >-- (strip_tac >>
     uex_tac >> qexists_tac ‘or’ >> arw[] >>
     rpt strip_tac >>
     irule FUN_EXT >> once_rw[tv_eq] >>
     rw[GSYM TRUE_def] >> strip_tac >>
     qsspecl_then [‘a’] strip_assume_tac Pair_has_comp >>
     arw[]) >>
 rw[DISJ_ex])
(form_goal
“?!or:(1+1) * (1 +1)->1+1. 
 !p1:1->1+1 p2. or o Pa(p1,p2) = TRUE <=> 
  (p1 = TRUE | p2 = TRUE)”));


val DISJ_def = DISJ_uex |> qsimple_uex_spec "DISJ" [] |> store_as "DISJ_def";


val All_ex = prove_store("All_ex",
e0
(strip_tac >> qexists_tac ‘Char(Tp1(True(X)))’ >>
 qby_tac ‘Mono(Tp1(True(X)))’ >-- rw[from_one_Mono] >> 
 drule Char_def >> pop_assum (assume_tac o GSYM) >>
 fs[GSYM TRUE_def] >> once_rw[one_to_one_id] >> rw[idR] >> rpt strip_tac >>
 qby_tac
 ‘(?x0:1->1. Tp1(True(X)) = Tp(pxy) o y) <=> 
  Tp1(True(X)) = Tp(pxy) o y’ 
 >-- (dimp_tac >> strip_tac >> qexists_tac ‘id(1)’ >> arw[]) >>
 arw[] >> dimp_tac >> rpt strip_tac (* 2 *) >--
 (qby_tac ‘Ev(X,1+1) o Pa(p1(X,1),Tp1(True(X)) o p2(X,1)) =
          Ev(X,1+1) o Pa(p1(X,1),Tp(pxy) o y o p2(X,1))’
 >-- arw[GSYM o_assoc] >>
 fs[Tp1_def,Ev_of_Tp,True_def] >>
 fs[Pa_o_split,GSYM o_assoc,Ev_of_Tp] >> fs[o_assoc] >> 
 qby_tac
 ‘(TRUE o To1(X) o p1(X, 1)) o Pa(x,id(1)) =
  (pxy o Pa(p1(X, 1), y o p2(X, 1))) o Pa(x,id(1))’ 
 >-- arw[] >> fs[o_assoc,Pa_distr,p12_of_Pa,idR] >>
 pop_assum  mp_tac >> once_rw[one_to_one_id] >> rw[idR] >> 
 strip_tac >> arw[]) >>
 flip_tac >> rw[Tp1_def] >> irule is_Tp >>
 rw[o_assoc,Pa_o_split] >> rw[GSYM o_assoc,Ev_of_Tp] >>
 irule FUN_EXT >> strip_tac >> rw[o_assoc,Pa_distr] >>
 once_rw[one_to_one_id] >> rw[idR] >> arw[] >>
 rw[True_def] >> rw[o_assoc] >> once_rw[one_to_one_id] >>
 rw[idR])
(form_goal
“!X.?Uq:Exp(X,1+1) -> 1+1. 
 !Y pxy:X * Y-> 1+1 y:1->Y.
 (Uq o Tp(pxy) o y = TRUE  <=> 
  !x:1->X. pxy o Pa(x,y) = TRUE)”));


val All_uex_lemma = proved_th $
e0
(rpt strip_tac >> irule FUN_EXT >>
 strip_tac >>
 once_rw[tv_eq] >> rw[GSYM TRUE_def] >>
 first_x_assum (qspecl_then [‘1’,‘Tp0(a) o p1(X,1)’,‘id(1)’] assume_tac) >>
 fs[GSYM Tp1_def,Tp1_Tp0_inv,idR])
(form_goal
 “∀X Uq1 Uq2:Exp(X,1+1) ->1+1.
  (!Y pxy:X * Y-> 1+1 y:1->Y.
  Uq1 o Tp(pxy) o y = TRUE <=>
  Uq2 o Tp(pxy) o y = TRUE) ⇒ Uq1 = Uq2 ”)



val All_uex = prove_store("All_uex",
e0
(strip_tac >>
 qsuff_tac
 ‘?Uq:Exp(X,1+1) -> 1+1. 
 !Y pxy:X * Y-> 1+1 y:1->Y.
 (Uq o Tp(pxy) o y = TRUE  <=> 
  !x:1->X. pxy o Pa(x,y) = TRUE)’
 >-- (strip_tac >> uex_tac >>
     qexists_tac ‘Uq’ >> arw[] >>
     rpt strip_tac >>
     irule All_uex_lemma >> arw[]) >>
 rw[All_ex])
(form_goal
“!X.?!Uq:Exp(X,1+1) -> 1+1. 
 !Y pxy:X * Y-> 1+1 y:1->Y.
 (Uq o Tp(pxy) o y = TRUE  <=> 
  !x:1->X. pxy o Pa(x,y) = TRUE)”));
 
val All_def = All_uex |> spec_all 
                     |> qsimple_uex_spec "All" [‘X’]
                     |> gen_all
                     |> store_as "All_def";




val pxy_true = prove_store("pxy_true",
e0
(rpt strip_tac >> dimp_tac >> rpt strip_tac (* 2 *) >--
 (arw[o_assoc,True_def] >> once_rw[one_to_one_id] >> 
 rw[idR]) >>
 irule FUN_EXT >> strip_tac >> once_rw[to_P_component] >>
 arw[True_def] >> rw[o_assoc] >> 
 once_rw[one_to_one_id] >> rw[idR])
(form_goal
“!X Y pred:X * Y -> 1+1.pred = True(X * Y) <=> 
    !x:1->X y:1->Y. pred o Pa(x,y) = TRUE”));


 
val Exq_ex = prove_store("Exq_ex",
e0
(strip_tac >> 
 qexists_tac ‘NEG o All(X) o Tp(NEG o Ev(X,1+1))’ >>
 rpt strip_tac >>
 rw[o_assoc,NEG_def] >>
 qby_tac
 ‘Tp(NEG o Ev(X,1+1)) o Tp(pxy) = Tp(NEG o pxy)’ 
 >-- (irule is_Tp >> rw[o_assoc,Pa_o_split] >> rw[GSYM o_assoc,Ev_of_Tp] >>
      rw[o_assoc,Ev_of_Tp]) >>
arw[TRUE_xor_FALSE,All_def] >> rw[o_assoc,NEG_def,Ev_of_Tp_el] >>
dimp_tac >> strip_tac (* 2 *) >--
(ccontra_tac >> 
 qsuff_tac ‘!x:1->X. pxy o Pa(x,y) = FALSE’ >-- arw[]>>
 strip_tac >>
 qpick_x_assum ‘~(!x:1->X. pxy o Pa(x,y) = FALSE)’ (K all_tac) >>
 rw[TRUE_xor_FALSE] >> ccontra_tac >>
 qsuff_tac ‘?x:1->X. pxy o Pa(x,y) = TRUE’ >-- arw[] >>
 qexists_tac ‘x’ >> arw[]) >>
ccontra_tac >>
first_x_assum (qspecl_then [‘x’] assume_tac) >> fs[TRUE_ne_FALSE]
)
(form_goal
“!X.?Exq:Exp(X,1+1) -> 1+1. 
 !Y pxy:X * Y->1+1 y:1->Y. 
 (Exq o Tp(pxy) o y = TRUE  <=> 
  ?x:1->X. pxy o Pa(x,y) = TRUE)”));


val Exq_uex = prove_store("Exq_uex",
e0
(strip_tac >>
 qsuff_tac
 ‘?Exq:Exp(X,1+1) -> 1+1. 
 !Y pxy:X * Y->1+1 y:1->Y. 
 (Exq o Tp(pxy) o y = TRUE  <=> 
  ?x:1->X. pxy o Pa(x,y) = TRUE)’
 >-- (strip_tac >> uex_tac >> qexists_tac ‘Exq’ >>
     arw[] >> rpt strip_tac >>
     irule All_uex_lemma >> arw[]) >>
 rw[Exq_ex])
(form_goal
“!X.?!Exq:Exp(X,1+1) -> 1+1. 
 !Y pxy:X * Y->1+1 y:1->Y. 
 (Exq o Tp(pxy) o y = TRUE  <=> 
  ?x:1->X. pxy o Pa(x,y) = TRUE)”));

val Ex_def = Exq_uex |> spec_all |> qsimple_uex_spec "Ex" [‘X’] |> gen_all
                    |> store_as "Ex_def"


val Eq_property_TRUE = prove_store("Eq_property_TRUE",
e0
(rpt strip_tac >> rw[GSYM True1TRUE] >> rw[GSYM Eq_property])
(form_goal
 “!X p1 p2.Eq(X) o Pa(p1,p2) = TRUE <=> p1 = p2”));

(*better have p1 p2 p3*)
val E1_ex = prove_store("E1_ex",
e0
(strip_tac >>
 abbrev_tac
 “IMP o 
    Pa(CONJ o Pa(Ev(X,1+1) o Pa(p1(X,X * Exp(X,1+1)), p2(X,Exp(X,1+1)) o p2(X,X * Exp(X,1+1))),
                 Ev(X,1+1) o Pa(p1(X,Exp(X,1+1)) o p2(X,X * Exp(X,1+1)),p2(X,Exp(X,1+1)) o p2(X,X * Exp(X,1+1)))),
      Eq(X) o 
      Pa(p1(X,X * Exp(X,1+1)), p1(X,Exp(X,1+1)) o p2(X,X * Exp(X,1+1)))) = p0” >>
 qexists_tac 
 ‘CONJ o
  Pa(Ex(X),All(X) o Tp(All(X) o Tp(p0)))’ >> rpt strip_tac >>
  rw[o_assoc,Pa_distr,CONJ_def] >> rw[All_def] >> rw[o_assoc,All_def] >>
 rw[Ex_def] >> 
 pop_assum (assume_tac o GSYM) >> once_arw[] >>
 rw[o_assoc,Pa_distr,IMP_def] >> once_rw[CONJ_def] >>
 rw[p12_of_Pa] >> once_rw[Eq_property_TRUE] >>
 rw[Ev_of_Tp_el] >> dimp_tac >> strip_tac (* 2 *)
 >-- (qexists_tac ‘x’ >> arw[] >> rpt strip_tac >> first_x_assum irule >> arw[]) >>
 strip_tac >-- (qexists_tac ‘x’ >> arw[]) >>
 rpt strip_tac >> 
 qsuff_tac ‘x'' = x  & x' = x’ >-- (strip_tac >> arw[]) >> strip_tac >>
 first_x_assum irule >> arw[]
 )
(form_goal
“!X.?Exq: Exp(X,1+1) -> 1+1. 
 !Y pxy:X * Y->1+1 y:1->Y. 
 (Exq o Tp(pxy) o y = TRUE  <=> 
  ?x:1->X. pxy o Pa(x,y) = TRUE & 
  !x0:1->X. pxy o Pa(x0,y) = TRUE ==> x0 = x)”));



val E1_uex = prove_store("E1_uex",
e0
(strip_tac >> 
 qsuff_tac
 ‘?Exq: Exp(X,1+1) -> 1+1. 
 !Y pxy:X * Y->1+1 y:1->Y. 
 (Exq o Tp(pxy) o y = TRUE  <=> 
  ?x:1->X. pxy o Pa(x,y) = TRUE & 
  !x0:1->X. pxy o Pa(x0,y) = TRUE ==> x0 = x)’
 >-- (strip_tac >> uex_tac >>
     qexists_tac ‘Exq’ >> arw[] >>
     rpt strip_tac >> irule All_uex_lemma >> arw[]) >>
 rw[E1_ex])
(form_goal
“!X.?!Exq: Exp(X,1+1) -> 1+1. 
 !Y pxy:X * Y->1+1 y:1->Y. 
 (Exq o Tp(pxy) o y = TRUE  <=> 
  ?x:1->X. pxy o Pa(x,y) = TRUE & 
  !x0:1->X. pxy o Pa(x0,y) = TRUE ==> x0 = x)”));



val E1_def =  E1_uex |> spec_all |> qsimple_uex_spec "E1" [‘X’] |> gen_all
                    |> store_as "E1_def";
 


fun NEG_CONJ2IMP_NEG0 A B = 
    let 
        val AB = mk_conj A B
        val l = mk_neg AB
        val nB = mk_neg B
        val r = mk_imp A nB
        val l2r = negE (conjI (assume A) (assume B)) (assume l) |> negI B |> disch A |> disch l
        val r2l = negE (conjE2 (assume AB)) (mp (assume r) (conjE1 (assume AB))) 
                       |> negI AB |> disch r
    in dimpI l2r r2l
    end

val NEG_CONJ2IMP_NEG = NEG_CONJ2IMP_NEG0 (mk_fvar "A" [] []) (mk_fvar "B" [] [])



val FUN_EXT_iff = prove_store("FUN_EXT_iff",
e0
(rpt strip_tac >> dimp_tac >> strip_tac (* 2 *) >-- 
 (drule FUN_EXT >> arw[]) >>
 rpt strip_tac >> arw[])
(form_goal
“!A B f:A->B g. (!a:1->A. f o a = g o a) <=> f = g”));


val True2TRUE = prove_store("True2TRUE",
e0
(rpt strip_tac >> rw[True_def,o_assoc] >>
 once_rw[one_to_one_id] >> rw[idR])
(form_goal
“!X x:1->X. True(X) o x = TRUE”));


val False2FALSE = prove_store("False2FALSE",
e0
(rw[False_def,o_assoc] >> once_rw[one_to_one_id] >>
 rw[idR])
(form_goal
 “!X x:1->X. False(X) o x = FALSE”)); 
 


local
val eq_sym = 
prove_store("eq_sym",
e0
(rpt strip_tac >> dimp_tac >> strip_tac >> once_arw[] >> rw[])
(form_goal
“!A B f:A->B g:A->B. f = g <=> g = f”));
in
val pred_subset_ex = prove_store("pred_subset_ex",
e0
(rpt strip_tac >> 
 qspecl_then [‘X’,‘1+1’,‘pred’,‘1’,‘TRUE’] strip_assume_tac isPb_ex >>
 drule $ GSYM Pb_fac_iff_1 >>
 qexistsl_tac [‘P’,‘p’] >> arw[] >> strip_tac >> 
 (*TODO: write one function do the long thing parametized by the eq_sym.*)
 fconv_tac (rand_fconv no_conv (once_depth_fconv no_conv (rewr_fconv (spec_all eq_sym)))) >> rw[] (*almost equally stupid*)
 (*stupid *) (*rpt strip_tac >> dimp_tac >> rpt strip_tac >--
 (qex_tac ‘a’ >> arw[]) >> qex_tac ‘x0’ >> arw[]*))
(form_goal
“!X pred:X->1+1.?A ss:A ->X.
 (!x:1->X. pred o x = TRUE <=> ?x0:1->A. x = ss o x0)”));
val pred_subset_ex' = prove_store("pred_subset_ex'",
e0
(rpt strip_tac >> 
 qspecl_then [‘X’,‘1+1’,‘pred’,‘1’,‘TRUE’] strip_assume_tac isPb_ex >>
 drule $ GSYM Pb_fac_iff>>
 qexistsl_tac [‘P’,‘p’] >> arw[] >>
 qby_tac ‘Mono(p)’
 >-- (drule Pb_Mono_Mono >>
     first_x_assum irule >> rw[from_one_Mono]) >>
 arw[] >> pop_assum (K all_tac) >>
 pop_assum mp_tac >> once_rw[To1_def] >>
 rw[GSYM True_def] >> strip_tac >> arw[] >>
 rpt strip_tac >>
 first_x_assum 
  (qspecl_then [‘K’,‘x’,‘To1(K)’] assume_tac) >>
 arw[] >>
 fconv_tac (rand_fconv no_conv (once_depth_fconv no_conv (rewr_fconv (spec_all eq_sym)))) >> rw[])
(form_goal
“!X pred:X->1+1.?A ss:A ->X. Mono(ss) & 
 (!K x:K->X. pred o x = True(K) <=> ?x0:K->A. x = ss o x0)”));
end

val Swap_def = qdefine_fsym("Swap",[‘A’,‘B’]) ‘Pa(p2(A,B),p1(A,B))’
                           |> gen_all |> store_as "Swap_def";


val Swap_property = proved_th $
e0
(rw[Swap_def,p12_of_Pa])
(form_goal
 “!A B. p1(B,A) o Swap(A,B) = p2(A,B) & p2(B,A) o Swap(A,B) = p1(A,B)”)


val Swap_Swap_id = prove_store("Swap_Swap_id",
e0
(rpt strip_tac >> irule to_P_eq >> rw[Swap_def,idR] >>
 rw[Pa_distr,p12_of_Pa])
(form_goal
 “!A B. Swap(B,A) o Swap(A,B) = id(A * B)”));

val Refl_Diag = prove_store("Refl_Diag",
e0
(rw[Refl_def] >> rpt strip_tac >>
 dimp_tac >> strip_tac >> qexists_tac ‘d’ (* 2 *)
 >-- (arw[Diag_def,Pa_distr,Pa_eq_eq]) >>
 fs[Diag_def,Pa_distr,Pa_eq_eq])
(form_goal
 “!R A f0:R->A f1. Refl(f0,f1) <=>
  ?d:A->R. Pa(f0,f1) o d = Diag(A)”));


val Sym_alt = prove_store("Sym_alt",
e0
(rw[Sym_def] >> rpt strip_tac >>
 dimp_tac >> strip_tac (* 2 *)
 >-- (qexists_tac ‘t’ >> arw[Pa_distr,Pa_eq_eq]) >>
 qexists_tac ‘d’ >> fs[Pa_distr,Pa_eq_eq] >>
 fs[Diag_def,Pa_distr,Pa_eq_eq])
(form_goal
 “!R A f0:R->A f1. Sym(f0,f1) <=>
  ?d:R ->R. Pa(f0,f1) o d = Pa(f1,f0)”));

val Pa_Swap_Mono0 = prove_store("Pa_Swap_Mono0",
e0
(rw[Mono_def] >> rpt strip_tac >>
 first_x_assum irule >>
 qby_tac
 ‘Swap(B,A) o Pa(f1, f0) o g = 
  Swap(B,A) o Pa(f1, f0) o h’ 
 >-- arw[] >>
 fs[Swap_def,GSYM o_assoc,Pa_distr,p12_of_Pa])
(form_goal
 “!R A B f0:R->A f1:R->B. Mono(Pa(f0,f1)) ==> Mono(Pa(f1,f0))”));


val Swap_Mono = prove_store("Swap_Mono",
e0
(strip_tac >> strip_tac >> strip_tac >>
 strip_tac >> once_rw[to_P_component] >>
 rpt strip_tac >> drule Pa_Swap_Mono0 >>
 rw[Swap_def,GSYM o_assoc,p12_of_Pa] >>
 first_x_assum accept_tac)
(form_goal
 “!R A B f:R->A * B. Mono(f) ==> Mono(Swap(A,B) o f)”));



val p21_Swap = prove_store("p12_Swap",
e0
(rpt strip_tac >> rw[Swap_def] >>
 irule to_P_eq >> rw[p12_of_Pa,GSYM o_assoc])
(form_goal
 “!R A B f:R->A * B. Pa(p2(A,B) o f,p1(A,B) o f) = Swap(A,B) o f”));



val Trans_alt = prove_store("Trans_alt",
e0
(rw[Trans_def] >> rpt strip_tac >>
 dimp_tac >> rpt strip_tac (* 2 *) >-- 
 (qby_tac ‘p1(A,A) o Pa(f0, f1) o r01 = 
           p1(A,A) o Pa(h0, h1) & 
           p2(A,A) o Pa(f0, f1) o r01 =
           p2(A,A) o Pa(h0, h1) & 
           p1(A,A) o Pa(f0, f1) o r12 = 
           p1(A,A) o Pa(h1, h2) & 
           p2(A,A) o Pa(f0, f1) o r12 =
           p2(A,A) o Pa(h1, h2)’ 
  >-- arw[] >>
  fs[GSYM o_assoc,p12_of_Pa] >>
  qby_tac ‘f1 o r01 = f0 o r12’ >-- arw[] >>
  first_x_assum drule >> pop_assum strip_assume_tac >>
  qexists_tac ‘u’ >> arw[Pa_distr,Pa_eq_eq]) >>
 qsuff_tac
 ‘?u:X->R. Pa(f0,f1) o u = Pa(f0 o h0, f1 o h1)’ >--
 (strip_tac >> qexists_tac ‘u’ >> 
  fs[Pa_distr,Pa_eq_eq]) >>
 first_x_assum irule >>
 qexistsl_tac [‘f1 o h0’,‘h0’,‘h1’] >>
 rw[Pa_distr,Pa_eq_eq] >> arw[])
(form_goal
 “!R A f0:R->A f1:R->A. Trans(f0,f1) <=>
  !X h0:X->A h1:X->A h2:X->A r01:X->R r12:X ->R .
  Pa(f0,f1) o r01 = Pa(h0,h1) &  Pa(f0,f1) o r12 = Pa(h1,h2) ==> ?r02. Pa(f0,f1) o r02 = Pa(h0,h2)”));



val prop_2_half2' = prove_store("prop_2_half2",
e0
(rpt strip_tac >> cases_on “is0(Y)” (* 2 *) >--
 (qby_tac ‘is0(X)’ >--
  (ccontra_tac >> 
   qsuff_tac ‘?y:1->Y.T’ >-- 
   (rw[] >> irule zero_no_MEM >> arw[]) >>
   drule NONZERO_EL >>
   pop_assum strip_assume_tac >>
   first_x_assum (qspecl_then [‘a o x’,‘x’] assume_tac) >>
   fs[] >> qexists_tac ‘xb'’ >> rw[]) >>
  fs[is0_expand] >>
  first_assum (qspecl_then [‘Y’] strip_assume_tac) >>
  qexists_tac ‘f’ >> 
  first_assum (qspecl_then [‘A’] strip_assume_tac) >>
  first_assum (qspecl_then [‘b o f’] strip_assume_tac) >>
  first_assum (qspecl_then [‘a’] strip_assume_tac) >>
  fs[]) >>
 drule Mono_no_zero_post_inv >> first_assum drule >>
 pop_assum strip_assume_tac >>
 qexists_tac ‘g o a’ >> irule FUN_EXT >>
 strip_tac >> 
 first_assum (qspecl_then [‘a o a'’,‘a'’] assume_tac) >>
 fs[] >> pop_assum (assume_tac o GSYM) >> arw[o_assoc] >>
 qby_tac ‘b o g o b o xb' = b o (g o b) o xb'’
 >-- rw[o_assoc] >>
 arw[idL])
(form_goal
 “!X A a:X->A Y b:Y->A. Mono(b) ==>
  (!x:1->A xb:1->X. a o xb = x ==> ?xb':1->Y. b o xb' = x)
  ==> ?h:X->Y. b o h = a”));


val Trans_alt' = prove_store("Trans_alt",
e0
(rw[Trans_alt] >> rpt strip_tac >>
 dimp_tac >> rpt strip_tac >-- 
 (first_x_assum irule >> 
 qexistsl_tac [‘h1’,‘r01’,‘r12’] >> arw[]) >>
 irule prop_2_half2' >> arw[] >>
 rpt strip_tac >>
 fs[Pa_eq_eq,Pa_distr] >>
 first_assum 
 (qspecl_then [‘h0 o xb’,‘h1 o xb’,‘h2 o xb’,
               ‘r01 o xb’,‘r12 o xb’]
 assume_tac) >>
 fs[GSYM o_assoc] >> rfs[] >>
 qexists_tac ‘r02’ >> arw[Pa_distr,Pa_eq_eq])
(form_goal
 “!R A f0:R->A f1:R->A. Mono(Pa(f0,f1)) ==> (Trans(f0,f1) <=>
  !h0:1->A h1:1->A h2:1->A r01:1->R r12:1 ->R .
  Pa(f0,f1) o r01 = Pa(h0,h1) &  Pa(f0,f1) o r12 = Pa(h1,h2) ==> ?r02. Pa(f0,f1) o r02 = Pa(h0,h2))”));

val Swap_Pa = prove_store("Swap_Pa",
e0
(rpt strip_tac >> rw[Swap_def] >> rw[Pa_distr,Pa_eq_eq,p12_of_Pa])
(form_goal “!X A f:X->A B g:X->B. Swap(A,B) o Pa(f,g) = Pa(g,f)”));


val p31_def = qdefine_fsym("p31",[‘A’,‘B’,‘C’]) ‘p1(A,B * C)’ 
                          |> gen_all 

val p32_def = qdefine_fsym("p32",[‘A’,‘B’,‘C’]) ‘p1(B,C) o p2(A,B * C)’ 
                          |> gen_all 

val p33_def = qdefine_fsym("p33",[‘A’,‘B’,‘C’]) ‘p2(B,C) o p2(A,B * C)’ 
                          |> gen_all 



val p31_of_Pa = prove_store("p31_of_Pa",
                            e0
                                (rpt strip_tac >> rw[p31_def,p1_of_Pa] )
                                (form_goal
                                     “!A B C X a:X-> A bc: X-> B * C. p31(A,B,C) o Pa(a, bc) = a”));


val p32_of_Pa = prove_store("p32_of_Pa",
e0
(rpt strip_tac >> rw[p32_def,o_assoc,p12_of_Pa] )
(form_goal
“!A B C X a:X-> A b: X-> B c: X-> C. p32(A,B,C) o Pa(a, Pa(b,c)) = b”));


val p33_of_Pa = prove_store("p33_of_Pa",
e0
(rpt strip_tac >> rw[p33_def,o_assoc,p2_of_Pa] )
(form_goal
“!A B C X a:X-> A b: X-> B c: X-> C. p33(A,B,C) o Pa(a, Pa(b,c)) = c”));

val Pa3_def = qdefine_fsym("Pa3",[‘f:X->A’,‘g:X->B’,‘h:X->C’]) 
                          ‘Pa(f,Pa(g,h))’ 
                          |> gen_all 


val Pa4_def = qdefine_fsym("Pa4",[‘f:X->A’,‘g:X->B’,‘h:X->C’,‘j:X->D’]) 
                          ‘Pa(f,Pa(g,Pa(h,j)))’ 
                          |> gen_all 
            
val p41_def = qdefine_fsym("p41",[‘A’,‘B’,‘C’,‘D’]) ‘p1(A,B * C * D)’ 
                          |> gen_all 

val p42_def = qdefine_fsym("p42",[‘A’,‘B’,‘C’,‘D’])
                          ‘p1(B, C * D) o p2(A,B * C * D)’ 
                          |> gen_all 

val p43_def = qdefine_fsym("p43",[‘A’,‘B’,‘C’,‘D’]) 
                          ‘p1(C,D) o p2(B, C * D) o p2(A,B * C * D)’ 
                          |> gen_all 

val p44_def = qdefine_fsym("p44",[‘A’,‘B’,‘C’,‘D’]) 
                          ‘p2(C,D) o p2(B, C * D) o p2(A,B * C * D)’ 
                          |> gen_all 

fun mk_o a1 a2 = mk_fun "o" [a1,a2]

val CONJ = mk_fun "CONJ" []

fun Pa f g = mk_fun "Pa" [f,g]

fun Ex X = mk_fun "Ex" [X]

fun Tp f = mk_fun "Tp" [f]

val IMP = mk_fun "IMP" []

val two = rastt "1+1";





val p31_of_Pa3 = proved_th $
e0
(rpt strip_tac >> rw[Pa3_def,p31_def,p1_of_Pa])
(form_goal
“!A B C X f:X->A g:X->B h:X->C. p31(A,B,C) o Pa3(f,g,h) = f”)



val p32_of_Pa3 = proved_th $
e0
(rpt strip_tac >> rw[Pa3_def,p32_def,p12_of_Pa,o_assoc])
(form_goal
“!A B C X f:X->A g:X->B h:X->C. p32(A,B,C) o Pa3(f,g,h) = g”)


val p33_of_Pa3 = prove_store("p33_of_Pa3",
e0
(rpt strip_tac >> rw[Pa3_def,p33_def,p2_of_Pa,o_assoc])
(form_goal
“!A B C X f:X->A g:X->B h:X->C. p33(A,B,C) o Pa3(f,g,h) = h”));


val Ev_of_Tp_el' = prove_store("Ev_of_Tp_el'",
e0
(rpt strip_tac >> 
 qby_tac ‘Tp(f) = Tp(f) o id(P)’ >-- rw[idR] >>
 once_arw[] >> rw[Ev_of_Tp_el])
(form_goal
“!A B P f:A * P -> B  a:P -> A.
Ev(A, B) o Pa(a, Tp(f)) = f o Pa(a, id(P))”));


val Ev_of_el = prove_store("Ev_of_el",
e0
(rpt strip_tac >>
 qby_tac 
 ‘f = Tp1(Tp0(f))’ >-- rw[Tp1_Tp0_inv] >> once_arw[] >>
 rw[Tp1_def,Ev_of_Tp_el'] >> rw[GSYM Tp1_def,Tp1_Tp0_inv] >>
 rw[o_assoc,p1_of_Pa,idR])
(form_goal
 “!A B f:1->Exp(A,B) a:1->A.
  Ev(A,B) o Pa(a,f) = Tp0(f) o a”));

fun Po A B = mk_fun "*" [A,B]


val p41_of_Pa4 = prove_store("p41_of_Pa4",
e0
(rpt strip_tac >> rw[Pa4_def,p41_def,p12_of_Pa])
(form_goal
“!A B C D X f:X->A g:X->B h:X->C k:X->D.
 p41(A,B,C,D) o Pa4(f,g,h,k) = f”));

val p42_of_Pa4 = prove_store("p42_of_Pa4",
e0
(rpt strip_tac >> rw[Pa4_def,p42_def,p12_of_Pa,o_assoc])
(form_goal
“!A B C D X f:X->A g:X->B h:X->C k:X->D.
 p42(A,B,C,D) o Pa4(f,g,h,k) = g”));


val p43_of_Pa4 = prove_store("p43_of_Pa4",
e0
(rpt strip_tac >> rw[Pa4_def,p43_def,p12_of_Pa,o_assoc])
(form_goal
“!A B C D X f:X->A g:X->B h:X->C k:X->D.
 p43(A,B,C,D) o Pa4(f,g,h,k) = h”));


val p44_of_Pa4 = prove_store("p44_of_Pa4",
e0
(rpt strip_tac >> rw[Pa4_def,p44_def,p12_of_Pa,o_assoc])
(form_goal
“!A B C D X f:X->A g:X->B h:X->C k:X->D.
 p44(A,B,C,D) o Pa4(f,g,h,k) = k”));


val Pa5_def = qdefine_fsym("Pa5",[‘f:X->A’,‘g:X->B’,‘h:X->C’,‘j:X->D’,‘k:X->E’]) 
                          ‘Pa(f,Pa(g,Pa(h,Pa(j,k))))’ 
                          |> gen_all 

val p51_def = qdefine_fsym("p51",[‘A’,‘B’,‘C’,‘D’,‘E’]) ‘p1(A,B * C * D * E)’ 
                          |> gen_all 

val p52_def = qdefine_fsym("p52",[‘A’,‘B’,‘C’,‘D’,‘E’])
                          ‘p1(B,C * D * E) o p2(A,B * C * D * E)’ 
                          |> gen_all 

val p53_def = qdefine_fsym("p53",[‘A’,‘B’,‘C’,‘D’,‘E’]) 
                          ‘p1(C,D * E) o p2(B,C * D * E) o p2(A,B * C * D * E)’ 
                          |> gen_all 

val p54_def = qdefine_fsym("p54",[‘A’,‘B’,‘C’,‘D’,‘E’]) 
                          ‘p1(D,E) o p2(C,D * E) o p2(B,C * D * E) o p2(A,B * C * D * E)’ 
                          |> gen_all 


val p55_def = qdefine_fsym("p55",[‘A’,‘B’,‘C’,‘D’,‘E’]) 
                          ‘p2(D,E) o p2(C, D * E) o p2(B,C * D * E) o p2(A,B * C * D * E)’ 
                          |> gen_all 



val p51_of_Pa5 = prove_store("p51_of_Pa5",
e0
(rpt strip_tac >> rw[Pa5_def,p51_def,p12_of_Pa])
(form_goal
“!A B C D E X f:X->A g:X->B h:X->C j:X->D k:X->E.
 p51(A,B,C,D,E) o Pa5(f,g,h,j,k) = f”));


val p52_of_Pa5 = prove_store("p52_of_Pa5",
e0
(rpt strip_tac >> rw[Pa5_def,p52_def,p12_of_Pa,o_assoc])
(form_goal
“!A B C D E X f:X->A g:X->B h:X->C j:X->D k:X->E.
 p52(A,B,C,D,E) o Pa5(f,g,h,j,k) = g”));


val p53_of_Pa5 = prove_store("p53_of_Pa5",
e0
(rpt strip_tac >> rw[Pa5_def,p53_def,p12_of_Pa,o_assoc])
(form_goal
“!A B C D E X f:X->A g:X->B h:X->C j:X->D k:X->E.
 p53(A,B,C,D,E) o Pa5(f,g,h,j,k) = h”));

 
val p54_of_Pa5 = prove_store("p54_of_Pa5",
e0
(rpt strip_tac >> rw[Pa5_def,p54_def,p12_of_Pa,o_assoc])
(form_goal
“!A B C D E X f:X->A g:X->B h:X->C j:X->D k:X->E.
 p54(A,B,C,D,E) o Pa5(f,g,h,j,k) = j”));


val p55_of_Pa5 = prove_store("p55_of_Pa5",
e0
(rpt strip_tac >> rw[Pa5_def,p55_def,p12_of_Pa,o_assoc])
(form_goal
“!A B C D X f:X->A g:X->B h:X->C j:X->D k:X->E.
 p55(A,B,C,D,E) o Pa5(f,g,h,j,k) = k”));


val p61_def = qdefine_fsym("p61",[‘A’,‘B’,‘C’,‘D’,‘E’,‘F’]) ‘p1(A,B * C * D * E * F)’ 
                          |> gen_all 

val p62_def = qdefine_fsym("p62",[‘A’,‘B’,‘C’,‘D’,‘E’,‘F’])
                          ‘p1(B,C * D * E * F) o p2(A,B * C * D * E * F)’ 
                          |> gen_all 

val p63_def = qdefine_fsym("p63",[‘A’,‘B’,‘C’,‘D’,‘E’,‘F’]) 
                          ‘p1(C,D * E * F) o p2(B,C * D * E * F) o p2(A,B * C * D * E * F)’ 
                          |> gen_all 

val p64_def = qdefine_fsym("p64",[‘A’,‘B’,‘C’,‘D’,‘E’,‘F’]) 
                          ‘p1(D,E * F) o p2(C,D * E * F) o p2(B,C * D * E * F) o p2(A,B * C * D * E * F)’ 
                          |> gen_all 


val p65_def = qdefine_fsym("p65",[‘A’,‘B’,‘C’,‘D’,‘E’,‘F’]) 
                          ‘p1(E,F) o p2(D,E * F) o p2(C, D * E * F) o p2(B,C * D * E * F) o p2(A,B * C * D * E * F)’ 
                          |> gen_all 


val p66_def = qdefine_fsym("p66",[‘A’,‘B’,‘C’,‘D’,‘E’,‘F’]) 
                          ‘p2(E,F) o p2(D,E * F) o p2(C, D * E * F) o p2(B,C * D * E * F) o p2(A,B * C * D * E * F)’ 
                          |> gen_all 

val Tp0_INJ = prove_store("Tp0_INJ",
e0
(rpt strip_tac >> dimp_tac >> strip_tac >-- 
 (once_rw[GSYM Tp1_Tp0_inv] >> arw[]) >> arw[])
(form_goal
 “!A B f:1->Exp(A,B) g:1->Exp(A,B).
  Tp0(f) = Tp0(g) <=> f = g”));

val pred_ext = prove_store("pred_ext",
e0
(rpt strip_tac >> dimp_tac >> strip_tac (* 2 *) >-- 
 (cases_on “p1:1->1+1 = TRUE” >-- fs[] >>
 fs[TRUE2FALSE] >> fs[TRUE_ne_FALSE] >>
 fs[TRUE2FALSE]) >>
 arw[])
(form_goal
“!p1 p2. (p1 = TRUE <=> p2 = TRUE) <=> p1 = p2”));


fun Exp A B  = mk_fun "Exp" [A,B];
fun Pow A = Exp A two

fun Tp0 f = mk_fun "Tp0" [f]


val In_def = qdefine_fsym("In",[‘X’]) ‘Ev(X,1+1)’ 
|> gen_all |> store_as "In_def";



(*val _ = new_pred "IN" [("a",ar_sort (mk_ob "X") (mk_ob "A")),
                       ("as",ar_sort (mk_ob "X") (Exp (mk_ob "A") two))]
*)

val IN_def0 = qdefine_psym("IN",[‘a:X->A’,‘ss:X->Exp(A,1+1)’])
‘In(A) o Pa(a,ss) = True(X)’ |> gen_all |> store_as "IN_def0";


val IN_def1 = prove_store("IN_def1",
e0
(rw[True1TRUE,IN_def0])
(form_goal “!A a:1->A ss:1->Exp(A,1+1). 
 IN(a,ss) <=> In(A) o Pa(a,ss) = TRUE”));



val IN_EXT0 = prove_store("IN_EXT0",
e0
(rw[IN_def0,In_def] >> rpt strip_tac >> dimp_tac >>
 rpt strip_tac >> arw[] >> irule Ev_eq_eq >> 
 fs[True1TRUE,pred_ext] >> irule FUN_EXT >>
 rpt strip_tac >> rw[Pa_distr,o_assoc] >>
 once_rw[one_to_one_id] >> rw[idR] >> arw[])
(form_goal “!X s1:1-> Exp(X,1+1) s2.
 s1 = s2 <=> (!x.IN(x,s1) <=> IN(x,s2))”));

val IN_EXT = GSYM IN_EXT0

(*
val Sing_def = qdefine_fsym("Sing",[‘A’]) ‘Tp(Char(Diag(A)))’
|> gen_all |> store_as "Sing_def";
*)

(*sigma*)
val Sig_ex = prove_store("Sig_ex",
e0
(strip_tac >> qexists_tac ‘Char(Sing(A))’ >>
 rw[])
(form_goal “!A. ?Sig. Char(Sing(A)) = Sig”));

val Sig_def = qdefine_fsym("Sig",[‘A’]) ‘Char(Sing(A))’
|> gen_all |> store_as "Sig_def"; 


val pred_ext' = prove_store("pred_ext'",
e0
(rpt strip_tac >> dimp_tac >> strip_tac >> arw[] >>
 irule FUN_EXT >> strip_tac >> 
 once_rw[GSYM pred_ext] >> arw[])
(form_goal
 “!X p1:X->1+1 p2. 
  (!x. p1 o x = TRUE <=> p2  o x = TRUE) <=> p1 = p2”));


val Sing_Mono = prove_store("Sing_Mono",
e0
(strip_tac >> rw[Mono_def] >> rpt strip_tac >>
 qby_tac ‘In(B) o Pa(p1(B,B),Sing(B) o p2(B,B))
          = Eq(B)’
 >-- rw[In_def,Sing_def,Eq_def,
        Ev_of_Tp] >> 
 qby_tac ‘Eq(B) o Pa(p1(B,X),g o p2(B,X)) = 
          Eq(B) o Pa(p1(B,X),h o p2(B,X))’
 >-- (pop_assum (assume_tac o GSYM) >> arw[] >>
     rw[o_assoc,Pa_distr,p12_of_Pa] >>
     arw[GSYM o_assoc]) >>
 irule FUN_EXT >> strip_tac >>
 qsuff_tac ‘!a'. g o a = a' <=> h o a = a'’ >--
 (rpt strip_tac >> 
 first_x_assum (qspecl_then [‘g o a’] assume_tac) >>
 fs[]) >>
 strip_tac >> 
 pop_assum mp_tac >>
 once_rw[GSYM pred_ext'] >> 
 strip_tac >>
 first_x_assum 
  (qspecl_then [‘Pa(a',a)’] assume_tac) >>
 fs[o_assoc,Pa_distr,p12_of_Pa,Eq_property_TRUE] >> 
 flip_tac >> arw[])
(form_goal “!B. Mono(Sing(B))”));



val In_Sing = prove_store("In_Sing",
e0
(rw[In_def,Sing_def] >>
 rw[Ev_of_Tp_el] >> rw[Char_Diag,TRUE_def] >>
 rpt strip_tac >> dimp_tac >> rpt strip_tac >> arw[])
(form_goal
 “!B b0:1->B b. In(B) o Pa(b,Sing(B) o b0) = TRUE<=>
 b0 = b ”));

val Rel_U_fac = prove_store("Rel_U_fac",
e0
(rpt strip_tac>> irule prop_2_half2' >>
 rw[Sing_Mono] >> rpt strip_tac >>
 first_x_assum (qsspecl_then [‘xb’] assume_tac) >>
 pop_assum (strip_assume_tac o uex_expand) >>
 qexists_tac ‘b’ >> 
 once_rw[GSYM IN_EXT] >>
 rw[IN_def0,True1TRUE] >>
 rw[In_Sing] >> 
 rw[In_def] >>
 last_x_assum (assume_tac o GSYM) >> arw[] >>
 rw[Ev_of_Tp_el] >>
 strip_tac >> dimp_tac >> strip_tac >--
 (pop_assum (assume_tac o GSYM) >> arw[]) >>
 first_x_assum drule >> arw[])
(form_goal
 “!A B R:B * A -> 1+1.
    (!a:1->A.?!b:1->B. R o Pa(b,a) = TRUE) ==>
    ?f:A->B. Sing(B) o f = Tp(R)”));

 
val Rel2Ar = prove_store("Rel2Ar",
e0
(rpt strip_tac >> drule Rel_U_fac >>
 pop_assum strip_assume_tac >>
 qexists_tac ‘h’ >>
 rpt strip_tac >> 
 qby_tac
 ‘In(B) o Pa(b,Sing(B) o h o a) = In(B) o Pa(b,Tp(R) o a)’
 >-- arw[GSYM o_assoc] >>
 fs[In_def,Sing_def,Ev_of_Tp_el] >> 
 pop_assum (assume_tac o GSYM) >> arw[] >>
 rw[Char_Diag,TRUE_def] >> rflip_tac >> rw[]
 )
(form_goal
 “!A B R:B * A -> 1+1. 
   (!a:1->A.?!b:1->B. R o Pa(b,a) = TRUE) ==>
   (?f:A->B. !a b. f o a = b <=> R o Pa(b,a) = TRUE)”));


val Rel2Ar' = prove_store("Rel2Ar'",
e0
(rpt strip_tac >> 
 assume_tac Rel2Ar >>
 qby_tac
 ‘?R'. !a b. R' o Pa(b,a) = TRUE <=> 
  R o Pa(a,b) = TRUE’
 >-- (qexists_tac ‘R o Swap(B,A)’ >>
     rw[o_assoc,Swap_Pa]) >>
 pop_assum strip_assume_tac >>
 qby_tac
 ‘!a:1->A. ?!b.R' o Pa(b,a) = TRUE’ 
 >-- (strip_tac >>uex_tac >>
     last_x_assum 
     (qspecl_then [‘a’] (strip_assume_tac o uex_expand)) >>
     qexists_tac ‘b’ >> arw[]) >>
 first_x_assum drule >>
 pop_assum strip_assume_tac >>
 qexists_tac ‘f’ >>
 fs[])
(form_goal
 “!A B R:A * B -> 1+1. 
   (!a:1->A.?!b:1->B. R o Pa(a,b) = TRUE) ==>
   (?f:A->B. !a b. f o a = b <=> R o Pa(a,b) = TRUE)”));


val Holds_def =
 qdefine_psym("Holds",[‘R:A * B -> 1+1’,‘a:1->A’,‘b:1->B’])
‘R o Pa(a,b) = TRUE’ |> gen_all |> store_as "Holds_def";


val P2fun = Rel2Ar' |> rewr_rule[GSYM Holds_def] |> store_as "P2fun";


 
val Fst_def = qdefine_fsym("Fst",[‘ab:X->A * B’]) ‘p1(A,B) o ab’
|> gen_all |> store_as "Fst_def";

val Snd_def = qdefine_fsym("Snd",[‘ab:X->A * B’]) ‘p2(A,B) o ab’
|> gen_all |> store_as "Snd_def";

val Fst_Snd_Pa = p12_of_Pa |> rewr_rule[GSYM Fst_def,GSYM Snd_def]
                           |> store_as "Fst_Snd_Pa";

val Fst_Pa = p1_of_Pa |> rewr_rule[GSYM Fst_def] |> store_as "Fst_Pa";

val Snd_Pa = p2_of_Pa |> rewr_rule[GSYM Snd_def] |> store_as "Snd_Pa";


val And_def = qdefine_fsym("And",[‘p:X->1+1’,‘q:X->1+1’]) 
‘CONJ o Pa(p,q)’ |> gen_all |> store_as "And_def";

val And_property = rewr_rule[GSYM And_def] CONJ_def

val Or_def = qdefine_fsym("Or",[‘p:X->1+1’,‘q:X->1+1’]) 
‘DISJ o Pa(p,q)’ |> gen_all |> store_as "Or_def";

val Or_property = rewr_rule[GSYM Or_def] DISJ_def

val Imp_def = qdefine_fsym("Imp",[‘p:X->1+1’,‘q:X->1+1’]) 
‘IMP o Pa(p,q)’ |> gen_all |> store_as "Imp_def";

val Imp_property = rewr_rule[GSYM Imp_def] IMP_def

val Iff_def = qdefine_fsym("Iff",[‘p:X->1+1’,‘q:X->1+1’]) 
‘IFF o Pa(p,q)’ |> gen_all |> store_as "Iff_def";

val Iff_property = rewr_rule[GSYM Iff_def] IFF_def


val ALL_def = qdefine_fsym("ALL",[‘p:X * Y->1+1’]) 
‘All(X) o Tp(p)’ |> gen_all |> store_as "ALL_def";

val ALL_property = All_def |> rewr_rule[GSYM o_assoc,GSYM ALL_def]


val EX_def = qdefine_fsym("EX",[‘p:X * Y->1+1’]) 
‘Ex(X) o Tp(p)’ |> gen_all |> store_as "EX_def";

val EX_property = Ex_def |> rewr_rule[GSYM o_assoc,GSYM EX_def]


val UE_def = qdefine_fsym("UE",[‘p:X * Y->1+1’]) 
‘E1(X) o Tp(p)’ |> gen_all |> store_as "UE_def";

val UE_property = E1_def |> rewr_rule[GSYM o_assoc,GSYM UE_def]

val EQ_ex = prove_store("EQ_ex",
e0
(rpt strip_tac >> qexists_tac ‘Eq(X) o Pa(f,g)’ >> rw[])
(form_goal “!A X f:A->X g. ?fg. Eq(X) o Pa(f,g) = fg”));

val EQ_def = qdefine_fsym("EQ",[‘f:A->X’,‘g:A->X’])
‘Eq(X) o Pa(f,g)’ |> GSYM |> gen_all
           |> store_as "EQ_def";

val EQ_property_TRUE = Eq_property_TRUE 
                           |> rewr_rule[GSYM EQ_def]

val EQ_property = Eq_property
                           |> rewr_rule[GSYM EQ_def]


val Not_def = qdefine_fsym("Not",[‘p:X->1+1’]) 
‘NEG o p’ |> gen_all |> store_as "Not_def";

val Not_property = rewr_rule[GSYM Not_def] NEG_def;


val p21_ex = prove_store("p21_ex",
e0
(rpt strip_tac >> qexists_tac ‘p1(A,B)’ >> rw[])
(form_goal
 “!A B. ?p. p1(A,B) = p”));


val p21_def = qdefine_fsym("p21",[‘A’,‘B’]) ‘p1(A,B)’
                          |> gen_all 


val p22_def = qdefine_fsym("p22",[‘A’,‘B’]) ‘p2(A,B)’
                          |> gen_all 

val p11_def = qdefine_fsym("p11",[‘A’]) ‘id(A)’
                          |> gen_all 

val IN_def = IN_def1;
(*
val IN_def = qdefine_psym ("IN",[‘a:1->A’,‘ss:1-> Exp(A, 1+1)’])
             ‘In(A) o Pa(a,ss) = TRUE’ 
             |> gen_all |> store_as "IN_def";
*)

 
val SS_def = qdefine_psym ("SS",[‘P1:1->Exp(A,1+1)’,‘P2:1->Exp(A,1+1)’])
                          ‘(∀a. IN(a,P1) ⇒ IN(a,P2))’
                          |> gen_all 
                          |> store_as "SS_def";



val SS_Trans = prove_store("SS_Trans",
e0
(rw[SS_def] >> rpt strip_tac >> first_x_assum irule >>
 first_x_assum irule >> arw[])
(form_goal 
 “∀A P1:1->Exp(A,1+1) P2. SS(P1,P2) ⇒ ∀P3. SS(P2,P3) ⇒ SS(P1,P3)”));

val SS_SS_eq = prove_store("SS_SS_eq",
e0
(rpt strip_tac >> irule $ iffLR IN_EXT >> fs[SS_def] >> 
 strip_tac >> dimp_tac >> strip_tac >> 
 first_x_assum irule >> arw[])
(form_goal “∀A p1:1->Exp(A,1+1) p2. SS(p1,p2) ∧ SS(p2,p1) ⇒
 p1 = p2”));


val IN_Tp1 = prove_store("IN_Tp1",
e0
(rw[IN_def,In_def,Tp1_def,Ev_of_Tp_el',o_assoc,p12_of_Pa,idR])
(form_goal “!A a:1->A s.IN(a,Tp1(s)) <=> s o a = TRUE”));


val Empty_def = proved_th $
e0
(strip_tac >>
 qsuff_tac
 ‘?s. !x:1->X. ~IN(x,s)’
 >-- (strip_tac >> uex_tac >> qexists_tac ‘s’ >> arw[] >>
      rpt strip_tac >> irule $ iffLR IN_EXT >> arw[]) >>
 qexists_tac ‘Tp1(FALSE o To1(X))’ >>
 rw[IN_Tp1] >> rw[o_assoc,one_to_one_id,idR,TRUE_ne_FALSE]
 (*qform2IL [‘s:1->Exp(X,1+1)’] ‘!x.~IN(x,s)’ *))
(form_goal “!X. ?!s. !x:1->X. ~IN(x,s)”)
|> qspecl [‘X’]
|> qsimple_uex_spec "Empty" [‘X’]
|> rewr_rule[]
|> gen_all |> store_as "Empty_def";



val BIGINTER_ex = prove_store("BIGINTER_ex",
e0
(strip_tac >> 
 qsuff_tac
 ‘?BI:Exp(Exp(A,1+1),1+1) -> Exp(A,1+1). 
  !sss a:1->A. IN(a,BI o sss) <=>
  !ss.IN(ss,sss) ==> IN(a,ss)’
 >-- (strip_tac >> uex_tac >> qexists_tac ‘BI’ >> arw[] >>
     rpt strip_tac >> irule FUN_EXT >> strip_tac >>
     irule $ iffLR IN_EXT >> arw[]) >>
 (*qform2IL [‘a:1->A’,‘sss:1->Exp(Exp(A,1+1),1+1)’]
 ‘!ss.IN(ss,sss) ==> IN(a,ss) ’*)
qexists_tac 
‘Tp(All(Exp(A, 1+1))
   o
   Tp(IMP o
    Pa(In(Exp(A, 1+1)) o
     Pa(p31(Exp(A, 1+1), A, Exp(Exp(A, 1+1), 1+1)),
      p33(Exp(A, 1+1), A, Exp(Exp(A, 1+1), 1+1))), In(A) o
     Pa(p32(Exp(A, 1+1), A, Exp(Exp(A, 1+1), 1+1)),
      p31(Exp(A, 1+1), A, Exp(Exp(A, 1+1), 1+1))))))’ >>
rw[IN_def,In_def,Ev_of_Tp_el] >>
rw[All_def,o_assoc,IMP_def,Pa_distr,p31_def,p32_def,p33_def,p12_of_Pa]
)
(form_goal
 “!A. ?!BI:Exp(Exp(A,1+1),1+1) -> Exp(A,1+1). 
  !sss a:1->A. IN(a,BI o sss) <=>
  !ss.IN(ss,sss) ==> IN(a,ss)”));
 

val BI_def = BIGINTER_ex |> spec_all
                         |> qsimple_uex_spec "BI" [‘A’]
                         |> gen_all
                         |> store_as "BI_def"; 


val BIGINTER_def = qdefine_fsym("BIGINTER",[‘sss:1->Exp(Exp(A,1+1),1+1)’])
‘BI(A) o sss’ |> gen_all |> store_as "BIGINTER_def";


val IN_BIGINTER = BI_def |> rewr_rule[GSYM BIGINTER_def] 
                         |> store_as "IN_BIGINTER";


val IN_def_P_ex = pred_subset_ex




val INS_def = proved_th $
e0
(strip_tac >>
 qsuff_tac
 ‘?INS:X * Exp(X,1+1) -> Exp(X,1 + 1).
 !xs x0 x:1->X. IN(x,INS o Pa(x0,xs)) <=> x = x0 | IN(x,xs)’
 >-- (strip_tac >> uex_tac >> qexists_tac ‘INS’ >> arw[] >>
     rpt strip_tac >> irule FUN_EXT >> strip_tac >>
     irule $ iffLR IN_EXT >> 
     qsspecl_then [‘a’] strip_assume_tac Pair_has_comp >> 
     arw[]) >>
 qexists_tac
 ‘Tp(DISJ
   o
   Pa(Eq(X) o Pa(p31(X, X, Exp(X, 1+1)), p32(X, X, Exp(X, 1+1))), In(X) o
    Pa(p31(X, X, Exp(X, 1+1)), p33(X, X, Exp(X, 1+1)))))’ >>
 rw[IN_def,In_def,Ev_of_Tp_el,DISJ_def,p31_def,p32_def,p33_def,
    Pa_distr,DISJ_def,Eq_property_TRUE,o_assoc,p12_of_Pa]
 (*qform2IL [‘x:1->X’,‘x0:1->X’,‘xs:1->Exp(X,1+1)’]
 ‘x = x0 | IN(x,xs)’*)
 )
(form_goal “!X.?!INS:X * Exp(X,1+1) -> Exp(X,1 + 1).
 !xs x0 x:1 -> X. IN(x,INS o Pa(x0,xs)) <=> x = x0 | IN(x,xs)”)
|> spec_all 
|> qsimple_uex_spec "INS" [‘X’]
|> gen_all
|> store_as "Ins_def";



val Ins_def = qdefine_fsym("Ins",[‘x0:1->X’,‘s0:1-> Exp(X,1+1)’])
‘INS(X) o Pa(x0,s0)’ |> qgen ‘s0’ |> qgen ‘x0’ |> qgen ‘X’
|> store_as "Ins_def";



val Rel2Ar_uex = prove_store("Rel2Ar_uex",
e0
(rpt strip_tac >>
 qsuff_tac
 ‘?f:A->B. !a b. f o a = b <=> R o Pa(a,b) = TRUE’
 >-- (strip_tac >> uex_tac >> qexists_tac ‘f’ >>
     arw[] >> rpt strip_tac >>
     irule FUN_EXT >> arw[] >>
     last_x_assum (K all_tac) >>
     last_x_assum (assume_tac o GSYM) >> arw[]) >>
 drule Rel2Ar' >> arw[])
(form_goal
 “!A B R:A * B -> 1+1. 
   (!a:1->A.?!b:1->B. R o Pa(a,b) = TRUE) ==>
   (?!f:A->B. !a b. f o a = b <=> R o Pa(a,b) = TRUE)”));

val P2fun_uex = Rel2Ar_uex |> rewr_rule[GSYM Holds_def] |> store_as "P2fun";

val Inj_def = 
    qdefine_psym ("Inj",[‘f:A->B’]) 
                 ‘!x1:1->A x2. f o x1 = f o x2 ==> x1 = x2’
    |> gen_all |> store_as "Inj_def";

val Inj_Mono = prove_store("Inj_Mono",
e0
(rpt strip_tac >>
 rw[Inj_def,Mono_def] >> dimp_tac >> rpt strip_tac (* 2 *)
 >-- (irule FUN_EXT >> strip_tac >>
     first_x_assum irule >> arw[GSYM o_assoc]) >>
 first_x_assum irule >> arw[])
(form_goal “!A B f:A->B. Inj(f) <=> Mono(f)”));


val Thm_2_4 = prove_store("Thm_2_4",
e0
(rpt strip_tac >>
 qsspecl_then [‘p’] strip_assume_tac pred_subset_ex' >>
 qexistsl_tac [‘A'’,‘ss’] >> fs[Inj_Mono,GSYM True1TRUE])
(form_goal 
 “!A p:A->1+1.?B i:B->A. Inj(i) & 
  !a:1->A. p o a = TRUE <=> ?b. a = i o b”));




val Inj_ex_uex = prove_store("Inj_ex_uex",
e0
(rpt strip_tac >> dimp_tac >> strip_tac (* 2 *)
 >-- first_x_assum (accept_tac o uex2ex_rule) >>
 uex_tac >> qexists_tac ‘a’ >> arw[] >> rpt strip_tac >>
 fs[Inj_def] >> first_x_assum irule >> arw[])
(form_goal “!A B f:A->B. Inj(f) ==>
 !b:1->B. (?!a. f o a = b) <=> (?a.f o a = b)”));
 
val P2fun_uex_R = prove_store("P2fun_uex_R",
e0
(rpt strip_tac >>
 qsuff_tac
 ‘?f:A->B. !a b. f o a = b <=> R o Pa(a,b) = TRUE’ 
 >-- (strip_tac >> uex_tac >>
     qexists_tac ‘f’ >> pop_assum (assume_tac o GSYM) >>
     arw[] >> rpt strip_tac >>
     irule FUN_EXT >> arw[]) >>
 drule Rel2Ar' >> arw[])
(form_goal
 “!A B R:A * B -> 1+1. 
   (!a:1->A.?!b:1->B. R o Pa(a,b) = TRUE) ==>
   (?!f:A->B. !a. R o Pa(a,f o a) = TRUE)”));


val P2fun_uex_Holds  = P2fun_uex_R |> rewr_rule[GSYM Holds_def]



val Prla_def = 
    qdefine_fsym ("Prla",[‘f:A->B’,‘g:C->D’])
    ‘Pa(f o p1(A,C),g o p2(A,C))’
    |> gen_all |> store_as "Prla_def";



val Thm_2_4_unique = proved_th $
e0
(rpt strip_tac >>
 qby_tac
 ‘!b b'. Holds(Eq(A) o Prla(i,i'),b,b') <=> i o b = i' o b'’ 
 >-- rw[Holds_def,o_assoc,Prla_def,Pa_distr,p12_of_Pa,
        Eq_property_TRUE] >>
 qby_tac
 ‘!b:1->B. ?!b'. Holds(Eq(A) o Prla(i,i'),b,b')’
 >-- (arw[] >> strip_tac >> flip_tac >>
     irule $ iffRL Inj_ex_uex >> arw[] >>
     first_x_assum 
     (qspecl_then [‘i o b’] (assume_tac o GSYM)) >>
     flip_tac >> arw[] >> qexists_tac ‘b’ >> rw[]) >>
 drule P2fun >>
 rfs[] >>
 pop_assum strip_assume_tac >>
 qby_tac
 ‘!b' b. Holds(Eq(A) o Prla(i',i),b',b) <=> i o b = i' o b'’ 
 >-- (rw[Holds_def,o_assoc,Prla_def,Pa_distr,p12_of_Pa,
        Eq_property_TRUE] >> rpt strip_tac >>
        rflip_tac >> rw[]) >>
 qby_tac
 ‘!b':1->B'. ?!b. Holds(Eq(A) o Prla(i',i),b',b)’
 >-- ( arw[] >> strip_tac >> 
     irule $ iffRL Inj_ex_uex >> arw[] >>
     flip_tac >> arw[] >> qexists_tac ‘b'’ >> rw[]) >>
 drule P2fun >>
 rfs[] >> 
 qexistsl_tac [‘f’,‘f'’] >> 
 once_rw[GSYM FUN_EXT_iff] >> rw[o_assoc] >> arw[idL] >>
 qsuff_tac
 ‘(!a:1->B'. i o f' o a = i' o a) &
  (!a:1->B. i o a = i' o f o a)’
 >-- (rpt strip_tac >> arw[]) >>
 qpick_x_assum
 ‘∀a:1->B b. f o a = b ⇔ i o a = i' o b’ 
 (assume_tac o GSYM) >>
 arw[] >>
 pop_assum (assume_tac o GSYM) >>
 arw[] >>
 pop_assum (K all_tac) >>
 pop_assum (assume_tac o GSYM) >> arw[])
(form_goal “
 ∀A p:A->1+1 B i:B->A B' i'.
 (Inj(i) &
      (∀a. p o a = TRUE <=> ∃b:1->B. a = i o b)) & 
 (Inj(i') & 
      (∀a. p o a = TRUE ⇔ ∃b:1->B'. a = i' o b)) ⇒
  ∃f:B -> B' g:B' -> B. 
     f o g = id(B') &
     g o f = id(B) &
     i' o f = i & i o g = i'”)



val Thm_2_4' = proved_th $
e0
(rpt strip_tac >>
 qspecl_then [‘A’,‘p’] strip_assume_tac Thm_2_4 >>
 qexistsl_tac [‘B’,‘i’] >> arw[] >>
 rpt strip_tac >>
 irule Thm_2_4_unique >> arw[] >>
 qexists_tac ‘p’ >> arw[])
(form_goal 
 “∀A p:A-> 1+1. 
    ∃B i:B->A. 
     (Inj(i) &
      (∀a. p o a = TRUE <=> ∃b:1->B. a = i o b)) &
     (∀B' i':B'->A.
      Inj(i') & 
      (∀a. p o a = TRUE ⇔ ∃b:1->B'. a = i' o b) ⇒
     ∃f:B -> B' g:B' -> B. 
     f o g = id(B') &
     g o f = id(B) &
     i' o f = i & i o g = i')”)

val T24_ts_ex = proved_th $
e0
(strip_tac >> qexistsl_tac [‘A’,‘id(A)’] >> rw[])
(form_goal “!A. ?B i:B->A. T”)


val Rrefl = proved_th $
e0
(rpt strip_tac >> qexistsl_tac [‘id(B)’,‘id(B)’] >> 
 rw[idR,idL])
(form_goal 
 “∀B i:B->A. 
  ∃f:B ->B g:B->B. f o g = id(B) & g o f = id(B) &
    i o f = i & i o g = i”)


val Rsym = proved_th $
e0
(rpt strip_tac >> qexistsl_tac [‘g’,‘f’] >> arw[])
(form_goal 
“∀B i:B ->A B' i':B' -> A. 
 (∃f:B->B' g:B'->B.
  f o g = id(B') & g o f = id(B) &
  i' o f = i & i o g = i') ⇒ 
 (∃f:B'->B g:B->B'.
  f o g = id(B) & g o f = id(B') &
  i o f = i' & i' o g = i)”)


val Rtrans = proved_th $
e0
(rpt strip_tac >> qexistsl_tac [‘f' o f’,‘g o g'’] >> arw[] >>
 arw[GSYM o_assoc] >> 
 qsuff_tac
 ‘f' o (f o g) o g' = id(B'') & g o (g' o f') o f = id(B)’ 
 >-- rw[o_assoc] >>
 arw[idL,idR])
(form_goal 
“∀B i:B ->A B' i':B' -> A B'' i'':B''->A. 
 (∃f:B->B' g:B'->B.
  f o g = id(B') & g o f = id(B) &
  i' o f = i & i o g = i') & 
 (∃f:B'->B'' g:B''->B'.
  f o g = id(B'') & g o f = id(B') &
  i'' o f = i' & i' o g = i'') ⇒
 (∃f:B->B'' g:B''->B.
  f o g = id(B'') & g o f = id(B) &
  i'' o f = i & i o g = i'')”)


val T24_eqv = conjI Rrefl (conjI Rsym Rtrans)


val set_spec_eqv = T24_eqv |> gen_all


val set_spec_arg12eqr0 = 
([("B",ob_sort),("i",ar_sort (rastt "B") (rastt "A"))],
 [("B'",ob_sort),("i'",ar_sort (rastt "B'") (rastt "A"))],
 “(∃f:B->B' g:B'->B.
           f o g = id(B') & g o f = id(B) &
           i' o f = i & i o g = i':B'->A)”)


fun set_spec oriset sname iname fvs uexth = 
    let val cuexth = concl uexth 
        val (buexth,arg) = strip_exists cuexth 
        val (Q,_) = dest_conj buexth
        val argQ = (arg,Q) 
        val tenv = mk_tinst [(("A",ob_sort),oriset)]
        val arg12eqr = 
            (List.map (dest_var o (inst_term (vd_of tenv)) o mk_var) 
                      (#1 set_spec_arg12eqr0),
            List.map (dest_var o (inst_term (vd_of tenv)) o mk_var) 
                      (#2 set_spec_arg12eqr0),
            inst_form tenv (#3 set_spec_arg12eqr0))
        val eth = T24_ts_ex |> allE oriset
        val eqvth = set_spec_eqv |> allE oriset
    in new_spec argQ arg12eqr [sname,iname] fvs eth eqvth uexth
    end



  
