# Raspberry Pi 4k media player

## Requirements

### Hardware

- \>= Raspberry Pi4 2GB+
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

Connect the ethernet to a switch / network and check the login using:
`ssh root@[ip address]`. The default user in L.Elec is `root`. After that set up an ssh-key  using [this guide](https://www.digitalocean.com/community/tutorials/how-to-configure-ssh-key-based-authentication-on-a-linux-server) so that you can easily `scp` media files over. Assuming you already have a keypair, copy the public key to the Pi, test logging in and transfer your files:

```shell
ssh-copy-id root@remote_host
# test it 
ssh root@remote_host
# back to localhost
exit
# copy files across straight into the remote video folder
scp movie.mov root@remote_host:videos/movie.mov
# (update the name of the movie to autoplay in autostart)
scp autostart.sh root@remote_host:.config/autostart.sh
ssh root@remote_host
chmod +x .config/autostart.sh
reboot
```

Hey presto! On reboot after a brief pause on the LibreELEC homescreen, the video will start and loop infinitely.

Everything else you should be able to configure from within the UI.


## Useful links
[fix audio sync issues](https://www.youtube.com/watch?v=G3v_dFVuwsE) - helped a lot with a 10m cable via a projector to a soundbar.

[LibreELEC wiki: startup/shutdown scripts](https://wiki.libreelec.tv/configuration/startup-shutdown) - where to put things & when they run

[KODI Wiki List of built-in functions](https://kodi.wiki/view/List_of_built-in_functions) - all the actions you can send via `kodi-send` (as we do in the startup script).