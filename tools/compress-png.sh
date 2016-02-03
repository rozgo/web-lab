#!/bin/bash

convert 150001.png -depth 8 -colors 32 -type palettematte GIF:- | convert - PNG8:150001-better.png
