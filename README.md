# r-place
Some code to analyse r/place

# bitmap file

Get the bitmap file every 10 seconds

```shell
while test 1 ; do wget https://www.reddit.com/api/place/board-bitmap ; sleep 5 ; done
```
# convert to png

Can be done with [this](https://github.com/trosh/rplace/blob/master/rplacelapse.py) code.
