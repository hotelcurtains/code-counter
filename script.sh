#!/bin/bash

# name of the user or org you want to rip from.
username="torvalds"

# name of the folder to dump all the new folders into.
# DO NOT USE SPACES.
collection="cc"

# amount of repos you want to pull;
# they are pulled in order of last commit.
limit=50

# script breaks if the collection folder exists.
rm -rf ./"$collection"

# clone and flatten each repo
gh repo list $username --limit $limit | while read -r repo _; do
	gh repo clone "$repo" ./"$collection"/"$repo" -- --depth=1
	rm -rf ./"$collection"/"$repo"/.git
	find ./"$collection"/ -mindepth 2 -type f -name '*.*'  -exec mv -t ./"$collection"/ -f --backup='t' '{}' +
	rm -rf ./"$collection"/$username
done

echo -----------------------------------------

# sort all the files
for f in ./"$collection"/*; do
	f=$(basename "$f")
	ext=$(echo ./"$collection"/"$(echo "${f%%.~*}" | cut -d '.' -f 2)"/ | tr '[:upper:]' '[:lower:]' )

	( mkdir -p "$ext"  &&
	mv -f "./$collection/$f" "${ext}" ) ||
	( mkdir -p ./"$collection"/unknown/ &&
	mv -f "./"$collection"/$f" ./"$collection"/unknown/ )
done

# display line counts
for f in ./"$collection"/*; do
	count=$(wc -l $f/* | tail --lines=1)
	count=${count%% total*}
	count=${count%% ./*}

	echo ${f##*/}: $'\t' $count lines
done

echo - - - - - - - - - - - - - - - - - - - - -

# display total word count
count=$(wc -l cc/*/* | tail --lines=1)
count=${count%% total*}
count=${count%% ./*}
echo TOTAL:$'\t'$count lines
