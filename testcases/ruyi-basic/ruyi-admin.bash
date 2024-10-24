# NOTE: Test ruyi admin
# RUN: bash %s | FileCheck %s

export RUYI_DEBUG=x

tmp_path=/tmp/rit-ruyi-basic-ruyi-admin
mkdir -p "$tmp_path"

ruyi admin manifest $0
# CHECK-SAME: [
# CHECK: "name":
# CHECK: "size":
# CHECK: "checksums":
ruyi admin manifest --format json $0
# CHECK-SAME: [
# CHECK: "name":
# CHECK: "size":
# CHECK: "checksums":

ruyi admin manifest --format toml $0
# CHECK-LABEL: [[distfiles]]
# CHECK-NEXT: name =
# CHECK-NEXT: size =
# CHECK-EMPTY:
# CHECK-NEXT: [distfiles.checksums]
# CHECK-NEXT: sha256 =
# CHECK-NEXT: sha512 =

ruyi admin manifest --format toml $0 > "$tmp_path"/test.toml
ruyi admin format-manifest "$tmp_path"/test.toml
cat "$tmp_path"/test.toml
# CHECK-LABEL: format = "v1"
# CHECK-EMPTY:
# CHECK-SAME: [metadata]
# CHECK: desc =
# CHECK: vendor =
# CHECK: [[distfiles]]
# CHECK: [distfiles.checksums]

rm -rf "$tmp_path"