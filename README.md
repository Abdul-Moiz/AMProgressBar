# AMProgressBar
[![Build Status](http://img.shields.io/travis/Abdul-Moiz/AMProgressBar.svg?style=flat)](https://travis-ci.org/Abdul-Moiz/AMProgressBar)

Elegant progress bar for your iOS app written in Swift.

## Features

* Up-to-date: Swift 3
* Super easy to use and lightweight
* `IBInspectable` properties can be customized from `Interface Builder`
* Global config file to apply same style across app.

![](AMProgressBar.gif)

## Usage

```swift
import AMProgressBar

let progressBar = AMProgressBar()
progressBar.progressValue = 1

self.view.addSubview(progressBar)
```

### Global configurations

Set a global style to all progress bar with these simple lines of code. It will override if there is some different value set from interface builder.
```
AMProgressBar.config.barColor = .blue
AMProgressBar.config.barCornerRadius = 10
AMProgressBar.config.barMode = .determined // .undetermined

AMProgressBar.config.borderColor = .white
AMProgressBar.config.borderWidth = 2

AMProgressBar.config.cornerRadius = 10

AMProgressBar.config.hideStripes = false

AMProgressBar.config.stripesColor = .red
AMProgressBar.config.stripesDelta = 80
AMProgressBar.config.stripesMotion = .right // .none or .left
AMProgressBar.config.stripesOrientation = .diagonalRight // .diagonalLeft or .vertical
AMProgressBar.config.stripesWidth = 30

AMProgressBar.config.textColor = .black
AMProgressBar.config.textFont = UIFont.systemFont(ofSize: 12)
AMProgressBar.config.textPosition = .onBar // AMProgressBarTextPosition
```

### Batched customization

When using AMProgressBar, it is recommended to use the `customize(block:)` method to customize it. The reason is that AMProgressBar is reacting to each property that you set. So if you set 3 properties, the progress bar is refreshed 3 times.

When using `customize(block:)`, you can group all the customizations on the progress bar, that way AMProgressBar is only going to refresh the it self once.

Example:

```swift
progressBar.customize { bar in
    bar.cornerRadius = 10
    bar.borderColor = UIColor.gray
    bar.borderWidth = 4

    bar.barCornerRadius = 10
    bar.barColor = UIColor.blue
    bar.barMode = AMProgressBarMode.determined.rawValue

    bar.hideStripes = false
    bar.stripesColor = UIColor.white
    bar.stripesWidth = 10
    bar.stripesDelta = 10
    bar.stripesMotion = AMProgressBarStripesMotion.right.rawValue
    bar.stripesOrientation = AMProgressBarStripesOrientation.diagonalRight.rawValue

    bar.textColor = UIColor.black
    bar.textFont = UIFont.systemFont(ofSize: 12)
    bar.textPosition = AMProgressBarTextPosition.middle.rawValue
}
```

### Example
To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
* Swift 3
* iOS 8.0+

## Installation

### CocoaPods
AMProgressBar is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
platform :ios, '8.0'
use_frameworks!

pod "AMProgressBar"
```

## Inspiration
* [YLProgressBar](https://github.com/yannickl/YLProgressBar) - Design and Animation
* [ActiveLabel.swift](https://github.com/optonaut/ActiveLabel.swift) - Batch customization

## License

AMProgressBar is available under the MIT license. See the LICENSE file for more info.
