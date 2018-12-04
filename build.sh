#!/usr/bin/env bash

source "lib.sh"

# where to store the downloads?
CACHE="cache"
mkdir -p "$CACHE"

# where to prepare the install data?
OUT="openschulportfolio"
rm -rf "$OUT"
mkdir -p "$OUT"

# where to source additional files?
FILES="osp"

# download and install DokuWiki stable
fetchAndInstall "https://download.dokuwiki.org/src/dokuwiki/dokuwiki-stable.tgz" ""

# download and install all the plugins
githubInstall "tatewake/dokuwiki-plugin-backup"             "lib/plugins/backup"
githubInstall "dokufreaks/plugin-blockquote"                "lib/plugins/blockquote"
githubInstall "dokufreaks/plugin-blog"                      "lib/plugins/blog"
githubInstall "Klap-in/dokuwiki-plugin-bookcreator"         "lib/plugins/bookcreator"
githubInstall "dr4Ke/cellbg"                                "lib/plugins/cellbg"
githubInstall "cosmocode/changes"                           "lib/plugins/changes"
githubInstall "dokufreaks/plugin-cloud"                     "lib/plugins/cloud"
githubInstall "dwp-forge/columns"                           "lib/plugins/columns"
githubInstall "LarsGit223/dokuwiki-plugin-definitionlist"   "lib/plugins/definitionlist"
githubInstall "tatewake/dokuwiki-plugin-displaywikipage"    "lib/plugins/displaywikipage"
#githubInstall "" "lib/plugins/doctree2filelist"
githubInstall "splitbrain/dokuwiki-plugin-dw2pdf"           "lib/plugins/dw2pdf"
githubInstall "cosmocode/edittable"                         "lib/plugins/edittable"
githubInstall "dokufreaks/plugin-filelist"                  "lib/plugins/filelist"
#githubInstall "" "lib/plugins/forcessl"
githubInstall "real-or-random/dokuwiki-plugin-icalevents"   "lib/plugins/icalevents"
githubInstall "dokufreaks/plugin-include"                   "lib/plugins/include"
githubInstall "ironiemix/dokuwiki-plugin-osp-infomail"      "lib/plugins/infomail"
githubInstall "cosmocode/dokuwiki-plugin-mediarename"       "lib/plugins/mediarename"
githubInstall "ironiemix/dokuwiki-plugin-menu"              "lib/plugins/menu"
githubInstall "michitux/dokuwiki-plugin-move"               "lib/plugins/move"
githubInstall "LarsGit223/dokuwiki_note"                    "lib/plugins/note"
githubInstall "LarsGit223/dokuwiki-plugin-odt"              "lib/plugins/odt"
githubInstall "dokufreaks/plugin-pagelist"                  "lib/plugins/pagelist"
githubInstall "ironiemix/dokuwiki-plugin-osp-pagepacks"     "lib/plugins/pagepacks"
#githubInstall "" "lib/plugins/shorturl"
githubInstall "iobataya/dokuwiki-plugin-tabinclude"         "lib/plugins/tabinclude"
githubInstall "dokufreaks/plugin-tag"                       "lib/plugins/tag"
githubInstall "splitbrain/dokuwiki-plugin-talkpage"         "lib/plugins/talkpage"
githubInstall "dokufreaks/plugin-task"                      "lib/plugins/task"

# download and install the template
githubInstall "cosmocode/dokuwiki-template-portfolio"       "lib/tpl/portfolio2"

# copy additional files
cp -av "$FILES/"* "$OUT/"

# create tar file
tar -czvf "$OUT.tgz" "$OUT"
