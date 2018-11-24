# ⛵️ Yalta

An intuitive and powerful Auto Layout library.

The entire library fits in a single file with less than 300 lines of code which you can just drag-n-drop into your app.

- [Quick Overview](#quick-overview)
- [Full Guide](https://github.com/kean/Yalta/blob/master/Docs/YaltaGuide.md)
- [Installation Guide](https://github.com/kean/Yalta/blob/master/Docs/InstallationGuide.md)

> Yalta strives for clarity and simplicity by following [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/). Although most of the APIs are compact, it is a *non-goal* to enable the most concise syntax possible. Instead, Yalta has a fluent API that makes use sites form grammatical English phrases - that's what makes Swift code really stand out.

## Anchors

Start by selecting an **anchor** or a **collection of anchors** of a view (or of a layout guide). Then use anchor's methods to create constraints.

> Anchors represent layout attributes of a view including **edges**, **dimensions**, **axis**, and **baselines**.

Each anchor and collection of anchors have methods tailored for that particular kind of anchor:

```swift
Constraints(for: title, subtitle) { title, subtitle in
    // Align one anchor with another
    subtitle.top.align(with: title.bottom + 10)

    // Align center with a superview
    title.centerX.alignWithSuperview()

    // Manipulate dimenstions
    title.width.set(100)
    subtitle.width.match(title.width * 2)

    // Change a priority of constraints inside a group:
    subtitle.bottom.pinToSuperview().priority = UILayoutPriority(999)
}
```

All anchors can be also be accessed using `.al` proxy:

```swift
title.al.top.pinToSuperview()
```

The best way to access anchors is by using a special `addSubview(_:constraints:)` method (supports up to 4 views). Here are some examples of what you can do using anchors:

```swift
view.addSubview(subview) {
    $0.edges.pinToSuperview(insets: Insets(10)) // Pin to superview edges
}
```

```swift
view.addSubview(subview) {
    $0.edges.pinToSuperviewMargins() // Or margins
}
```

```swift
view.addSubview(subview) {
    $0.edges(.left, .right).pinToSuperview() // Fill along horizontal axis
    $0.centerY.alignWithSuperview() // Center along vertical axis
}
```

> With `addSubview(_:constraints:)` method you define a view hierarchy and layout views at the same time. It encourages splitting layout code into logical blocks and prevents some programmer errors (e.g. trying to add constraints to views which are not in a view hierarchy).

> Yalta has full test coverage. If you'd like to learn about which constraints (`NSLayoutConstraint`) Yalta creates each time you call one of its methods, test cases are a great place to start.

## Requirements

- iOS 9.0, tvOS 9.0
- Xcode 10
- Swift 4.2

## Why Yalta

Yalta is for someone who:

- Prefers fluent API that follows [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- [Doesn't want](http://chris.eidhof.nl/post/micro-autolayout-dsl/) to depend on big, complex libraries
- Doesn't overuse operator overloads, prefers [fast compile times](https://github.com/robb/Cartography/issues/215)
- Likes [NSLayoutAnchor](https://developer.apple.com/library/ios/documentation/AppKit/Reference/NSLayoutAnchor_ClassReference/index.html) but wishes it had simpler, more fluent API which didn't require manually activating constraints

> [Yalta](https://en.wikipedia.org/wiki/Yalta) is a beautiful port city on the Black Sea and a great name for *yet another layout tool* with *anchors*.
