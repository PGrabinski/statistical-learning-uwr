#!/bin/bash
set -ex

git config --global user.name "Paweł Grabiński"
git config --global user.email "pawelrgrabinski@gmail.com"

sudo apt-get update
sudo apt-get install -y texlive-latex-base texlive-latex-extra