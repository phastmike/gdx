#!/bin/bash

for i in 16 22 24 32 48 256 512
do
    inkscape -z -e hicolor/$i\x$i/apps/org.ampr.ct1enq.gdx.png -w $i -h $i org.ampr.ct1enq.gdx.svg
done
