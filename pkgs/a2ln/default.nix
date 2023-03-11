{ lib
, pkgs
, fetchFromGitHub
, python311
, wrapGAppsNoGuiHook
}:

python311.pkgs.buildPythonApplication rec {
  pname = "a2ln";
  version = "1.1.10";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "patri9ck";
    repo = "a2ln-server";
    rev = version;
    hash = "sha256-tMTCc9ngSCbDwjzTVCQ9Km8onp/t1hvn3pj5PO+1/Hc=";
  };

  doCheck = false;  # no tests available

  buildInputs = with pkgs; [
    libnotify
    gtk3
  ];

  nativeBuildInputs = [
    pkgs.gobject-introspection
    wrapGAppsNoGuiHook
  ];

  propagatedBuildInputs = with python311.pkgs; [
    setuptools

    pillow
    pygobject3
    pyzmq
    setproctitle
    qrcode
  ];

  meta = with lib; {
    homepage = "https://patri9ck.dev/a2ln/";
    description = "Android 2 Linux Notifications (A2LN) is a way to display your Android phone notifications on your Linux computer. This repository contains the server part of A2LN.";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
