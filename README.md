# Code Counter
Counts the lines of code you've published to GitHub, and sorts all of the files by extension
for further analysis.

This is made for WSL with Ubuntu. It probably works anywhere you run Bash on Ubuntu. 

# Setup

## GitHub cli
If you already have the cli set up, you don't need this part.

From anywhere, run:
```bash
$ sudo apt install gh
$ gh auth login
```
and login as requested. This is how the script accesses your repos.

## `username="torvalds"`
Name of the user or org you want to clone from. For the main use case this is your username. If
you want to do this with an organization, you can use the org's name.

## `collection="cc"`
Name of the folder to dump all the new folders into. It will be placed in the directory of the
script. DO NOT USE SPACES.
All of your files will be sorted by their extension into subfolders of `$collection`. That is
to say, if we place the script in `~` and run it from there, the final result will look like
this:
```
ubuntu@wsl:~$ tree ~
/home/ubuntu
├── cc
│   ├── c
│   │   ├── main.c
│   │   └── utils.c
│   ├── h
│   │   └── utils.h
│   ├── md
│   │   └── notes.md
│   ├── png
│   │   ├── image-1.png
│   │   ├── image-2.png
│   │   ├── image-3.png
│   │   └── image.png
│   └── sh
│       └── fulltest.sh
└── script.sh
```

## `limit=50`
Amount of repos you want to include. They are pulled in order of most recent commit. They are
cloned with a depth of 1 to make download faster; git files get deleted anyway.

# Running
Just run it. Copy the script into the directory you want to have the collection, then `cd`
there and run:
```
$ bash script.sh
```
***It will take a while.*** Especially if you have a lot of repos, since the slowest part by far is the cloning.