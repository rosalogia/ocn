open Ocn.Util

let () =
    let server_port = int_of_string (Sys.argv.(1)) in
    let command = Sys.argv.(2) in
    let open Lwt_unix in
    Lwt_main.run begin
        (* Bind a socket to a port and record the server's address *)
        let client_sock = socket PF_INET SOCK_DGRAM 0 in
        let client_addr = localhost 3005 in
        let%lwt () = bind client_sock client_addr in
        let server_addr = localhost server_port in

        (* Encode the command given as command-line input
        with Bin_prot and store the encoded bytes along with
        their length *)
        let (msg, len) = write_bp_string command in
        (* Send the message to the server *)
        let%lwt _ = sendto client_sock msg 0 len [] server_addr in
        (* Create a buffer of default length 50 for receiving the
        response from the server *)
        let buff = Bytes.create 50 in
        let%lwt (_, _) = recvfrom client_sock buff 0 50 [] in
        (* Decode the response with Bin_prot, then print its
        contents *)
        let%lwt () = Lwt_io.printf "%s\n" (read_bp_bytes buff) in
        Lwt.return ()
    end