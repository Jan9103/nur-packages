# nushell-custom

This package was forked from this NUR's nushell package (which was forked from nixpkgs)

Note: i build this version for myself. This version will most likely get no support and
might contain more bugs. Use at your own risk.


## Special things about the `custom` version:

- based on the main branch
- fix `ls` error when a symlink has no target ([MR](https://github.com/nushell/nushell/pull/8276)) 
- better error for `else if` ([MR](https://github.com/nushell/nushell/pull/8274))
- a improved `cp` progress bar ([MR](https://github.com/nushell/nushell/pull/8325))
- enable error reporting from vt ([MR](https://github.com/nushell/nushell/pull/8373))
- readd `get -i` ([MR](https://github.com/nushell/nushell/pull/8488))
- fix `{} | explore` (no MR)


## Goals:

- assemble a "future version" of nushell
- keep the syntax close to the current one (scripts should work the same as in the last/next release)
  - A example for an exception: [MR 8475](https://github.com/nushell/nushell/pull/8475) is a revert (to a behaviour 1 nu version back), fixes a bug and will most likely get merged into the next Hotfix.
