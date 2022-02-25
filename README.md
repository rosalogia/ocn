# OCaml UDP Networking Example

This small project demonstrates a simple server-client application using UDP in OCaml and [`Bin_prot`](https://github.com/janestreet/bin_prot)
for data encoding. The server maintains a counter that clients may ask to increment or read.

## Running

### Server

```bash
$ esy
$ esy dune exec server/main.exe 3000
```

### Client

```bash
$ esy
$ esy dune exec client/main.exe 3000 inc
# or
$ esy dune exec client/main.exe 3000 read
```