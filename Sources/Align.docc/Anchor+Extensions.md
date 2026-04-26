# ``Align/Anchor``

### Core Constraints

```swift
// Align two views along one of the edges
a.anchors.leading.equal(b.anchors.leading)

// Other options are available:
// a.anchors.leading.greaterThanOrEqual(b.anchors.leading)
// a.anchors.leading.greaterThanOrEqual(b.anchors.leading, constant: 10)

// Set height to the given value (CGFloat)
a.anchors.height.equal(30)
```

![03](03.png)

> tip: Align automatically sets `translatesAutoresizingMaskIntoConstraints` to `false` for every view that you manipulate using it, so you no longer have to worry about it. 
 
Align also allows you to offset, multiply, and divide anchors. This is a lightweight operation with no allocations involved.

```swift
// Offset one of the anchors, creating a "virtual" anchor
b.anchors.leading.equal(a.anchors.trailing + 20)

// Set aspect ratio for a view
b.anchors.height.equal(a.anchors.width * 2)

// Divide an anchor — equivalent to multiplying by the reciprocal
b.anchors.height.equal(a.anchors.height / 2)
```

![04](04.png)

### Semantic Constraints

```swift
// Set spacing between two views
a.anchors.bottom.spacing(20, to: b.anchors.top)

// Pin an edge to the superview
a.anchors.trailing.pin(inset: 20)
```


![05](05.png)

```swift
// Clamps the dimension of a view to the given limiting range.
a.anchors.width.clamp(to: 40...100)
```

![06](06.png)

### Setting a Priority

Every constraint-creating method accepts an optional `priority:` parameter. When `nil` (the default), the system's default priority is used.

```swift
// Set a required width, with a fallback maximum
a.anchors.width.equal(100, priority: .defaultHigh)
a.anchors.width.lessThanOrEqual(200)
```

## Topics

### Core Constraints for Edges and Center

These constraints can be added between anchors that represent view edges and center, but only if they operate in the same axis.

- ``equal(_:constant:priority:)-(Anchor<OtherType,Axis>,_,_)``
- ``greaterThanOrEqual(_:constant:priority:)-(Anchor<OtherType,Axis>,_,_)``
- ``lessThanOrEqual(_:constant:priority:)-(Anchor<OtherType,Axis>,_,_)``

### Core Constraints for Dimensions

- ``equal(_:priority:)``
- ``greaterThanOrEqual(_:priority:)``
- ``lessThanOrEqual(_:priority:)``

- ``equal(_:constant:priority:)-(Anchor<OtherType,OtherAxis>,_,_)``
- ``greaterThanOrEqual(_:constant:priority:)-(Anchor<OtherType,OtherAxis>,_,_)``
- ``lessThanOrEqual(_:constant:priority:)-(Anchor<OtherType,OtherAxis>,_,_)``

### Core Constraints

- ``offsetting(by:)``
- ``multiplied(by:)``

### Semantic Constraints for Edges

- ``pin(to:inset:relation:priority:)``
- ``spacing(_:to:relation:priority:)``

### Semantic Constraints for Dimensions

- ``clamp(to:priority:)``

### Semantic Constraints for Center

- ``align(offset:priority:)``

### Anchor Parameters

- ``AnchorAxis``
- ``AnchorType``
