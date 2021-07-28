# StreamUpdate

StreamUpdate in an OpenPlanet plugin for Trackmania 2020 that changes your Twitch stream title automatically with the map you're playing.

## Installation

Put the files in your OpenPlanet directory which is located under:
```
C:\Users\<username>\OpenplanetNext\Scripts\StreamUpdate
```

You will also need to create a Twitch application so that you can have a ClientID as well as a OAuth token.

Note: When you are creating your application, please put `https://localhost` in the `OAuth redirect URL` field.

## Settings
You'll need to update the plugin settings tab file with some informations:
- `ClientID` that you can get from you [Application Console](https://dev.twitch.tv/console/apps).
- `Bearer` that you can find it with [this link](https://id.twitch.tv/oauth2/authorize?client_id=<CLIEND_ID>&redirect_uri=<OAUTH_REDIRECT_URL>&response_type=token&scope=channel_editor) (replace the `<OAUTH_REDIRECT_URL>` with `https://localhost` if that's what you've done earlier) and once you've approved the application, you'll find the Bearer token in the URL.
- `Broadcaster ID` that you can find from [here](https://www.streamweasels.com/support/convert-twitch-username-to-user-id/) by putting your channel name.

## Usage
Once properly configured, just launch Trackmania and it should sync the title from your stream to the plugin automatically.


You should find a tab named `Stream Update` in your settings from where you can configure your stream title. There is an optionnal `{map}` tag that you can place anywhere in your title and it will be replaced with the map you're playing. If you're not playing any map, it will be replaced with empty text.

You can let the plugin run by itself but you can also force the update with the menu under `Stream Update` named `Update stream informations`.

You can also check the stream title with the `View stream informations` sub-menu.

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)