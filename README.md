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


# Installation 

Right now there is only a makefile. In the future I will put together a pkg installer. I just have not learnt how to do that yet. So if you feel like assisting, do let me know.

To install:
- sudo make install

Uninstall:
- sudo make uninstall

# About
- This makes use of an older open source project to record system audio. WavTap. As such, it has some bugs and I hope to hire someone to help me fix them up in the future. For right now it seems to work for me (Mavericks). 


# Warning / Bugs / Use at your own risk (for now)
- This may be some of the worst Obj-C you have seen? Made this while learning it so if you see improvements please submit pull request.
- The kernel extension for recording the system audio has some bugs and is old. It works fine for me, but you may have issues.
- When doing selection screen recordings, there is a bug I have not figured out yet. It seems to crash if opening the select screen multiple times?


# Fixes
- If you notice your speakers not outputting sound anymore simply: System Preferences -> Sound -> Internal Speakers. If you want to then try using Cutter again do the previous with Cutter closed and then open it. Hopefully that works.


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


# Feedback / Contact
- If you need to reach me for any reason please email: jordan@howlett.io or submit an issue.

# License
Feel free to do whatever you wish with the code. This will be open source forever. Let's give it an MIT.
