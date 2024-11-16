{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  # enable access to the TPM
  security.tpm2.enable = true;
  users.users.tobias.extraGroups = [ "tss" ];

  environment.systemPackages = [ pkgs.unstable.ssh-tpm-agent ];

  # as generated by `ssh-tpm-agent --install-user-units`
  systemd.user.services.ssh-tpm-agent = {
    name = "ssh-tpm-agent.service";
    description = "ssh-tpm-agent";
    documentation = [
      "man:ssh-agent(1)"
      "man:ssh-add(1)"
      "man:ssh(1)"
    ];

    requires = [ "ssh-tpm-agent.socket" ];
    unitConfig = {
      ConditionEnvironment = "!SSH_AGENT_PID";
    };
    serviceConfig = {
      Environment = "SSH_AUTH_SOCK=%t/ssh-tpm-agent.sock";
      ExecStart = pkgs.unstable.ssh-tpm-agent + /bin/ssh-tpm-agent;
      SuccessExitStatus = "2";
      Type = "simple";
    };
  };

  # as generated by `ssh-tpm-agent --install-user-units`
  systemd.user.sockets.ssh-tpm-agent = {
    name = "ssh-tpm-agent.socket";
    description = "SSH TPM agent socket";
    documentation = [
      "man:ssh-agent(1)"
      "man:ssh-add(1)"
      "man:ssh(1)"
    ];

    wantedBy = [ "sockets.target" ];
    listenStreams = [ "%t/ssh-tpm-agent.sock" ];
    socketConfig = {
      Service = "ssh-tpm-agent.service";
      SocketMode = "0600";
    };
  };
}
