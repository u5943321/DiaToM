val _ = use "buildcore/Systeml.sig";
val _ = use "buildcore/Systeml.sml";
val _ = use "buildcore/QuoteFilter.sml";
val _ = use "buildcore/QFRead.sig";
val _ = use "buildcore/QFRead.sml";
val _ = use "buildcore/holrepl.ML";

structure QUse =
struct

fun use_reader fname (reader as {read = infn0, eof, reset}) =
  let
    val lineNo = ref 1
    fun infn () =
      case infn0 () of
          NONE => NONE
        | SOME (c as #"\n") => (lineNo := !lineNo + 1;
                                SOME c)
        | SOME c => SOME c
    open PolyML
  in
    while not (eof()) do
          compiler (infn, [Compiler.CPFileName fname,
                           Compiler.CPLineNo (fn () => !lineNo)]) ()
  end

fun use fname = use_reader fname (QFRead.fileToReader fname)

fun useScript fname =
    let
      val istream = TextIO.openIn fname
      val reader = QFRead.streamToReader true istream
      val _ = use_reader fname reader
              handle e => (TextIO.closeIn istream; raise e)
    in
      TextIO.closeIn istream
    end

end

structure Globals =
struct
  val hol_clock = Timer.startCPUTimer()
  val interactive = ref true
  val HOLDIR = OS.FileSys.getDir()
end

structure HOL_Interactive =
struct
  val qd = ref false
  fun toggle_quietdec () =
    if !qd then
      ( PolyML.Compiler.prompt1 := "> "
      ; PolyML.Compiler.prompt2 := "# "
      ; PolyML.print_depth 100
      ; qd := false
      ; false
      )
    else
      ( PolyML.Compiler.prompt1 := ""
      ; PolyML.Compiler.prompt2 := ""
      ; PolyML.print_depth 0
      ; qd := true
      ; true
      )
  fun amquiet () = !qd
end

structure PPBackEnd = struct datatype foo = emacs_terminal end

val use = QUse.use;

val _ = use "master.ML";

fun main() = let
  val diag = case CommandLine.arguments() of
                 ["-d"] => (fn s => TextIO.output(TextIO.stdErr, s ^ "\n"))
               | _ => (fn s => ())
in
  PolyML.print_depth 100;
  HOL_REPL.sigint_handler();
  diag "Starting REPL";
  HOL_REPL.topLevel diag {startExec = fn () => (),
                          endExec = fn () => (),
                          exitLoop = fn () => false,
                          exitOnError = false,
                          isInteractive = true,
                          nameSpace = PolyML.globalNameSpace}
end
