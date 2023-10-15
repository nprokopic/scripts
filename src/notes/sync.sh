#!/bin/bash

# source "../io/log.sh"

sync-notes() {
    cd ~/src/nprokopic/notes
    git add .
    git commit -m "Sinhronizacija beleški"
    git pull --rebase
    git push
}
