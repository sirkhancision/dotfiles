#!/bin/sh
sed -i \
         -e 's/rgb(0%,0%,0%)/#232323/g' \
         -e 's/rgb(100%,100%,100%)/#D9D6D9/g' \
    -e 's/rgb(50%,0%,0%)/#1D1D1D/g' \
     -e 's/rgb(0%,50%,0%)/#C84454/g' \
 -e 's/rgb(0%,50.196078%,0%)/#C84454/g' \
     -e 's/rgb(50%,0%,50%)/#1D1D1D/g' \
 -e 's/rgb(50.196078%,0%,50.196078%)/#1D1D1D/g' \
     -e 's/rgb(0%,0%,50%)/#D9D6D9/g' \
	"$@"