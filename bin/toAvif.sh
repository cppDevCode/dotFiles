#!/bin/bash

avifenc --min 30 --max 63 --speed 10 --yuv 420 -d 8 --codec aom $1 $2
