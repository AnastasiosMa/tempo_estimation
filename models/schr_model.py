#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jan 29 11:02:06 2024

@author: anmavrol
"""

#install tempocnn
import os
from tempocnn.classifier import TempoClassifier
from tempocnn.feature import read_features
import pandas as pd

model_name = 'cnn'
dir_name = 'wav_tracks'
os.chdir(dir_name) 
track_filenames = os.listdir()
classifier = TempoClassifier(model_name)
tempi = []

for val in track_filenames:
    if 'mp4'not in val:
        track_filenames.remove(val)
print(len(track_filenames))
for k in track_filenames:
    features = read_features(k)
    tempo = classifier.estimate_tempo(features, interpolate=False)
    print(f"Estimated global tempo: {tempo}")
    tempi.append(tempo)


dc = {'name':track_filenames,'tempo':tempi}
data = pd.DataFrame(dc)
data.to_csv('global_tempo.csv',index=False)

    