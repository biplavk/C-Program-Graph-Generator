open Cil
open Cil_types
let print_stmt out =
function
 | Instr i -> !Ast_printer.d_instr out i
 | Return _ -> Format.pp_print_string out "<return>"
 | Goto _ -> Format.pp_print_string out "<goto>"
 | Break _ -> Format.pp_print_string out "<break>"
 | Continue _ -> Format.pp_print_string out "<continue>"
 | If (e,_,_,_) -> Format.fprintf out "if %a" !Ast_printer.d_exp e
 | Switch(e,_,_,_) -> Format.fprintf out "switch %a" !Ast_printer.d_exp e
 | Loop _ -> Format.fprintf out "<loop>"
 | Block _ -> Format.fprintf out "<enter block>"
 | UnspecifiedSequence _ -> Format.fprintf out "<enter unspecified sequence>"
 | TryFinally _ | TryExcept _ -> Format.fprintf out "<try>"
class print_cfg out =
object
 inherit Visitor.frama_c_inplace
 method vstmt_aux s =
 Format.fprintf out "s%d@[[label=%S]@];@\n" s.sid (Pretty_utils.to_string print_stmt
s.skind);
 List.iter
 (fun succ -> Format.fprintf out "s%d -> s%d;@\n" s.sid succ.sid)
 s.succs;
 DoChildren
 method vglob_aux g =
 match g with
 | GFun(f,loc) ->
 Format.fprintf out "@[<hov 2>subgraph cluster_%a {@\n\
 graph [label=\"%a\"];@\n"
 Cil_datatype.Varinfo.pretty f.svar
 Cil_datatype.Varinfo.pretty f.svar;
 ChangeDoChildrenPost([g], fun g -> Format.fprintf out "}@\n@]"; g)
 | _ -> SkipChildren
 method vfile f =
 Format.fprintf out "@[<hov 2>digraph cfg {@\n";
 ChangeDoChildrenPost (f,fun f -> Format.fprintf out "}@."; f)
end
let run () =
 let chan = open_out "cfg.out" in
 let fmt = Format.formatter_of_out_channel chan in
 Visitor.visitFramacFileSameGlobals (new print_cfg fmt) (Ast.get())
let () = Db.Main.extend run