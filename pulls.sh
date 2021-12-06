#!/bin/bash

for ARGUMENT in "$@"
do

    NAME=$(echo $ARGUMENT | cut -f1 -d=)  

done

SUM=0
for ((i=1;i<=3;i++));  do    I=$(curl -s -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/datamove/linux-git2/pulls?state=all?per_page=100&page=$i" | jq '[.[] | select(.user.login == '\"$NAME\"')] | length'); SUM=$(($SUM+$I)); done

echo "PULLS $SUM"


TIME=$(curl -s -H "Accept: application/vnd.github.v3+json" ["{https://api.github.com/repos/datamove/linux-git2/pulls?state=all?per_page=100&page=1}" "{https://api.github.com/repos/datamove/linux-git2/pulls?state=all?per_page=100&page=2}" "{https://api.github.com/repos/datamove/linux-git2/pulls?state=all?per_page=100&page=3}"] | jq '[.[] | select(.user.login == '$NAME') | .created_at] | min')

NUMBER=$(curl -s -H "Accept: application/vnd.github.v3+json" ["{https://api.github.com/repos/datamove/linux-git2/pulls?state=all?per_page=100&page=1}" "{https://api.github.com/repos/datamove/linux-git2/pulls?state=all?per_page=100&page=2}" "{https://api.github.com/repos/datamove/linux-git2/pulls?state=all?per_page=100&page=3}"] | jq -r --arg TIME "$TIME" '.[] | select(.user.login == '$NAME') | select(.created_at=='$TIME') | .number')


echo "EARLIEST $NUMBER"




MERGED=$(curl -s -H "Accept: application/vnd.github.v3+json" ["{https://api.github.com/repos/datamove/linux-git2/pulls?state=all?per_page=100&page=1}" "{https://api.github.com/repos/datamove/linux-git2/pulls?state=all?per_page=100&page=2}" "{https://api.github.com/repos/datamove/linux-git2/pulls?state=all?per_page=100&page=3}"] | jq -r --arg TIME "$TIME" '.[] | select(.user.login == '$NAME') | select(.created_at=='$TIME') | .merged_at')

if [[ -n "$MERGED" ]]
then
    echo "1"
else
    echo "0"
fi