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

Additionally this package provides some API endpoints to switch channels. Those can be used by sending a message to the
node to the following paths:

| Path          | Data             |
| ------------- | ---------------- |
| channel/up    | empty            |
| channel/down  | empty            |
| channel/name  | channel name     |
| channel/id    | channel index/id |

## Updates

### Version sl-2.4.0

Updated bundled streamlink to 2.4.0

### Version sl-2.1.2

Updated bundled streamlink to 2.1.2

### Version pi4

Updated for Pi4 compatibility.

### Version sl-1.1.0

Updated bundled streamlink to 1.1.0

### Version sl-965c375

Updated bundled streamlink to 965c375. This fixes problems with YouTube livestreams.
