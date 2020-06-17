# Align 2 Migration Guide

This guide is provided in order to ease the transition of existing applications using Align 1.x to the latest version, as well as explain the design and structure of new and changed functionality.

## `.al` extensions deprecated, replaced by `.anchor`

```swift
// Align 1
view.al.top.align(with: superview.al.top)

// Align 2
view.anchors.top.align(with: superview.anchors.top)
```

## Reworked `pin()` methods

There are major changes in `pin()` family of methods.

- All of the previous methods were deprecated and replaced with only two new methods:

```swift
// Align 2
view.pin(
    to item2: LayoutItem? = nil,
    axis: NSLayoutConstraint.Axis? = nil,
    insets: EdgeInsets = .zero,
    alignment: Alignmment = .fill
)

view.pin(
    to item2: LayoutItem? = nil,
    axis: NSLayoutConstraint.Axis? = nil,
    insets: CGFloat = .zero,
    alignment: Alignmment = .fill
)
```

- The `relation: NSLayoutRelation` option which was initially copied from PureLayout, but never really made sense, was replaced with a much more clear and powerful `alignment: Alignment` option

You can find more information about the new `pin()` method in the README, with clear illustrations, and more. But here are some example of how you code might change.

```swift
// Align 1
view.anchors.edges.pinToSuperview()

// Align 2
view.anchors.edges.pin()
```

```swift
// Align 1
view.anchors.edges.pinToSuperview(insets: UIEdgeInsets(top: 10, bottom: 10, right: 10, top: 10))

// Align 2
view.anchors.edges.pin(insets: 10)
```

```swift
// Align 1
view.anchors.edges.pinToSuperview(relation: .greaterThanOrEqual)
view.anchors.center.alignWithSuperview()

// Align 2
view.anchors.edges.pin(alignment: .center)
```

```swift
// Align 1
view.anchors.edges(.top, .bottom).pinToSuperview()

// Align 2
view.anchors.edges.pin(axis: vertical)
```

```swift
// Align 1
view.anchors.edges.pinToSuperviewMargins()

// Align 2
view.anchors.edges.pin(to: container.layoutMarginsGuide)
```

```swift
// Align 1
view.anchors.edges.pinToSafeArea(of: self)

// Align 2
view.anchors.edges.pin(to: view.safeAreaLayoutGuide)
```

## `func edges(_ edges: LayoutEdge...)` deprecated

```swift
// Align 1
view.anchors.edges(.top, .bottom).pinToSuperview()

// Align 2
view.anchors.edges.pin(axis: vertical)
```
