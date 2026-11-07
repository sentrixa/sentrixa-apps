{ lib, stdenv, fetchurl, dpkg, autoPatchelfHook, makeWrapper, wrapGAppsHook3
, gtk3, glib, pango, cairo, gdk-pixbuf, atk, harfbuzz, libepoxy, libGL, libglvnd
, fontconfig, freetype, zlib, xz, util-linux, libsecret, alsa-lib, mpv-unwrapped
, libx11, libxext, libxrender, libxi, libxrandr, libxcursor, libxfixes, libxcb
, gst_all_1, xdg-utils }:

# StrataVault 1.3.1 — encrypted notes / knowledge management (Flutter Linux). Packaged straight from
# the Sentrixa apt repo's .deb (the same file the laptop installs), patched to run on Sentrixa OS.

stdenv.mkDerivation {
  pname = "stratavault";
  version = "1.3.1";

  src = fetchurl {
    url = "https://repo.sentrixa.co.uk/sentrixa/pool/main/s/stratavault/stratavault_1.3.1_amd64.deb";
    sha256 = "0a36a4fcc43379c8e11f4774e2bcc512dfb19be950f4d4062e9d984771fcd774";
  };

  nativeBuildInputs = [ dpkg autoPatchelfHook makeWrapper wrapGAppsHook3 ];
  buildInputs = [
    gtk3 glib pango cairo gdk-pixbuf atk harfbuzz libepoxy libGL libglvnd fontconfig freetype
    zlib xz util-linux libsecret alsa-lib mpv-unwrapped
    libx11 libxext libxrender libxi libxrandr libxcursor libxfixes libxcb
    gst_all_1.gstreamer gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good
    stdenv.cc.cc.lib
  ];
  dontWrapGApps = true;
  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/opt $out/bin $out/share
    cp -r usr/lib/stratavault $out/opt/stratavault
    cp -r usr/share/applications usr/share/icons $out/share/ 2>/dev/null || true
    makeWrapper $out/opt/stratavault/stratavault $out/bin/stratavault \
      "''${gappsWrapperArgs[@]}" \
      --prefix PATH : ${lib.makeBinPath [ xdg-utils ]} \
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : ${lib.makeSearchPath "lib/gstreamer-1.0" [ gst_all_1.gstreamer gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good ]}
    # the deb's .desktop points at /usr/bin/stratavault
    sed -i 's|^Exec=.*|Exec=stratavault %U|' $out/share/applications/stratavault.desktop
    runHook postInstall
  '';

  meta = {
    description = "StrataVault — encrypted notes and knowledge management (Flutter Linux)";
    mainProgram = "stratavault";
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.unfree;
  };
}
