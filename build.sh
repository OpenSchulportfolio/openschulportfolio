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
githubInstall "OpenSchulportfolio/dokuwiki-plugin-osp-filelist"      "lib/plugins/filelist"
githubInstall "OpenSchulportfolio/dokuwiki-plugin-osp-newpagelink"   "lib/plugins/newpagelink"

githubInstall "dokufreaks/plugin-tag"                       "lib/plugins/tag"
githubInstall "dokufreaks/plugin-task"                      "lib/plugins/task"
githubInstall "dokufreaks/plugin-blockquote"                "lib/plugins/blockquote"
githubInstall "dokufreaks/plugin-blog"                      "lib/plugins/blog"
githubInstall "dokufreaks/plugin-pagelist"                  "lib/plugins/pagelist"
githubInstall "dokufreaks/plugin-include"                   "lib/plugins/include"
githubInstall "dokufreaks/plugin-cloud"                     "lib/plugins/cloud"
githubInstall "splitbrain/dokuwiki-plugin-smtp"             "lib/plugins/smtp"

githubInstall "splitbrain/dokuwiki-plugin-talkpage"         "lib/plugins/talkpage"
githubInstall "splitbrain/dokuwiki-plugin-dw2pdf"           "lib/plugins/dw2pdf"
githubInstall "splitbrain/dokuwiki-plugin-bureaucracy"      "lib/plugins/bureaucracy"
githubInstall "splitbrain/dokuwiki-plugin-searchindex"      "lib/plugins/searchindex"

githubInstall "cosmocode/changes"                           "lib/plugins/changes"
githubInstall "cosmocode/edittable"                         "lib/plugins/edittable"
githubInstall "cosmocode/dokuwiki-plugin-mediarename"       "lib/plugins/mediarename"

githubInstall "LarsGit223/dokuwiki_note"                    "lib/plugins/note"
githubInstall "LarsGit223/dokuwiki-plugin-odt"              "lib/plugins/odt"
githubInstall "LarsGit223/dokuwiki-plugin-definitionlist"   "lib/plugins/definitionlist"

githubInstall "tatewake/dokuwiki-plugin-backup"             "lib/plugins/backup"
githubInstall "rztuc/dokuwiki-plugin-authchained"           "lib/plugins/authchained"
githubInstall "Klap-in/dokuwiki-plugin-bookcreator"         "lib/plugins/bookcreator"
githubInstall "dr4Ke/cellbg"                                "lib/plugins/cellbg"
githubInstall "dwp-forge/columns"                           "lib/plugins/columns"
githubInstall "michitux/dokuwiki-plugin-move"               "lib/plugins/move"
githubInstall "iobataya/dokuwiki-plugin-tabinclude"         "lib/plugins/tabinclude"
githubInstall "selfthinker/dokuwiki_plugin_wrap"            "lib/plugins/wrap"
githubInstall "ssahara/dw-plugin-encryptedpasswords"        "lib/plugins/encryptedpasswords"

fetchAndInstall "https://github.com/real-or-random/dokuwiki-plugin-icalevents/releases/download/2017-06-16/dokuwiki-plugin-icalevents-2017-06-16.zip" "lib/plugins/icalevents"

# download and install the template
githubInstall "OpenSchulportfolio/dokuwiki-template-portfolio"       "lib/tpl/portfolio2"

# copy additional files
echo 
echo -n "INFO: Copy files from osp to build area..."
cp -a "$FILES/"* "$OUT/"
echo " done."

echo 
echo -n "INFO: Removing install.php and fixsettings.php..."
rm -r "$OUT/fixsettings.php"
rm -r "$OUT/install.php"
echo " done."

echo 
echo "INFO: Applying patches" 
for patch in $(find patches -name '*.patch'); do 
    filetopatch=${patch%*.patch}
    filetopatch=${filetopatch#patches/}
    filetopatch=${OUT}/$filetopatch
    echo " Running: patch  -u $filetopatch  -i $patch"
    patch  -u $filetopatch  -i $patch
done

echo 
echo "INFO Patching version."
sed -i "s/###VERSION###/${version}/" openschulportfolio/lib/tpl/portfolio2/version.php

echo
echo "INFO: Creating packages"
echo -n " Creating install package (tar)..."
tar -czf "${OUT}-${version}-install.tgz" "$OUT"
echo " done."
echo -n " Creating install package (zip)..."
zip -q -r "${OUT}-${version}-install.zip" "$OUT"
echo " done."

cp ${OUT}/conf/dokuwiki.php ./dwphp.tmp
rm -rf ${OUT}/conf
rm -rf ${OUT}/data
mkdir ${OUT}/conf
mv ./dwphp.tmp ${OUT}/conf/dokuwiki.php
echo -n " Creating update package (tar)..."
tar -czf "${OUT}-${version}-update.tgz" "$OUT"
echo " done."
echo -n " Creating update  package (zip)..."
zip -q -r "${OUT}-${version}-update.zip" "$OUT"
echo " done."
