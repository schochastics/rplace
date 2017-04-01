# Analyse r/place
Some code to analyse r/place

## bitmap file

Get the bitmap file every 10 seconds

```shell
while test 1 ; do wget https://www.reddit.com/api/place/board-bitmap ; sleep 10 ; done
```
## convert to png

Can be done with [this](https://github.com/trosh/rplace/blob/master/rplacelapse.py) code.

## convert to mp4

```shell
ffmpeg -framerate 128 -i board-bitmap.%d.png -c:v libx264 -crf 21 place.mp4
```
change framerate at will

## color distribution

use `colorDistr.R`
