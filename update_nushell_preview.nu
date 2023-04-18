#!/usr/bin/env nu
let pkg = ($env | get -i PKG | default "nushell-preview")

let preset_file = $"./pkgs/($pkg)/preset.nix"
let build_file = $"./pkgs/($pkg)/default.nix"
let build_file_backup = $"./pkgs/($pkg)/default.nix.old"

def generate_file [
	src_rev: string
	src_sha256: string = "lib.fakeHash"
	cargo_sha256: string = "lib.fakeHash"
] {
	open -r $preset_file
	| str replace -s '{src_rev}' $src_rev
	| str replace -s '{src_sha256}' $src_sha256
	| str replace -s '{cargo_sha256}' $cargo_sha256
	| save -rf $build_file
}

def get_expected_hash [] {
	do { nix-build -A $pkg } | complete | get stderr
	| parse -r 'got: *(?P<sha>sha256-[a-zA-Z0-9+/]+=)' | get 0.sha
}

mv -f $build_file $build_file_backup

try {
	let commit = (http get "https://api.github.com/repos/nushell/nushell/commits/main").sha
	let commit = $'"($commit)"'
	print $"commit: ($commit)"

	generate_file $commit
	let src_sha256 = $'"(get_expected_hash)"'
	print $"src_sha256: ($src_sha256)"

	generate_file $commit $src_sha256
	let cargo_sha256 = $'"(get_expected_hash)"'
	print $"cargo_sha256: ($cargo_sha256)"

	generate_file $commit $src_sha256 $cargo_sha256

	let build_attempt = (do { nix-build -A $pkg } | complete)
	if $build_attempt.exit_code != 0 {
		print -e "build failed"
		print -e ($build_attempt.stderr)
		error make {msg: "failed build"}
	}

	print 'build finished and verified.'
	rm $build_file_backup
} catch {|err|
	print -e "Auto update failed! restoring backup.."
	mv -fv $build_file_backup $build_file
	print -e $err
}

# vim: ft=nu
