structure drule :> drule = 
struct
open term form logic 

fun simple_fail s = form.simple_fail ("drule."^s)

fun imp_trans th1 th2 = 
    let val (ant,cl) = dest_imp (concl th1)
    in disch ant (mp th2 (mp th1 (assume ant)))
    end

fun add_assum f th = mp (disch f th) (assume f)

fun undisch th = mp th (assume (#1(dest_imp (concl th))))

fun undisch_all th = 
    if is_imp (concl th) then undisch_all (undisch th) 
    else th

(**********************************************************************

A1 |- t1, A2 |- t2 
------------------------ prove_hyp
A1 u (A2 - {t1}) |- t2

**********************************************************************)

fun prove_hyp th1 th2 = mp (disch (concl th1) th2) th1
                        handle e => raise wrap_err "prove_hyp." e


fun equivT th = 
    let val (G,A,C) = dest_thm th
    in
        dimpI (disch C (trueI (C :: A)))
              (disch TRUE (add_assum TRUE th))
    end

fun frefl f = dimpI (disch f (assume f)) (disch f (assume f))

fun dimpl2r th = conjE1 (dimpE th)

fun dimpr2l th = conjE2 (dimpE th)

fun imp_iff th1 th2 = 
    let 
        val (G1,A1,C1) = dest_thm th1
        val (G2,A2,C2) = dest_thm th2
        val (a1,a2) = dest_dimp C1
        val (b1,b2) = dest_dimp C2
        val a12a2 = dimpl2r th1
        val a22a1 = dimpr2l th1
        val b12b2 = dimpl2r th2
        val b22b1 = dimpr2l th2
        val imp1 = mk_imp a1 b1
        val imp2 = mk_imp a2 b2
        val imp12imp2 = disch imp1 (imp_trans a22a1 (imp_trans (assume imp1) b12b2))
        val imp22imp1 = disch imp2 (imp_trans a12a2 (imp_trans (assume imp2) b22b1))
    in 
        dimpI imp12imp2 imp22imp1
    end


fun cj_imp1 pq = disch pq (conjE1 (assume pq))

fun cj_imp2 pq = disch pq (conjE2 (assume pq))


(*given |- A1 <=> A2 , |- B1 <=> B2, return |- A1 /\ B1 <=> A2 /\ B2, similar for other _iff thms*)

fun conj_iff th1 th2 = 
    let 
        val (G1,A1,C1) = dest_thm th1
        val (G2,A2,C2) = dest_thm th2
        val (a1,a2) = dest_dimp C1
        val (b1,b2) = dest_dimp C2
        val a12a2 = dimpl2r th1
        val a22a1 = dimpr2l th1
        val b12b2 = dimpl2r th2
        val b22b1 = dimpr2l th2
        val cj1 = mk_conj a1 b1
        val cj2 = mk_conj a2 b2
    in dimpI
            (disch cj1
                   (conjI 
                        (mp a12a2 (conjE1 (assume cj1)))
                        (mp b12b2 (conjE2 (assume cj1))))
            )
            (disch cj2
                   (conjI
                        (mp a22a1 (conjE1 (assume cj2)))
                        (mp b22b1 (conjE2 (assume cj2))))
            )
    end


fun disj_iff th1 th2 = 
    let 
        val (G1,A1,C1) = dest_thm th1
        val (G2,A2,C2) = dest_thm th2
        val (a1,a2) = dest_dimp C1
        val (b1,b2) = dest_dimp C2
        val a1ona2 = undisch (dimpl2r th1)
        val a2ona1 = undisch (dimpr2l th1)
        val b1onb2 = undisch (dimpl2r th2)
        val b2onb1 = undisch (dimpr2l th2)
        val dj1 = mk_disj a1 b1
        val dj2 = mk_disj a2 b2
        val a1ondj2 = disjI1 b2 a1ona2
        val b1ondj2 = disjI2 a2 b1onb2
        val dj12dj2 = disch dj1 
                            (disjE (assume dj1) a1ondj2 b1ondj2)
        val a2ondj1 = disjI1 b1 a2ona1
        val b2ondj1 = disjI2 a1 b2onb1
        val dj22dj1 = disch dj2
                            (disjE (assume dj2) a2ondj1 b2ondj1) 
    in 
        dimpI dj12dj2 dj22dj1
    end

fun neg_iff th = 
    let
        val (G,A,C) = dest_thm th
        val (a1,a2) = dest_dimp C
        val a1ona2 = undisch (dimpl2r th)
        val a2ona1 = undisch (dimpr2l th)
        val neg1 = mk_neg a1
        val neg2 = mk_neg a2
        val neg1a22F = negE a2ona1 (assume neg1)
        val neg2a12F = negE a1ona2 (assume neg2)
        val neg12neg2 = disch neg1 (negI a2 neg1a22F)
        val neg22neg1 = disch neg2 (negI a1 neg2a12F)
    in 
        dimpI neg12neg2 neg22neg1
    end


fun simple_exists (v as (n,s)) th = existsI v (mk_var v) (concl th) th


(*will be used in chained implication tactic*)

(*A /\ B ==> C <=> A ==> B ==> C*)

fun conj_imp_equiv A B C = 
    let val ab = mk_conj A B
        val ab2c = mk_imp ab C
        val a2b2c = mk_imp A (mk_imp B C)
        val conjabonc = mp (assume ab2c) (conjI (assume A) (assume B))
        val conj2imp = disch ab2c (disch A (disch B conjabonc))
        val abona = conjE1 (assume ab)
        val abonb = conjE2 (assume ab)
        val imp2conj = disch a2b2c (disch ab (mp (mp (assume a2b2c) abona) abonb))
    in dimpI conj2imp imp2conj
    end

(*A , A <=> B gives B. A <=> B , B gives A*)

fun dimp_mp_l2r A B =  mp (dimpl2r B) A
                          
fun dimp_mp_r2l B A =  mp (dimpr2l B) A

(*A /\ ¬A ==> B*)

fun contra2any A B = 
    let val na = mk_neg A
        val a_na = negE (assume A) (assume na)
        val F2b = disch FALSE (falseE [FALSE] B)
        val anaonb = mp F2b a_na
        val a2na2b = disch A (disch na anaonb)
    in dimp_mp_r2l (conj_imp_equiv A na B) a2na2b
    end

(*A \/ B <=> ¬A ==> B*)

fun disj_imp_equiv A B = 
    let val na = mk_neg A
        val imp = mk_imp na B
        val ana2b = contra2any A B
        val anaonb = undisch (undisch (dimp_mp_l2r ana2b (conj_imp_equiv A na B)))
        val aorbnaonb = disjE (assume (mk_disj A B)) anaonb (assume B)
        val disj2imp = disch (mk_disj A B) (disch na aorbnaonb)
        val t = tautI A 
        val aonaorb = disjI1 B (assume A)
        val impnaonaorb = disjI2 A (mp (assume imp) (assume na))
        val imp2disj = disch imp (disjE t aonaorb impnaonaorb)
    in
        dimpI disj2imp imp2disj
    end

fun disj_swap A B = 
    let val dj = mk_disj A B
        val aonbora = disjI2 B (assume A)
        val bonbora = disjI1 A (assume B)
    in disch dj (disjE (assume dj) aonbora bonbora)
    end

fun disj_comm A B = dimpI (disj_swap A B) (disj_swap B A)

fun double_neg f = 
    let val nf = mk_neg f
        val nnf = mk_neg nf
        val fnfonF = negE (assume f) (assume nf)
        val f2nnf = disch f (negI nf fnfonF)
        val nforf = dimp_mp_l2r (tautI f) (disj_comm f nf)
        val nnf2f = dimp_mp_l2r nforf (disj_imp_equiv nf f)
    in
        dimpI nnf2f f2nnf
    end

val conj_T = equivT (conjI (trueI []) (trueI []))

(* T /\ f <=> f; f /\ T <=> f; F /\ f <=> F ; f /\ F <=> f*)

fun T_conj1 f =
    let 
        val l2r = mk_conj TRUE f |> assume |> conjE2 
                          |> disch (mk_conj TRUE f)
        val r2l = assume f |> conjI (trueI []) |> disch f
    in dimpI l2r r2l
    end

fun T_conj2 f = dimpI (disch (mk_conj f TRUE) (conjE1 (assume (mk_conj f TRUE))))
                      (disch f (conjI (assume f) (trueI [])))

fun F_conj1 f = dimpI (disch (mk_conj FALSE f) (conjE1 (assume (mk_conj FALSE f))))
                      (disch FALSE (falseE [FALSE] (mk_conj FALSE f)))

fun F_conj2 f = dimpI (disch (mk_conj f FALSE) (conjE2 (assume (mk_conj f FALSE))))
                      (disch FALSE (falseE [FALSE] (mk_conj f FALSE)))

fun T_imp1 f =
    let val Timpf2f = disch (mk_imp TRUE f) (mp (assume (mk_imp TRUE f)) (trueI []))
        val f2Timpf = disch f (disch TRUE (add_assum TRUE (assume f)))
    in
        dimpI Timpf2f f2Timpf
    end

fun T_imp2 f = 
    let val f2T2T = disch (mk_imp f TRUE) (trueI [mk_imp f TRUE])
        val T2f2T = disch TRUE (disch f (trueI [f,TRUE]))
    in dimpI f2T2T T2f2T
    end

fun F_imp1 f = 
    let val F2f2T = disch (mk_imp FALSE f) (trueI [mk_imp FALSE f])
        val T2F2f = disch TRUE (disch FALSE (falseE [FALSE] f))
    in dimpI F2f2T T2F2f
    end

fun F_imp2 f = 
    let val nf2f2F = disch (mk_neg f) (disch f (negE (assume f) (assume (mk_neg f)))) 
        val f2F2nf = disch (mk_imp f FALSE) ((C negI) (mp (assume (mk_imp f FALSE)) (assume f)) f)
    in dimpI f2F2nf nf2f2F
    end

fun T_disj1 f = 
    let val Torf = mk_disj TRUE f
        val Torf2T = disch Torf (trueI [Torf]) 
        val T2Torf = disch TRUE (disjI1 f (assume TRUE))
    in dimpI Torf2T T2Torf
    end

fun T_disj2 f = 
    let val forT = mk_disj f TRUE
        val forT2T = disch forT (trueI [forT]) 
        val T2forT = disch TRUE (disjI2 f (assume TRUE))
    in dimpI forT2T T2forT
    end

fun F_disj1 f = 
    let val Forf = mk_disj FALSE f
        val Forf2f = disch Forf (disjE (assume Forf) (falseE [FALSE] f) (assume f))
        val f2Forf = disch f (disjI2 FALSE (assume f))
    in dimpI Forf2f f2Forf
    end


fun F_disj2 f = 
    let val forF = mk_disj f FALSE
        val forF2f = disch forF (disjE (assume forF) (assume f) (falseE [FALSE] f))
        val f2forF = disch f (disjI1 FALSE (assume f))
    in dimpI forF2f f2forF
    end

fun tautT f = 
    let val t = concl (tautI f)
        val t2T = disch t (trueI [t])
        val T2t = disch TRUE (add_assum TRUE (tautI f))
    in dimpI t2T T2t
    end

fun contraF f = 
    let val fnf = mk_conj f (mk_neg f)
        val fnf2F = disch fnf (negE (conjE1 (assume fnf)) (conjE2 (assume fnf)))
        val F2fnf = disch FALSE (falseE [FALSE] fnf)
    in dimpI fnf2F F2fnf
    end


fun T_dimp1 f = 
    let val Teqf = mk_dimp TRUE f
        val Teqf2f = disch Teqf (dimp_mp_l2r (trueI []) (assume Teqf))
        val f2Teqf = disch f (dimpI (disch TRUE (add_assum TRUE (assume f)))
                                    (add_assum f (disch f (trueI [f]))))
    in dimpI Teqf2f f2Teqf
    end

fun T_dimp2 f = 
    let val feqT = mk_dimp f TRUE
        val feqT2f = disch feqT (dimp_mp_r2l (assume feqT) (trueI []))
        val f2feqT = disch f (dimpI (add_assum f (disch f (trueI [f])))
                                    (disch TRUE (add_assum TRUE (assume f))))
    in dimpI feqT2f f2feqT
    end

fun F_dimp1 f = 
    let val Feqf = mk_dimp FALSE f
        val Feqf2nf = disch Feqf (negI f (dimp_mp_r2l (assume Feqf) (assume f)))
        val nf2Feqf = disch (mk_neg f) (dimpI (disch FALSE (add_assum (mk_neg f) (falseE [FALSE] f)))
                                     (disch f (negE (assume f) (assume (mk_neg f)))))
    in dimpI Feqf2nf nf2Feqf
    end

fun F_dimp2 f = 
    let val feqF = mk_dimp f FALSE
        val feqF2nf = disch feqF (negI f (dimp_mp_l2r (assume f) (assume feqF)))
        val nf2feqF = disch (mk_neg f) (dimpI (disch f (negE (assume f) (assume (mk_neg f))))
                                              (disch FALSE (add_assum (mk_neg f) (falseE [FALSE] f))))
    in dimpI feqF2nf nf2feqF
    end



fun forall_true (n,s) = 
    let val aT = mk_forall n s TRUE
        val G = HOLset.union(HOLset.add(essps,(n,s)),fvs s)
        val aT2T = disch aT (trueI [aT])
        val T2aT = disch TRUE (allI (n,s) (add_cont G (assume TRUE)))
    in dimpI aT2T T2aT
    end


fun forall_false (n,s) = 
    let val aF = mk_forall n s FALSE
        val G = HOLset.union(HOLset.add(essps,(n,s)),fvs s)
        val aF2F = disch aF ((C allE) (add_cont G (assume aF)) (mk_var(n,s)))
        val F2aF = disch FALSE (falseE [FALSE] aF)
    in dimpI aF2F F2aF
    end

(*?a:A->B.F <=> F *)

fun exists_false (n,s) = 
    let val F2eF = disch FALSE (falseE [FALSE] 
                                       (mk_exists n s FALSE))
        val eF2F = disch (mk_exists n s FALSE)
                         (existsE (n,s) (assume (mk_exists n s FALSE)) (assume FALSE))
    in
        dimpI eF2F F2eF
    end


fun iff_trans th1 th2 =
    let 
        val (G1,A1,C1) = dest_thm th1
        val (G2,A2,C2) = dest_thm th2
    in
        case (view_form C1,view_form C2) of 
            (vConn("<=>",[f1,f2]), vConn("<=>",[f3,f4])) => 
            if eq_form (f2,f3) then 
                let val f1f2 = conjE1 (dimpE th1)
                    val f2f1 = conjE2 (dimpE th1)
                    val f2f4 = conjE1 (dimpE th2)
                    val f4f2 = conjE2 (dimpE th2)
                    val f1f4 = imp_trans f1f2 f2f4
                    val f4f1 = imp_trans f4f2 f2f1
                in dimpI f1f4 f4f1
                end
            else 
                raise ERR ("iff_trans.two iffs do not match",[],[],[C1,C2])
          | _ => raise ERR ("iff_trans.not a pair of iffs",[],[],[C1,C2])
    end

fun iff_swap th = 
    let val Q2P = conjE2 (dimpE th)
        val P2Q = conjE1 (dimpE th)
    in dimpI Q2P P2Q
    end

(*P <=> P', Q <=> Q', gives (P <=> Q) <=> (P' <=> Q')*)

fun dimp_iff th1 th2 =
    let val (G1,A1,C1) = dest_thm th1
        val (G2,A2,C2) = dest_thm th2
    in
        case (view_form C1,view_form C2) of 
            (vConn("<=>",[P1,P2]), vConn("<=>",[Q1,Q2])) => 
            let val P1iffQ1 = mk_dimp P1 Q1
                val P2iffQ2 = mk_dimp P2 Q2
                val P1iffQ12P2iffQ2 = disch P1iffQ1 (iff_trans (iff_swap th1) (iff_trans (assume P1iffQ1) th2))
                val P2iffQ22P1iffQ1 = disch P2iffQ2 (iff_trans (iff_trans th1 (assume P2iffQ2)) (iff_swap th2))
            in dimpI P1iffQ12P2iffQ2 P2iffQ22P1iffQ1
            end
          | _ => raise ERR ("dimp_iff.not a pair of iff: ",[],[],[C1,C2])
    end



fun depends_on (n,s) t = HOLset.member(fvt t,(n,s))




fun exists_iff (n,s) th = 
    let
        val (G,A,C) = dest_thm th
        val (P,Q) = dest_dimp C
        val P2Q = undisch (conjE1 (dimpE th))
        val Q2P = undisch (conjE2 (dimpE th))
        val eP = mk_exists n s P
        val eQ = mk_exists n s Q
        val P2eQ = existsI (n,s) (mk_var (n,s)) Q P2Q
        val Q2eP = existsI (n,s) (mk_var (n,s)) P Q2P
        val eP2eQ = existsE (n,s) (assume eP) P2eQ |> disch eP
        val eQ2eP = existsE (n,s) (assume eQ) Q2eP |> disch eQ
    in dimpI eP2eQ eQ2eP
    end

(*F_IMP: ~f ==> f ==> F*)

fun F_imp f = assume f|> (C negE) (assume (mk_neg f)) |> disch f |> disch (mk_neg f)

(*theorems with fVars to be matched, to deal with propositional taut*)

val T_conj_1 = T_conj1 (mk_fvar "f0" [] [])
val T_conj_2 = T_conj2 (mk_fvar "f0" [] [])
val F_conj_1 = F_conj1 (mk_fvar "f0" [] [])
val F_conj_2 = F_conj2 (mk_fvar "f0" [] [])

val T_disj_1 = T_disj1 (mk_fvar "f0" [] [])
val T_disj_2 = T_disj2 (mk_fvar "f0" [] [])
val F_disj_1 = F_disj1 (mk_fvar "f0" [] [])
val F_disj_2 = F_disj2 (mk_fvar "f0" [] [])

val T_imp_1 = T_imp1 (mk_fvar "f0" [] [])
val T_imp_2 = T_imp2 (mk_fvar "f0" [] [])
val F_imp_1 = F_imp1 (mk_fvar "f0" [] [])
val F_imp_2 = F_imp2 (mk_fvar "f0" [] [])

val T_dimp_1 = T_dimp1 (mk_fvar "f0" [] [])
val T_dimp_2 = T_dimp2 (mk_fvar "f0" [] [])
val F_dimp_1 = F_dimp1 (mk_fvar "f0" [] [])
val F_dimp_2 = F_dimp2 (mk_fvar "f0" [] [])


fun forall_true_sort srt = forall_true (srt2ns srt)



fun exists_false_sort srt = 
    let val (ns as (n,s)) = srt2ns srt
    in exists_false ns
    end 

(*A \/ B ==> C  <=> A ==> C /\ B ==> C*)

fun disj_imp_distr1 A B C = 
    let val AorB = mk_disj A B
        val AorB2C = mk_imp AorB C
        val AonC = mp (assume AorB2C) (disjI1 B (assume A))
    in disch AorB2C (disch A AonC)
    end


fun disj_imp_distr2 A B C = 
    let val AorB = mk_disj A B
        val AorB2C = mk_imp AorB C
        val BonC = mp (assume AorB2C) (disjI2 A (assume B))
    in disch AorB2C (disch B BonC)
    end

fun imp_disj_distr A B C = 
    let val A2C = mk_imp A C
        val B2C = mk_imp B C
        val A2CandB2C = mk_conj A2C B2C
        val AorB = mk_disj A B
        val AonC = mp (conjE1 (assume A2CandB2C)) (assume A)
        val BonC = mp (conjE2 (assume A2CandB2C)) (assume B)
    in disch A2CandB2C (disch AorB (disjE (assume AorB) AonC BonC))
    end


fun disj_imp_distr A B C = 
    dimpI (disch (mk_imp (mk_disj A B) C)
               (conjI (undisch (disj_imp_distr1 A B C)) (undisch (disj_imp_distr2 A B C)))) (imp_disj_distr A B C)
  
fun disj_imp_distr_th th = 
    if is_imp (concl th)
    then 
        let val (PorQ,R) = dest_imp (concl th)
        in
            if is_disj PorQ then
                let val (P,Q)  = dest_disj PorQ 
                in
                    dimp_mp_l2r th (disj_imp_distr P Q R)
                end
            else raise ERR ("disj_imp_distr_th.antecedent is not a disjunction: ",[],[],[concl th])
        end
    else
        raise ERR ("disj_imp_distr_th.not a implication: ",[],[],[concl th])


(*(?x A) ==> B ==> A[y/x] ==> B*)

fun exists_imp x s y A B = 
    let val eA = mk_exists x s A
        val eA2B = mk_imp eA B
        val Ayx = substf ((x,s),y) A
        val AyxoneA = existsI (x,s) y A (assume Ayx) 
        val AyxonB = mp (assume eA2B) AyxoneA
    in  disch eA2B (disch Ayx AyxonB)
    end

val nT_equiv_F = 
    let val nT2F = disch (mk_neg TRUE) (negE (trueI []) (assume (mk_neg TRUE)))
        val F2nT = disch FALSE (falseE [FALSE] (mk_neg TRUE))
    in dimpI nT2F F2nT
    end





fun eqT_intro_form f = 
    let val f2feqT = disch f (dimpI (disch f (trueI [f,f]))
                                    (disch TRUE (add_assum TRUE (assume f))))
        val feqT2f = disch (mk_dimp f TRUE) (dimp_mp_r2l (assume (mk_dimp f TRUE)) (trueI []))
    in
        dimpI f2feqT feqT2f
    end
                           
fun eqT_intro th = dimp_mp_l2r th (eqT_intro_form (concl th)) 

fun eqF_intro_form f = 
    let 
        val nF2feqF = disch (mk_neg f)
                            (dimpI (disch f (negE (assume f) (assume (mk_neg f))))
                                   (disch FALSE
                                                 (add_assum (mk_neg f) (falseE [FALSE] f))))
        val Feqf2nF = disch (mk_dimp f FALSE) 
                            (negI f (dimp_mp_l2r (assume f) (assume (mk_dimp f FALSE))))
    in 
        dimpI nF2feqF Feqf2nF
    end

fun eqF_intro th = 
    case (view_form (concl th)) of
        vConn("~",[f]) => dimp_mp_l2r th (eqF_intro_form f)
      | _ => raise ERR ("eqF_intro.conclusion is not an negation: ",[],[],[concl th]) 
   
(**********************************************************************

specl: if bounded variable name clash with existing variable, then add a " ' "

**********************************************************************)

fun specl l th = 
    case l of [] => th 
            | h :: t => if is_forall (concl th) then 
                            let val f1 = allE h th  
                            in 
                                specl t f1
                            end
                        else raise ERR ("specl.thm is not universally quantified",[],[],[concl th])


fun spec_all th = 
    let 
        val fv = cont th
        val v2bs = snd (strip_forall (concl th))
        val v2bs' = List.map (pvariantt fv) (List.map mk_var v2bs)
    in 
        specl v2bs' th
    end



(**********************************************************************

gen_all:to quantify over a term, we just need to make sure that all of 
the variables which appears in it has already be quantified.

**********************************************************************)

open SymGraph

fun depends_t (ns as (n,s)) t = 
    case view_term t of 
        vVar(n1,s1) => 
        n = n1 andalso s = s1
        orelse depends_s ns s1
      | vFun(f,s1,l) => depends_s ns s1 
                       orelse List.exists (depends_t ns) l 
      | _ => false
and depends_s (ns as (n,s)) sort = 
    case dest_sort sort of
        (sn,tl) => List.exists (depends_t ns) tl

fun edges_from_fvs1 (ns as (n:string,s:sort)) l = 
    case l of [] => []
            | h :: t => 
              if depends_t ns (mk_var h) then 
                  (ns,h) :: edges_from_fvs1 ns t
              else edges_from_fvs1 ns t

fun edges_from_fvs0 nss = 
    let val l = HOLset.listItems nss
    in List.foldr 
           (fn (ns,l0) => (edges_from_fvs1 ns l) @ l0) [] l 
    end

fun edges_from_fvs nss = 
    List.filter
        (fn ((n1,s1),(n2,s2)) => 
            n1 <> n2 orelse not $ s1 = s2) (edges_from_fvs0 nss)


fun order_of_fvs f = 
    let val nss = fvf f
        val g0 = HOLset.foldr (fn ((n,s),g) => new_node (n,s) g) empty nss
        val g = List.foldr (fn (((n1,_),(n2,_)),g) => 
                               add_edge (n1,n2) g) g0 (edges_from_fvs nss)
    in topological_order g
    end

fun order_of nss = 
    let 
        val g0 = HOLset.foldr (fn ((n,s),g) => new_node (n,s) g) empty nss
        val g = List.foldr (fn (((n1,_),(n2,_)),g) => 
                               add_edge (n1,n2) g) g0 (edges_from_fvs nss)
    in topological_order g
    end

fun abstl l th = 
    case l of 
        [] => th
      | (n,s) :: t => allI (n,s) (abstl t th)

fun find_var l n = 
    case l of 
        [] => raise simple_fail ("variable with name: " ^ n ^ " is not found")
      | h :: t => 
        if fst h = n then h 
        else find_var t n

fun genl vsl th = 
    let
        val ovs = order_of ((foldr (uncurry (C (curry HOLset.add)))) essps vsl)
        val vl = List.map (find_var vsl) ovs
    in 
        abstl vl th
    end


fun simple_genl vsl th = 
    case  vsl of 
        [] => th
      | h :: t => allI h (simple_genl t th) 


fun gen_all th = 
    let 
        val vs = HOLset.difference
                     (fvf (concl th), fvfl (ant th))
        val vsl = HOLset.listItems vs
        val ovs = order_of vs
        val vl = List.map (find_var vsl) ovs
    in 
        abstl vl th
    end

fun dischl l th = 
    case l of 
        [] => th
      | h :: t => dischl t (disch h th)

fun disch_all th = dischl (ant th) th


fun gen_dischl l th = 
    case l of 
        [] => th
      | h :: t => gen_dischl t (gen_all th |> disch h)

fun gen_disch_all th = gen_dischl (ant th) th


(*f1,f2 |- C maps to f1 /\ f2 |- C*)

fun conj_assum f1 f2 th = 
    let 
        val (G,A,C) = dest_thm th
        val _ = fmem f1 A orelse raise ERR ("conj_assum.first formula not in assumption: ",[],[],[f1])
        val _ = fmem f2 A orelse raise ERR ("conj_assum.second formula not in assumption: ",[],[],[f2])
        val th1 = disch f1 (disch f2 th)
    in mp (mp th1 (conjE1 (assume (mk_conj f1 f2))))
          (conjE2 (assume (mk_conj f1 f2)))
    end

fun conj_all_assum th = 
    case ant th of 
        [] => th
       |[h] => th
       | h1 :: h2 :: t => conj_all_assum (conj_assum h1 h2 th)

(*~f |-> f ==> F*)

fun notf_f2F f = 
    let val d1 = negE (assume f) (assume (mk_neg f))|> disch f |> disch (mk_neg f)
        val d2 = (assume (mk_imp f FALSE)) |> undisch |> negI f|> disch (mk_imp f FALSE)
    in
        dimpI d1 d2
    end

fun strip_neg th = 
    case view_form (concl th) of 
        (vConn("~",[f])) => dimp_mp_l2r th (notf_f2F f)
      | _ => th


(*F2f f = |-F ⇒ f *)

fun F2f f = disch FALSE (falseE [FALSE] f)

(*for a th with concl FALSE, A |- F. 
CONTR f th = A |- f
*)

fun contr f th =
    if eq_form(concl th,FALSE) then
        mp (F2f f) th else 
    raise ERR ("contr.input theorem not a FALSE",[],[],[concl th])

fun double_neg_th th = 
    dimp_mp_r2l (double_neg (concl th)) th

fun elim_double_neg th = 
    dimp_mp_l2r th (double_neg(dest_neg (dest_neg (concl th)))) 

fun exists_forall (n,s) = 
    let 
        val f0 = mk_fvar "f0" [] []
        val af0 = mk_forall n s (mk_neg f0)
        val ef0 = mk_exists n s f0
        val d1 = (C negI)
                     (existsE (n,s) (assume ef0)
                 (negE (assume f0) 
                   ((C allE) (assume af0) (mk_var(n,s)))))
                 af0 |>
                 disch ef0
        val d2 = elim_double_neg
                     ((C negI)
                          (negE
                               (allI (n,s)
                                     ((C negI)
                                          (negE
                                               (existsI (n,s) (mk_var(n,s)) f0 ((C add_cont) (assume f0) (HOLset.add(essps,(n,s))))
                                                        )
                                               (assume (mk_neg ef0)))
                                          f0))
                               (assume (mk_neg af0))
)
                          (mk_neg ef0))|>
                     disch (mk_neg af0)
    in dimpI d1 d2
    end

fun split_assum f th = 
    if fmem f (ant th) then
        case view_form f of (vConn("&",[f1,f2])) => 
                  th |> disch f |> (C mp) (conjI (assume f1) (assume f2))
                | _ =>  raise ERR ("split_assum.not a conjunction: ",[],[],[f])
    else raise ERR ("split_assum.formula not in assumption list",[],[],[f])

(*~F <=> T and also ~T <=> F*)

val nF2T = 
    let val l2r = trueI [mk_neg FALSE] |> disch_all
        val r2l = assume FALSE |> add_assum TRUE |> negI FALSE |> disch_all
    in dimpI l2r r2l
    end

val nT2F = 
    let val l2r = assume (mk_neg TRUE) |> negE (trueI []) |> disch_all
        val r2l = falseE [FALSE] (mk_neg TRUE) |> disch_all
    in dimpI l2r r2l
    end

val double_neg_elim = double_neg (mk_fvar "f0" [] [])


(*
fun forall_exists (n,s) = 
    let val th0 = exists_forall (n,s) |> neg_iff |> inst_thm (mk_inst [] [("f0",mk_neg (mk_fvar "f0"))]) 
        val rhs1 = double_neg (mk_fvar "f0") |> forall_iff (n,s)
        val rhs2 = double_neg (mk_forall n s (mk_neg (mk_neg (mk_fvar "f0"))))
        val rhs = iff_trans rhs2 rhs1
        val th0' = iff_trans th0 rhs
    in iff_swap th0'
    end
*)


fun strip_all_and_imp th = 
    if is_forall (concl th) then 
        strip_all_and_imp (spec_all th)
    else if is_imp (concl th) then 
        strip_all_and_imp (undisch th)
    else th

fun contrapos impth =
      let
         val (ant, conseq) = dest_imp (concl impth)
         val notb = mk_neg conseq
      in
         disch notb
           (dimp_mp_l2r 
                  (disch ant (mp (assume notb |> eqF_intro |> dimpl2r) (mp impth (assume ant)))) (F_imp2 ant))
      end
      handle e => raise wrap_err "contrapos." e

fun pe_cl1 (n,s) = 
    let 
        val P = mk_fvar "f0" [] []
        val ef = mk_exists n s P
        val Q = mk_fvar "f1" [] []
        val lhs = mk_imp ef Q 
        val Px2Q = mk_imp P Q
        val rhs = mk_forall n s Px2Q
        val l2r = assume P
                 |> add_cont (HOLset.add(essps,(n,s)))
                 |> existsI (n,s) (mk_var(n,s)) P 
                 |> mp (assume lhs) 
                 |> disch P |> allI (n,s) 
                 |> disch lhs
        val r2l = assume rhs |> allE (mk_var(n,s)) 
                         |> C mp $ assume P
                         |> existsE (n,s) (assume ef) 
                         |> disch ef |> disch rhs
    in dimpI l2r r2l
    end

(*(∃x. P x) ∧ Q ⇔ ∃x. P x ∧ Q*)

fun pe_cl2 (n,s) = 
    let
        val P = mk_fvar "f0" [] []
        val Q = mk_fvar "f1" [] []
        val eP = mk_exists n s P
        val lhs = mk_conj eP Q
        val PxQ = mk_conj P Q
        val rhs = mk_exists n s PxQ
        val l2r = assume P
                 |> existsE (n,s) (assume eP)
                 |> C conjI (assume Q) 
                 |> conj_assum eP Q
                 |> existsI (n,s) (mk_var(n,s)) PxQ
                 |> disch lhs
        val r2l = assume P 
                 |> existsI (n,s) (mk_var(n,s)) P
                 |> C conjI (assume Q)
                 |> conj_assum P Q
                 |> existsE (n,s) (assume rhs)
                 |> disch rhs
    in dimpI l2r r2l
    end

fun pe_cl3 (n,s) = 
    let
        val P = mk_fvar "f0" [] []
        val Q = mk_fvar "f1" [] []
        val eP = mk_exists n s P
        val lhs = mk_conj Q eP
        val QxP = mk_conj Q P
        val rhs = mk_exists n s QxP
        val l2r = assume P
                 |> existsE (n,s) (assume eP)
                 |> conjI (assume Q) 
                 |> conj_assum Q eP
                 |> existsI (n,s) (mk_var(n,s)) QxP
                 |> disch lhs
        val r2l = assume P 
                 |> existsI (n,s) (mk_var(n,s)) P
                 |> conjI (assume Q)
                 |> conj_assum Q P
                 |> existsE (n,s) (assume rhs)
                 |> disch rhs
    in dimpI l2r r2l
    end

fun mk_conjl fl = 
    case fl of h :: t =>
    if eq_forml t [] then h else 
    mk_conj h (mk_conjl t)
  | _ => raise simple_fail "mk_conjl.list is empty"


fun mk_disjl fl = 
    case fl of h :: t =>
    if eq_forml t [] then h else 
    mk_disj h (mk_disjl t)
  | _ => raise simple_fail "mk_disjl.list is empty"

fun conjIl thl = 
    case thl of h :: t =>
    if length t = 0 then h else 
    conjI h (conjIl t)
  | _ => raise simple_fail "mk_conjIl.list is empty"

fun split_assum0 f th = 
    if fmem f (ant th) then
        case view_form f of (vConn("&",[f1,f2])) => 
                  th |> disch f |> (C mp) (conjI (assume f1) (assume f2))
                | _ =>  raise ERR ("split_assum0.not a conjunction: ",[],[],[f])
    else raise ERR ("split_assum0.formula not in assumption list",[],[],[f])

fun split_assum th = 
    let fun f _ f0 = if is_conj f0 then SOME f0 else NONE
    in
        case first_opt f (ant th) of
            NONE => raise simple_fail "split_assum.no conjunction"
          | SOME cj0 => split_assum0 cj0 th
    end


(*---------------------------------------------------------------------------*
 *       A,t1 |- t2                A,t |- F                                  *
 *     --------------              --------                                  *
 *     A |- t1 ==> t2               A |- ~t                                  *
 *---------------------------------------------------------------------------*)

fun neg_disch t th =
   if eq_form(concl th,FALSE) then negI t th 
   else disch t th



(* (A & B) & C <=> A & B & C*)

fun conj_assoc A B C = 
    let
        val AB = mk_conj A B
        val BC = mk_conj B C
        val ABC1 = mk_conj AB C
        val ABC = mk_conj A BC
        val l2r = conjI (assume ABC1 |> conjE1 |> conjE1)
                        (conjI (assume ABC1 |> conjE1 |> conjE2)
                               (assume ABC1 |> conjE2)) |> disch_all
        val r2l = conjI (conjI (assume ABC |> conjE1)
                               (assume ABC |> conjE2 |> conjE1))
                        (assume ABC |> conjE2 |> conjE2) |> disch_all
    in 
        dimpI l2r r2l
    end

val CONJ_ASSOC = conj_assoc (mk_fvar "A" [] []) (mk_fvar "B" [] []) (mk_fvar "C" [] [])

(*A /\ B ==> C <=> A ==> B ==> C*)

val CONJ_IMP_IMP = conj_imp_equiv (mk_fvar "A" [] []) (mk_fvar "B" [] []) (mk_fvar "C" [] [])

(* ~(A /\ B) <=> A ==> ~B*)

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


fun forall_iff (n,s) th = 
    let val (G,A,C0) = dest_thm th
    in
        case view_form C0 of 
            vConn("<=>",[P,Q]) => 
            let val allP = mk_forall n s P
                val allQ = mk_forall n s Q
                val allP2allQ = disch allP (allI (n,s) (dimp_mp_l2r ((C allE) (assume allP) (mk_var(n,s))) th))
                val allQ2allP = disch allQ (allI (n,s) (dimp_mp_r2l th ((C allE) (assume allQ) (mk_var(n,s)))))
        in
            dimpI allP2allQ allQ2allP
        end
      | _ => raise ERR ("all_iff.conclusion of theorem is not an iff:",[],[],[C0])
    end



fun forall_iff (n,s) th = 
    let val (G,A,C0) = dest_thm th
    in
        case view_form C0 of 
            vConn("<=>",[P,Q]) => 
            let val _ = not $ HOLset.member(fvfl A,(n,s)) orelse
                        raise simple_fail "forall_iff.variable to be abstract occurs in assumption" 
                val G0 = HOLset.delete(G,(n,s)) handle _ => G
                val _ = case HOLset.find 
                                 (fn (n0,s0) => depends_on (n,s) (mk_var (n0,s0))) G0 of 
                            NONE => ()
                          | SOME _ => 
                            raise simple_fail
                                  "variable to be abstract occurs in context" 
                val G1 = HOLset.union(G0,fvs s)
            in mk_thm(G1,A,mk_dimp (mk_forall n s P) (mk_forall n s Q))
            end
          | _ => raise ERR ("all_iff.conclusion of theorem is not an iff:",[],[],[C0])
    end

fun exists_iff (n,s) th = 
    let
        val (G,A,C) = dest_thm th
        val (P,Q) = dest_dimp C
        val P2Q = undisch (conjE1 (dimpE th))
        val Q2P = undisch (conjE2 (dimpE th))
        val eP = mk_exists n s P
        val eQ = mk_exists n s Q
        val P2eQ = existsI (n,s) (mk_var(n,s)) Q P2Q
        val Q2eP = existsI (n,s) (mk_var(n,s)) P Q2P
        val eP2eQ = existsE (n,s) (assume eP) P2eQ |> disch eP
        val eQ2eP = existsE (n,s) (assume eQ) Q2eP |> disch eQ
    in dimpI eP2eQ eQ2eP
    end


fun uex_iff (n,s) th = 
    let
        val (G,A,C) = dest_thm th
        val (P,Q) = dest_dimp C
        val ueP = mk_uex n s P
        val ueQ = mk_uex n s Q
        val uePdef = uex_def ueP
        val PR = snd o dest_dimp o concl $ uePdef
        val (_,PRb) = dest_exists PR
        val ueQdef = uex_def ueQ
        val QR = snd o dest_dimp o concl $ ueQdef
        val (_,QRb) = dest_exists QR
        val (n',s') = dest_var (pvariantt G (mk_var(n^"'",s)))
        val dimp0 = imp_iff 
                   (inst_thm (mk_inst [((n,s),mk_var(n',s'))] []) th)
                   (frefl (mk_eq (mk_var(n',s')) (mk_var(n,s))))
        val dimp1 = forall_iff (n',s') dimp0
        val dimp2 = conj_iff th dimp1
        val dimp3 = exists_iff (n,s) dimp2
        val dimp4 = iff_trans (iff_trans uePdef dimp3) (iff_swap ueQdef)
    in
        dimp4
    end



val CONJ_COMM = 
    let val p = mk_fvar "P" [] []
        val q = mk_fvar "Q" [] []
        val lhs = mk_conj p q
        val rhs = mk_conj q p
        val l2r = conjI (assume lhs |> conjE2) (assume lhs |> conjE1) 
                        |> disch lhs
        val r2l = conjI (assume rhs |> conjE2) (assume rhs |> conjE1) 
                        |> disch rhs
    in
        dimpI l2r r2l
    end



(*
fun fVar_sInst_th f f' th = 
    let val (P,args) = dest_fvar f
        val vl = List.map dest_var args
    in fVar_Inst_th (P,(vl,f')) th
    end

*)

fun eq_sym a = 
    if mem a (!EqSorts) then 
        let val ns0 = srt2ns a
            val v1 = mk_var ns0
            val v2 = pvariantt (HOLset.add(essps,ns0)) v1
            val v1v2 = mk_eq v1 v2
            val v2v1 = mk_eq v2 v1
            val l2r = assume v1v2 |> sym|> disch_all
            val r2l = assume v2v1 |> sym|> disch_all
        in dimpI l2r r2l
        end
    else raise ERR ("eq_sym.input sort: " ^ a ^ " does not have equality",
                    [],[],[])


fun uex_expand th = dimp_mp_l2r th (uex_def $ concl th)

fun uex_ex f = 
    let val th0 = dimpl2r $ uex_def f |> undisch
        val c0 = concl th0
        val ((n,s),b) = dest_exists c0
        val th1 = assume b |> conjE1 
        val th2 = existsI (n,s) (mk_var(n,s)) (concl th1) th1
        val th3 = existsE (n,s) th0 th2
    in disch f th3
    end

fun uex2ex_rule th = mp (uex_ex $concl th) th




fun ex_P_ex f = 
    let val ((n,s),b) = dest_exists f 
        val th0 = trueI [] |> add_cont (HOLset.add(essps,(n,s)))
                        |> existsI (n,s) (mk_var(n,s)) TRUE
                        |> existsE (n,s) (assume f)
                        |> disch f
    in th0
    end




fun uex_expand' th = 
    let val th0 = uex_expand th 
        val (ns0,b0) = dest_exists (concl th0) 
        val (c1,c2) = dest_conj b0 
        val (ns',b') = dest_forall c2 
        val (ante,conclu) = dest_imp b' 
        val (t1,t2) = dest_eq conclu
        val sconcluth =  
            dimpI (assume conclu|> sym |> disch_all) (assume (mk_eq t2 t1) |> sym |> disch_all)
        val impth = imp_iff (frefl ante) sconcluth
        val forallth = forall_iff ns' impth
        val conjth = conj_iff (frefl c1) forallth 
        val existth = exists_iff ns0 conjth 
    in dimp_mp_l2r th0 existth
    end

fun EQ_fvar p vl thml = fvar_cong p vl vl thml 


fun fVar_prpl_th1 (P,sl,fm) = 
fVar_prpl_th (Binarymap.insert(Binarymap.mkDict(pair_compare String.compare (list_compare sort_compare)),(P,sl),fm))



end
