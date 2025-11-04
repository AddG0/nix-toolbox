{
  lib,
  stdenv,
  uv,
  python312,
  makeWrapper,
  ...
}:
stdenv.mkDerivation rec {
  pname = "mcp-google-sheets";
  version = "latest";

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${uv}/bin/uvx $out/bin/mcp-google-sheets \
      --add-flags "--python ${python312}/bin/python3.12" \
      --add-flags "mcp-google-sheets@latest"
  '';

  meta = with lib; {
    description = "MCP server that bridges AI assistants with Google Sheets and Google Drive APIs";
    homepage = "https://github.com/xing5/mcp-google-sheets";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
