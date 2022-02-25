(lang dune 3.0)

(name ocn)

(generate_opam_files true)

(source
 (github rosalogia/ocn))

(authors "Ambika Eshwar")

(maintainers "Ambika Eshwar")

(license LICENSE)

; (documentation https://url/to/documentation)

(package
 (name ocn)
 (synopsis "A short example of a UDP server and client in OCaml using Bin_prot for data encoding")
 (description "A short example of a UDP server and client in OCaml using Bin_prot for data encoding")
 (depends ocaml dune bin_prot lwt)
 (tags
  (networking udp bin_prot)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
