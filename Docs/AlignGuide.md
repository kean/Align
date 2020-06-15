# Align Guide

- [Introduction](#introduction)
- [Anchors](#anchors)
  * [Accessing Anchors](#accessing-anchors)
  * [Creating Constraints Using Anchors](#creating-constraints-using-anchors)
    + [Alignment Anchors (Edge, Center, Baseline)](#alignment-anchors--edge--center--baseline-)
    + [Edge Anchors Only](#edge-anchors-only)
    + [Center Anchors Only](#center-anchors-only)
    + [Dimension Anchors Only](#dimension-anchors-only)
- [Anchor Collections](#anchor-collections)
  * [AnchorCollectionEdges](#anchorcollectionedges)
  * [AnchorCollectionCenter](#anchorcollectioncenter)
  * [AnchorCollectionSize](#anchorcollectionsize)
- [Extensions](#extensions)
  * [Add Subviews](#add-subviews)

## Introduction

Align has a simple and consistent model for creating constraints. Start by selecting an [**anchor**](#anchors) or a [**collection of anchors**](#anchor-collections) of a view (or of a layout guide). Then use anchor's methods to create constraints.

Anchors are type-safe, they prevent you from creating invalid constraints, and help you avoid typicaly Auto Layour pitfalls such as forgetting to set `translatesAutoresizingMaskIntoConstraints` to `false`.

## Anchors

An anchor (`Anchor<Type, Axis>`) corresponds to a layout attribute (`NSLayoutConstraint.Attribute`) of a view (`UIView`) or of a layout guide (`UILayoutGuide`).

There are four types of anchors:

**AnchorType.Edge:**

```swift
var top: Anchor<AnchorType.Edge, AnchorAxis.Vertical>
var bottom: Anchor<Edge, Vertical>
var left: Anchor<Edge, Horizontal>
var right: Anchor<Edge, Horizontal>
var leading: Anchor<Edge, Horizontal>
var trailing: Anchor<Edge, Horizontal>
```

**AnchorType.Center:**

```swift
var centerX: Anchor<Center, Horizontal>
var centerY: Anchor<Center, Vertical>
```

**AnchorType.Baseline:**

```swift
var firstBaseline: Anchor<Baseline, Vertical>
var lastBaseline: Anchor<Baseline, Vertical>
```

**AnchorType.Dimension:**

```swift
var width: Anchor<Dimension, Horizontal>
var height: Anchor<Dimension, Vertical>
```

To get access to margins and safe area use `margins` or `safeArea` layout guides (`UILayoutGuide`) respectively:

```swift
let view = UIView()

view.al.margins.top
view.al.safeArea.top

// Alternative syntax:
view.layoutMarginsGuide.al.top
view.safeAreaLayoutGuide.al.top
```

### Accessing Anchors

Anchors represent layout attributes of a view including **edges**, **dimensions**, **axis**, and **baselines**. To create constraints, start by selecting an **anchor** or a **collection of anchors** of a view (or of a layout guide). Then use anchor's methods to create constraints.

```swift
Constraints(for: view) {
    $0.top.pinToSuperview()
    $0.centerX.alignWithSuperview()
}
```

Every view that you manipulate using Align has `translatesAutoresizingMaskIntoConstraints` set to `false`.

Align also automatically activates all of the created constraints. Constraints created using `Constraints` API are activated all of the same time when you exit from the closure. It gives you a chance to change `priority` of the constraints.

There is an option to disable automatic activation of constraints:

```swift
Constraints(for: view, activate: false) {
    self.widthConstraint = $0.width.set(0)
}
```

Anchors can be also be accessed using a convenience `.al` proxy:

```swift
title.al.top.pinToSuperview()
```

### Creating Constraints Using Anchors

Anchors can be used for creating layout constraints (`NSLayoutConstraint`) using a fluent API. Different types of anchors have different APIs designed specifically for this type.

#### Alignment Anchors (Edge, Center, Baseline)

Alignment anchors have a subtype `AnchorTypeAlignment` and include `AnchorType.Edge`, `AnchorType.Center`, `AnchorType.Baseline`.

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
}
```

Align also provides convenient way to set `constants` and `multipliers`:

```swift
Constraints(for: title, subtitle) { title, subtitle in
    title.top.align(with: subtitle.top * 2 + 10)
    title.top.align(with: subtitle.top + 10) * 2) // This will also do the right thing
}
```

You can also set relations:

```swift
Constraints(for: title, subtitle) { title, subtitle in
    title.top.align(with: subtitle.top * 2 + 10, relation: .greaterThanOrEqual)
}
```

#### Edge Anchors Only

Edge anchors (`.top`, `.left`, etc) have a special family of methods which allow you to *pin* anchor to the containers. When you *pin* an anchor Align automatically converts a given `inset` to a proper `constant` to be used in a constraint.

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
title.al.width.match(title.al.height * 2) // aspect ratio
```

## Anchor Collections

There are three types anchors collections which allow you to manipulate multiple anchors at the same time.

### AnchorCollectionEdges

The first one is `AnchorCollectionEdges` which allows to manipulate multiple edges of a view at the same time:

```swift
view.addSubview(stack) {
    $0.edges.pinToSuperview() // pins the edges to fill the superview
    $0.edges.pinToSuperview(insets: Insets(10)) // with insets
    $0.edges.pinToSuperviewMargins() // or margins
    $0.edges(.left, .right).pinToSuperview() // fill along horizontal axis
}
```

### AnchorCollectionCenter

The second is `AnchorCollectionCenter` which allow to align centers of the views:

```swift
Constraints(for: title) {
    $0.center.alignWithSuperview() // centers in a superview
    $0.center.align(with: view.al.center)
}
```

### AnchorCollectionSize

The third is `AnchorCollectionSize` which allows you to manipulate size:

```swift
Constraints(for: view, container) { view, container in
    view.size.set(CGSize(width: 44, height: 44))
    view.size.match(container.size)
}
```

## Extensions

You can extend Align by adding the code samples from this section in your project.

### Add Subviews

The best way to access anchors is by using a special `addSubview(_:constraints:)` method (supports up to 4 views):

```swift
view.addSubview(stack) {
    $0.edges(.left, .right).pinToSuperview() // fill along horizontal axis
    $0.centerY.alignWithSuperview() // center along vertical axis
}
```

With `addSubview(_:constraints:)` method you define a view hierarchy and layout views at the same time. It encourages splitting layout code into logical blocks and prevents programmer errors (e.g. trying to add constraints to views not in view hierarchy). 

```swift
// MARK: - UIView + Constraints

public extension UIView {
    @discardableResult @nonobjc func addSubview(_ a: UIView, constraints: (LayoutProxy<UIView>) -> Void) -> Constraints {
        addSubview(a)
        return Constraints(for: a, constraints)
    }

    @discardableResult @nonobjc func addSubview(_ a: UIView, _ b: UIView, constraints: (LayoutProxy<UIView>, LayoutProxy<UIView>) -> Void) -> Constraints {
        [a, b].forEach(addSubview)
        return Constraints(for: a, b, constraints)
    }

    @discardableResult @nonobjc func addSubview(_ a: UIView, _ b: UIView, _ c: UIView, constraints: (LayoutProxy<UIView>, LayoutProxy<UIView>, LayoutProxy<UIView>) -> Void) -> Constraints {
        [a, b, c].forEach(addSubview)
        return Constraints(for: a, b, c, constraints)
    }

    @discardableResult @nonobjc func addSubview(_ a: UIView, _ b: UIView, _ c: UIView, _ d: UIView, constraints: (LayoutProxy<UIView>, LayoutProxy<UIView>, LayoutProxy<UIView>, LayoutProxy<UIView>) -> Void) -> Constraints {
        [a, b, c, d].forEach(addSubview)
        return Constraints(for: a, b, c, d, constraints)
    }
}
```
