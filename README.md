# PURequestLogger

[![Version](https://img.shields.io/cocoapods/v/PURequestLogger.svg?style=flat)](https://cocoapods.org/pods/PURequestLogger)
[![Platform](https://img.shields.io/cocoapods/p/PURequestLogger.svg?style=flat)](https://cocoapods.org/pods/PURequestLogger)
[![Swift Version](https://img.shields.io/badge/Swift-5.0–5.3-brightgreen.svg?style=flat)](https://developer.apple.com/swift)
[![License](https://img.shields.io/cocoapods/l/PURequestLogger.svg?style=flat)](https://cocoapods.org/pods/PURequestLogger)

## Content
- [About](#about)
- [Requirements](#requirements)
- [Setup](#setup)
- [How to use](#how-to-use)
- [License](#license)

## About
PURequestLogger is a handy iOS tool for viewing app's network activity.

## Requirements
- iOS 10.0+
- Swift 5

## Setup
[CocoaPods](https://cocoapods.org):

```ruby
pod 'PURequestLogger'
```

## How to use
Log your app's network activity using
```swift
let requestLogInfo = PURequestInfo(...))
PURequestLogger.sharedInstance.logRequestInfo(requestLogInfo)
```
and then view it by presenting the logs screen
```swift
PURequestLogger.sharedInstance.presentLogsViewController()
```

Present the logs screen from wherever you want. For example, you could use the motion shake gesture at your base navigation controller to present the screen every time you shake your phone:
```swift
import UIKit
import PURequestLogger

class BaseNavigationController: UINavigationController {
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        super.motionBegan(motion, with: event)
        
        if motion == .motionShake {
            PURequestLogger.sharedInstance.presentLogsViewController()
        }
    }
}
```

## License
PURequestLogger is available under the MIT license. See [LICENSE](LICENSE) for more info.
