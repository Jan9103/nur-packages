# nushell-custom

This package was forked from this NUR's nushell package (which was forked from nixpkgs)

Note: i build this version for myself. This version will most likely get no support and
might contain more bugs. Use at your own risk.

Special things about the `custom` version:
- based on the main branch
- fix `ls` error when a symlink has no target ([MR](https://github.com/nushell/nushell/pull/8276)) 
- better error for `else if` ([MR](https://github.com/nushell/nushell/pull/8274))
- a improved `cp` progress bar ([MR](https://github.com/nushell/nushell/pull/8325))
