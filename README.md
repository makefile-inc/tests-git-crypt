# test-git-crypt

Tests for https://github.com/makefile-inc/git-crypt

## Key file

[here](./.key-test-git-crypt)

## Cases

### Unlock

```bash
out_repo_dir="test-git-crypt-$RANDOM"
git clone --recurse-submodules git@github.com:makefile-inc/test-git-crypt.git "$out_repo_dir"
cd "$out_repo_dir"
git checkout -b "test-SOME_PREFIX"
git push -u origin "test-SOME_PREFIX"

# check that is binary and not readable
#   ./test-1.key
#   ./keys-dir/file.tfa
#   ./keys-dir/sub/sub-key
#   ./first.settings.tf
#   ./second.settings.tf
#   ./dir/third.settings.tf

# SHOULD FAIL
make git-crypt/symmetric/init KEY_PATH="../${out_repo_dir}.key"
# Should ok
make git-crypt/symmetric/unlock KEY_PATH=".key-test-git-crypt"
# Should ok
make git-crypt/symmetric/unlock KEY_PATH=".key-test-git-crypt"
```

### Remove

```bash
make git-crypt/remove TO_REMOVE=test-1.key
git push
# check that is not binary and readable
#   ./test-1.key

make git-crypt/remove TO_REMOVE=keys-dir/
git push
# check that is not binary and readable
#   ./keys-dir/file.tfa
#   ./keys-dir/sub/sub-key

make git-crypt/remove TO_REMOVE=*.settings.tf
git push
# check that is not binary and readable
#   ./first.settings.tf
#   ./second.settings.tf
#   ./dir/third.settings.tf
```

### Add

```bash
make git-crypt/add/file FILE=test-1.key
git push
# check that is binary and not readable
#   ./test-1.key

make git-crypt/add/dir DIR=keys-dir
git push
# check that is binary and not readable
#   ./keys-dir/file.tfa
#   ./keys-dir/sub/sub-key

make git-crypt/add/file FILE=*.settings.tf
git push
# check that is binary and not readable
#   ./first.settings.tf
#   ./second.settings.tf
#   ./dir/third.settings.tf
```
