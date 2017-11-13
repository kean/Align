# Yalta Guide

- [Anchors](#anchors)
  * [Type of Anchors](#type-of-anchors)
  * [Accessing Anchors](#accessing-anchors)
  * [Creating Constraints Using Anchors](#creating-constraints-using-anchors)
    + [Alignment Anchors (Edge, Center, Baseline)](#alignment-anchors--edge--center--baseline-)
    + [Edge Anchors Only](#edge-anchors-only)
    + [Center Anchors Only](#center-anchors-only)
    + [Dimension Anchors Only](#dimension-anchors-only)
  * [Anchors Collections](#anchors-collections)
- [Methods (Fill and Center)](#methods--fill-and-center-)
- [Stacks and Spacers](#stacks-and-spacers)
- [Constraint Groups](#constraint-groups)

## Anchors

An anchor (`Anchor<Type, Axis>`) corresponds to a layout attribute (`NSLayoutConstraint.Attribute`) of a view (`UIView`) or layout guide (`UILayoutGuide`).

### Type of Anchors

There are four types of anchors:

**AnchorTypeEdge:**

```swift
var top: Anchor<AnchorTypeEdge, AnchorAxisVertical>
var bottom: Anchor<AnchorTypeEdge, AnchorAxisVertical>
var left: Anchor<AnchorTypeEdge, AnchorAxisHorizontal>
var right: Anchor<AnchorTypeEdge, AnchorAxisHorizontal>
var leading: Anchor<AnchorTypeEdge, AnchorAxisHorizontal>
var trailing: Anchor<AnchorTypeEdge, AnchorAxisHorizontal>
```

**AnchorTypeCenter:**

```swift
var centerX: Anchor<AnchorTypeCenter, AnchorAxisHorizontal>
var centerY: Anchor<AnchorTypeCenter, AnchorAxisVertical>
```

**AnchorTypeBaseline:**

```swift
var firstBaseline: Anchor<AnchorTypeBaseline, AnchorAxisVertical>
var lastBaseline: Anchor<AnchorTypeBaseline, AnchorAxisVertical>
```

**AnchorTypeDimension:**

```swift
var width: Anchor<AnchorTypeDimension, AnchorAxisHorizontal>
var height: Anchor<AnchorTypeDimension, AnchorAxisVertical>
```

Yalta doesn't provide anchor properties for the layout margins attributes. Instead use `margins` or `safeArea` layout guides (`UILayoutGuide`) that represents these margins:

```
let view = UIView()

view.al.margins.top
view.al.safeArea.top

// alternative syntax:
view.layoutMarginsGuide.al.top
view.safeAreaLayoutGuide.al.top
```


### Accessing Anchors

You can access anchors via `.al` proxy however a recommended way is to create a `Constraints` group (more about it later) instead:

```swift
view.al.top
view.al.centerX
view.al.width

Constraints(for: view) { view in
	view.top
	view.centerX
	view.width
}
```


### Creating Constraints Using Anchors

Anchors can be used for creating layout constraints (`NSLayoutConstraint`) using a fluent API. Different types of anchors have different APIs designed specifically for the type.

#### Alignment Anchors (Edge, Center, Baseline)

Alignment anchors have a subtype `AnchorTypeAlignment` and include `AnchorTypeEdge`, `AnchorTypeCenter`, `AnchorTypeBaseline`.

Alignment anchor can be `aligned` with another alignment anchor of any type, but only as long as they have the same axis. Invalid combinations of anchors are not going to compile.

```swift
Constraints(for: title, subtitle) { title, subtitle in
    // Allowed:
    title.top.align(with: subtitle.top)
    title.top.align(with: subtitle.centerY)
    title.top.align(with: subtitle.firstBaseline)

    // Not allowed (won't compile):
    title.top.align(with: subtitle.left)
    title.top.align(with: subtitle.centerX)
    title.left.align(with: subtitle.firstBaseline)

    // Full signature:
    title.top.align(with: subtitle.top, offset: 10, multiplier: 2, relation: .greaterThanOrEqual)
}
```

An `offsetting(by:)` method allows you to create a new (zero-overhead) anchor with a given `offset` from the current anchor.

```swift
let anchor = title.al.top.offsetting(by: 10)
subtitle.al.top.align(with: anchor)
```

#### Edge Anchors Only

Edge anchors (`.top`, `.left`, etc) have a special family of methods which allow you to *pin* anchor to the containers. When you *pin* an anchor Yalta automatically converts a given `inset` to a proper `constant` to be used in a constraint.

```swift
title.al.top.pinToSuperview()
title.al.top.pinToSuperview(inset: 10)
title.al.top.pinToSuperviewMargin()
title.al.right.pin(to: view.layoutMarginsGuide, inset: 10)

title.al.right.pinToSuperview(inset: 10)
// NSLayoutConstraint(item: title, attribute: .right, toItem: title.superview!, attribute: .right, constant: -10)

title.al.right.pinToSuperview(inset: 10, relation: .greaterThanOrEqual)
// NSLayoutConstraint(item: title, attribute: .right, relation: .greaterThanOrEqual toItem: title.superview!, attribute: .right, constant: -10)
```

#### Center Anchors Only

Center anchors (`.centerX`, `.centerY`) apart from being allowed to aligned with other anchors (see `Alignment Anchors`) can also be aligned with a superview:

```swift
title.al.centerY.alignWithSuperview()
title.al.centerY.alignWithSuperview(offset: 10)
```

#### Dimension Anchors Only

Dimension anchors (`width` and `height`) have two special methods. The first one allows to set a size of a dimension to a specific value (`CGFloat`):

```swift
title.al.width.set(44)
title.al.width.set(44, relation: .lessThanOrEqual)
```

And the second one allows to `match` the size of one dimension with another:

```swift
title.al.width.match(title.al.height)
title.al.width.match(title.al.height, multiplier: 2.0) // aspect ratio
```

### Anchors Collections

There are two anchors collections which allow you to manipulate multiple anchors at the same time.

The first one is `AnchorCollectionCenter` which allow to align centers of the views:

```swift
title.al.center.align(with: view.al.center)
```

The second is `AnchorCollectionSize` which allows you to manipulate size:

```swift
view.al.size.set(CGSize(width: 44, height: 44))
view.al.size.match(container.al.size)
```


## Methods (Fill and Center)

Yalta provides a couple of high-level methods which allow you to think in terms not just individual anchors, but entire views.

**Fill(...** family of methods aligns the edges of the view to the edges (or margins) of the superview so the the view fills the available space in a container.

```swift
view.al.fillSuperview()
view.al.fillSuperview(insets: Insets(15))
view.al.fillSuperview(insets: Insets(top: 10, left: 20, bottom: 10, right: 20))
view.al.fillSuperview(insets: Insets(15), relation: .lessThanOrEqual) // smaller than superview

view.al.fillSuperviewMargins()

view.al.fill(container)

// Along a particular axis
view.al.fillSuperview(alongAxis: .horizontal)
view.al.fillSuperview(alongAxis: .horizontal, insets: Insets(10))
```

*Centering* functions allow to center a view in a superview:

```swift
view.al.centerInSuperview()
view.al.centerInSuperview(alongAxis: .vertical)
```


## Stacks and Spacers

[`UIStackView`](https://developer.apple.com/documentation/uikit/uistackview) is king when it comes to aligning and distributing multiple views at the same time. Yalta doesn't try to compete with stacks - it complements them:

```swift
// Creating stack views with Yalta require much less boilerplate:
let labels = Stack([title, subtitle], axis: .vertical)
let stack = Stack([image, labels], spacing: 15, alignment: .top)

// You also get a convenience of Spacers (including flexible ones):
Stack(title, Spacer(minWidth: 16), subtitle) // alt syntax
```

> Check out [Let's Build UIStackView](https://kean.github.io/post/lets-build-uistackview) to learn how stacks work under the hood (it's constraints all the way down).


## Constraint Groups

You can access Yalta APIs via `.al` proxy however a recommended way is to create a `Constraints` group instead. The constraints that you create inside a group are not installed until the group is finished. This means that you can lower a priority of constraints inside the block:

```swift
Constraints(for: title, subtitle) { title, subtitle in
    title.top.pinToSuperview()
    subtitle.top.align(with: title.bottom, offset: 10)

    // You can change a priority of constraints inside a group:
    subtitle.bottom.pinToSuperview().priority = UILayoutPriority(999)
}
```

There is even more convenient to define constraints which also allows you to manipulate view hierarchy:

```swift
view.al.addSubviews(title, subtitle) { title, subtitle in
    title.top.pinToSuperview()
    subtitle.top.align(with: title.bottom, offset: 10)

    // You can change a priority of constraints inside a group:
    subtitle.bottom.pinToSuperview().priority = UILayoutPriority(999)
}
```
