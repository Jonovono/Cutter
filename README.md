# CUTTER (for Mac only right now)

The best way to make clips of video / audio on your Mac. Simply select the video and audio input and hit record. The options are:

VIDEO:
- Full Screen
- Screen selection (like a screenshot, but will record that section of your screen)
- Webcam
- None

AUDIO:
- System audio (intercepts the sound as it is leaving your computer. Able to even record sounds when listening to a song with headphones)
- Microphone
- None

These will be able to mixed and matched however you want.

# Warning
- The kernel extension for recording the system audio has some bugs and is old. It works fine for me, but you may have issues.


# Structure
- Extension/ contains the kernel. This is copied from WavTap
- Cutter/ contains the UI of the app and all the functions to start recording, etc

# TODO
- Pause / continue recording
- Fix issues with recording system audio
- Some bugs that happen when you try to screen select too many times
- A PKG builder
- Gif maker
- Auto subtitle video option
- Better upload form (upload older vids)
- See previews / edit clips



Most of this it seems can be accomplished with Monosnap. The difference is I want to also provide the ability to easily capture the system audio and upload to a public website! Other than that, monosnap is great!
