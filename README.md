# test-git-crypt

Tests for https://github.com/makefile-inc/git-crypt

## Key file

[here](./.key-test-git-crypt)

## Clone and prepare

```bash
out_repo_dir="test-git-crypt-$RANDOM"
git clone --recurse-submodules git@github.com:makefile-inc/test-git-crypt.git "$out_repo_dir"
cd "$out_repo_dir"
git checkout -b "test-SOME_PREFIX"
cd makefile-git-crypt/
git fetch -a && git checkout NEW_VERSION
cd ../
git add makefile-git-crypt/
git commit -m "Upgrade to NEW_VERSION"
git push -u origin "test-SOME_PREFIX"
```

## Cases

### Unlock

```bash
# Before unlock
# check that is binary and not readable
#   ./test-1.key
#   ./keys-dir/file.tfa
#   ./keys-dir/sub/sub-key
#   ./first.settings.tf
#   ./second.settings.tf
#   ./dir/third.settings.tf
#   ./subdir/deep/key.txt

# SHOULD FAIL
make git-crypt/repo/symmetric/init KEY_PATH="../${out_repo_dir}.key"
# Should ok
make git-crypt/repo/symmetric/unlock KEY_PATH=".key-test-git-crypt"
# Should ok
make git-crypt/repo/symmetric/unlock KEY_PATH=".key-test-git-crypt"
```

### Remove

```bash
## remove dir
make git-crypt/remove TO_REMOVE=keys-dir/
git push
# check that is not binary and readable
#   ./keys-dir/file.tfa
#   ./keys-dir/sub/sub-key

make git-crypt/remove TO_REMOVE=keys-dir/
# check that not fail and no add commit

## remove single file
make git-crypt/remove TO_REMOVE=test-1.key
git push
# check that is not binary and readable
#   ./test-1.key

make git-crypt/remove TO_REMOVE=test-1.key
# check that not fail and no add commit

## remove files by glob
make git-crypt/remove TO_REMOVE=*.settings.tf
git push
# check that is not binary and readable
#   ./first.settings.tf
#   ./second.settings.tf
#   ./dir/third.settings.tf

make git-crypt/remove TO_REMOVE=*.settings.tf
# check that not fail and no add commit

## remove file in sub-folder
make git-crypt/remove TO_REMOVE=subdir/deep/key.txt
git push
# check that is not binary and readable
#   ./subdir/deep/key.txt

make git-crypt/remove TO_REMOVE=subdir/deep/key.txt
# check that not fail and no add commit
```

### Add

```bash
## Add single file
make git-crypt/add/file FILE=test-1.key
git push
# check that is binary and not readable
#   ./test-1.key

make git-crypt/add/file FILE=test-1.key
# check that not fail and no add commit

## Add dir
make git-crypt/add/dir DIR=keys-dir/
git push
# check that is binary and not readable
#   ./keys-dir/file.tfa
#   ./keys-dir/sub/sub-key

make git-crypt/add/dir DIR=keys-dir/
# check that not fail and no add commit

## Add files by glob
make git-crypt/add/file FILE=*.settings.tf
git push
# check that is binary and not readable
#   ./first.settings.tf
#   ./second.settings.tf
#   ./dir/third.settings.tf

make git-crypt/add/file FILE=*.settings.tf
# check that not fail and no add commit

## Add file in sub-dir
make git-crypt/add/file FILE=subdir/deep/key.txt
git push
# check that is binary and not readable
#   ./subdir/deep/key.txt

make git-crypt/add/file FILE=subdir/deep/key.txt
# check that not fail and no add commit
```
### Add not exist files and dirs

```bash
## Add not exist file
make git-crypt/add/file FILE=NOT_EXISTS_FILE
git push
# check that adding not fail with not exists file and .gitattributes commit

make git-crypt/remove TO_REMOVE=NOT_EXISTS_FILE
git push
# check that removing not fail with not exists file and .gitattributes commit

## File encrypted after add not exist file and cleanup
make git-crypt/add/file FILE=NOT_EXISTS_FILE_ADDED_AFTER
echo "secret" > NOT_EXISTS_FILE_ADDED_AFTER
git add NOT_EXISTS_FILE_ADDED_AFTER
git commit -m "add NOT_EXISTS_FILE_ADDED_AFTER secret"
git push
# check that is binary and not readable
#   ./NOT_EXISTS_FILE_ADDED_AFTER

make git-crypt/remove TO_REMOVE=NOT_EXISTS_FILE_ADDED_AFTER
rm -f NOT_EXISTS_FILE_ADDED_AFTER
git add NOT_EXISTS_FILE_ADDED_AFTER
git commit -m "remove NOT_EXISTS_FILE_ADDED_AFTER secret"
git push
# check that ./NOT_EXISTS_FILE_ADDED_AFTER fully removed 

## Add not exist dir
make git-crypt/add/dir DIR=NOT_EXISTS_DIR/
git push
# check that adding not fail with not exists dir and .gitattributes commit

make git-crypt/remove TO_REMOVE=NOT_EXISTS_DIR/
git push
# check that removing not fail with not exists dir and .gitattributes commit

## Files encrypted after add not exist dir and cleanup
make git-crypt/add/dir DIR=NOT_EXISTS_DIR_ADDED_AFTER/
mkdir NOT_EXISTS_DIR_ADDED_AFTER/
echo "in folder secret" > NOT_EXISTS_DIR_ADDED_AFTER/added.txt
git add NOT_EXISTS_DIR_ADDED_AFTER/
git commit -m "add NOT_EXISTS_DIR_ADDED_AFTER/ dir secret"
git push
# check that is binary and not readable
#   ./NOT_EXISTS_DIR_ADDED_AFTER/added.txt

make git-crypt/remove TO_REMOVE=NOT_EXISTS_DIR_ADDED_AFTER/
rm -rfv NOT_EXISTS_DIR_ADDED_AFTER/
git add NOT_EXISTS_DIR_ADDED_AFTER/
git commit -m "remove NOT_EXISTS_DIR_ADDED_AFTER/ dir secret"
git push
# check that ./NOT_EXISTS_DIR_ADDED_AFTER/ dir fully removed 
```
