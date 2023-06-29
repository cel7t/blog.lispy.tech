#!/usr/bin/env bash

cd ~/Documents/Code/Guile/blog
haunt build
cd ..
cp -r blog/site/* git-blog/
cp -r blog/* git-blog/src/
cd git-blog/src/
rm -r site
rm */*.~undo-tree~
cd ..
git add *
git commit -m "Automatic Commit @ $(date +%s)"
git push origin master
