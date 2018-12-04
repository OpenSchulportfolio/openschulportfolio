die() {
    echo "$1"
    exit 1
}

fetchAndInstall() {
    SRC=$1
    DST=$2

    if [[ -z "$DST" ]]; then
        DL='dokuwiki.tgz'
    else
        DL=`basename $DST`;
        DL="$DL.tgz"
    fi

    if [[ ! -s "$CACHE/$DL" ]]; then
        wget "$SRC" -O "$CACHE/$DL" || die 'Download failed'
    fi

    mkdir -p "$OUT/$DST"
    tar -xzvf "$CACHE/$DL" --strip-components 1 -C "$OUT/$DST" || die 'Failed to extract archive'
}

githubInstall() {
    REPO=$1
    DST=$2
    URL="https://github.com/$REPO/archive/master.tar.gz"
    fetchAndInstall "$URL" "$DST"
}
