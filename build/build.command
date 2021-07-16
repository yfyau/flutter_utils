#!/bin/bash
set -e

CURR_PATH="`dirname \"$0\"`"
cd $CURR_PATH

echo "Enter stage DEV (D) / UAT (U) / PROD (P) :"
read STAGE

case $STAGE in
    d|D|dev|DEV)
        STAGE="DEV"
    ;;

    u|U|uat|UAT)
        STAGE="UAT"
    ;;

    p|P|prod|PROD)
        STAGE="PROD"
    ;;

	*)
		echo 'Inputted stage is invalid'
		exit 1
	;;
esac

# Stash local changes --- START
# get stash count
ORIGINAL_STASH_COUNT=$(git rev-list --walk-reflogs --count refs/stash 2> /dev/null)

if [ $? -ne 0 ]; then
	ORIGINAL_STASH_COUNT=0
fi

# stash any unstaged changes
git stash -q --keep-index --include-untracked

# get stash count
NEW_STASH_COUNT=$(git rev-list --walk-reflogs --count refs/stash 2> /dev/null)

if [ $? -ne 0 ]; then
	NEW_STASH_COUNT=0
fi

echo "Stash count - ${ORIGINAL_STASH_COUNT} vs ${NEW_STASH_COUNT}"

# pop stash controll - 0 is true in shell script practice
SHOULD_STASH_POP=0

if [ $ORIGINAL_STASH_COUNT -eq $NEW_STASH_COUNT ]; then
	echo 'Stash count is same'

	SHOULD_STASH_POP=1
fi
# Stash local changes --- END


# Increase version number
VERSION=$(dart run ./increase_build_number.dart)

# Change Stage
dart run ./change_env_stage.dart <<< $STAGE

# Build IOS
BUILD_OUTPUT=$(flutter build ipa --release --no-tree-shake-icons --obfuscate --split-debug-info=build/app/outputs/symbols)

if [ $? -ne 0 ]; then
	echo "${BUILD_OUTPUT}" | grep 'error •.*$' --color
	echo 'Build IOS Failed'

	# unstash the unstashed changes
	git stash pop -q
	exit 1
fi

# Build APK
BUILD_OUTPUT=$(flutter build apk --no-tree-shake-icons --obfuscate --split-per-abi --split-debug-info=build/app/outputs/symbols)

if [ $? -ne 0 ]; then
	echo "${BUILD_OUTPUT}" | grep 'error •.*$' --color
	echo 'Build APK Failed'

	# unstash the unstashed changes
	git stash pop -q
	exit 1
fi

cd ..
git tag "${STAGE}_v${VERSION}"
git push origin "${STAGE}_v${VERSION}"
git reset --hard

# unstash the unstashed changes
if [ $SHOULD_STASH_POP -eq 0 ]; then
	echo 'Stash Pop'

	git stash pop -q
fi

exit 0