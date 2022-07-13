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
 
Align also allows you to offset and multiply anchors. This is a lightweight operation with no allocations involved.

```swift
// Offset one of the anchors, creating a "virtual" anchor
b.anchors.leading.equal(a.anchors.trailing + 20)

// Set aspect ratio for a view
b.anchors.height.equal(a.anchors.width * 2)
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

## Topics

### Core Constraints for Edges and Center

These constraints can be added between anchors that represent view edges and center, but only if they operate in the same axis.

- ``equal(_:constant:)-9a08m``
- ``greaterThanOrEqual(_:constant:)-3ths2``
- ``lessThanOrEqual(_:constant:)-9nco3``

### Core Constraints for Dimensions

- ``equal(_:)``
- ``greaterThanOrEqual(_:)``
- ``lessThanOrEqual(_:)``

- ``equal(_:constant:)-88kx7``
- ``greaterThanOrEqual(_:constant:)-6c6e9``
- ``lessThanOrEqual(_:constant:)-9dk3k``

### Core Constraints

- ``offsetting(by:)``
- ``multiplied(by:)``

### Semantic Constraints for Edges

- ``pin(to:inset:)``
- ``spacing(_:to:relation:)``

### Semantic Constraints for Dimensions

- ``clamp(to:)``

### Semantic Constraints for Center

- ``align(offset:)``

### Anchor Parameters

- ``AnchorAxis``
- ``AnchorType``
