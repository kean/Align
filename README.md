# ⛵️ Yalta

Yalta is an intuitive and powerful Auto Layout library. Designed to be simple and safe, Yalta is perfect for both new and seasoned developers.

The entire library fits in a single file with less than 250 lines of code which you can just drag-n-drop into your app.

- [Quick Overview](#quick-overview)
- [Full Guide](https://github.com/kean/Yalta/blob/master/Docs/YaltaGuide.md)
- [Installation Guide](https://github.com/kean/Yalta/blob/master/Docs/InstallationGuide.md)

> Yalta strives for clarity and simplicity by following [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/). Although most of the APIs are compact, it is a *non-goal* to enable the most concise syntax possible. Instead Yalta has a fluent API that makes use sites form grammatical English phrases - that's what makes Swift code really stand out.


## Quick Overview

### Stack and Spacers

[`UIStackView`](https://developer.apple.com/documentation/uikit/uistackview) is king when it comes to aligning and distributing multiple views at the same time. Yalta doesn't try to compete with stacks - it complements them: 

```swift
// There are two concise ways to create stack in Yalta:
let labels = Stack([title, subtitle], axis: .vertical)
let stack = Stack(image, labels) {
    $0.spacing = 15
    $0.alignment = .top
}

// You also get convenient Spacers (including flexible ones):
Stack(title, Spacer(minWidth: 16), subtitle) // alt syntax
```

> Check out [Let's Build UIStackView](https://kean.github.io/post/lets-build-uistackview) to learn how stacks work under the hood (it's constraints all the way down).


### Anchors

It's time to add a stack to a view hierarchy and lay it out. In Yalta you start by selecting an **anchor** or a **collection of anchors** of a view (or a layout guide). Then use anchor's methods to create constraints.

> Anchors represent layout attributes of a view including **edges**, **dimensions**, **axis** and **baselines**.

The best way to access anchors is by using a special `addSubview(_:constraints:)` method (supports up to 4 views):

```swift
view.addSubview(stack) {
    $0.edges.pinToSuperview() // pins the edges to fill the superview
    $0.edges.pinToSuperview(insets: Insets(10)) // with insets
    $0.edges.pinToSuperviewMargins() // or margins

    $0.edges(.left, .right).pinToSuperview() // fill along horizontal axis
    $0.centerY.alignWithSuperview() // center along vertical axis
}
```

> With `addSubview(_:constraints:)` method you define a view hierarchy and layout views at the same time. It encourages splitting layout code into logical blocks and prevents programmer errors (e.g. trying to add constraints to views not in view hierarchy). 


Each anchor and collection of anchors have methods which make sense for that particular kind of anchor:

```swift
view.addSubview(title, subtitle) { title, subtitle in
    subtitle.top.align(with: title.bottom, offset: 10)

    title.centerX.alignWithSuperview()

    title.width.set(100)
    subtitle.width.match(title.width)

    // You can change a priority of constraints inside a group:
    subtitle.bottom.pinToSuperview().priority = UILayoutPriority(999)
}

title.al.top.pinToSuperview() // all anchors are also accessible via `.al` proxy
```

In addition to `addSubview(_:constraints:)` method there is a `Constraints` type which allows you to operate on an existing view hierarchy:

```swift
Constraints(for: a, b) { a, b in
    a.center.align(with: b.center)
    a.size.match(b.size)
}
```

> Yalta has full test coverage. If you'd like to learn about which constraints (`NSLayoutConstraint`) Yalta creates each time you call one of its methods, test cases are a great place to start.


## Why Yalta

Yalta is for someone who:

- Prefers fluent APIs that follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- [Doesn't want](http://chris.eidhof.nl/post/micro-autolayout-dsl/) to depend on big, complex libraries
- Avoids operator overloads and prefers [fast compile times](https://github.com/robb/Cartography/issues/215)
- Likes [NSLayoutAnchor](https://developer.apple.com/library/ios/documentation/AppKit/Reference/NSLayoutAnchor_ClassReference/index.html) but wished it had simpler, more fluent API which didn't requires manually activating constraints
- Is a beginner and wants to start with high-level abstractions (*stacks*, *simple methods*) and then slowly work their way down to *anchors*, and then individual *constraints*.

> [Yalta](https://en.wikipedia.org/wiki/Yalta) is a beautiful port city on the Black Sea, and a great name for *yet another layout tool* with *anchors*.
