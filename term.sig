signature term = 
sig
eqtype sort
eqtype term


datatype term_view =
    vVar of string * sort
  | vB of int 
  | vFun of string * sort * term list

datatype sort_view = 
         vSrt of string * term list

val sort_name: sort -> string
val depends_on: sort -> term list
val dest_sort: sort -> string * term list
val of_sort: string -> term -> bool


val SortDB: (string, (string * sort) list) Binarymap.dict ref
val SortInx: (string, string) Binarymap.dict ref
val ground_sorts: (string, (string * sort) list) Binarymap.dict -> string list
val listof_sorts:
   (string, (string * sort) list) Binarymap.dict ->
     (string * (string * sort) list) list
val new_sort: string -> (string * sort) list -> unit
val new_sort_infix: string -> string -> unit
val on_ground: string -> bool
val sort_infixes0: (string, string) Binarymap.dict
val sortname_of_infix: string -> string
val sorts0: (string, (string * sort) list) Binarymap.dict

val srt2ns: string -> string * sort

val EqSorts: string list ref
val has_eq: string -> bool

val view_sort: sort -> sort_view
val view_term: term -> term_view


val eq_term: term * term -> bool
val eq_sort: sort * sort -> bool

exception TER of string * sort list * term list

val mk_sort: string -> term list -> sort

val mk_var: string * sort -> term
val mk_fun: string -> term list -> term 
val mk_fun0: string -> sort -> term list -> term 
val mk_bound: int -> term

val sort_of: term -> sort


val is_var: term -> bool
val dest_fun: term -> string * sort * term list
val dest_var: term -> string * sort


val replaces: int * term -> sort -> sort
val replacet: int * term -> term -> term

val substs: (string * sort) * term -> sort -> sort
val substt: (string * sort) * term -> term -> term 

val fvt: term -> (string * sort) set
val fvtl: term list -> (string * sort) set
val fvs: sort -> (string * sort) set

val pair_compare: ('a * 'b -> order) -> ('c * 'd -> order) -> ('a * 'c) * ('b * 'd) -> order
val sort_compare: sort * sort -> order
val term_compare: term * term -> order
val essps: (string * sort) set
val pvariantt: (string * sort) set -> term -> term

val fsymss: sort -> string set
val fsymst: term -> string set

val fxty: string -> int
val is_const: string -> bool



type fsymd = (string, sort * (string * sort) list) Binarymap.dict
val fsyms0: fsymd
val fsyms: fsymd ref
val lookup_fun: fsymd -> string -> (sort * (string * sort) list) option
val is_fun: string -> bool
val new_fun:
   string -> sort * (string * sort) list -> unit




type psymd = (string, (string * sort) list) Binarymap.dict
val psyms0: psymd
val psyms: psymd ref
val lookup_pred: psymd -> string -> (string * sort) list option
val is_pred: string -> bool
val new_pred:
   string -> (string * sort) list -> unit

type vd
val emptyvd:vd
val mk_tenv: ((string * sort) * term) list -> vd
val v2t: string * sort -> term -> vd -> vd
val lookup_t: vd -> string * sort -> term option
val match_term: (string * sort) set -> term -> term -> vd -> vd
val match_sort: (string * sort) set -> sort -> sort -> vd -> vd
val match_tl: (string * sort) set -> term list -> term list -> vd -> vd
val pvd: vd -> ((string * sort) * term) list

val inst_sort: vd -> sort -> sort
val inst_term: vd -> term -> term

val ill_formed_fv: string * sort -> bool
val has_bound_t: term -> bool
val has_bound_s: sort -> bool


val bigunion: ('a * 'a -> order) -> 'a set list -> 'a set
val var_bigunion: (string * sort) set list -> (string * sort) set

val abbrdict: (string * (term list), string * (term list)) Binarymap.dict ref
val unabbrdict: (string * (term list), string * (term list)) Binarymap.dict ref
val new_abbr: string * term list -> string * term list -> unit


exception CLASH
val dest_s: string * sort -> sort * int -> sort
val dest_t: string * sort -> term * int -> term



val vreplaces: int * (string * sort) -> sort -> sort
val vreplacet: int * (string * sort) -> term -> term


val pinst_s: vd -> sort -> sort
val pinst_t: vd -> term -> term
val pmatch_s:
   sort list -> (string * sort) set -> sort -> sort -> vd -> vd
val pmatch_t:
   sort list -> (string * sort) set -> term -> term -> vd -> vd
val pmatch_tl:
   sort list -> (string * sort) set -> term list -> term list -> vd -> vd
val recover_s: int -> sort -> sort
val recover_t: int -> term -> term
val shift_vd: int -> vd -> vd
val shift_vd_eval: int -> vd -> (string * sort) -> term

val filter_cont: (string * sort) set -> (string * sort) set

val fvsl: sort list -> (string * sort) set
val sprpl: int -> term list -> sort -> sort
val tprpl: int -> term list -> term -> term
val absvl:
   int -> string * sort -> (string * sort) list -> (string * sort) list
val vl2sl: (string * sort) list -> sort list
val vl2sl0: (string * sort) list -> (string * sort) list
val sshift: int -> sort -> sort
val tshift: int -> term -> term


val sabs: string * sort -> int -> sort -> sort
val tabs: string * sort -> int -> term -> term
val delete_fsym: string -> unit
val list_compare: ('a * 'b -> order) -> 'a list * 'b list -> order
end

