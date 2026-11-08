{
  description = "Sentrixa's first-party Linux apps, packaged for Nix — individually installable per user (`nix profile install github:sentrixa/sentrixa-apps#<app>`), separate from the private sentrixa-os repo so any machine can reach them, not just ours.";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };

      # Sentrixa's curated security toolkit: the tools Sentrixa Command and the
      # Satellite rely on, plus the standard pentest staples. Re-exported from the
      # pinned nixpkgs (so installs are cached binaries, not source builds) under
      # one stable, public flake - the Sentrixa Store installs them from here.
      securityToolkit = with pkgs; {
        # network discovery and scanning
        inherit nmap arp-scan traceroute whois netcat-openbsd net-snmp avahi;
        # packet capture and analysis
        inherit wireshark tcpdump;
        tshark = wireshark-cli;
        # web application testing
        inherit nikto sqlmap gobuster dirb burpsuite;
        # password and credential auditing
        inherit john hashcat;
        hydra = thc-hydra;
        # wireless
        inherit aircrack-ng;
        reaver = callPackage ./pkgs/reaver { };
        # exploitation
        inherit metasploit;
        # reverse engineering
        inherit ghidra;
        # forensics and disk tools
        inherit dcfldd sleuthkit foremost nwipe;
        # network defence (what the Satellite runs)
        inherit suricata zeek clamav;
      };
    in
    {
      packages.${system} = securityToolkit // {
        stratavault = pkgs.callPackage ./pkgs/stratavault { };
        default = self.packages.${system}.stratavault;
      };
    };
}
