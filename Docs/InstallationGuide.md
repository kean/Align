# Installation Guide

- [Installation](#installation)]
  * [Swift Package Manager](#swift-package-manager)
  * [Manually](#manually)
  * [CocoaPods](#cocoapods)
  * [Carthage](#carthage)
- [License](#license)

## Requirements

| Align            | Swift                 | Xcode                | Platforms              |
|------------------|-----------------------|----------------------|------------------------|
| Align 2.0      | Swift 5.1       | Xcode 11.0      | iOS 11.0 / tvOS 11.0 / macOS 10.13 |
| Align 1.1-1.2    | Swift 4.2 – 5.0       | Xcode 10.1 – 10.2    | iOS 10.0 / tvOS 10.0   |
| Align 1.0        | Swift 4.0 – 4.2       | Xcode 9.2 – 10.1     | iOS 9.0 / tvOS 9.0     | 

## Installation

### Swift Package Manager

[Swift Package Manager](https://swift.org/package-manager/) is a dependency manager built into Xcode.

If you are using Xcode 11 or higher, go to **File / Swift Packages / Add Package Dependency...** and enter package repository URL **https://github.com/kean/Align.git**, then follow the instructions.

To remove the dependency, select the project and open **Swift Packages** (which is next to **Build Settings**). You can add and remove packages from this tab.

> Swift Package Manager can also be used [from the command line](https://swift.org/package-manager/).

### Manually

The entire library fits in a single file with under 250 lines of code which you can just drag-n-drop into your app. This way you won't have to manually `import` it in your source files.


### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1+ is required to build Align

To integrate Align into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'Align'
end
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate Align into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "kean/Align"
```

Run `carthage update` to build the framework and drag the built `Align.framework` into your Xcode project.

## License

Align is available under the MIT license. See the LICENSE file for more info.
