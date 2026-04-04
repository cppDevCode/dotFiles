#!/bin/bash

ffmpeg -i $1 -c:a libopus -b:a 128K $2
