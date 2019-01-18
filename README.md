[![Import](https://cdn.infobeamer.com/s/img/import.png)](https://info-beamer.com/use?url=https://github.com/info-beamer/package-livestream)

# Description

Uses the [streamlink](https://streamlink.github.io/) streaming command line utility to stream from various stream providers
like Twitch, Youtube or others. You can find the full list of supported sources [here](https://streamlink.github.io/plugin_matrix.html).

This package is still experimental, so streaming might not work. You also get little feedback about the state of the
stream. If you run into problems, please use the [issue tracker](https://github.com/info-beamer/package-livestream/issues).

## Remote control and channels

You can define multiple channels. Each with its own name and stream url source. You can use use `channel up` and
`channel down` keys on your TV remote to switch between the channels. This needs an info-beamer hosted OS version
that supports [CEC](https://info-beamer.com/blog/info-beamer-hosted-adds-cec-support).

Alternatively you can visit the device detail page for any of your devices and use the 
[remote control interface](https://info-beamer.com/blog/introducing-device-remote-control-interfaces) to trigger
`Channel Up` or `Channel Down` events. This allows you to switch channels from remote.

## Updates

### Version sl-965c375

Updated bundled streamlink to 965c375. This fixes problems with YouTube livestreams.
