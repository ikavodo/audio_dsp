# Audio DSP MATLAB Implementations

This repository contains various **Audio DSP (Digital Signal Processing)** algorithms implemented in **MATLAB**, for the "Audio Signal Processing" course at Aalto University.
Algorithms are placed within separate directories because their implementation may involve a proof-of-concept, demanding some audio files (which are thus supplied). 

## Algorithms Included

### 1. **DPW (Differentiated Parabolic Wave)**
   The **DPW algorithm** is a signal synthesis method that generates a waveform by modeling the shape of a parabolic curve. It is used for synthesizing specific waveforms that resemble natural sounds, particularly for creating sounds in physical modeling synthesis or as a way to generate bell-like tones.

### 2. **audioPaK (Lossless Compression Algorithm)**
   **audioPaK** is a lossless compression algorithm designed specifically for audio signals. It works by removing redundancies within the audio data without compromising quality. This can significantly reduce the file size while retaining full fidelity, making it suitable for applications where data storage is a concern but sound quality cannot be sacrificed.

### 3. **Karplus-Strong Algorithm**
   The **Karplus-Strong algorithm** is a classic method used in digital synthesis to simulate plucked string instruments like guitars or harps. It works by recursively filtering a short burst of white noise through a delay line, emulating the vibration of a string. This algorithm is widely used for physical modeling synthesis and sound design for stringed instruments.

### 4. **Onset Detection**
   **Onset detection** is a technique used to identify the beginning (onset) of musical events, such as beats or notes, within an audio signal. This algorithm is crucial for tasks like tempo estimation, rhythmic analysis, and segmentation of audio recordings. The onset detection process typically looks for sudden changes in the signal's amplitude or spectral content, indicating the start of an event.

### 5. **Shelving Filter Implementation**
   **Shelving filters** are a type of equalizer used in audio processing to modify the frequency response of a signal. A shelving filter boosts or attenuates the amplitude of frequencies above or below a certain cutoff frequency. This is particularly useful for adjusting the tone of an audio signal, such as adding brightness to a track by boosting higher frequencies or enhancing the warmth by adjusting low frequencies.

### 6. **Velvet Noise**
   **Velvet noise** is a type of noise signal that has a smooth, soft texture, unlike white or pink noise, which can sound harsh or too sharp. It is used for applications where a more natural-sounding noise is desired, such as in sound design for film, relaxation music, or procedural audio generation. Velvet noise is often used to simulate non-intrusive background noise that blends smoothly with other sounds.

## Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/ikavodo/audio_dsp.git
    ```

2. Open MATLAB and add the repository to your MATLAB path:
    ```matlab
    addpath(genpath('path/to/audio_dsp'));
    ```
