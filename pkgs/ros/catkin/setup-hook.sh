declare -gA _catkinPackagesSeen

isCatkinPackage() {
    [ -f "$1/.catkin" ]
}

_findCatkinEnvHooks() {
    local pkg="$1"
    local pkgEnvHookDir=$pkg/etc/catkin/profile.d
    if isCatkinPackage "$pkg" && [ -z "${_catkinPackagesSeen[$pkg]:-}" ]; then
        _catkinPackagesSeen["$pkg"]=1
    fi
}
addEnvHooks "$hostOffset" _findCatkinEnvHooks

_catkinPostInstallHook() {
    pushd $out
    rm -f *setup.*sh
    popd
}
postInstallHooks+=(_catkinPostInstallHook)
