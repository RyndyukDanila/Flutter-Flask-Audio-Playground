import matplotlib.pyplot as plt
import librosa
import librosa.display
from librosa.feature import melspectrogram
from werkzeug.utils import secure_filename


def create_and_save_wave_plot(filename):
    imageWaveFilename = secure_filename(filename)
        
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


def create_and_save_mel_plot(filename):
    imageMelFilename = secure_filename(filename)
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