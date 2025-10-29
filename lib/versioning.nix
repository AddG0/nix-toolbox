{lib}:
with lib; {
  # Parse semantic version string
  parseVersion = versionStr: let
    parts = splitString "." versionStr;
    major = toInt (head parts);
    minor = toInt (head (tail parts));
    patch = toInt (head (tail (tail parts)));
  in {
    inherit major minor patch;
    string = versionStr;
  };

  # Compare two semantic versions
  compareVersions = v1: v2: let
    ver1 =
      if isString v1
      then parseVersion v1
      else v1;
    ver2 =
      if isString v2
      then parseVersion v2
      else v2;
  in
    if ver1.major != ver2.major
    then
      if ver1.major > ver2.major
      then 1
      else -1
    else if ver1.minor != ver2.minor
    then
      if ver1.minor > ver2.minor
      then 1
      else -1
    else if ver1.patch != ver2.patch
    then
      if ver1.patch > ver2.patch
      then 1
      else -1
    else 0;

  # Check if version satisfies constraint
  satisfiesConstraint = version: constraint: let
    ver =
      if isString version
      then parseVersion version
      else version;
    constraintMatch = builtins.match "([~^>=<]+)([0-9.]+)" constraint;
  in
    if constraintMatch == null
    then throw "Invalid version constraint: ${constraint}"
    else let
      operator = head constraintMatch;
      targetVersion = parseVersion (head (tail constraintMatch));
      cmp = compareVersions ver targetVersion;
    in
      if operator == "~"
      then ver.major == targetVersion.major && ver.minor == targetVersion.minor && cmp >= 0
      else if operator == "^"
      then ver.major == targetVersion.major && cmp >= 0
      else if operator == ">="
      then cmp >= 0
      else if operator == ">"
      then cmp > 0
      else if operator == "<="
      then cmp <= 0
      else if operator == "<"
      then cmp < 0
      else if operator == "=" || operator == ""
      then cmp == 0
      else throw "Unsupported version operator: ${operator}";

  # Pin versions for reproducible builds
  pinVersions = versions: mapAttrs (name: constraint: constraint) versions;
}
