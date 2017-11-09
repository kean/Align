# ⛵️ Yalta

An ultimate micro Auto Layout DSL - simple and powerful. A single file with under 250 lines of code, which you can just copy into your app and own.

Yalta combines the idea of Apple's [layout anchors](https://developer.apple.com/documentation/uikit/nslayoutanchor) with expressive power of [PureLayout](https://github.com/PureLayout/PureLayout). It's instantly familiar. Yalta APIs are designed for clarity, consistency, and discoverability.

> [About me](https://kean.github.io). I made [Arranged](https://github.com/kean/Arranged) (UIStackView backport), wrote about [UIStackView under the hood](https://kean.github.io/post/lets-build-uistackview). I'm a strong proponent of creating layouts programatically with a help of Playgrounds.

## Usage

Two most common operations when defining layouts are: creating and configuring **stack views**, and then **pinning** them to superviews. That's exactly what Yalta is optimized for:

```swift
let labels = Stack([title, subtitle], axis: .vertical)
let stack = Stack([image, labels], spacing: 15, alignment: .top)
stack.edges.pinToSuperviewMargins()
```

### Anchors

There is a single consistent way to use Yalta. First, you select either an *anchor* or a *collection of anchors*. Then you manipulate them using their methods. It requires less cognitive load then using long methods and helps with discoverability.

```swift
title.al.top.equal(subtitle.al.bottom) // Returns `NSLayoutConstraint`
title.al.height.equal(100)

// `UILayoutGuide` is supported:
title.al.leading.equal(view.al.margins.leading)
title.al.leading.equal(view.al.safeArea.leading)

// And you can create zero-overhead anchors with offsets on the fly:
let anchor = title.al.bottom.offset(by: 10)
subtitle.al.top.equal(anchor)

// If you need customization it's their for you:
title.al.top.equal(subtitle.al.bottom, offset: 10, relation: .greaterThanOrEqual)
title.al.height.equal(100, relation: .greaterThanOrEqual)
```

Anchors are similar to the native ones but with a few advantages:

- Activated automatically
- Designed for [Swift](https://swift.org/documentation/api-design-guidelines/), have a much smaller and discoverable API surface
- Less emphasis on relations which are rarely used in practice

### Anchors Collections

The most powerful Yalta's features come with *collections of anchors* which allow you to manipulate multiple attributes at the same time:

#### Edges

```swift
// Pin all the edges at the same time:
title.al.edges.pinToSuperview()
title.al.edges.pinToSuperviewMargins()

// Or select which ones to pin:
title.al.edges(.leading, .trailing).pinToSuperview()

// `pin...` automatically figure out correct offsets and relations for you:
let insets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
title.al.edges.pinToSuperview(insets: insets, relation: .greaterThanOrEqual)

// If you are pinning not to superviews:
title.al.edges.pin(to: view.al)
title.al.edges.pin(to: view.al.margins)
title.al.edges.pin(to: view.al.safeArea)
```

#### Axis

```swift
title.al.axis.centerInSuperview()
title.al.axis.centerInSuperviewMargins()
title.al.axis.equal(to: view.al.axis)
```

#### Dimensions

```swift
title.al.size.equal(CGSize(width: 44, height: 44))
title.al.size.equal(CGSize(width: 44, height: 44), relation: .greaterThanOrEqual)

title.al.size.equal(subtitle.al.size)
title.al.size.equal(view.al.size, insets: CGSize(width: 20, height: 20))
title.al.size.equal(view.al.size, multiplier: 2)
```

### Stacks and Spacers

The second part of Yalta APIs focuses on manipulating stacks:

```swift
Stack([title, subtitle], axis: .vertical, spacing: 5)

Stack(title, subtitle) {
    $0.axis = .vertical
    $0.spacing = 5
}
```

And spacers:

```swift
Spacer(height: 16)
Spacer(minHeight: 16)
Stack(title, Spacer(width: 16), subtitle)
Stack(title, Spacer(minWidth: 16), subtitle)
```

### Priorities and Identifiers

Yalta autoinstalls created constraints. To lower the priority of the constraints use `Layout.make` method:

```swift
Layout.make(priority: UILayoutPriority(999), id: "PinToEdges") { // can be nested
    title.al.edges(.top, .leading, .trailing).pinToSuperview() // priority `999` and id "PinToEdges"
    title.al.bottom.pinToSuperview().identifier = "PinToBottom" // overrides "PinToEdges"
    title.al.width.equal(80).priority = UILayoutPriority(666) // overrides `999`
}
```

## Why Yalta

Yalta is for someone who:

- Wants clean, concise and convenient Auto Layout code which is consistent with modern Apple's APIs
- [Doesn't want](http://chris.eidhof.nl/post/micro-autolayout-dsl/) to depend on big, complex libraries, infected with custom operator overloads and protocols
- Prefers [fast compile times](https://github.com/robb/Cartography/issues/215)
- Likes [NSLayoutAnchor](https://developer.apple.com/library/ios/documentation/AppKit/Reference/NSLayoutAnchor_ClassReference/index.html) but wished it had cleaner API, didn't requires manually activating each constraint, and allowed you to create multiple constraints at the same time

> [Yalta](https://en.wikipedia.org/wiki/Yalta) is a beautiful port city on the Black Sea, and a great name for *yet another layout tool* with *anchors*.
