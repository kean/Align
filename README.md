# ⛵️ Yalta

Yalta is an intuitive and powerful Auto Layout library. Designed to be simple and approachable, Yalta is perfect for both beginners and seasoned developers.

The entire library fits in a single file with under 250 lines of code which you can just drag-n-drop into your app. The best way to start using Yalta is by downloading the project and jumping into a Playground.

> The philosophy behind Yalta is to strive for clarity and simplicity by  following [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/). Although most of the APIs are compact, it is a *non-goal* to enable the most concise syntax possible. It strives for fluent usage by providing methods that form grammatical phrases. Most common operations are easy to discover and use.

## Usage

The common way to create layouts on iOS is with **stack views** ([`UIStackView`](https://developer.apple.com/documentation/uikit/uistackview)). Yalta helps you with that:

```swift
// Creating stack views now require much less boilerplate:
let labels = Stack([title, subtitle], axis: .vertical)
let stack = Stack([image, labels], spacing: 15, alignment: .top)

// Spacers (including flexible ones) are also there for you:
Stack(title, Spacer(minWidth: 16), subtitle)
```

After you've created a stack view, it's time to add it to a view hierarchy:

```swift
view.addSubview(stack)

// You may want your stack to fill the superview:
stack.al.fillSuperview()

// Or only fill along a particular axis and center along other axis:
stack.al.fillSuperview(alongAxis: .horizontal)
stack.al.centerInSuperview(alongAxis: .vertical)

// You can also fill inside layout margins:
stack.al.fillSuperviewMargins()

// Or add insets manually instead:
stack.al.fillSuperview(insets: 10)
stack.al.fillSuperview(insets: UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15))
stack.al.fillSuperview(alongAxis: .horizontal, insets: 10)
```

These are more **filling** and **centering** functions and more options available, but you are rarely going to need anything more than those simple ones.


### Anchors

In the first part we were using high level functions which allow you to think in terms on entire views. However, sometimes you have to think in terms of an individual **edge**, **dimension** or **axis** of a view.

Start with a `UIView` (or `UILayoutGuide`) and select one of the object's *anchors*. Use anchor's methods to specify what kind of layout you'd like to make.

```swift
// You can pin an edge to a superview:
title.al.top.pinToSuperview(inset: 10)

// Or a margin:
title.al.top.pinToSuperviewMargin()
title.al.top.align(with: view.al.margins.top) // Alternative syntax

// Or align it with an other edge:
subtitle.al.top.align(with: title.al.bottom, offset: 10)

// You can also align center of the view:
title.al.centerX.alignWithSuperview()
subtitle.al.centerX.align(with: title.al.centerX)

// And manipulate view's dimensions:
title.al.width.set(100)
subtitle.al.width.same(as: title.al.width)
```

In some cases you might want to operate on multiple anchors at the same time:

```swift
subtitle.al.center.align(with: subtitle.al.size)
subtitle.al.size.same(as: title.al.size)
```

Anchors in Yalta are similar to Apple's [NSLayoutAnchor](https://developer.apple.com/documentation/uikit/nslayoutanchor) API, but with a few advantages:

- No need to manually activate created constraints
- Designed for [Swift](https://swift.org/documentation/api-design-guidelines/), have a smaller and more discoverable API surface
- Less emphasis on relations which are rarely used in practice

> Anchors in Yalta are implemented as a thin layer on top of raw `NSLayoutConstraint` API. They have more type information then `NSLayoutAnchor` which enabled semantic method names. Compare `subtitle.top.align(with: title.bottom, offset: 10)` with `NSLayoutAnchor`'s `title.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10`).


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

- Wants clean, concise and convenient Auto Layout API
- [Doesn't want](http://chris.eidhof.nl/post/micro-autolayout-dsl/) to depend on big, complex libraries
- Prefers no operator overloads and [fast compile times](https://github.com/robb/Cartography/issues/215)
- Likes [NSLayoutAnchor](https://developer.apple.com/library/ios/documentation/AppKit/Reference/NSLayoutAnchor_ClassReference/index.html) but wished it had cleaner API, didn't requires manually activating constraints, and allowed you to create multiple constraints at the same time

> [Yalta](https://en.wikipedia.org/wiki/Yalta) is a beautiful port city on the Black Sea, and a great name for *yet another layout tool* with *anchors*.
