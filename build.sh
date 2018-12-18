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
githubInstall "cosmocode/changes"                                    "lib/plugins/changes"
githubInstall "cosmocode/dokuwiki-plugin-mediarename"                "lib/plugins/mediarename"
githubInstall "cosmocode/edittable"                                  "lib/plugins/edittable"
githubInstall "dokufreaks/plugin-blockquote"                         "lib/plugins/blockquote"
githubInstall "dokufreaks/plugin-blog"                               "lib/plugins/blog"
githubInstall "dokufreaks/plugin-cloud"                              "lib/plugins/cloud"
githubInstall "dokufreaks/plugin-filelist"                           "lib/plugins/filelist"
githubInstall "dokufreaks/plugin-include"                            "lib/plugins/include"
githubInstall "dokufreaks/plugin-pagelist"                           "lib/plugins/pagelist"
githubInstall "dokufreaks/plugin-tag"                                "lib/plugins/tag"
githubInstall "dokufreaks/plugin-task"                               "lib/plugins/task"
githubInstall "dr4Ke/cellbg"                                         "lib/plugins/cellbg"
githubInstall "dwp-forge/columns"                                    "lib/plugins/columns"
githubInstall "iobataya/dokuwiki-plugin-tabinclude"                  "lib/plugins/tabinclude"
githubInstall "Klap-in/dokuwiki-plugin-bookcreator"                  "lib/plugins/bookcreator"
githubInstall "LarsGit223/dokuwiki-plugin-definitionlist"            "lib/plugins/definitionlist"
githubInstall "LarsGit223/dokuwiki-plugin-odt"                       "lib/plugins/odt"
githubInstall "LarsGit223/dokuwiki_note"                             "lib/plugins/note"
githubInstall "michitux/dokuwiki-plugin-move"                        "lib/plugins/move"
githubInstall "OpenSchulportfolio/dokuwiki-doctree2filelist"         "lib/plugins/doctree2filelist"
githubInstall "OpenSchulportfolio/dokuwiki-plugin-menu"              "lib/plugins/menu"
githubInstall "OpenSchulportfolio/dokuwiki-plugin-osp-infomail"      "lib/plugins/infomail"
githubInstall "OpenSchulportfolio/dokuwiki-plugin-osp-pagepacks"     "lib/plugins/pagepacks"
githubInstall "OpenSchulportfolio/dokuwiki-plugin-shorturl"          "lib/plugins/shorturl"
githubInstall "OpenSchulportfolio/dokuwiki-plugin-simplefilelist"    "lib/plugins/simplefilelist"
githubInstall "splitbrain/dokuwiki-plugin-dw2pdf"                    "lib/plugins/dw2pdf"
githubInstall "splitbrain/dokuwiki-plugin-talkpage"                  "lib/plugins/talkpage"
githubInstall "tatewake/dokuwiki-plugin-backup"                      "lib/plugins/backup"
fetchAndInstall "https://github.com/real-or-random/dokuwiki-plugin-icalevents/releases/download/2017-06-16/dokuwiki-plugin-icalevents-2017-06-16.zip" \
                "lib/plugins/icalevents"

# download and install the template
githubInstall "OpenSchulportfolio/dokuwiki-template-portfolio" "lib/tpl/portfolio2"

# copy additional files
cp -av "$FILES/"* "$OUT/"

# create tar file
tar -czvf "$OUT.tgz" "$OUT"
