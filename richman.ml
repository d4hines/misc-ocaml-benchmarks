module Int_map = Map.Make (Int)

module Coord_map = Map.Make (Bytes)

type chunk = Bytes.t Coord_map.t

let random_chunk () =
  List.init (Random.int 100) Fun.id
  |> List.fold_left
       (fun acc _ ->
         let bytes = Bytes.create 4 in
         let zero = Bytes.get bytes 3 in
         let () = Bytes.set_int32_ne bytes 0 (Random.bits32 ()) in
         let ty = Bytes.create 1 in
         Bytes.set ty 0 (Bytes.get bytes 3);
         Bytes.set bytes 3 zero;
         let coords = Bytes.mapi (fun i _ -> Bytes.get bytes i) (Bytes.create 3) in
         Coord_map.add coords ty acc)
       Coord_map.empty

let t = Unix.gettimeofday ()

let () = print_endline "Preparing giant map..."

let giant_map : chunk Int_map.t =
  List.init 1 Fun.id
  |> List.fold_left
       (fun acc i ->
         Int_map.add i (random_chunk ()) acc)
       Int_map.empty

let () = Format.printf "Done in %3f\n%!" (Unix.gettimeofday () -. t)

let main () =

let random_indexes = List.init 1_000_000 (fun _ -> 1) in

let t = Unix.gettimeofday () in

let chunk = ref None in

let () =  
  List.iter (fun i -> 
    try
    let c = Int_map.find i giant_map in
    chunk := Some c
     with  | _ -> ()
    ) random_indexes in

Format.printf "Done in %3f\n%!" (Unix.gettimeofday () -. t) 

let bench () =
  print_endline "richman benches";
  ignore @@ List.init 5 (fun _ -> main())
