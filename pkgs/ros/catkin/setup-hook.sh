# Credit to lopsided98
#
# https://github.com/lopsided98/nix-ros-overlay/blob/master/catkin-setup-hook/setup-hook.sh

declare -gA _catkinPackagesSeen
declare -gA _catkinShEnvHooks
declare -gA _catkinBashEnvHooks

isCatkinPackage() {
    [ -f "$1/.catkin" ]
}

_findCatkinEnvHooks() {
    local pkg="$1"
    local pkgEnvHookDir=$pkg/etc/catkin/profile.d
    if isCatkinPackage "$pkg" && [ -z "${_catkinPackagesSeen[$pkg]:-}" ]; then
        _catkinPackagesSeen["$pkg"]=1
        if [ -d "$pkgEnvHookDir" ]; then
            # This mimics the bahavior of _setup_util.py
            for hook in $(ls -d ${pkgEnvHookDir}/*.sh 2>/dev/null); do
                if [ "${hook}" != "." ]; then
                    _catkinShEnvHooks["$(basename $hook)"]="$hook"
                fi
            done

            for hook in $(ls -d ${pkgEnvHookDir}/*.bash 2>/dev/null); do
                _catkinBashEnvHooks["$(basename $hook)"]="$hook"
            done
        fi
    fi
}
addEnvHooks "$hostOffset" _findCatkinEnvHooks

# Copied from lopisded98
_runCatkinEnvHook() {
    [ -n "$1" ] || return 0
    echo "Sourcing $(basename $1)"
    # Causes hooks to look in the wrong place
    unset CATKIN_ENV_HOOK_WORKSPACE
    # Some hooks assume set +u
    set +u
    # Some hooks fail in stripped down bash during builds
    source "$1" || true
    set -u
}

_runCatkinEnvHooksArray() {
    # Run hooks in sorted order of their file names
    # This would fail if a filename contained EOT
    while IFS= read -rd '' hook; do
        _runCatkinEnvHook "$hook"
    done < <(printf "%s\0" "$@" | \
                 # Replace final / with EOT, separating the file name
                 sed -z 's|\(.*\)/|\1'$'\4''|' | \
                     # Sort on second EOT separated field (file name)
                 LC_ALL=C sort -zt$'\4' -k2 | \
                     # Substitute / back in for EOT
                 sed -z 's|'$'\4''|/|')
}

_runCatkinEnvHooks() {
    _runCatkinEnvHooksArray "${_catkinShEnvHooks[@]}"
    _runCatkinEnvHooksArray "${_catkinBashEnvHooks[@]}"
}
postHooks+=(_runCatkinEnvHooks)

_catkinPostInstallHook() {
    pushd $out
    rm -f *setup.*sh
    popd
}
postInstallHooks+=(_catkinPostInstallHook)
