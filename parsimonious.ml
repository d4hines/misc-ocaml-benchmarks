module Int32_map = Map.Make (Int32)

module Coord = struct
  type t = char * char * char

  let compare (a, a', a'') (b, b', b'') =
    match Char.compare a b with
    | 0 -> ( match Char.compare a' b' with 0 -> Char.compare a'' b'' | x -> x)
    | x -> x
end

module Coord_map = Map.Make (Coord)

type chunk = char Coord_map.t

let random_chunk () =
  List.init (Random.int 100) Fun.id
  |> List.fold_left
       (fun acc _ ->
         let bytes = Bytes.create 4 in
         let () = Bytes.set_int32_ne bytes 0 (Random.bits32 ()) in
         let x = Bytes.get bytes 0 in
         let y = Bytes.get bytes 1 in
         let z = Bytes.get bytes 2 in
         let ty = Bytes.get bytes 3 in
         Coord_map.add (x, y, z) ty acc)
       Coord_map.empty

let t = Unix.gettimeofday ()

let () = print_endline "Preparing giant map..."

let giant_map : chunk Int32_map.t =
  List.init 1_000_000 Int32.of_int
  |> List.fold_left
       (fun acc (i : Int32.t) ->
         Int32_map.add i (random_chunk ()) acc)
       Int32_map.empty

let () = Format.printf "Done in %3f\n%!" (Unix.gettimeofday () -. t)

let main () =

let random_indexes = List.init 1_000_000 (fun _ -> Random.int32 Int32.max_int ) in

let t = Unix.gettimeofday () in

let chunk = ref None in

let () =  
  List.iter (fun i -> 
    try
    let c = Int32_map.find i giant_map in
    chunk := Some c
     with  | _ -> ()
    ) random_indexes in

Format.printf "Done in %3f\n%!" (Unix.gettimeofday () -. t) 

let bench () =
  print_endline "Parsimonious benches";
  ignore @@ List.init 5 (fun _ -> main())
