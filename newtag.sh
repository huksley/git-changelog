#!/bin/bash
#
# Create new tag on repository, produce log if new tag is found
#
BASE=${1:-release}
NOW=`date +%Y%m%d`
TAG=$BASE-$NOW
INC=0
LATEST=`git tag | grep $BASE | tail -n1`

while git tag | grep -q "$TAG"; do
    INC=`expr $INC + 1`
    TAG=$BASE-$NOW-$INC
done

DIFF=`git diff $LATEST HEAD`
if [ "$DIFF" != "" ]; then
    git tag $TAG
    echo Creating new tag: $TAG
else
    echo No differences found, not creating new tag
fi
