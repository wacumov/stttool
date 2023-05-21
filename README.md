# STTtool
STTtool (Speech-To-Text tool) is a command-line utility for converting audio files to text using a pretrained model.

## Installation
To install STTtool, you simply need to run the following command in your terminal:
```bash
make install
```

## Downloading Models
You can download pretrained models from [here](https://huggingface.co/ggerganov/whisper.cpp).

## Usage
You can use the STTtool by providing it with paths to the input audio file, the pretrained model, and the output text file as command line arguments.

### Command
```bash
stttool transcribe <input_file_path> <model_file_path> <output_file_path>
```

### Arguments
- `input_file_path`: Path to the input audio file that you want to transcribe.
- `model_file_path`: Path to the pretrained model used for speech recognition.
- `output_file_path`: Path to the output text file where the transcription will be written.
