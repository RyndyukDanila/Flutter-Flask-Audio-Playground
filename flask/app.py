import io
import flask
import os
import speech_recognition as sr
import matplotlib.pyplot as plt
import librosa
import librosa.display
from librosa.feature import melspectrogram
from flask import after_this_request, send_file, url_for
from werkzeug.utils import secure_filename

import utils


app = flask.Flask(__name__)

directory = os.getcwd()
print(directory)
app.config['FOLDER'] = directory


@app.route('/', methods=['GET'])
def index():
    json_file = {}
    json_file['main'] = 'test'
    return flask.jsonify(json_file)


@app.route("/STT", methods=["POST"])
def predictSTT():
    try:
        filename = './stt.wav'
        filename = secure_filename(filename)

        language = flask.request.form.get('speech-language')
        audio_file = flask.request.files["file"]
        audio_file.save(filename)

        with sr.AudioFile(filename) as source:
            r = sr.Recognizer()
            audio = r.record(source)
            text = r.recognize_google(audio,
                                      language=language
                                      )
            print(f'You said: {text}')
        
        # await utils.create_and_save_wave_plot('./STTWave.png')
        imageWaveFilename = secure_filename('./STTWave.png')
        
        y, sample_rate = librosa.load(filename)
        fig, ax = plt.subplots(nrows=2, sharex=True, sharey=True)
        librosa.display.waveshow(y, sr=sample_rate, ax=ax[0])
        ax[0].set(title='Monophonic')
        ax[0].label_outer()

        y, sample_rate = librosa.load(filename)
        y_harm, y_perc = librosa.effects.hpss(y)
        librosa.display.waveshow(y_harm, sr=sample_rate, alpha=0.25, ax=ax[1])
        librosa.display.waveshow(y_perc, sr=sample_rate, color='r', alpha=0.5, ax=ax[1])
        ax[1].set(title='Harmonic + Percussive')

        fig.savefig(imageWaveFilename)
        
        # await utils.create_and_save_mel_plot('./STTMel.png')
        imageMelFilename = secure_filename('./STTMel.png')
        y, sample_rate = librosa.load(filename)
        fig = plt.figure()
        ax = fig.add_subplot(111)
        ax.axes.get_xaxis().set_visible(False)
        ax.axes.get_yaxis().set_visible(False)
        ax.set_frame_on(False)
        mel_spectogram = melspectrogram(y=y)
        log_mel_spectrogram = librosa.power_to_db(mel_spectogram)
        librosa.display.specshow(log_mel_spectrogram)
        plt.savefig(imageMelFilename, bbox_inches='tight',pad_inches=0)

        json_file = {}
        json_file['STTtext'] = text
        return flask.jsonify(json_file)
    
    except:
        raise


@app.route("/TTS", methods=["POST"])
def predictTTS():
    try:
        filename = './tts.wav'
        filename = secure_filename(filename)

        from gtts import gTTS

        slow = flask.request.form.get('tts-slow')
        if slow == 'true': slow = True
        else: slow = False

        lang = flask.request.form.get('text-language')
        text = flask.request.form.get('tts-text')

        print(f'You send: {text}')

        tts = gTTS(
                slow=slow,
                lang=lang, 
                text=text,
                )

        tts.save(filename)

        # await utils.create_and_save_wave_plot('./TTSWave.png')
        imageWaveFilename = secure_filename('./TTSWave.png')
        
        y, sample_rate = librosa.load(filename)
        fig, ax = plt.subplots(nrows=2, sharex=True, sharey=True)
        librosa.display.waveshow(y, sr=sample_rate, ax=ax[0])
        ax[0].set(title='Monophonic')
        ax[0].label_outer()

        y, sample_rate = librosa.load(filename)
        y_harm, y_perc = librosa.effects.hpss(y)
        librosa.display.waveshow(y_harm, sr=sample_rate, alpha=0.25, ax=ax[1])
        librosa.display.waveshow(y_perc, sr=sample_rate, color='r', alpha=0.5, ax=ax[1])
        ax[1].set(title='Harmonic + Percussive')

        fig.savefig(imageWaveFilename)
        
        # await utils.create_and_save_mel_plot('./TTSMel.png')
        imageMelFilename = secure_filename('./TTSMel.png')
        y, sample_rate = librosa.load(filename)
        fig = plt.figure()
        ax = fig.add_subplot(111)
        ax.axes.get_xaxis().set_visible(False)
        ax.axes.get_yaxis().set_visible(False)
        ax.set_frame_on(False)
        mel_spectogram = melspectrogram(y=y)
        log_mel_spectrogram = librosa.power_to_db(mel_spectogram)
        librosa.display.specshow(log_mel_spectrogram)
        plt.savefig(imageMelFilename, bbox_inches='tight',pad_inches=0)

        return send_file(
            f'../{filename}', 
            )
    
    except:
        raise


@app.route("/download", methods=["POST"])
def download():
    try:
        filename = flask.request.form.get('filename')
        filename = secure_filename(filename)
        filename = f'{filename}.png'
        print(filename)
        filepath = os.path.join(app.config['FOLDER'], filename)
        print(filepath)
    
        return_data = io.BytesIO()
        with open(filepath, 'rb') as fo:
            return_data.write(fo.read())
        return_data.seek(0)

        os.remove(filepath)

        return send_file(
            return_data,
            mimetype='image/png'
        )
    
    except:
        raise

if __name__ == '__main__':
    app.run(debug=True,)
