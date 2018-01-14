# DereGuide

## Introduction
This is an unofficial iOS utility application for **The Idolmaster Cinderella Girls: Starlight Stage (デレステ)**. It's mainly based on APIs provided by other sites. It's designed to collect, cache and rearragne the game data so that you can easily search them. It also has some advance features such as live score simulator and beatmap player.

## Modules
* Card Viewer
* Beatmap Viewer and Player
* Character Viewer
* Song Viewer
* Unit Editor
* Live Score Simulator
* Gacha Viewer and Simulator
* Event Viewer
* Colleague Finder
* Birthday Reminder

## Download at App Store
<https://itunes.apple.com/app/dereguide/id1131934691>

## Requirements
* iOS 9.0+
* Xcode 9.0+
* Swift 4.0+

## How to build
* Clone the repository
```
$ git clone https://github.com/superk589/DereGuide.git
```
* Install dependencies with [CocoaPods](https://cocoapods.org).
```
$ pod install
```
* Open the workspace in Xcode
```
$ open DereGuide.xcworkspace
```

## Localization
Localization files can be found in DereGuide/*.lproj.

Though the base localization is in Chinese, you can take the English one in en.lproj or the Japanese one in ja.lproj as reference.

| File name | Description|
| :------- | :------ |
| InfoPlist.strings       | Localizable strings for some app settings
| LaunchScreen.strings    | Localizable strings for launch screen, unused now
| Localizable.strings     | Localizable strings for all strings in code
| Main.strings            | Localizable strings for UI made by storyboard, length sensitive
| ToolboxList.plist       | Xml style, localizable strings for tools in toolbox

## Contributors of other languages
### English:
* [The Holy Constituency of the Summer Triangle](https://github.com/summertriangle-dev)

### Japanese:
* [CaiMiao](https://github.com/CaiMiao)
* [suzutan](https://github.com/suzutan)
* ApricotSalt

## Acknowledgement

### API Provider
* [Starlight Database](https://starlight.kirara.ca)
    * by [The Holy Constituency of the Summer Triangle](https://github.com/summertriangle-dev)
    * Chinese branch maintained by [CaiMiao](https://github.com/CaiMiao)

* deresute.info
    * by [Snack-X](https://github.com/Snack-X)

* [starlight.tachibana.cool](https://starlight.tachibana.cool)
    * by [Cryptomelone](https://github.com/Cryptomelone)

* [Starlight Portal](https://portal.starlightstage.jp)

* [deresute.me](https://deresute.me)
    * by [Hector Martin](https://github.com/marcan)

### Design and Algorithm Support
* KIYOMI拖把酱
* [statementreply](https://github.com/statementreply)

## Contact
Follow and contact me on [Twitter](https://twitter.com/superk64). If you find an issue, just [open a ticket](https://github.com/superk589/DereGuide/issues/new). Pull requests are warmly welcome as well.
