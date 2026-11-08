{ lib, stdenv, fetchurl, autoreconfHook, libpcap }:

# reaver — WPS PIN brute-force attack, used by Sentrixa Command's WiFi
# pentest wizard (tool_availability_service.dart lists it, apt package
# "reaver"). Not in nixpkgs, so packaged here from the actively-maintained
# community fork (upstream reaver-wps has been dead since ~2013; t6x's fork
# is what every distro that still ships reaver — including Kali — actually
# packages).

stdenv.mkDerivation rec {
  pname = "reaver";
  version = "1.6.6";

  src = fetchurl {
    url = "https://github.com/t6x/reaver-wps-fork-t6x/archive/refs/tags/v${version}.tar.gz";
    sha256 = "sha256-cxiXgrII0SuN3cTynTLh9ysfNgnlc8nqlRDe6+w5RYM=";
  };

  sourceRoot = "reaver-wps-fork-t6x-${version}/src";

  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [ libpcap ];

  meta = {
    description = "WPS PIN brute-force attack tool (Sentrixa Command WiFi pentest wizard)";
    homepage = "https://github.com/t6x/reaver-wps-fork-t6x";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    mainProgram = "reaver";
  };
}
