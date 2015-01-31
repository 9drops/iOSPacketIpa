if test $# -lt 3 ;then
    echo "Usage:$0 ipaName bundleName version"
    echo "[Warnning]Not enough parameters, use default values!"
fi

WORKSPACE=$PWD
OUTPUT=/Users/drops/Desktop

. "$WORKSPACE/autobuild/build.config"

proc=`ls -d *.xcodeproj`
procName=${proc%.*}
buildPlist=`find ./$procName -name *.plist`
CFBundleVersion=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" $buildPlist)
CFBundleVersionINCR=$((${CFBundleVersion%.*} + 1))

#in parameters
JOB_NAME=${1-$procName}
CFBundleName=${2-$procName}
CFBundleShortVersionString=${3-1.0}

/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $CFBundleShortVersionString" $buildPlist
/usr/libexec/PlistBuddy -c "Set :CFBundleName $CFBundleName" $buildPlist
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $CFBundleVersionINCR" $buildPlist

for config in $CONFIGURATIONS; do
    provfile=$(eval echo \$`echo ProvisionFile$config`)
    codesign=$(eval echo \$`echo Codesign$config`)
    cert="$WORKSPACE/autobuild/$provfile"
    fileprefix="$JOB_NAME-$CFBundleVersionINCR-$config";
    ipaname="$fileprefix.ipa"
    echo $ipaname
    echo $codesign-$cert
    xcodebuild clean
    xcodebuild -configuration $config build || failed build;
    app_path=$(ls -d build/$config-iphoneos/*.app)
    xcrun -sdk iphoneos PackageApplication \
    "$app_path" -o "$OUTPUT/$ipaname" \
    --sign "$codesign" --embed "$cert"

    xcrun -sdk iphoneos PackageApplication \
        -v "$app_path"\
        -o "$OUTPUT/$ipaname"\
        --embed "$cert"\
        CODE_SIGN_IDENTITY "$codesign"
echo "Completed, ipa:$OUTPUT/$ipaname, bundle name:$CFBundleName, version:$CFBundleShortVersionString"
done
