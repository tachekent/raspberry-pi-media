# Raspberry Pi 4k media player for installations

Instructions for setting up a standalone media player on a Pi. With additional steps and script for autostarting and looping a single file for media installations.

## Requirements

### Hardware

- \>= Raspberry Pi4 2GB+
- Pi case - [Flirc](https://flirc.tv/products/flirc-raspberry-pi-4-case-silver?variant=43085036454120) do nice heatsinking ones
- Sandisk MicroSDX card Extreme+ 64GB
- USB-C charge cable
- Micro HDMI - standard HDMI cable
- USB keyboard and mouse
- Ethernet cable

### Software

- LibreElec distro
- [autostart.sh](./autostart.sh) adjusted for the relevant video

### Media

- h265 HEVC encoded video file
  - Gamma settings [check]
  - 4K UHD resolution 3840 × 2160
  - Optional fixed bitrate 40000KB (works for me)
  - Stereo audio track

Output from FFProbe from a video that worked well:

```ffprobe
Stream #0:0[0x1]: Video: hevc (Main 10) (hvc1 / 0x31637668), yuv420p10le(tv, bt709, progressive), 3840x2160 [SAR 1:1 DAR 16:9], 38059 kb/s, 25 fps, 25 tbr, 12800 tbn (default)

Stream #0:1[0x2]: Audio: aac (LC) (mp4a / 0x6134706D), 48000 Hz, stereo, fltp, 334 kb/s (default)
```

## Setup

Flash the MicroSD with the LibreElec Raspberry Pi OS using the [RPi Imager tool](https://downloads.raspberrypi.org/imager/imager_latest.dmg). We use LibreElec because it has a good setup for wifi, bluetooth & ssh. It usees kodi under the hood which has good possibilities for remote control.

Connect the Pi and bootup into LibreElec. Setup either ssh or WiFi so that you can transfer files and setup the autorun script. You'll need to setup an ssh password.

If connected via SSH check the IP address in the network settings in the LibreElec addon.

The default user in LibreELEC is `root`. Connect the ethernet to a switch / network and check the login. You'll be promted for the password you setup earlier:

```shell
ssh root@[ip address]
```

After that set up an ssh-key using [this guide](https://www.digitalocean.com/community/tutorials/how-to-configure-ssh-key-based-authentication-on-a-linux-server) so that you can easily `scp` media files over. Assuming you already have a keypair, copy the public key to the Pi, test logging in and transfer your files:

```shell
# Set up and test it
ssh-copy-id root@remote_host
ssh root@remote_host
exit

# Copy files across
# (remember to update the filename in autostart.sh)
scp movie.mov root@remote_host:videos/movie.mov
scp autostart.sh root@remote_host:.config/autostart.sh
ssh root@remote_host
chmod +x .config/autostart.sh
reboot
```

Hey presto! On reboot after a brief pause on the LibreELEC homescreen, the video will start and loop infinitely.

Everything else you should be able to configure from within the LibreELEC UI.

I powered the Pi via USB from the projector so that it powered up and down in tandem. Probably not great for it in the long run, but until it breaks I'll stick with it 🌞


## Useful links
[Fix audio sync issues](https://www.youtube.com/watch?v=G3v_dFVuwsE) - Pretty basic but helped me fix a delay issue with a 10m cable via a projector to a soundbar.

[LibreELEC wiki: startup/shutdown scripts](https://wiki.libreelec.tv/configuration/startup-shutdown) - where to put things & when they run

[KODI Wiki List of built-in functions](https://kodi.wiki/view/List_of_built-in_functions) - all the actions you can send via `kodi-send` (as we do in the startup script).

## Next time...

Next time I do this I'm going to look at mpv <https://mpv.io/manual/master/> which seems to have an advanced set of command line controls along with the possibility for primary/secondary sync mode over a network. This seems to be the preferred replacement for omxplayer that I used for multiscreen sync on a previous project.

I tried using VLC from the command line this time around, but it had difficulty with the data rate and the video quickly became choppy.

- [Video players for Raspberry pi](https://www.luisllamas.es/en/mpv-player-on-raspberry-pi/)
- [Replacing OMXplayer with VLC](https://forums.raspberrypi.com/viewtopic.php?t=336535)
