# DereGuide

## Introduction
This is an iOS app for Cinderella Girls Starlight Stage(デレステ). Based on data/api from   
* English version of card data api <https://starlight.kirara.ca>
* Chinese version of card data api <http://starlight.346lab.org>
* Image data <https://hoshimoriuta.kirara.ca>
* Event data <https://starlight.tachibana.cool>

## Features
* Card, beatmap and character information
* Live score calculation
* Birthday notification
* Gacha simulation
* Event information
* Colleague finder

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
* Install dependencies with [CocoaPods](https://cocoapods.org). **By now, installation with CocoaPods will cause all the pods built on swift 4.0, but not all the pods are competiable with swift 4.0, so you have to modify them manually to 3.2 in Xcode build settings.**
```
$ pod install
```
* Open the workspace in Xcode
```
$ open DereGuide.xcworkspace
```

## Localization
DereGuide now provide files of localizable strings for other languages
[How to localize DereGuide](https://github.com/superk589/DereGuide/wiki)

## Contributors of other languages
### English:
* [The Holy Constituency of the Summer Triangle](https://github.com/summertriangle-dev)

### Japanese:
* [CaiMiao](https://github.com/CaiMiao)
* [suzutan](https://github.com/suzutan)
* ApricotSalt

## Acknowledgement
### [sparklebox](https://github.com/summertriangle-dev/sparklebox)
* Author: [The Holy Constituency of the Summer Triangle](https://github.com/summertriangle-dev)
* Chinese branch maintainer: [CaiMiao](https://github.com/CaiMiao)  

### deresute.info (not exists though, DereGuide's beatmap is mainly based on the design of this site)
* Author: [Snack-X](https://github.com/Snack-X)

### [starlight.tachibana.cool](https://starlight.tachibana.cool)
* Author: [Cryptomelone](https://github.com/Cryptomelone)

### [deresute.me](https://deresute.me)
* Author: [Hector Martin](https://github.com/marcan)

## Contact
Follow and contact me on [Twitter](https://twitter.com/superk64). If you find an issue, just [open a ticket](https://github.com/superk589/DereGuide/issues/new). Pull requests are warmly welcome as well.
