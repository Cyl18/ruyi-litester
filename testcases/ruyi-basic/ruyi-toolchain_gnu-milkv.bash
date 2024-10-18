# NOTE: Test ruyi gnu-milkv toolchains
# REQUIRES: x86_64
#
# RUN: bash %s | FileCheck %s

export RUYI_DEBUG=x

ruyi update

ruyi install gnu-milkv-milkv-duo-bin gnu-milkv-milkv-duo-musl-bin gnu-milkv-milkv-duo-elf-bin

venv_path=/tmp/rit-ruyi-basic-ruyi-toolchain_gnu-milkv
ruyi venv -t gnu-milkv-milkv-duo-musl-bin -t gnu-milkv-milkv-duo-elf-bin --sysroot-from gnu-milkv-milkv-duo-musl-bin generic "$venv_path"
# CHECK-LABEL: info: Creating a Ruyi virtual environment at
# CHECK: info: The virtual environment is now created.

mkdir "$venv_path"/test_tmp
cat > "$venv_path"/test_tmp/test.c << EOF
int main() {return 0;}
EOF

source "$venv_path"/bin/ruyi-activate

echo Gcc compilation checkpoint
riscv64-unknown-elf-gcc -O2 -o "$venv_path"/test_tmp/test.c "$venv_path"/test_tmp/test.o
echo $?
riscv64-unknown-linux-musl-gcc -O2 -o "$venv_path"/test_tmp/test.c "$venv_path"/test_tmp/test.o
echo $?
# CHECK-LABEL: Gcc compilation checkpoint
# CHECK-COUNT-2: 0

ruyi-deactivate
rm -rf "$venv_path"

ruyi venv -t gnu-milkv-milkv-duo-bin generic "$venv_path"
mkdir "$venv_path"/test_tmp
cat > "$venv_path"/test_tmp/test.c << EOF
int main() {return 0;}
EOF
source "$venv_path"/bin/ruyi-activate

riscv64-unknown-linux-gnu-gcc -O2 -o "$venv_path"/test_tmp/test.c "$venv_path"/test_tmp/test.o
echo $?
# CHECK-SAME: 0

ruyi-deactivate
rm -rf "$venv_path"
