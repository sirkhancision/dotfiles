#!/usr/bin/env bash

cmus-remote -C clear
cmus-remote -C "add ~/Músicas"
cmus-remote -C "update-cache -f"
