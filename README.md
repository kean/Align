# ⛵️ Yalta

Yalta is an intuitive and powerful Auto Layout library. Designed to be simple and safe, Yalta is perfect for both new and seasoned developers.

The entire library fits in a single file with under 250 lines of code which you can just drag-n-drop into your app. The best way to start using Yalta is by downloading the project and jumping into a Playground.

- [Quick Overview](#quick-overview)
- [Full Guide](https://github.com/kean/Yalta/blob/master/Docs/YaltaGuide.md)
- [Installation Guide](https://github.com/kean/Yalta/blob/master/Docs/InstallationGuide.md)

> Yalta strives for clarity and simplicity by following [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/). Although most of the APIs are compact, it is a *non-goal* to enable the most concise syntax possible. Instead Yalta provides a fluent APIs that form grammatical phrases. Most common operations are easy to discover and use.


## Quick Overview

### Stack and Spacers

[`UIStackView`](https://developer.apple.com/documentation/uikit/uistackview) is king when it comes to aligning and distributing multiple views at the same time. Yalta doesn't try to compete with stacks - it complements them: 

```swift
// Creating stack views with Yalta require much less boilerplate:
let labels = Stack([title, subtitle], axis: .vertical)
let stack = Stack([image, labels], spacing: 15, alignment: .top)

// You also get a convenience of Spacers (including flexible ones):
Stack(title, Spacer(minWidth: 16), subtitle) // alt syntax
```

> Check out [Let's Build UIStackView](https://kean.github.io/post/lets-build-uistackview) to learn how stacks work under the hood (it's constraints all the way down).

### Fill and Center

It's time to add stack to a view hierarchy. Yalta has some high-level functions for that:

```swift
view.addSubview(stack)

// You may want your stack to fill the superview:
stack.al.fillSuperview()
stack.al.fillSuperview(insets: Insets(10)) // with insets
stack.al.fillSuperviewMargins() // or margins

// Or only fill along a particular axis and center along the other:
stack.al.fillSuperview(alongAxis: .horizontal)
stack.al.centerInSuperview(alongAxis: .vertical)
```

These are more **filling** and **centering** functions with more options available.


### Anchors

Stacks and `fill(...)` functions are great for laying out entire views, however sometime you have to think in terms of individual **anchors**. Each anchor represents either **edge**, **dimension** or **axis** of a view.

You can access anchors via `.al` extension however a recommended way is to create a `Constraints` group instead:

```swift
Constraints(for: title, subtitle) { title, subtitle in
    // Start with a `UIView` (or `UILayoutGuide`) and select one of the object's
    // anchors. Use anchor's methods to create constraints:
    title.top.pinToSuperview()

    // Yalta has a fluent API which read like grammatical phrase:
    subtitle.top.align(with: title.bottom, offset: 10)

    title.centerX.alignWithSuperview()
    subtitle.centerX.align(with: title.centerX)

    title.width.set(100)
    subtitle.width.match(title.width)

    // You can change a priority of constraints inside a group:
    subtitle.bottom.pinToSuperview().priority = UILayoutPriority(999)
}
```

> As you've probably noticed `Constraints` group allows you to get rid of `.al` prefix. More importantly, it encourages you to split constraints into small logical groups. Make sure that you do!

In some cases you might want to operate on multiple anchors at the same time:

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
