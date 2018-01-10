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
    + [AnchorCollectionEdges](#anchorcollectionedges)
    + [AnchorCollectionCenter](#anchorcollectioncenter)
    + [AnchorCollectionSize](#anchorcollectionsize)

## Anchors

Yalta has a simple and consistent model for creating constraints. You start by selecting an **anchor** or a **collection of anchors** of a view (or a layout guide). Then use anchor's methods to create constraints.

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

```swift
let view = UIView()

view.al.margins.top
view.al.safeArea.top

// alternative syntax:
view.layoutMarginsGuide.al.top
view.safeAreaLayoutGuide.al.top
```


### Accessing Anchors

The best way to access anchors is by using a special `addSubview(_:constraints:)` method (supports up to 4 views):

```swift
view.addSubview(stack) {
    $0.edges(.left, .right).pinToSuperview() // fill along horizontal axis
    $0.centerY.alignWithSuperview() // center along vertical axis
}
```

With `addSubview(_:constraints:)` method you define a view hierarchy and layout views at the same time. It encourages splitting layout code into logical blocks and prevents programmer errors (e.g. trying to add constraints to views not in view hierarchy). 

You can asso access anchors via `.al` proxy:

```swift
stack.al.edges.pinToSuperview()
```

In addition to `addSubview(_:constraints:)` method there is a `Constraints` 
type which allows you to operate on an existing view hierarchy:

```swift
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
let anchor = title.al.bottom.offsetting(by: 10)
subtitle.al.top.align(with: anchor)

// There is also a convenience operator available:
subtitle.al.top.align(with: title.al.bottom + 10)
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

There are three types anchors collections which allow you to manipulate multiple anchors at the same time.

#### AnchorCollectionEdges

The first one is `AnchorCollectionEdges` which allows to manipulate multiple edges of a view at the same time:

```swift
view.addSubview(stack) {
    $0.edges.pinToSuperview() // pins the edges to fill the superview
    $0.edges.pinToSuperview(insets: Insets(10)) // with insets
    $0.edges.pinToSuperviewMargins() // or margins
    $0.edges(.left, .right).pinToSuperview() // fill along horizontal axis
}
```

#### AnchorCollectionCenter

The second is `AnchorCollectionCenter` which allow to align centers of the views:

```swift
Constraints(for: title) {
    $0.center.alignWithSuperview() // centers in a superview
    $0.center.align(with: view.al.center)
}
```

#### AnchorCollectionSize

The third is `AnchorCollectionSize` which allows you to manipulate size:

```swift
Constraints(for: view, container) { view, container in
    view.size.set(CGSize(width: 44, height: 44))
    view.size.match(container.size)
}
```
