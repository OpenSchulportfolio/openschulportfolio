# show a message and exit with code 1
#
# @param {string} message
die() {
    echo "$1"
    exit 1
}

# extract the given URL to the given directory
#
# We assume that zip files have no top directory while tgz files have (which we strip)
# This is a very naive approach but works for our use case currently
#
# @param {string} url to download
# @param {string} destination path to unpack into
fetchAndInstall() {
    SRC=$1
    DST=$2

    if [[ -z "$DST" ]]; then
        DL='dokuwiki.archive'
    else
        DL=`basename $DST`;
        DL="$DL.archive"
    fi

    if [[ ! -s "$CACHE/$DL" ]]; then
        wget "$SRC" -O "$CACHE/$DL" || die 'Download failed'
    fi

    mkdir -p "$OUT/$DST"


    if file -b "$CACHE/$DL" | grep 'Zip archive'; then
        unzip "$CACHE/$DL" -d "$OUT/$DST/"  || die 'Failed to extract ZIP archive'
    else
        tar -xzvf "$CACHE/$DL" --strip-components 1 -C "$OUT/$DST" || die 'Failed to extract TGZ archive'
    fi
}

# download and install the master branch of the given repo
#
# @param {string} repo in the form user/reponame
# @param {string} destination path to unpack into
githubInstall() {
    REPO=$1
    DST=$2
    URL="https://github.com/$REPO/archive/master.tar.gz"
    fetchAndInstall "$URL" "$DST"
}
