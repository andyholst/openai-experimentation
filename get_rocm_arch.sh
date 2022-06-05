#!/bin/bash

rocminfo | grep -m1 gfx | awk '{print $2}'
