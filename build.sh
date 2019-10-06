#!/usr/bin/env bash

source "lib.sh"
source "version"

# where to store the downloads?
CACHE="cache"

# where to prepare the install data?
OUT="openschulportfolio"

if [ "x$1" == "xclean" ]; then 
    echo 
    echo "INFO: Cleaning up"
    echo -n " Removing cache.."
    rm -rf $CACHE
    echo " done."
    echo -n " Removing OSP builds..."
    rm -rf ${OUT}*.tgz  
    rm -rf ${OUT}*.zip  
    echo " done."
fi

rm -rf "$OUT"
mkdir -p "$OUT"
mkdir -p "$CACHE"

# where to source additional files?
FILES="osp"

# download and install DokuWiki stable
fetchAndInstall "https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz" ""

# download and install all the plugins
githubInstall "OpenSchulportfolio/dokuwiki-plugin-osp-infomail"      "lib/plugins/infomail"
githubInstall "OpenSchulportfolio/dokuwiki-doctree2filelist"         "lib/plugins/doctree2filelist"
githubInstall "OpenSchulportfolio/dokuwiki-plugin-menu"              "lib/plugins/menu"
githubInstall "OpenSchulportfolio/dokuwiki-plugin-osp-pagepacks"     "lib/plugins/pagepacks"
githubInstall "OpenSchulportfolio/dokuwiki-plugin-shorturl"          "lib/plugins/shorturl"

githubInstall "tatewake/dokuwiki-plugin-backup"             "lib/plugins/backup"
githubInstall "rztuc/dokuwiki-plugin-authchained"           "lib/plugins/authchained"
githubInstall "dokufreaks/plugin-blockquote"                "lib/plugins/blockquote"
githubInstall "dokufreaks/plugin-blog"                      "lib/plugins/blog"
githubInstall "Klap-in/dokuwiki-plugin-bookcreator"         "lib/plugins/bookcreator"
githubInstall "dr4Ke/cellbg"                                "lib/plugins/cellbg"
githubInstall "cosmocode/changes"                           "lib/plugins/changes"
githubInstall "dokufreaks/plugin-cloud"                     "lib/plugins/cloud"
githubInstall "dwp-forge/columns"                           "lib/plugins/columns"
githubInstall "LarsGit223/dokuwiki-plugin-definitionlist"   "lib/plugins/definitionlist"
#githubInstall "tatewake/dokuwiki-plugin-displaywikipage"    "lib/plugins/displaywikipage"
githubInstall "splitbrain/dokuwiki-plugin-dw2pdf"           "lib/plugins/dw2pdf"
githubInstall "cosmocode/edittable"                         "lib/plugins/edittable"
githubInstall "dokufreaks/plugin-filelist"                  "lib/plugins/filelist"
githubInstall "cosmocode/dokuwiki-plugin-simplefilelist"    "lib/plugins/simplefilelist"
#githubInstall "" "lib/plugins/forcessl"
fetchAndInstall "https://github.com/real-or-random/dokuwiki-plugin-icalevents/releases/download/2017-06-16/dokuwiki-plugin-icalevents-2017-06-16.zip" "lib/plugins/icalevents"
githubInstall "dokufreaks/plugin-include"                   "lib/plugins/include"
githubInstall "cosmocode/dokuwiki-plugin-mediarename"       "lib/plugins/mediarename"
githubInstall "michitux/dokuwiki-plugin-move"               "lib/plugins/move"
githubInstall "LarsGit223/dokuwiki_note"                    "lib/plugins/note"
githubInstall "LarsGit223/dokuwiki-plugin-odt"              "lib/plugins/odt"
githubInstall "dokufreaks/plugin-pagelist"                  "lib/plugins/pagelist"
githubInstall "iobataya/dokuwiki-plugin-tabinclude"         "lib/plugins/tabinclude"
githubInstall "dokufreaks/plugin-tag"                       "lib/plugins/tag"
githubInstall "splitbrain/dokuwiki-plugin-talkpage"         "lib/plugins/talkpage"
githubInstall "dokufreaks/plugin-task"                      "lib/plugins/task"

# download and install the template
githubInstall "OpenSchulportfolio/dokuwiki-template-portfolio"       "lib/tpl/portfolio2"

# copy additional files
echo 
echo -n "INFO: Copy files from osp to build area..."
cp -a "$FILES/"* "$OUT/"
echo " done."

echo 
echo "INFO: Applying patches" 
for patch in $(find patches -name '*.patch'); do 
    filetopatch=${patch%*.patch}
    filetopatch=${filetopatch#patches/}
    filetopatch=${OUT}/$filetopatch
    patch  -u $filetopatch  -i $patch

done


echo
echo "INFO: Creating packages"
echo -n " Creating install package (tar)..."
tar -czf "${OUT}-${version}-install.tgz" "$OUT"
echo " done."
echo -n " Creating install package (zip)..."
zip -q -r "${OUT}-${version}-install.zip" "$OUT"
echo " done."


rm -rf ${OUT}/conf
echo -n " Creating update package (tar)..."
tar -czf "${OUT}-${version}-update.tgz" "$OUT"
echo " done."
echo -n " Creating update  package (zip)..."
zip -q -r "${OUT}-${version}-update.zip" "$OUT"
echo " done."
