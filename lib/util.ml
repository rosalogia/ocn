let write_bp_string s =
    let buff = Bin_prot.(Utils.bin_dump Type_class.bin_writer_string s) in
    let len = Bin_prot.Size.bin_size_string s in
    let byte_msg = Bytes.create len in
    Bin_prot.Common.blit_buf_bytes buff byte_msg ~len;
    (byte_msg, len)

let addr_to_string addr =
    let open Lwt_unix in
    match addr with
    | ADDR_UNIX (a) -> a
    | ADDR_INET (ia, p) -> Printf.sprintf "%s:%d" (Unix.string_of_inet_addr ia) p

let read_bp_str buff =
    Bin_prot.Read.bin_read_string buff ~pos_ref:(ref 0)

let read_bp_bytes b =
    let len = Bytes.length b in
    let buff = Bin_prot.Common.create_buf (Bytes.length b) in
    Bin_prot.Common.blit_bytes_buf b buff ~len;
    read_bp_str buff

let localhost port =
  Lwt_unix.ADDR_INET(Unix.inet_addr_loopback, port)