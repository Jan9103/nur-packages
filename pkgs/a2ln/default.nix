{ lib
, pkgs
, fetchFromGitHub
, python3
, wrapGAppsNoGuiHook
}:

python3.pkgs.buildPythonApplication rec {
  pname = "a2ln";
  version = "1.1.8";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "patri9ck";
    repo = "a2ln-server";
    rev = version;
    #hash = lib.fakeHash;
    hash = "sha256-nyzxPy+4z+GAuYFkX+3a/Qw16bUhrPigkSYajvZPeuo=";
  };

  doCheck = false;  # no tests available

  buildInputs = with pkgs; [
    libnotify
    gtk3
    #gst_all_1.gstreamer
  ];

  nativeBuildInputs = [
    pkgs.gobject-introspection
    wrapGAppsNoGuiHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
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
