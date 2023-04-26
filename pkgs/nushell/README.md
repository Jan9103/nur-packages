# nushell

This was forked from `nixos/nixpkgs` some time ago.

## variants

### nushell

Latest vanilla version of nushell.  
The modifications are kept to a absolute minimum:
- remove `let else`, since nix's outdated rustc does not support it

### nushell-preview

A unreleased version of nushell based on the github `main` branch.  
I try to keep this fairly vanilla and stable, but no guarantees.

### nushell-unstable

**Not actively maintained / updated**

Me trying to hack something together in case nushell breaks the build
system again with complete disregard for stability.  
Might update or might stay on the same outdated version forever.

### nushell-custom

**Not actively maintained / updated**

A fairly stable customized build of nushell (including unmerged patches, etc)
based on the github `main` branch (but not necessarily the same commit as `nushell-preview`)
