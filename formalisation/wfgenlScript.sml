open HolKernel Parse boolLib bossLib;

val _ = new_theory "wfgenl";


Definition mk_FALLL_def:
mk_FALLL [] b = b ∧
mk_FALLL ((n,s) :: vl) b = mk_FALL n s (mk_FALLL vl b)
End




Theorem mk_FALL_FALLL0:
∀k n s sl b i. LENGTH sl = k ⇒ 
(fabs (n,s) i (FALLL sl b)) =
 FALLL (abssl (n,s) i sl) (fabs (n,s) (i + LENGTH sl) b)
Proof
Induct_on ‘k’ >> Cases_on ‘sl’ >> gs[FALLL_def,abssl_def] >>
rw[] >> simp[fabs_def,arithmeticTheory.ADD1]
QED

 
        
Theorem fVslfv_mk_FALL:
fVslfv (mk_FALL n s b) = fVslfv b
Proof
rw[mk_FALL_def,fVslfv_fabs,abst_def,fVslfv_def,fVars_def,fVars_fabs]
QED


Theorem fVslfv_mk_FALLL:
∀k vl f. LENGTH vl = k ⇒
fVslfv (mk_FALLL vl f) = fVslfv f
Proof
Induct_on ‘k’ >> Cases_on ‘vl’ >> simp[mk_FALLL_def] >>
Cases_on ‘h’ >> gs[mk_FALLL_def,fVslfv_mk_FALL]
QED




Theorem DIFF_of_UNION:
(A ∪ B) DIFF C = A DIFF C ∪ B DIFF C
Proof
rw[EXTENSION] >> metis_tac[]
QED
        




Definition absvl_def:
absvl i v [] = [] ∧
absvl i v ((n:string,s) :: t) = 
(n,sabs v i s) :: (absvl (i+1) v t)
End

Definition vl2sl0_def:
  vl2sl0 [] = [] ∧
  vl2sl0 (v :: vs) = v :: absvl 0 v (vl2sl0 vs)
End

Definition vl2sl_def:
  vl2sl vl = MAP SND (vl2sl0 vl)
End


Theorem fVars_mk_FALL:
fVars (mk_FALL n s b) = fVars b
Proof
simp[mk_FALL_def,fVars_fabs,abst_def,fVars_def]
QED


Theorem fVars_mk_FALLL:
∀vl b. fVars (mk_FALLL vl b) = fVars b
Proof
Induct_on ‘vl’ >> gs[mk_FALLL_def,fVars_mk_FALL] >>
rw[] >> Cases_on ‘h’ >> simp[mk_FALLL_def,fVars_mk_FALL]
QED




(*parallel variable to bound*)
Definition tpv2b_def:
(tpv2b v2b (Var n s) = if (n,s) ∈ FDOM v2b then Bound (v2b ' (n,s))
                     else Var n s) ∧
(tpv2b v2b (Fn f s tl) =
Fn f (spv2b v2b s) (MAP (tpv2b v2b) tl)) ∧
(tpv2b v2b (Bound i) = Bound i) ∧
spv2b v2b (St n tl) = St n (MAP (tpv2b v2b) tl)
Termination
WF_REL_TAC
   ‘measure
    (λs. case s of
           INL (_,t) => term_size t
         | INR (_,st) => sort_size st)’   
End



(*parallel variable to bound*)

           
Definition vpv2b_def:
(vpv2b v2b (n,s) = if (n,s) ∈ FDOM v2b then Bound (v2b ' (n,s))
                     else Var n s)
End                     


                
Definition mk_v2b_def:
mk_v2b vl = TO_FMAP (ZIP (vl,COUNT_LIST (LENGTH vl)))
End


Theorem FAPPLY_mk_v2b:
ALL_DISTINCT vl ⇒
∀n. n < LENGTH vl ⇒ (mk_v2b vl) ' (EL n vl) = n
Proof
rw[mk_v2b_def] >> irule TO_FMAP_MEM >>
simp[MEM_EL,PULL_EXISTS] >> qexists ‘n’ >>
‘LENGTH (COUNT_LIST (LENGTH vl)) = LENGTH vl’
 by simp[rich_listTheory.LENGTH_COUNT_LIST] >>
pop_assum $ assume_tac o GSYM >>  
drule_then assume_tac EL_ZIP >>
first_x_assum $ drule_then assume_tac >> gs[] >>
simp[rich_listTheory.EL_COUNT_LIST] >>
‘(MAP FST (ZIP (vl,COUNT_LIST (LENGTH vl)))) = vl’
 suffices_by metis_tac[] >>
‘ MAP (I ∘ FST) (ZIP (vl,COUNT_LIST (LENGTH vl))) = MAP I vl’
 by (irule $ cj 3 MAP_ZIP >> simp[]) >> gs[]
QED 




(*
Definition mk_v2b_def:
mk_v2b vl = TO_FMAP (ZIP (REVERSE vl,COUNT_LIST (LENGTH vl)))
End


Theorem FAPPLY_mk_v2b:
ALL_DISTINCT vl ⇒
∀n. n < LENGTH vl ⇒ (mk_v2b vl) ' (EL n vl) = LENGTH vl - SUC n
Proof
rw[mk_v2b_def] >> irule TO_FMAP_MEM >>
simp[MEM_EL,PULL_EXISTS] >> qexists ‘LENGTH vl - SUC n’ >>
‘LENGTH (COUNT_LIST (LENGTH vl)) = LENGTH (REVERSE vl)’
 by simp[rich_listTheory.LENGTH_COUNT_LIST] >>
pop_assum $ assume_tac o GSYM >>  
drule_then assume_tac EL_ZIP >>
first_x_assum $ drule_then assume_tac >> gs[] >>
simp[rich_listTheory.EL_COUNT_LIST] >>
‘(MAP FST (ZIP (vl,COUNT_LIST (LENGTH vl)))) = vl’
 suffices_by metis_tac[] >>
‘ MAP (I ∘ FST) (ZIP (vl,COUNT_LIST (LENGTH vl))) = MAP I vl’
 by (irule $ cj 3 MAP_ZIP >> simp[]) >> gs[]
QED 
*)

        
Definition fpv2b_def:
fpv2b v2b (Pred p tl) = Pred p (MAP (tpv2b v2b) tl) ∧
fpv2b v2b (IMP f1 f2) = IMP (fpv2b v2b f1) (fpv2b v2b f2) ∧
fpv2b v2b (fVar p sl tl) = fVar p sl (MAP (tpv2b v2b) tl) ∧
fpv2b v2b (FALL s b) = FALL (spv2b v2b s) (fpv2b v2b b)
End


(*        
Theorem mk_FALLL_FALLL:
  wfabsvlof Σ vl f ⇒
  mk_FALLL vl ( = FALLL (vl2sl vl) (
Proof
*)


Theorem vl2sl_EMPTY:
vl2sl [] = []
Proof
simp[vl2sl_def,vl2sl0_def]
QED 


Theorem TAKE_LAST:
l ≠ [] ⇒ TAKE (LENGTH l − 1) l ⧺ [LAST l] = l
Proof
rw[] >>
‘LENGTH l ≠ 0’ by simp[] >>
‘1 + (LENGTH l - 1) = LENGTH l’ by simp[] >>
drule_then assume_tac rich_listTheory.APPEND_TAKE_LASTN >>
drule_then assume_tac rich_listTheory.LASTN_1 >> gs[]
QED

Theorem mk_FALL_FALLL:
mk_FALL n s (FALLL sl b) =
FALLL (s :: (abssl (n,s) 0 sl)) (fabs (n,s) (LENGTH sl) b)
Proof
qspecl_then [‘LENGTH sl’,‘n’,‘s’,‘sl’,‘b’,‘0’] assume_tac
mk_FALL_FALLL0 >> gs[mk_FALL_def,abst_def] >>
simp[FALLL_def]
QED

Theorem MAP_SND_absvl0:
∀k l v i. LENGTH l = k ⇒
          MAP SND (absvl i v l) = abssl v i (MAP SND l)
Proof
Induct_on ‘k’
>- (rw[] >> Cases_on ‘v’ >> simp[absvl_def,abssl_def])
>- (Cases_on ‘l’ >>  gs[] >> Cases_on ‘v’ >>  Cases_on ‘h’ >> 
   simp[absvl_def,abssl_def])
QED   


Theorem MAP_SND_absvl:
∀l v i. MAP SND (absvl i v l) = abssl v i (MAP SND l)
Proof
rw[] >>
qspecl_then [‘LENGTH l’,‘l’,‘v’,‘i’] assume_tac MAP_SND_absvl0 >>
gs[]
QED   


      
Theorem vl2sl_CONS:
vl2sl (v :: vl) = (SND v) :: (abssl v 0 (vl2sl vl))
Proof
Cases_on ‘v’ >> simp[vl2sl_def,vl2sl0_def] >>
Cases_on ‘vl’
>- simp[vl2sl0_def,absvl_def,abssl_def] >>
simp[vl2sl0_def,absvl_def] >> Cases_on ‘h’ >>
simp[absvl_def] >> simp[abssl_def] >>
simp[MAP_SND_absvl]
QED


Theorem LENGTH_absvl:
∀i v.LENGTH (absvl i v l) = LENGTH l
Proof        
Induct_on ‘LENGTH l’ >> rw[] >> gs[absvl_def] >>
Cases_on ‘l’
>- simp[absvl_def] >>
Cases_on ‘v'’ >> simp[absvl_def] >> gs[] >>
Cases_on ‘h’ >> simp[absvl_def]
QED

Theorem LENGTH_vl2sl0:
LENGTH (vl2sl0 l) = LENGTH l
Proof
Induct_on ‘LENGTH l’ >> gs[vl2sl0_def] >>
Cases_on ‘l’ >- gs[] >>
gs[] >> simp[vl2sl0_def,LENGTH_absvl]
QED 

Theorem LENGTH_vl2sl:
∀l.LENGTH (vl2sl l) = LENGTH l
Proof
strip_tac >> Induct_on ‘LENGTH l’ >> rw[vl2sl_def,vl2sl0_def] >>
Cases_on ‘l’ >> gs[] >> Cases_on ‘h’ >>
rw[vl2sl_def,vl2sl0_def] >> simp[LENGTH_absvl] >>
simp[LENGTH_vl2sl0]
QED



Theorem tabs_tpv2b:
(∀tm v2b n s i.
   (n,s) ∉ FDOM v2b ⇒
   tabs (n,s) i (tpv2b v2b tm) =
   tpv2b (v2b |+ ((n,s),i)) tm) ∧
(∀st v2b n s i.
   (n,s) ∉ FDOM v2b ⇒ 
   sabs (n,s) i (spv2b v2b st) =
   spv2b (v2b |+ ((n,s),i)) st)   
Proof   
ho_match_mp_tac better_tm_induction>>
gs[tabs_def,tpv2b_def,MAP_MAP_o,MAP_EQ_f] >> rw[] >>
Cases_on ‘(s0,st) ∈ FDOM v2b’ >> gs[tabs_def,FAPPLY_FUPDATE_THM]
(* 2 *)
>-  (‘¬(s0 = n ∧ st = s)’ by (CCONTR_TAC >> gs[]) >>simp[]) >>
Cases_on ‘n = s0 ∧ s = st’ >> simp[] >>
Cases_on ‘ s0 = n ∧ st = s’ >> simp[] >> gs[]
QED



Theorem vpv2b_tpv2b:
vpv2b v2b (n,s) = tpv2b v2b (Var n s)
Proof
rw[vpv2b_def,tpv2b_def]
QED
        
        
Theorem FDOM_mk_v2b:
FDOM (mk_v2b l) = set l
Proof
simp[mk_v2b_def,FDOM_TO_FMAP] >> 
‘LENGTH l  = LENGTH (COUNT_LIST (LENGTH l))’
 by simp[rich_listTheory.LENGTH_COUNT_LIST] >>
AP_TERM_TAC >>
‘ MAP (I o FST) (ZIP (l,COUNT_LIST (LENGTH l))) = MAP I l’
 suffices_by simp[] >>
irule $ cj 3 MAP_ZIP >> simp[] 
QED 


Theorem FAPPLY_mk_v2b_APPEND:
n < LENGTH l1 ∧ ALL_DISTINCT (l1 ++ l2) ⇒
mk_v2b (l1 ++ l2) ' (EL n l1) = mk_v2b l1 ' (EL n l1)
Proof
rw[]>>
‘ALL_DISTINCT l1’ by gs[ALL_DISTINCT_APPEND] >>
drule_then assume_tac FAPPLY_mk_v2b >>
first_x_assum $ drule_then assume_tac >>
rev_drule_then assume_tac FAPPLY_mk_v2b >>
first_x_assum $ qspecl_then [‘n’] assume_tac >> gs[] >>
drule_then assume_tac rich_listTheory.EL_APPEND1 >> gs[]
QED

Theorem mk_v2b_FUPDATE:
ALL_DISTINCT vl ∧ ¬ MEM h vl ⇒ mk_v2b (vl ++ [h]) = (mk_v2b vl) |+ (h,LENGTH vl)
Proof
simp[fmap_EXT,FDOM_mk_v2b] >>
‘h INSERT set vl = {h} ∪ set vl’ by simp[Once INSERT_SING_UNION] >>
simp[] >> simp[SimpLHS,Once UNION_COMM] >> strip_tac >>
‘ALL_DISTINCT (vl ++ [h])’ by simp[ALL_DISTINCT_APPEND] >>
drule_then assume_tac FAPPLY_mk_v2b >>
simp[MEM_EL,PULL_EXISTS] >> rw[] (* 2 *)
>- (first_x_assum $ qspecl_then [‘n’] assume_tac >> gs[] >>
   ‘MEM (EL n vl) vl’ by (simp[MEM_EL] >> metis_tac[]) >>
   ‘EL n vl ≠ h’ by metis_tac[] >>
   simp[FAPPLY_FUPDATE_THM] >> metis_tac[FAPPLY_mk_v2b_APPEND]) >>
simp[FAPPLY_FUPDATE_THM] >>
‘LENGTH vl < LENGTH (vl ++ [h])’ by simp[] >>
drule_then assume_tac FAPPLY_mk_v2b >>
first_x_assum $ drule_then assume_tac >>
‘(EL (LENGTH vl) (vl ⧺ [h])) = h’ suffices_by metis_tac[] >>
‘LENGTH vl ≤ LENGTH vl’ by simp[] >>
drule_then assume_tac rich_listTheory.EL_APPEND2 >>
first_x_assum $ qspecl_then [‘[h]’] assume_tac>> gs[]
QED
   
        


        
Theorem mk_v2b_EMPTY_FUPDATE:
(mk_v2b [] |+ ((q,r),0)) = (mk_v2b [(q,r)])
Proof
simp[fmap_EXT,FDOM_mk_v2b,mk_v2b_def] >>
‘LENGTH [(q,r)] = LENGTH (COUNT_LIST 1)’
 by simp[rich_listTheory.LENGTH_COUNT_LIST] >>
irule TO_FMAP_MEM >>
qspecl_then [‘COUNT_LIST 1’,‘[(q,r)]’,‘I’] assume_tac
(GEN_ALL $ cj 3 $ MAP_ZIP) >>
gs[] >>
‘COUNT_LIST 1 = [0]’ by EVAL_TAC >>
gs[]
QED

Theorem ALL_DISTINCT_TAKE:
ALL_DISTINCT l ⇒ ∀n. n < LENGTH l ⇒ ALL_DISTINCT (TAKE n l)
Proof
simp[EL_ALL_DISTINCT_EL_EQ] >> rw[] >>
qspecl_then [‘n’,‘n1’] assume_tac EL_TAKE >>
qspecl_then [‘n’,‘n2’] assume_tac EL_TAKE >>
gs[]
QED


        
Theorem mk_FALLL_fVar:
∀k vl0.
LENGTH vl0 = k ∧ ALL_DISTINCT vl0 ⇒ 
mk_FALLL (REVERSE vl0) (fVar P sl (MAP Var' vl)) =
FALLL (vl2sl (REVERSE vl0))
(fVar P sl (MAP (vpv2b (mk_v2b vl0)) vl))
Proof
Induct_on ‘k’
>- (simp[mk_v2b_def,rich_listTheory.COUNT_LIST_def,mk_FALLL_def,
        FALLL_def,vl2sl_EMPTY] >>
   simp[MAP_EQ_f] >> rw[] >> Cases_on ‘e’ >>
   simp[vpv2b_def,FDOM_TO_FMAP]) >>
Cases_on ‘vl0’ >> gs[] >> rw[] >>
Cases_on ‘t= []’ >> gs[]
>- (Cases_on ‘h’ >>
   simp[mk_FALLL_def,FALLL_def,vl2sl_EMPTY,vl2sl_def,mk_FALL_def,
        vl2sl0_def,absvl_def,abst_def,fabs_def,
        MAP_MAP_o,MAP_EQ_f] >> rw[] >> Cases_on ‘e’ >>
   simp[vpv2b_tpv2b] >>
   qspecl_then [‘(Var q' r')’,‘(mk_v2b [])’,‘q’,‘r’,‘0’]
   assume_tac $ cj 1 tabs_tpv2b >>
   gs[FDOM_mk_v2b] >> simp[mk_v2b_EMPTY_FUPDATE]) >> 
‘LENGTH t ≠ 0’ by simp[] >>
‘SUC (LENGTH t − 1) = LENGTH t’ by simp[] >>
gs[] >>
qabbrev_tac ‘t1 = (TAKE (LENGTH t − 1) t)’ >> 
‘(REVERSE t ⧺ [h]) = LAST t :: (REVERSE t1 ⧺ [h])’
by (simp[Abbr‘t1’] >>
‘REVERSE (REVERSE t) = REVERSE
(LAST t::REVERSE (TAKE (LENGTH t − 1) t))’
by (REWRITE_TAC[REVERSE_REVERSE] >>
   simp[REVERSE_DEF] >>
   simp[TAKE_LAST]) >> gs[]) >>
gs[] >>
qabbrev_tac ‘v = LAST t’ >> Cases_on ‘v’ >>
simp[mk_FALLL_def] >>
first_x_assum $ qspecl_then [‘h :: t1’] assume_tac >>
‘¬MEM h t1 ∧ ALL_DISTINCT t1’
 by (simp[Abbr‘t1’] >> rw[] (* 2 *)
    >- (CCONTR_TAC >> gs[] >>
       drule rich_listTheory.MEM_TAKE >> gs[]) >>
    irule ALL_DISTINCT_TAKE >> simp[]) >> gs[] >> 
‘LENGTH (h::t1) = LENGTH t ’ by simp[Abbr‘t1’] >> gs[] >>
simp[mk_FALL_FALLL] >> simp[vl2sl_CONS] >>
simp[LENGTH_vl2sl] >>
AP_TERM_TAC >> simp[fabs_def,MAP_MAP_o,MAP_EQ_f] >> rw[] >>
Cases_on ‘e’ >> simp[vpv2b_tpv2b] >>
‘t = t1 ++ [(q,r)]’
 by (simp[Abbr‘t1’] >>
    qpat_x_assum ‘LAST t = (q,r)’ (assume_tac o GSYM) >> simp[] >>
    simp[TAKE_LAST]) >>
simp[] >>
‘(h::(t1 ⧺ [(q,r)])) = (h::t1) ⧺ [(q,r)]’ by simp[] >>
pop_assum SUBST_ALL_TAC >> 
‘(mk_v2b (h::t1 ⧺ [(q,r)])) =
 (mk_v2b (h::t1)) |+ ((q,r),LENGTH (h :: t1))’
 by (irule mk_v2b_FUPDATE >> simp[ALL_DISTINCT] >> rw[] (* 2 *)
    >- (CCONTR_TAC >> gs[]) >>
    ‘ALL_DISTINCT (REVERSE (t1 ⧺ [(q,r)]))’
     by simp[ALL_DISTINCT_REVERSE] >>
    qpat_x_assum ‘ALL_DISTINCT (t1 ⧺ [(q,r)])’ (K all_tac) >>
    qpat_x_assum ‘REVERSE (t1 ⧺ [(q,r)]) = (q,r)::REVERSE t1’
    SUBST_ALL_TAC >>
    gs[ALL_DISTINCT]) >>
pop_assum SUBST_ALL_TAC >>
‘LENGTH (h::t1) = LENGTH t1 + 1’ by simp[] >>
pop_assum SUBST_ALL_TAC >>
irule $ cj 1 tabs_tpv2b >> simp[FDOM_mk_v2b] >>
gs[] >> gs[ALL_DISTINCT_APPEND]
QED




Theorem mk_FALLL_fVar1:
ALL_DISTINCT vl ⇒
     mk_FALLL vl (fVar P sl (MAP Var' vl)) =
     FALLL (vl2sl vl) (fVar P sl (MAP (vpv2b (mk_v2b (REVERSE vl))) vl))
Proof     
metis_tac[mk_FALLL_fVar |> Q.SPECL [‘LENGTH vl’,‘REVERSE vl’]
              |> SRULE [EQ_REFL]]
QED              



Theorem vpv2b_mk_v2b_EL:
ALL_DISTINCT vl ∧ x < LENGTH vl ⇒
vpv2b (mk_v2b vl) (EL x vl) = Bound x
Proof
rw[] >> Cases_on ‘EL x vl’ >> rw[vpv2b_def,FDOM_mk_v2b] (* 2 *)
>- (drule_all_then assume_tac FAPPLY_mk_v2b >> gs[]) >>
gs[MEM_EL]
QED
        


Theorem fVar_MAP_vpv2b:
ALL_DISTINCT vl ⇒ (MAP (vpv2b (mk_v2b vl)) (REVERSE vl)) =
(MAP Bound (REVERSE (COUNT_LIST (LENGTH vl))))
Proof
rw[] >> 
irule LIST_EQ >> simp[rich_listTheory.LENGTH_COUNT_LIST] >>
rw[] >> simp[EL_MAP] >>
‘LENGTH (COUNT_LIST (LENGTH vl)) = LENGTH vl’ by
simp[rich_listTheory.LENGTH_COUNT_LIST] >>
‘LENGTH (REVERSE (COUNT_LIST (LENGTH vl))) = LENGTH vl’ by simp[] >>
simp[EL_MAP] >>
drule_all_then assume_tac vpv2b_mk_v2b_EL >> gs[] >>
simp[EL_REVERSE] >> simp[Once EQ_SYM_EQ] >>
‘(PRE (LENGTH vl − x)) < LENGTH vl’ by simp[] >>
drule_all_then assume_tac vpv2b_mk_v2b_EL >> gs[] >>
irule rich_listTheory.EL_COUNT_LIST >> simp[]
QED


        
Theorem mk_FALLL_fVar_FALLL:
∀vl. ALL_DISTINCT vl ⇒
mk_FALLL vl (fVar P (vl2sl vl) (MAP Var' vl)) =
FALLL (vl2sl vl) (plainfV (P,(vl2sl vl)))
Proof
rw[] >>
qspecl_then [‘vl2sl vl’,‘LENGTH vl’,‘REVERSE vl’] assume_tac (Q.GEN ‘sl’ mk_FALLL_fVar) >> gs[] >> AP_TERM_TAC >>
simp[plainfV_def] >> simp[LENGTH_vl2sl] >>
‘ALL_DISTINCT (REVERSE vl)’ by simp[] >>
drule_all_then assume_tac fVar_MAP_vpv2b >> gs[]
QED



Definition wfdpvl_def:
(wfdpvl [] f ⇔ T) ∧
(wfdpvl (v :: vs) f ⇔
  wfdpvl vs f ∧
  v ∉ fVslfv f ∧
  ∀n s. (n,s) ∈ ffv (mk_FALLL vs f) ⇒
  v ∉ sfv s)
End

Definition wfvl_def:
  wfvl Σ vl f ⇔ wfdpvl vl f ∧
                ∀v. MEM v vl ⇒ wfs Σ (SND v)
End


Theorem fVslfv_mk_FALLL1:
fVslfv (mk_FALLL vl f) = fVslfv f
Proof
metis_tac[fVslfv_mk_FALLL]
QED

Theorem mk_FALLL_fVar_wff:
∀f.
wff Σ f ∧ wfvl (FST Σ) vl f ⇒ 
wff Σ (mk_FALLL vl f)
Proof
Induct_on ‘LENGTH vl’
>- rw[mk_FALLL_def] >>
Cases_on ‘vl’ >> simp[] >>
Cases_on ‘h’ >> simp[wfvl_def,mk_FALLL_def] >>
rw[] >> Cases_on ‘Σ’ >> Cases_on ‘r'’ >>
irule $ cj 6 wff_rules >>
rename [‘(Σf,Σp,Σe)’] >> gs[] >> gs[wfdpvl_def] >>
‘wff (Σf,Σp,Σe) (mk_FALLL t f)’
 by (first_x_assum irule >> simp[] >>
    simp[wfvl_def]) >> simp[] >>
‘wfs Σf r’ by gs[DISJ_IMP_THM] >> simp[fVslfv_mk_FALLL1] >>
metis_tac[]
QED 



mk_FALLL_fVar_FALLL    

∀k vl0.
LENGTH vl0 = k ∧ ALL_DISTINCT vl0 ⇒ 
mk_FALLL (REVERSE vl0) (fVar P sl (MAP Var' vl)) =
FALLL (vl2sl (REVERSE vl0))
(fVar P sl (MAP (vpv2b (mk_v2b vl0)) vl))    


mk_FALLL_fVar1
mk_FALLL_fVar

Theorem fabs_TRUE:
fabs v i TRUE = TRUE
Proof
rw[TRUE_def,fabs_def]
QED        
        

Theorem mk_FALLL_TRUE:
(mk_FALLL t TRUE) = FALLL (vl2sl t) TRUE
Proof
Induct_on ‘LENGTH t’
>- simp[vl2sl_def,vl2sl0_def,FALLL_def,mk_FALLL_def] >>
Cases_on ‘t’ >> simp[] >>
simp[vl2sl_CONS,mk_FALLL_def,FALLL_def] >>
Cases_on ‘h’ >> simp[mk_FALLL_def] >> rw[] >>
simp[mk_FALL_def,abst_def] >>
qspecl_then [‘LENGTH t'’,‘q’,‘r’,‘vl2sl t'’,‘TRUE’,‘0’]
assume_tac mk_FALL_FALLL0 >>
gs[LENGTH_vl2sl, fabs_TRUE]
QED

Theorem ffv_TRUE:
ffv TRUE = {}
Proof
simp[TRUE_def]
QED        
        

Theorem tfv_tpv2b_SUBSET:
(∀tm v2b. tfv (tpv2b v2b tm) ⊆ tfv tm) ∧
(∀st v2b. sfv (spv2b v2b st) ⊆ sfv st)
Proof
ho_match_mp_tac better_tm_induction >>
simp[tfv_thm,tpv2b_def,MEM_MAP,MAP_EQ_f] >>
rw[] (* 4 *)
>- (Cases_on ‘(s0,st) ∈ FDOM v2b’ >> simp[])
>> (gs[SUBSET_DEF,PULL_EXISTS] >> metis_tac[])
QED 
        
Theorem tlfv_MAP_Bound_EMPTY:
tlfv (MAP Bound l) = {}
Proof
rw[tlfv_def]>> Cases_on ‘l’ >> simp[] >>
disj2_tac >> simp[MEM_MAP] >>
simp[Once EXTENSION,PULL_EXISTS] >>
rw[] >> rw[EQ_IMP_THM,tfv_thm] (* 3 *)
>- simp[tfv_thm]
>- simp[tfv_thm] >>
qexists ‘Bound h’ >> simp[]
QED


Theorem slfv_alt:
slfv vl = BIGUNION {sfv v | MEM v vl}
Proof
simp[Once EXTENSION,IN_slfv] >> rw[] >>
Cases_on ‘x’ >> simp[IN_slfv] >> metis_tac[]
QED

        
Theorem tfv_tabs_SUBSET1:
(∀tm n s i.tfv (tabs (n,s) i tm) ⊆ tfv tm) ∧
(∀st n s i.sfv (sabs (n,s) i st) ⊆ sfv st)
Proof
ho_match_mp_tac better_tm_induction >>
simp[tfv_thm,tabs_def] >> rw[] (* 4 *)
>- (Cases_on ‘n = s0 ∧ s = st’ >> simp[SUBSET_DEF])
>> (gs[SUBSET_DEF,MEM_MAP] >> metis_tac[])
QED


Theorem slfv_CONS:
slfv (s :: sl) = sfv s ∪ slfv sl
Proof
simp[slfv_alt] >> rw[Once EXTENSION] >> metis_tac[]
QED





Theorem slfv_abssl:
(∀n s. (n,s) ∈ slfv sl ⇒ (q,r) ∉ sfv s) ∧
(q,r) ∈ slfv sl ⇒
sfv r ∪ slfv (abssl (q,r) 0 sl) = slfv sl DELETE (q,r)
Proof
rw[] >> gs[IN_slfv] >>
irule $ iffLR SUBSET_ANTISYM_EQ >> rw[] (* 3 *)
>- (simp[SUBSET_DEF]>> Cases_on ‘x’ >>
   simp[IN_slfv,PULL_EXISTS] >> metis_tac[vsort_tfv_closed])
>- (simp[SUBSET_DEF] >> Cases_on ‘x’ >>
   simp[IN_slfv,PULL_EXISTS,MEM_EL,LENGTH_abssl] >> rw[] >>
   drule_then assume_tac abssl_EL>> gs[] >>
   qspecl_then [‘n’,‘EL n sl’,‘q’,‘r’,‘tt’]
   assume_tac $ Q.GEN ‘i’
   $ cj 2 tfv_tabs_SUBSET >>
   qexists ‘n’ >> simp[]>>
   ‘sfv (sabs (q,r) n (EL n sl)) ⊆ sfv (EL n sl) DELETE (q,r)’
    by metis_tac[MEM_EL] >>
   gs[SUBSET_DEF] >> first_x_assum $ drule_then assume_tac >>
   gs[]) >>
gs[SUBSET_DEF] >> Cases_on ‘x’ >>
simp[IN_slfv]>> rw[] >> gs[MEM_EL]>>
drule_then assume_tac abssl_EL >> simp[LENGTH_abssl] >>
simp[PULL_EXISTS]>>
Cases_on ‘(q,r) ∈ sfv (EL n' sl)’
>- (qspecl_then [‘n'’,‘(EL n' sl)’,‘q’,‘r’] assume_tac
$ Q.GEN ‘i’ $ cj 2 tfv_tabs >>
‘sfv r ∪ sfv (sabs (q,r) n' (EL n' sl)) = sfv (EL n' sl) DELETE (q,r)’
 by (first_x_assum irule >> simp[] >>
    metis_tac[]) >>
   pop_assum (assume_tac o GSYM) >>
   ‘(q',r') ∈ sfv (EL n' sl) DELETE (q,r)’ by gs[] >>
   qpat_x_assum ‘_ = _’ SUBST_ALL_TAC >> gs[] >>
   disj2_tac >> qexists ‘n'’ >>
   first_x_assum $ qspecl_then [‘q’,‘r’,‘0’] assume_tac >>
   gs[]) >>
disj2_tac >> qexists ‘n'’ >> simp[] >>
drule_then assume_tac $ cj 2 tabs_id  >> simp[]
QED
 


Theorem wfdpvl_ffv_mk_FALLL:
∀f. wfdpvl vl f ⇒
ffv (mk_FALLL vl f) = slfv (vl2sl vl) ∪ (ffv f DIFF set vl)
Proof
Induct_on ‘LENGTH vl’
>- (rw[] >>
    simp[mk_FALLL_def,slfv_def,vl2sl_EMPTY,Uof_EMPTY]) >>
Cases_on ‘vl’ >> simp[] >>
Cases_on ‘h’ >> simp[mk_FALLL_def,wfdpvl_def] >>
rw[] >>
first_x_assum $ qspecl_then [‘t’] assume_tac >>
gs[] >>
first_x_assum $ drule_then assume_tac >>
qspecl_then [‘(mk_FALLL t f)’,‘q’,‘r’] assume_tac
ffv_mk_FALL >> gs[] >>
‘ffv (mk_FALL q r (mk_FALLL t f)) =
        slfv (vl2sl t) ∪ (ffv f DIFF set t) ∪ sfv r DELETE (q,r)’ suffices_by
 (rw[] >> simp[vl2sl_CONS] >>
 simp[slfv_CONS] >>
 reverse (Cases_on ‘(q,r) ∈ slfv (vl2sl t)’) (* 2 *)
 >- (‘abssl (q,r) 0 (vl2sl t) = vl2sl t’
      by (irule abssl_id >> gs[IN_slfv] >> metis_tac[]) >>
    simp[]>>
    irule $ iffLR SUBSET_ANTISYM_EQ >>
  simp[SUBSET_DEF,PULL_EXISTS] >> rw[] (* 4 *)
     >- metis_tac[]
     >- metis_tac[]
     >- metis_tac[] >>
     metis_tac[tm_tree_WF]) >> 
 ‘sfv r ∪ slfv (abssl (q,r) 0 (vl2sl t)) ∪
        (ffv f DIFF ((q,r) INSERT set t)) =
 sfv r ∪ (sfv r ∪ slfv (abssl (q,r) 0 (vl2sl t))) ∪
        (ffv f DIFF ((q,r) INSERT set t))’
    by (rw[Once EXTENSION] >> metis_tac[]) >>
 pop_assum SUBST_ALL_TAC >>
 ‘sfv r ∪ slfv (abssl (q,r) 0 (vl2sl t)) =
 (slfv (vl2sl t) DELETE (q,r))’ suffices_by
  (rw[]>> irule $ iffLR SUBSET_ANTISYM_EQ >>
  simp[SUBSET_DEF,PULL_EXISTS] >> rw[] (* 4 *)
     >- metis_tac[]
     >- metis_tac[]
     >- metis_tac[] >>
     metis_tac[tm_tree_WF]) >>
  gs[DISJ_IMP_THM] >>
  irule slfv_abssl >> simp[] >> metis_tac[]) >>
first_x_assum irule >> simp[fVars_mk_FALLL]>>
rw[] (* 3 *)
>- (gs[IN_fVslfv] >> metis_tac[]) >>
metis_tac[]
QED

(*
Theorem wfdpvl_alt:
wfdpvl [] f = T ∧
wfdpvl         
*)


Definition okvnames_def:
okvnames vl ⇔
∀m n. m < n ∧ n < LENGTH vl ⇒ EL n vl ∉ sfv (SND (EL m vl))
End

Theorem okvnames_CONS:
okvnames (h :: t) ⇔ okvnames t ∧
∀v. MEM v t ⇒ v ∉ sfv (SND h)
Proof
simp[okvnames_def,EQ_IMP_THM] >>
rw[] (* 3 *)
>- (first_x_assum $ qspecl_then [‘SUC m’,‘SUC n’] assume_tac
   >> gs[])
>- (gs[MEM_EL] >>
   first_x_assum $ qspecl_then [‘0’,‘SUC n’] assume_tac >>
   gs[]) >>
Cases_on ‘n < LENGTH t’ (* 2 *)
>- (Cases_on ‘m’ >> gs[] >> Cases_on ‘n’ >> gs[MEM_EL] >>
   first_x_assum irule >> qexists ‘n'’ >> simp[]) >>
Cases_on ‘m’ >> Cases_on ‘n’ >>  gs[MEM_EL] >>
metis_tac[]
QED

        
Theorem wfdpvl_expand:
∀f. wfdpvl vl f ∧ okvnames vl ⇒
∀f1. (∀n s. (n,s) ∈ ffv f1 DIFF ffv f ⇒
            ∀v. MEM v vl ⇒ v ∉ sfv s) ∧
     (∀v. MEM v vl ⇒ v ∉ fVslfv f1) ⇒
wfdpvl vl f1
Proof
Induct_on ‘vl’
>- simp[okvnames_def,wfdpvl_def] >>
Cases_on ‘h’ >> simp[wfdpvl_def,okvnames_CONS] >>
rw[] (* 2 *)
>- (first_x_assum irule >> simp[] >>
   metis_tac[]) >>
‘wfdpvl vl f1’ by
  (first_x_assum irule >> simp[] >>
   metis_tac[]) >>
‘ffv (mk_FALLL vl f) = slfv (vl2sl vl) ∪ (ffv f DIFF set vl)’
 by metis_tac[wfdpvl_ffv_mk_FALLL] >>
pop_assum SUBST_ALL_TAC >>
gs[DISJ_IMP_THM] >>
‘ffv (mk_FALLL vl f1) = slfv (vl2sl vl) ∪ (ffv f1 DIFF set vl)’
 by metis_tac[wfdpvl_ffv_mk_FALLL] >>
pop_assum SUBST_ALL_TAC >> gs[]
>- metis_tac[] >>
metis_tac[]
QED

Theorem wfdpvl_NOTIN_slfv:
∀f. wfdpvl vl f ∧ okvnames vl ⇒ ∀v. MEM v vl ⇒ v ∉ slfv (vl2sl vl)
Proof
Induct_on ‘LENGTH vl’
>- rw[vl2sl_EMPTY] >>
Cases_on ‘vl’ >> simp[] >>
Cases_on ‘h’ >> simp[wfdpvl_def,vl2sl_CONS,slfv_CONS] >>
rw[] (* 4 *)
>- simp[tm_tree_WF]
>- cheat
>- 


     
Theorem wfdpvl_ffv:
wfdpvl vl TRUE ∧ ALL_DISTINCT vl ⇒
∀sl. (∀v. MEM v vl ⇒ v ∉ slfv sl) ⇒
wfdpvl vl TRUE
∀n. n ≤ LENGTH vl ⇒ wfdpvl (DROP n vl) (fVar P sl (MAP Var' vl))
Proof
Induct_on ‘LENGTH vl’
>- cheat >>
Cases_on ‘vl’ >> simp[] >>
Cases_on ‘h’ >> simp[wfdpvl_def] >> rw[] >>
Cases_on ‘n = SUC (LENGTH t)’ >> gs[] (* 2 *)
>- simp[rich_listTheory.DROP_LENGTH_NIL,wfdpvl_def] >>
Cases_on ‘n’ >> simp[] (* 2 *)
>- simp[wfdpvl_def] >> 
simp[rich_listTheory.DROP] 

   
Induct_on ‘LENGTH vl’
>- cheat >>
Cases_on ‘vl’ >> simp[] >> Cases_on ‘h’ >>
simp[wfdpvl_def] >> rw[] >>
‘wfdpvl t f’
 by (first_x_assum irule >> metis_tac[]) >>
Cases_on ‘(n,s) ∈ (ffv f DIFF set vl)’
>- 
        
     


Theorem wfdpvl_ffv:
wfdpvl vl TRUE ∧ ALL_DISTINCT vl ⇒
∀f. (∀v. MEM v vl ⇒ v ∉ fVslfv f) ⇒
wfdpvl vl f
Proof
Induct_on ‘LENGTH vl’
>- cheat >>
Cases_on ‘vl’ >> simp[] >> Cases_on ‘h’ >>
simp[wfdpvl_def] >> rw[] >>
‘wfdpvl t f’
 by (first_x_assum irule >> metis_tac[]) >>
Cases_on ‘(n,s) ∈ (ffv f DIFF set vl)’
>- 




        
        
Theorem wfdpvl_ffv:
wfdpvl vl TRUE ∧ ALL_DISTINCT vl ⇒
wfdpvl vl (fVar P (vl2sl vl) (MAP Var' vl))
Proof        
Induct_on ‘LENGTH vl’
>- cheat >>
Cases_on ‘vl’ >>
simp[wfdpvl_def,fVars_def,Uof_Sing] >> strip_tac >>
strip_tac >> reverse (rw[])
>- (qspecl_then [‘h :: t’,‘vl2sl (h::t)’,‘LENGTH t’,‘REVERSE t’] assume_tac
   (mk_FALLL_fVar |> Q.GENL [‘vl’,‘sl’]) >> gs[] >>
   qspecl_then [‘(vl2sl t)’,‘(fVar P (vl2sl (h::t))
                (vpv2b (mk_v2b (REVERSE t)) h::
                   MAP (vpv2b (mk_v2b (REVERSE t))) t))’] assume_tac ffv_FALLL >>
   pop_assum SUBST_ALL_TAC >>
   pop_assum (K all_tac) >> 
   SUBST_ALL_TAC mk_FALLL_TRUE >>
   qspecl_then [‘(vl2sl t)’,‘TRUE’] assume_tac ffv_FALLL >>
   SUBST_ALL_TAC ffv_TRUE >>
   pop_assum mp_tac >> simp[] >> rw[] >>
   pop_assum SUBST_ALL_TAC >>
   ‘(n,s) ∈
        ffv
          (fVar P (vl2sl (h::t))
             (vpv2b (mk_v2b (REVERSE t)) h::
                MAP (vpv2b (mk_v2b (REVERSE t))) t)) ⇒
    h ∉ sfv s’ suffices_by (gs[] >> metis_tac[]) >>
    pop_assum (K all_tac) >>
    qspecl_then [‘REVERSE t’] assume_tac
                (Q.GEN ‘vl’ fVar_MAP_vpv2b) >>
   qspecl_then [‘t’] SUBST_ALL_TAC REVERSE_REVERSE >>
    ‘ALL_DISTINCT (REVERSE t)’ by simp[] >>
    first_x_assum $ dxrule_then assume_tac >>
    pop_assum SUBST_ALL_TAC >>
    ‘(n,s)∈ slfv (vl2sl (h::t)) ⇒ h ∉ sfv s’
     by (simp[vl2sl_CONS] >>
        Cases_on ‘(n,s) ∈ sfv (SND h)’
        >- (CCONTR_TAC >> gs[] >>
           Cases_on ‘h’ >> gs[] >>
           metis_tac[vsort_tfv_closed,tm_tree_WF]) >>
        cheat) >>
    ‘(n,s) ∈
        tlfv
             (vpv2b (mk_v2b (REVERSE t)) h::
                MAP Bound (REVERSE (COUNT_LIST (LENGTH (REVERSE t))))) ⇒
        h ∉ sfv s’
     suffices_by
     (gs[slfv_def,tlfv_def,Uof_def] >> metis_tac[]) >>
    rw[] >>
    Cases_on ‘(n,s) ∈ tfv (vpv2b (mk_v2b (REVERSE t)) h)’
    (* 2 *)
    >- (Cases_on ‘h’ >> gs[vpv2b_tpv2b] >> 
       qspecl_then [‘Var q r’,‘mk_v2b (REVERSE t)’]
       assume_tac $ cj 1 tfv_tpv2b_SUBSET >>
       ‘(n,s) ∈ tfv (Var q r)’ by
       (gs[SUBSET_DEF] >>
       first_x_assum $ qspecl_then [‘(n,s)’] assume_tac >>
       gs[]) >>
       strip_tac >> gs[] (* 2 *)
       >- metis_tac[tm_tree_WF] >>
       metis_tac[vsort_tfv_closed,tm_tree_WF]) >>
    ‘(n,s) ∈ tlfv
     (MAP Bound (REVERSE (COUNT_LIST (LENGTH t))))’
      by (gs[tlfv_def] >> metis_tac[]) >>
     ‘tlfv (MAP Bound (REVERSE (COUNT_LIST (LENGTH t)))) =
     {}’ suffices_by metis_tac[MEMBER_NOT_EMPTY] >>
     simp[tlfv_MAP_Bound_EMPTY])
>- simp[fVslfv_def,fVars_def,Uof_Sing] >>
   simp[vl2sl_CONS] >> Cases_on ‘h’ >> simp[] >>
   ‘ffv (mk_FALLL t TRUE) = slfv (vl2sl t)’
     by simp[ffv_mk_FALLL_TRUE,ffv_FALLL,ffv_TRUE,
          slfv_alt] >>
   pop_assum SUBST_ALL_TAC >> simp[slfv_CONS,tm_tree_WF] >>
   cheat >>
   
   


   
   
   gs[ffv_mk_FALLL_TRUE,ffv_FALLL,PULL_EXISTS,ffv_TRUE] >>
   simp[slfv_alt] >> rw[] >>
   Cases_on ‘(q,r) ∉ s’ >> gs[] >> rw[] (* 2 *)
   >- metis_tac[tm_tree_WF] >>
   strip_tac >>
   qpat_x_assum ‘(q,r) ∈ sfv v’ mp_tac >> simp[] >>
   first_x_assum irule >> gs[MEM_EL,PULL_EXISTS] >>
   gs[LENGTH_abssl] >> 
   drule_then assume_tac abssl_EL>>
   gs[] >> strip_tac >>
   qspecl_then [‘(EL n (vl2sl t))’,‘q’,‘r’,‘n’] assume_tac
   $ cj 2 tfv_tabs_SUBSET1 >>
   gs[SUBSET_DEF] >>
   first_x_assum $ drule_then assume_tac >>
   pop_assum mp_tac >> simp[] >>
   first_x_assum irule >> 
   
   
   simp[slfv_def,Uof_def] >> rw[] >>
   
   Cases_on ‘(q,r) ∉ s’ >> gs[] >> rw[]  
       
       vpv2b_tpv2b   


      rw[slfv_def,Uof_UNION] 
    
   



strip_tac >> strip_tac >>


Cases_on ‘h’ >> simp[wfdpvl_def,vl2sl_CONS] >>
  
      
        
Theorem mk_FALLL_fVar_wff:
∀k vl0.
LENGTH vl0 = k ∧
wfvl (FST Σ) vl0 TRUE ⇒ 
wff Σ
(mk_FALLL (REVERSE vl0) (fVar P sl (MAP Var' vl))) =
      

Theorem mk_FALLL_fVar_wff:
wfvl (FST Σ) vl TRUE ⇒
wff Σ (mk_FALLL vl (fVar P (vl2sl vl) (MAP Var' vl)))
Proof
Induct_on ‘LENGTH vl’ >- cheat >>
Cases_on ‘vl’ >> simp[] >> Cases_on ‘h’ >>
simp[wfvl_def,mk_FALLL_def] >>
rw[] >>


        




        

Definition mk_FALLL_fVar:
mk_FALLL_fVar P vl sl tl = mk_FALLL vl (fVar P sl tl)
End

        
Definition add_head:
add_head s t (fVar P sl tl) = fVar P (s:: sl) (t :: tl)
End


Definition abstl_def:
abstl [] i tl  = tl ∧
abstl (h :: t) i tl = MAP 

        
Theorem mk_FALLL_fVar:
mk_FALLL vl (fVar P [] []) = fVar P [] [] ∧
mk_FALLL vl (fVar P (s:: sl) (t :: tl)) =
mk_FALL 
Proof


        
Theorem foo:
wfvl vs TRUE ⇒
mk_FALLL vs (fVar P (vl2sl vs) (MAP Var' vs)) =
FALLL (vl2sl vs) (plainfV (P,vl2sl vs))
Proof
Induct_on ‘LENGTH vs’ (* 2 *)
>- cheat >>
Cases_on ‘vs’ >> simp[] >>
Cases_on ‘h’ >> rename [‘(an,as)’] >>
simp[wfvl_def,vl2sl0_def,FALLL_def,vl2sl_def,mk_FALLL_def] >>
rw[] >> 
        

Definition wfabsvl_def:
(wfabsvl Σ [] f = T) ∧
(wfabsvl Σ (v :: vl) f ⇔
 wfabsvl vl f ∧ (wfs Σ 
 



 
Theorem foo:
∀sl. wfabsap (FST Σ) sl (MAP Var' vl) ⇒
mk_FALLL vl (fVar P sl (MAP Var' vl)) =
FALLL sl (plainfV(P,sl)) ∧ wff Σ (FALLL sl (plainfV(P,sl)))
Proof
Induct_on ‘LENGTH vl’
>- cheat >>
Cases_on ‘vl’ >> simp[] >> rw[] >>
Cases_on ‘sl’ >> Cases_on ‘h’ >>
gs[wfabsap_def,sort_of_def] >> simp[mk_FALLL_def] >>
‘(mk_FALLL t (fVar P (r::t') (Var q r::MAP Var' t))) =
 add_head (r,Var q r) (mk_FALLL t (fVar P (specsl 0 (Var q r) t') (MAP Var' t)))’
 by cheat >> simp[] >>
 
first_x_assum $ qspecl_then [‘t’] assume_tac >>
gs[] >> first_x_assum$ drule_then assume_tac >>

Cases_on ‘’



val _ = export_theory();
