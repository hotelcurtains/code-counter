#!/bin/bash

# name of the user or org you want to rip from.
username="example"

# name of the folder to dump all the new folders into.
# DO NOT USE SPACES.
collection="cc"

# amount of repos you want to pull;
# they are pulled in order of last commit.
limit=3

# script breaks if the collection folder exists.
rm -rf ./"$collection"

# clone and flatten each repo
gh repo list $username --limit $limit | while read -r repo _; do
	gh repo clone "$repo" ./"$collection"/"$repo" -- --depth=1

	# removing .git info and dotfiles. they're hard to deal with and, really, who cares?
	rm -rf ./"$collection"/"$repo"/.git*
	find ./"$collection"/ -mindepth 2 -name ".*" -type f -exec rm -rf '{}' \;
	
	find ./"$collection"/ -mindepth 2 -name "*.*" -type f -exec mv '{}' ./"$collection" -f --backup='t' \;
	rm -rf ./"$collection"/$username
done

# sort all the files
for f in ./"$collection"/*; do
	
	if [[ "$f" == *.~* ]];then
		old="$f"
		f=$(echo $f | sed -r 's/(.*)\.(.*)\.~([0-9]{1,})~$/\1_\3.\2/')
		mv -f "$old" "$f"
	fi

	f=$(basename "$f")
	ext=$(echo ./"$collection"/"$(echo "${f%%.~*}" | cut -d '.' -f 2)"/ | tr '[:upper:]' '[:lower:]' )
	
	( ( mkdir -p "$ext" ) && 
	mv -f "./$collection/$f" "${ext}" ) ||
	( (mkdir -p ./"$collection"/unknown/) &&
	mv -f "./"$collection"/$f" ./"$collection"/unknown/ )
done
printf "\e[0m"

echo -----------------------------------------

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
