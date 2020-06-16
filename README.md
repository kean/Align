<img width="500" alt="Screen Shot 2020-06-15 at 23 00 49" src="https://user-images.githubusercontent.com/1567433/84727079-4ce2b780-af5c-11ea-9d8b-52624818b879.png">

Layout Anchors. Reimagined.

<p align="left">
<img src="https://img.shields.io/badge/platforms-iOS%2C%20tvOS%2C%20macOS-lightgrey.svg">
<img src="https://img.shields.io/badge/supports-CocoaPods%2C%20Carthage%2C%20SwiftPM-green.svg">
<a href="https://travis-ci.org/kean/Align"><img src="https://travis-ci.org/kean/Align.svg?branch=master"></a>
<img src="https://img.shields.io/badge/test%20coverage-100%25-brightgreen.svg">
</p>

<hr/>

Align introduces a better alternative to Auto Layout [anchors](https://developer.apple.com/documentation/uikit/nslayoutanchor).

> **POWERFUL**. Manipulate multiple anchors at the same time. **TYPE SAFE**. Invalid constraints are not possible. **FLUENT**. Simplicity and clarity at the point of use. **FRIENDLY**. Stop worrying about managing `translatesAutoresizingMaskIntoConstraints` and manually activating constraints.

## Getting Started

The entire library fits in a single file with less than 300 lines of code. You can simply drag-n-drop it into your app if you'd like. For more installation options, see [**Installation Guide**](https://github.com/kean/Align/blob/master/Docs/InstallationGuide.md). This README file has a great overview of the Align APIs. For a complete list, see a dedicated [**Align Programming Guide**](https://github.com/kean/Align/blob/master/Docs/AlignGuide.md).

## Anchors

Anchors represent layout attributes of a view including **edges**, **dimensions**, **axis**, and **baselines**. To create constraints, start by selecting an **anchor** or a **collection of anchors** of a view (or of a layout guide). Then use anchor's methods to create constraints.

Each anchor and collection of anchors have methods tailored for that particular kind of anchor:

```swift
Constraints(for: title, subtitle) { title, subtitle in
    // Align one anchor with another
    subtitle.top.align(with: title.bottom + 10)

    // Align center with a superview
    title.centerX.alignWithSuperview()

    // Fill along the horizontal axis
    title.edges.pinToSuperview(insets: 16)

    // Manipulate dimensions
    title.width.set(100)

    // Offset and multiply anchors using convenient operators
    subtitle.width.match(title.width * 2)

    // Change a priority of constraints inside a group:
    subtitle.bottom.pinToSuperview().priority = UILayoutPriority(999)
}
```

Every view that you manipulate using Align has `translatesAutoresizingMaskIntoConstraints` set to `false`. Align also automatically activates all of the created constraints. Constraints created using `Constraints` API are activated all of the same time when you exit from the closure. It gives you a chance to change `priority` of the constraints.

Anchors can be also be accessed using a convenience `.al` proxy:

```swift
title.al.top.pinToSuperview()
```

There are a variety of APIs in Align that you can use to create constraints. All of them are easily discoverable using code completion in Xcode. For a complete list, you can always refer to [**Align Programming Guide**](https://github.com/kean/Align/blob/master/Docs/AlignGuide.md).

> Align has full test coverage. If you'd like to learn about which constraints (`NSLayoutConstraint`) Align creates each time you call one of its methods, test cases are a great place to start.

## Requirements

| Align            | Swift                 | Xcode                | Platforms              |
|------------------|-----------------------|----------------------|------------------------|
| Align 2.0      | Swift 5.1       | Xcode 11.0      | iOS 11.0 / tvOS 11.0 / macOS 10.13 |
| Align 1.1-1.2    | Swift 4.2 – 5.0       | Xcode 10.1 – 10.2    | iOS 10.0 / tvOS 10.0   |
| Align 1.0        | Swift 4.0 – 4.2       | Xcode 9.2 – 10.1     | iOS 9.0 / tvOS 9.0     | 

## Why Align

Align strives for clarity and simplicity by following [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/). Although most of the APIs are compact, it is a *non-goal* to enable the most concise syntax possible. Instead, Align has a fluent API that makes use sites form grammatical English phrases - that's what makes Swift code really stand out.

Align is for someone who:

- Prefers fluent API that follows [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- [Doesn't want](http://chris.eidhof.nl/post/micro-autolayout-dsl/) to depend on big, complex libraries
- Doesn't overuse operator overloads, prefers [fast compile times](https://github.com/robb/Cartography/issues/215)
- Likes [NSLayoutAnchor](https://developer.apple.com/library/ios/documentation/AppKit/Reference/NSLayoutAnchor_ClassReference/index.html) but wishes it had simpler, more fluent API which didn't require manually activating constraints
