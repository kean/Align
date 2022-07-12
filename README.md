<img width="918" alt="Screen Shot 2020-06-15 at 23 06 32" src="https://user-images.githubusercontent.com/1567433/84727379-e01bed00-af5c-11ea-834d-149a991c166a.png">

<p align="left">
<img src="https://img.shields.io/badge/platforms-iOS%2C%20tvOS%2C%20macOS-lightgrey.svg">
<img src="https://img.shields.io/badge/supports-CocoaPods%2C%20Carthage%2C%20SwiftPM-green.svg">
<a href="https://travis-ci.org/kean/Align"><img src="https://travis-ci.org/kean/Align.svg?branch=master"></a>
<img src="https://img.shields.io/badge/test%20coverage-100%25-brightgreen.svg">
</p>

Align introduces a better alternative to Auto Layout [anchors](https://developer.apple.com/documentation/uikit/nslayoutanchor).

- **Semantic**. Align APIs focus on your goals, not the math behind Auto Layout constraints.  
- **Powerful**. Create multiple constraints with a single line of code.  
- **Type Safe**. Makes it impossible to create invalid constraints, at compile time.  
- **Fluent**. Concise and clear API that follows [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/).  
- **Simple**. Stop worrying about `translatesAutoresizingMaskIntoConstraints` and constraints activation.  

To give you a taste of what the *semantic* APIs look like, here is an example:

```swift
view.anchors.edges.pin(insets: 20, alignment: .center)
```

<img src="https://user-images.githubusercontent.com/1567433/84931836-5cb7e400-b0a1-11ea-8342-ce76b151fcad.png" alt="pin edges with center alignmnet" width="360px"/>

## Getting Started

The entire library fits in a single file with around 300 lines of code. You can simply drag-n-drop it into your app if you'd like. For more installation options, see [**Installation Guide**](https://github.com/kean/Align/blob/master/Docs/InstallationGuide.md).

- **Anchors** ‣ [Introduction](#introduction) · [Core API](#core-api) · [Semantic API](#semantic-api)
- **Anchor Collections** ‣ [Edges](#edges) · [Center](#center) · [Size](#size)
- [**Advanced**](#advanced) · [**Requirements**](#requirements) · [**Why Align**](#why-align)

## Introduction

Anchors (`Anchor<Type, Axis`) represent layout attributes of a view including **edges**, **dimensions**, **axis**, and **baselines**. You use anchors to create constraints. The Align APIs fit in the following quadrant:

<img src="https://user-images.githubusercontent.com/1567433/85213133-4ec7c480-b328-11ea-9c2a-9f214f682760.png" width="500px">

**Core API** allows you to create constraints by setting relations between one or more anchors, there APIs are similar to what `NSLayoutAnchor` provides. **Semantic API** is a high-level API that focus on your goals, such as pinning edges to the container, aligning the view, setting spacing between views, etc.

Both of these types of APIs are designed to be easily discoverable using Xcode code completions. There is also a [**cheat sheet**](https://github.com/kean/Align/blob/master/Docs/align-cheat-sheet.pdf) available, as well as an illustrated guide located in this README. 

<a href="https://github.com/kean/Align/blob/master/Docs/align-cheat-sheet.pdf">
<img alt="Align Cheat Sheet" src="https://user-images.githubusercontent.com/1567433/85484529-0234f100-b595-11ea-889e-a8458cc86dd0.png">
</a>

## Anchors

### Core API

```swift
// Align two views along one of the edges
a.anchors.leading.equal(b.anchors.leading)

// Other options are available:
// a.anchors.leading.greaterThanOrEqual(b.anchors.leading)
// a.anchors.leading.greaterThanOrEqual(b.anchors.leading, constant: 10)

// Set height to the given value (CGFloat)
a.anchors.height.equal(30)
```

<img src="https://user-images.githubusercontent.com/1567433/84966617-f30afa80-b0df-11ea-8f62-0abd95eea4ef.png" alt="pin edges" width="360px"/>

Align automatically sets `translatesAutoresizingMaskIntoConstraints` to `false` for every view that you manipulate using it, so you no longer have to worry about it. 

Align also automatically activates the created constraints. Using [`(NSLayoutConstraint.active(_:)`](https://developer.apple.com/documentation/uikit/nslayoutconstraint/1526955-activate) is typically slightly more efficient than activating each constraint individually. To take advantage of this method, wrap your code into `Constrains` initializer.

```swift
Constraints {       
    // Create constraints in this closure
}
```
 
> Align has full test coverage. If you'd like to learn about which constraints (`NSLayoutConstraint`) Align creates each time you call one of its methods, test cases are a great place to start.

Align also allows you to offset and multiply anchors. This is a lightweight operation with no allocations involved.

```swift
// Offset one of the anchors, creating a "virtual" anchor
b.anchors.leading.equal(a.anchors.trailing + 20)

// Set aspect ratio for a view
b.anchors.height.equal(a.anchors.width * 2)
```

<img src="https://user-images.githubusercontent.com/1567433/84966337-4df02200-b0df-11ea-9bfe-e9c333cb09ef.png" alt="pin edges" width="360px"/>

### Semantic API

```swift
// Set spacing between two views
a.anchors.bottom.spacing(20, to: b.anchors.top)

// Pin an edge to the superview
a.anchors.trailing.pin(inset: 20)
```

<img src="https://user-images.githubusercontent.com/1567433/84966505-b3441300-b0df-11ea-8c83-cd9436e09abd.png" alt="pin edges" width="360px"/>

```swift
Clamps the dimension of a view to the given limiting range.
a.anchors.width.clamp(to: 40...100)
```

<img src="https://user-images.githubusercontent.com/1567433/85213053-47ec8200-b327-11ea-878e-2b6d19e37fdc.png" alt="pin edges" width="360px"/>


## Anchor Collections

With Align, you can manipulate multiple edges at the same time, creating more than one constraint at a time. 

### Edges

`pin()` is probably the most powerful and flexible API in Align.

```swift
view.anchors.edges.pin(insets: 20)

// Same as the following:
view.anchors.edges.pin(
    to: view.superview!
    insets: EdgeInsets(top: 20, left: 20, bottom: 20, trailing: 20),
    alignment: .fill
)
```

<img src="https://user-images.githubusercontent.com/1567433/84931360-b10e9400-b0a0-11ea-937b-eb4fbb97a6f7.png" alt="pin edges" width="360px"/>

By default, `pin()` method pin the edges to the superview of the current view. However, you can select any target view or layout guide:

```swift
// Pin to superview
view.anchors.edges.pin()

// Pin to layout margins guide
view.anchors.edges.pin(to: container.layoutMarginsGuide)

// Pin to safe area
view.anchors.edges.pin(to: container.safeAreaLayoutGuide)
```

> Align also provides a convenient way to access anchors of the layout guide: `view.anchors.safeArea.top`.

By default, `pin()` users `.fill` alignment. There are variety of other alignments available (81 if you combine all possible options).

```swift
view.anchors.edges.pin(insets: 20, alignment: .center)
```

<img src="https://user-images.githubusercontent.com/1567433/84931836-5cb7e400-b0a1-11ea-8342-ce76b151fcad.png" alt="pin edges with center alignmnet" width="360px"/>

You can create constraint along the given axis.

```swift
view.anchors.edges.pin(insets: 20, axis: .horizontal, alignment: .center)
```

<img src="https://user-images.githubusercontent.com/1567433/84932039-af919b80-b0a1-11ea-9798-43a944f4b681.png" alt="pin edges with center alignmnet for horizontal axis" width="360px"/>


Or pin the view to to a corner.

```swift
view.anchors.edges.pin(insets: 20, alignment: .topLeading)
```

<img src="https://user-images.githubusercontent.com/1567433/84932173-e36cc100-b0a1-11ea-9a5d-b6381cde2df7.png" alt="pin edges with center alignmnet for horizontal axis" width="360px"/>

You can create custom alignments (see `Alignment` type) by providing a vertical and horizontal component.

```swift
anchors.edges.pin(insets: 20, alignment: Alignment(vertical: .center, horizontal: .leading))
```

<img src="https://user-images.githubusercontent.com/1567433/84932264-0b5c2480-b0a2-11ea-9574-d32a6de77fb7.png" alt="pin edges with center alignmnet for horizontal axis" width="360px"/>

### Center

```swift
a.anchors.center.align()
```

<img src="https://user-images.githubusercontent.com/1567433/84965361-bc7fb080-b0dc-11ea-8353-389f05888470.png" alt="size equal" width="360px"/>

### Size

```swift
a.anchors.size.equal(CGSize(width: 120, height: 40))
```

> `greaterThanEqual` and `lessThanOrEqual` options are also available

<img src="https://user-images.githubusercontent.com/1567433/84965098-f7351900-b0db-11ea-9e22-09f017f6c730.png" alt="size equal" width="360px"/>

```swift
a.anchors.size.equal(b)
```

<img src="https://user-images.githubusercontent.com/1567433/84965233-54c96580-b0dc-11ea-8200-0e7741801432.png" alt="size equal other view" width="360px"/>

## Advanced

By default, Align automatically activates created constraints. Using `Constraints` API, constraints are activated all of the same time when you exit from the closure. It gives you a chance to change the `priority` of the constraints.

```swift
Constraints(for: title, subtitle) { title, subtitle in
    // Align one anchor with another
    subtitle.top.spacing(10, to: title.bottom + 10)

    // Manipulate dimensions
    title.width.equal(100)

    // Change a priority of constraints inside a group:
    subtitle.bottom.pin().priority = UILayoutPriority(999)
}
```

`Constraints` also give you easy access to Align anchors (notice, there is no `.anchors` call in the example). And if you want to not activate the constraints, there is an option for that:

```swift
Constraints(activate: false) {
    // Create your constraints here
}
```

## Requirements

| Align          | Swift       | Xcode             | Platforms                          |
|----------------|-------------|-------------------|------------------------------------|
| Align 3.0      | Swift 5.6   | Xcode 13.3        | iOS 12.0 / tvOS 12.0 / macOS 10.14 |
| Align 2.0      | Swift 5.1   | Xcode 11.0        | iOS 11.0 / tvOS 11.0 / macOS 10.13 | 

## Why Align

Align strives for clarity and simplicity by following [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/). Although most of the APIs are compact, it is a *non-goal* to enable the most concise syntax possible.

Align is for someone who:

- Prefers fluent API that follows [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- [Doesn't want](http://chris.eidhof.nl/post/micro-autolayout-dsl/) to depend on big, complex libraries
- Prefers to have as little extensions for native classes as possible, `Align` only adds one property
- Doesn't overuse operator overloads, prefers [fast compile times](https://github.com/robb/Cartography/issues/215)
- Likes [NSLayoutAnchor](https://developer.apple.com/library/ios/documentation/AppKit/Reference/NSLayoutAnchor_ClassReference/index.html) but wishes it had simpler, more fluent API which didn't require manually activating constraints
