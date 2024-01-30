#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jan 30 17:28:06 2024

@author: anmavrol
"""

import os
from pydub import AudioSegment
#AudioSegment.converter = "Users/anmavrol/Documents/projects/github/tempo_estimation/ffmpeg"
#AudioSegment.ffmpeg = "Users/anmavrol/Documents/projects/github/tempo_estimation/ffmpeg"
#AudioSegment.ffprobe ="Users/anmavrol/Documents/projects/github/tempo_estimation/ffmpeg"

dir_input = 'mp4_tracks'
dir_output = 'wav_tracks'

track_names = os.listdir(dir_input)

# convert mp4 to wav
for name in track_names:
    sound = AudioSegment.from_file(dir_input + '/' + name,format="mp4")
    sound.export(dir_output + '/' + name, format="wav")