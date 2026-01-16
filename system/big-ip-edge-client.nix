{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  options.big-ip-edge-client.enable = lib.mkEnableOption "Enable BIG-IP Edge Client";

  config =
    let
      f5fpc = pkgs.stdenv.mkDerivation {
        pname = "f5fpc";
        version = "7261.2025.1009.1";
        src = pkgs.fetchzip {
          url = "https://ucloud.univie.ac.at/public.php/dav/files/jHBoq29zbfTxd4f";
          hash = "sha256-s+nANg4l2mN7GHk9BydTc2d2R/G1axB7WIEWnq0BZog=";
          stripRoot = false;
          extension = "tar.xz";
        };

        nativeBuildInputs = [ pkgs.autoPatchelfHook ];

        installPhase = ''
          mkdir -p $out/vendor
          cp -r . $out/vendor

          #mkdir -p $out/bin
          #ln -s $out/vendor/f5fpc_x86_64 $out/bin/f5fpc
        '';
      };
      svpn-program = "f5fpc_svpn_${f5fpc.version}";
      root-certificate = pkgs.fetchurl {
        url = "https://zid.univie.ac.at/fileadmin/user_upload/d_zid/zid-open/daten/datennetz/vpn/Linux/SHA-2_Root_USERTrust_RSA_Certification_Authority.crt";
        hash = "sha256-ij28uSqxxid2R/4quFNrXJgqu/2x8d9XKOAbkGq6lTo=";
      };
    in
    lib.mkIf config.big-ip-edge-client.enable {
      environment.systemPackages = [ f5fpc ];

      security.wrappers.f5fpc = {
        source = "${f5fpc}/vendor/f5fpc_x86_64";
        owner = "root";
        group = "root";
        capabilities = "cap_kill+ep";
      };

      security.wrappers.f5fpc-svpn = {
        source = "${f5fpc}/vendor/svpn_x86_64";
        program = svpn-program;
        owner = "root";
        group = "root";
        setuid = true;
      };

      security.pki.certificateFiles = [ "${root-certificate}" ];

      system.activationScripts = {
        f5fpc.text =
          let
            svpn-location = "/usr/local/lib/F5Networks/SSLVPN";
          in
          ''
            mkdir -p ${svpn-location}
            ln -sf ${config.security.wrapperDir}/${svpn-program}  ${svpn-location}/svpn_x86_64

            # mkdir -p /etc/ssl/certs
            # ln -sf  /etc/ssl/certs/fc5a8f99.0
          '';
      };
    };
}
