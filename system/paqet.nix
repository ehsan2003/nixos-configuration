{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
  installShellFiles,
}:
buildGoModule rec {
  pname = "paqet";
  version = "1.0.0-alpha.14";
  src = fetchFromGitHub {
    owner = "hanselime";
    repo = "${pname}";
    rev = "v${version}";
    hash = "sha256-U5NBbXkyYcEemKgApNeDvxe3dKAt6HViUXlYcvvK0UU=";
  };

  vendorHash = "sha256-Vf3bKdhlM4vqzBv5RAwHeShGHudEh1VNTCFxAL/cwLw=";

  nativeBuildInputs = [ installShellFiles ];
  buildInputs = [ libpcap ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/${pname}

    if [ "1" = "${if stdenv.buildPlatform.canExecute stdenv.hostPlatform then "1" else "0"}" ]; then
      installShellCompletion --cmd ${pname} \
        --bash <($out/bin/${pname} completion bash) \
        --fish <($out/bin/${pname} completion fish) \
        --zsh  <($out/bin/${pname} completion zsh)
    fi
  '';

  meta = with lib; {
    description = "A bidirectional Packet-level proxy built using raw sockets in Go";
    homepage = "https://github.com/hanselime/paqet";
    license = licenses.mit;
    maintainers = with maintainers; [ nix-julia ];
  };
}
