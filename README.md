![surfware xoxo](./assets/woadtoad-icon.png)

# Woad Toad Arena!

Entry for the [48hr Game Competition!](http://48hr.making-games.net/)

## Credits

See [our boilerplate](http://github.com/woadtoad/love-boilerplate).

## Getting Started

1. Download love2d ([v0.9.2](https://github.com/love2d/love/releases/tag/0.9.2))
2. Run `love` against the root directory; for Mac this is something like `./love.app/Contents/MacOS/love ./`

### Troubleshooting

#### Game Controller Compatibility

* At the time of the comp, only mappings native to love were depended on. This was fine.
* Fast-foward to 2021, we now load in additional mappings from [SDL_GameControllerDB](https://raw.githubusercontent.com/gabomdq/SDL_GameControllerDB/68d3f1e/gamecontrollerdb.txt).
* Sometimes a controller's GUID (just in _love_!! confirmed by using [gamepadtool](https://www.generalarcade.com/gamepadtool/)) doesn't match the above DB entries, so add that to `src/config/gamecontrollerdb/customdb.txt`...
