(** Produces bytes corresponding to the input string
encoded with Bin_prot, along with the byte-length of the
resultant Bin_prot encoding *)
val write_bp_string : string -> bytes * int
(** Produces a string representation of a Unix
socket address *)
val addr_to_string : Unix.sockaddr -> string
(** Produces a decoded string from an encoded Bin_prot
string buffer *)
val read_bp_str : Bin_prot.Common.buf -> string
(** Produces a decoded string from the bytes corresponding
to an encoded Bin_prot string buffer *)
val read_bp_bytes : bytes -> string
(** Produces the Unix socket address corresponding to
localhost:<port> for convenience *)
val localhost : int -> Unix.sockaddr