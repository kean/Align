# ⛵️ Yalta

An ultimate micro Auto Layout DSL - simple and powerful. A single file with under 250 lines of code, which you can just copy into your app and own.

Yalta combines the idea of Apple's [layout anchors](https://developer.apple.com/documentation/uikit/nslayoutanchor) with expressive power of [PureLayout](https://github.com/PureLayout/PureLayout). It's instantly familiar. Yalta APIs are designed for clarity, consistency, and discoverability.

> A little bit [about me](https://kean.github.io). I've made [Arranged](https://github.com/kean/Arranged) (UIStackView backport), written about [how UIStackView works under the hood](https://kean.github.io/post/lets-build-uistackview). I'm a long-time [PureLayout](https://github.com/PureLayout/PureLayout) user, a strong proponent of creating layouts programatically with a help of Playgrounds.

## Usage

Two most common operations when defining layouts are: creating and configuring **stack views**, and then **pinning** them to superviews. That's exactly what Yalta is optimized for:

```swift
let labels = Stack([title, subtitle], axis: .vertical)
let stack = Stack([image, labels], spacing: 15, alignment: .top)
stack.edges.pinToSuperviewMargins()
```

### Anchors

There is a single consistent way to use Yalta. First you select either an *anchor* or a *collection of anchors*. Then you manipulate them by using their methods. It requires less cognitive load then remembering long methods, and it helps with discoverability.

```swift
title.al.top.equal(subtitle.al.bottom)
title.al.top.equal(subtitle.al.bottom, offset: 10, relation: .greaterThanOrEqual)

let constraint: NSLayoutConstraint = title.al.height.equal(100) // Constraint is returned
title.al.height.equal(100, relation: .greaterThanOrEqual)

// `UILayoutGuide` is also supported:
title.al.leading.equal(view.al.margins.leading)
title.al.leading.equal(view.al.safeArea.leading)

// And you can create zero-overhead anchors with offsets on the fly:
let anchor = title.al.bottom.offset(by: 10)
subtitle.al.top.equal(anchor)
```

Anchors are similar to the native ones but with a few advantages:

- Activated automatically
- Designed for [Swift](https://swift.org/documentation/api-design-guidelines/), small and discoverable API surface
- Less emphasis on relations which are rarely used in practice

### Anchors Collections

The most powerful Yalta's methods come with *collections of anchors* which allow you to manipulate multiple edges, axis, or dimensions at the same time.

#### Edges

```swift
// You can pin all edges at the same time:
title.al.edges.pinToSuperview()
title.al.edges.pinToSuperviewMargins()

// Or select which ones you'd like to pin:
title.al.edges(.leading, .trailing).pinToSuperview()

// `pin...` methods automatically figure out correct offsets and relations for you 
let insets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
title.al.edges.pinToSuperview(insets: insets, relation: .greaterThanOrEqual)

// In most cases you're pinning to superviews, but there might also come in handy:
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

The second part of Yalta APIs focuses on manipulating stacks and spacers.

There are two concise ways to create stack with Yalta:

```swift
Stack([title, subtitle], axis: .vertical, spacing: 5)

Stack(title, subtitle) {
    $0.axis = .vertical
    $0.spacing = 5
    $0.alignment = .center
}
```

And there is a special `Spacer` type which can also be used inside stacks:

```swift
Stack(title, Spacer(width: 16), subtitle)
Stack(title, Spacer(minWidth: 16), subtitle)
Spacer(height: 16)
Spacer(minHeight: 16)
```

### Priorities and Identifiers

Yalta autoinstalls created constraints. However, if you'd like to lower the priority of the constraints, you can still do that inside `Layout.make` block. The `Layout.make` function also allows use to (optionally) set the priority and/or identifier for *all* of the created constraints:

```swift
Layout.make(priority: UILayoutPriority(999), id: "PinToEdges") {
    title.al.edges(.top, .leading, .trailing).pinToSuperview() // priority `999` and id "PinToEdges"
    title.al.bottom.pinToSuperview().identifier = "PinToBottom" // overrides "PinToEdges"
    title.al.width.equal(80).priority = UILayoutPriority(666) // overrides `999`
}
```

## Why Yalta

Yalta is for someone who:

- Wants clean, concise and convenient Auto Layout code which is consistent with modern Apple's APIs style
- [Doesn't want](http://chris.eidhof.nl/post/micro-autolayout-dsl/) to depend on big, complex libraries, infected with custom operator overloads and protocols
- Prefers [fast compile times](https://github.com/robb/Cartography/issues/215)
- Likes [NSLayoutAnchor](https://developer.apple.com/library/ios/documentation/AppKit/Reference/NSLayoutAnchor_ClassReference/index.html) but wished it had cleaner API, didn't requires manually activating each constraint, and allowed you to create multiple constraints at the same time

> [Yalta](https://en.wikipedia.org/wiki/Yalta) is a beautiful port city on the Black Sea, and a great name for *yet another layout tool* with *anchors*.
