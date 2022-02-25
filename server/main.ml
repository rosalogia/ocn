open Lwt
open Ocn.Util

(* A mutable reference to an integer which the client can ask
to increment or read *)
let counter = ref 0

(* Initializes a socket and binds it to localhost:<port>
before returning it *)
let create_socket port =
    let open Lwt_unix in
    let ssock = socket PF_INET SOCK_DGRAM 0 in
    let addr = ADDR_INET(Unix.inet_addr_loopback, port) in
    let%lwt () = bind ssock addr in
    let%lwt () = Lwt_io.printf "Bound to address: %s\n" (addr_to_string addr) in
    return ssock

let handle_message msg =
    let msg_length = Bytes.length msg in
    let buff = Bin_prot.Common.create_buf msg_length in
    Bin_prot.Common.blit_bytes_buf msg buff ~len:msg_length;
    let (response, len) =
        (match read_bp_str buff with
        | "read" -> string_of_int !counter
        | "inc" -> counter := !counter + 1; "Counter has been incremented"
        | _ as c -> Printf.sprintf "Unknown command %s" c) 
        |> write_bp_string in
    (response, len)

let create_server ssock =
    let rec serve () =
        let open Lwt_unix in
        (* Create a buffer of default size 50 for storing the incoming
        message from the client *)
        let buff = Bytes.create 50 in
        let [@warning "-8"] ADDR_INET (_, port) = getsockname ssock in
        let%lwt () = Lwt_io.printf "Waiting on port %d\n" port in

        (* Receive a message from a connecting client, blit it onto the buffer
        we created earlier, and store the client's address as caddr *)
        let%lwt (_, caddr) = recvfrom ssock buff 0 50 [] in
        (* Print the address of the client to visually verify the connection *)
        let%lwt () = Lwt_io.printf "Connected to client %s\n" (addr_to_string caddr) in
        (* Print the message received from the client *)
        let msg_str = read_bp_bytes buff in
        let%lwt () = Lwt_io.printf "Got message %s\n\n" msg_str in
        (* Prepare a message to send back to the client, then send it
        with sendto *)
        let (res, res_len) = handle_message buff in
        let%lwt _ = sendto ssock res 0 res_len [] caddr in
        serve () in
    serve

let () =
    let port = int_of_string (Sys.argv.(1)) in
    Lwt_main.run begin
        let%lwt ssock = create_socket port in
        let serve = create_server ssock in
        serve ()
    end