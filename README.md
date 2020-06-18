<img width="918" alt="Screen Shot 2020-06-15 at 23 06 32" src="https://user-images.githubusercontent.com/1567433/84727379-e01bed00-af5c-11ea-834d-149a991c166a.png">

<p align="left">
<img src="https://img.shields.io/badge/platforms-iOS%2C%20tvOS%2C%20macOS-lightgrey.svg">
<img src="https://img.shields.io/badge/supports-CocoaPods%2C%20Carthage%2C%20SwiftPM-green.svg">
<a href="https://travis-ci.org/kean/Align"><img src="https://travis-ci.org/kean/Align.svg?branch=master"></a>
<img src="https://img.shields.io/badge/test%20coverage-100%25-brightgreen.svg">
</p>

Align introduces a better alternative to Auto Layout [anchors](https://developer.apple.com/documentation/uikit/nslayoutanchor).

- **SEMANTIC**. Align APIs are high level and focus on what your goals are.  
- **POWERFUL**. Create multiple constraints with a single line by manipulating collections of anchors.  
- **TYPE SAFE**. Makes in impossible to create invalid constraints, at compile time.  
- **FLUENT**. Concise and clear API that follows [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/).  
- **SIMPLE**. Stop worrying about `translatesAutoresizingMaskIntoConstraints` and manually activating constraints.  

To give you a taste, of what Align APIs looks, here is just one example:

```swift
view.anchors.edges.pin(insets: 20, alignment: .center)
```

<img src="https://user-images.githubusercontent.com/1567433/84931836-5cb7e400-b0a1-11ea-8342-ce76b151fcad.png" alt="pin edges with center alignmnet" width="400px"/>


## Getting Started

The entire library fits in a single file with less than 300 lines of code. You can simply drag-n-drop it into your app if you'd like. For more installation options, see [**Installation Guide**](https://github.com/kean/Align/blob/master/Docs/InstallationGuide.md).

## Anchors

Anchors represent layout attributes of a view including **edges**, **dimensions**, **axis**, and **baselines**. To create constraints, start by selecting an anchor of a view (or of a layout guide). Then use anchor's methods to create constraints. Each anchor has methods tailored for its particular type.

```swift
a.anchors.leading.align(with: b.anchors.leading)
```

<img src="https://user-images.githubusercontent.com/1567433/84958877-43785d00-b0cc-11ea-9425-a848844c524e.png" alt="pin edges" width="400px"/>

> **Note**. Every view that you manipulate using Align has `translatesAutoresizingMaskIntoConstraints` set to `false`. Align also automatically activates all of the created constraints.

There are a variety of APIs in Align that you can use to create constraints. Align APIs are designed to be easily discoverable using code completion in Xcode.

> Align has full test coverage. If you'd like to learn about which constraints (`NSLayoutConstraint`) Align creates each time you call one of its methods, test cases are a great place to start.

```swift
a.anchors.bottom.spacing(20, to: b.anchors.top)
```

<img src="https://user-images.githubusercontent.com/1567433/84958928-5f7bfe80-b0cc-11ea-97d3-66ccd1ecace2.png" alt="pin edges" width="400px"/>

```swift
a.anchors.height.match(b.anchors.height)
```

<img src="https://user-images.githubusercontent.com/1567433/84958748-07dd9300-b0cc-11ea-9f55-ce7df2356b2a.png" alt="pin edges" width="400px"/>

## Edges

With Align, you can manipulate multiple edges at the same time, creating more than one constraint at a time. `pin()` is probably the most powerful and flexible API in Align.

```swift
view.anchors.edges.pin(insets: 20)

// Same as the following:
view.anchors.edges.pin(
    insets: EdgeInsets(top: 20, left: 20, bottom: 20, trailing: 20),
    alignment: .fill
)
```

<img src="https://user-images.githubusercontent.com/1567433/84931360-b10e9400-b0a0-11ea-937b-eb4fbb97a6f7.png" alt="pin edges" width="400px"/>

There are variety of other alignments available.

```swift
view.anchors.edges.pin(insets: 20, alignment: .center)
```

<img src="https://user-images.githubusercontent.com/1567433/84931836-5cb7e400-b0a1-11ea-8342-ce76b151fcad.png" alt="pin edges with center alignmnet" width="400px"/>

You can create constraint along the given axis.

```swift
view.anchors.edges.pin(insets: 20, axis: .horizontal, alignment: .center)
```

<img src="https://user-images.githubusercontent.com/1567433/84932039-af919b80-b0a1-11ea-9798-43a944f4b681.png" alt="pin edges with center alignmnet for horizontal axis" width="400px"/>


Or pin the view to to a corner.

```swift
view.anchors.edges.pin(insets: 20, alignment: .topLeading)
```

<img src="https://user-images.githubusercontent.com/1567433/84932173-e36cc100-b0a1-11ea-9a5d-b6381cde2df7.png" alt="pin edges with center alignmnet for horizontal axis" width="400px"/>

You can create custom alignments (see `Alignment` type) by providing a vertical and horizontal component.

```swift
anchors.edges.pin(insets: 20, alignment: Alignment(vertical: .center, horizontal: .leading))
```

<img src="https://user-images.githubusercontent.com/1567433/84932264-0b5c2480-b0a2-11ea-9574-d32a6de77fb7.png" alt="pin edges with center alignmnet for horizontal axis" width="400px"/>


## Center



## Size


## Advanced

Constraints created `Constraints` API are activated all of the same time when you exit from the closure. It gives you a chance to change `priority` of the constraints.

```swift
Constraints(for: title, subtitle) { title, subtitle in
    // Align one anchor with another
    subtitle.top.align(with: title.bottom + 10)

    // Manipulate dimensions
    title.width.set(100)

    // Change a priority of constraints inside a group:
    subtitle.bottom.pinToSuperview().priority = UILayoutPriority(999)
}
```

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
