**General Structure**

This repository contains a small C project implementing a FUSE-based client for the Plan 9 9P protocol.  
Main components:

1. **Top-level source files**
   - `9pfs.c` – FUSE filesystem implementation and program entry point.
   - `9p.c` – Core 9P protocol helpers (open, walk, read/write, etc.).
   - `util.c` and `util.h` – Small allocation and debugging helpers.
   - Header files (`9pfs.h`, `fcall.h`, `libc.h`, `auth.h`) declare shared structures and constants.

2. **`lib/` directory**
   - Contains code adapted from plan9front for encoding/decoding 9P messages (`convS2M.c`, `convM2S.c`), manipulating `Dir` structures (`convD2M.c`, `convM2D.c`), authentication utilities (`auth_*`), and some helpers (`readn.c`, `strecpy.c`).

3. **Documentation**
   - `readme.md` introduces the project and provides install instructions and benchmark comparisons.
   - `9pfs.1` (mandoc format) documents usage and options such as authentication and caching.

4. **Build**
   - Compilation is handled via a simple `Makefile`. Adjust `BIN` and `MAN` variables to control installation paths.

**Important Details**

- The FUSE operations are registered in `fsops` and implemented in functions like `fsgetattr`, `fsread`, and `fswrite` within `9pfs.c`.
- The `main()` routine parses command-line options, sets up the connection to a 9P server (TCP or UNIX socket), performs optional authentication through Plan 9’s factotum, attaches to the server, then starts FUSE.
- Caching is directory-based. A special filename `.fscache` clears cached entries when read or written. Cache management functions (`addtocache`, `iscached`, `clearcache`) are near the bottom of `9pfs.c`.
- The low-level protocol helpers in `9p.c` assemble and send 9P messages. For example, `_9pwalk` performs a Walk operation on a given path and returns a new file identifier.
- Structures for 9P messages (`Fcall`), directory information (`Dir`), and constants are defined in `fcall.h` and `libc.h`.

**Learning Path**

1. **Understand the 9P protocol**  
   Reading `fcall.h` alongside the helper functions in `lib/` clarifies how 9P messages are serialized and parsed.

2. **Explore FUSE basics**  
   Study how `fsops` in `9pfs.c` maps FUSE callbacks to 9P operations. The FUSE documentation will help interpret these functions.

3. **Authentication and Factotum**  
   The optional `-a` flag triggers authentication; look at `auth_proxy` and `auth_getkey` in `lib/` for how factotum is used.

4. **Caching design**  
   Examine `lookupdir` and related routines in `9p.c`/`9pfs.c` to see how directory caching and the `.fscache` control file work.

5. **Build and run**  
   Follow the simple instructions in `readme.md` for building (`make`). Testing with a local or remote 9P service can illustrate the client’s behavior.

This project is a minimal yet full-featured 9P filesystem client and serves as a compact reference for working with the protocol via FUSE.
