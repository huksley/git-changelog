#!/bin/sh
revlist=$(git rev-list HEAD)
(
  echo '<?xml version="1.0"?>'
  echo '<?xml-stylesheet type="text/xsl" href="changelog.xsl"?>'
  echo '<log>'
  for rev in $revlist
  do
    echo "$(git log -1 --date=iso --pretty=format:"<logentry revision=\"%h\">%n<author>%an</author>%n<date>%ad</date>%n<msg><![CDATA[%B]]></msg>%n" $rev | sed -re "s/&/&amp;/g;s/\[\]//g")"
    files=$(git log -1 --pretty="format:" --name-only $rev)
    echo '<paths>'
    for file in $files
    do
      echo "<path>$file</path>"
    done
    echo '</paths>'
    echo '</logentry>'
  done
  echo '</log>'
)
