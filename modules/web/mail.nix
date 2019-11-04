{ config, pkgs, ... }:

{
  imports = [
    (fetchTarball {
      url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/v2.2.1/nixos-mailserver-v2.2.1.tar.gz";
      sha256 = "03d49v8qnid9g9rha0wg2z6vic06mhp0b049s3whccn1axvs2zzx";
    })
  ];

  config = {
    networking.firewall.allowedTCPPorts = [ 25 ];
    mailserver = {
      enable = true;
      fqdn = "mail.breakds.org";
      domains = [ "breakds.org" ];

      # A list of all login accounts. To create the password hashes, use
      # mkpasswd -m sha-512 "super secret password"
      loginAccounts = {
        "bds@breakds.org" = {
          hashedPassword = "$6$HMeq1NVWy$nkaFBQDm3hJJ8QNImJ1JbK6fEv4XsgTOH6uXr7lNuShD/kkhJskXM1GxXUnRM7lyiGDt0eKZnr5qlRziDk6mE0";

          aliases = [
            "postmaster@breakds.org"
          ];

          # Make this user the catchAll address for domains example.com and
          # example2.com
          catchAll = [
            "breakds.org"
          ];
        };
      };

      dkimKeyDirectory = "/var/dkim/dkim";

      # Extra virtual aliases. These are email addresses that are forwarded to
      # loginAccounts addresses.
      extraVirtualAliases = {};

      # Use Let's Encrypt certificates. Note that this needs to set up a stripped
      # down nginx and opens port 80.
      certificateScheme = 3;

      # Enable IMAP and POP3
      enableImap = true;
      enablePop3 = true;
      enableImapSsl = true;
      enablePop3Ssl = true;

      # Enable the ManageSieve protocol
      enableManageSieve = true;

      # whether to scan inbound emails for viruses (note that this requires at least
      # 1 Gb RAM for the server. Without virus scanning 256 MB RAM should be plenty)
      virusScanning = false;
    };
  };
}
