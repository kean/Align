# ``Align/AnchorCollectionEdges``

### Pin Edges

The main API available for edges is ``pin(to:insets:axis:alignment:priority:)-(_,EdgeInsets,_,_,_)`` that pins the edges to the container.

```swift
// A convenience method:
view.anchors.edges.pin(insets: 20)

// Same output as the following:
view.anchors.edges.pin(
    to: view.superview!,
    insets: EdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
    alignment: .fill
)
```

![Edges](edges-01.png)

By default, it pins the edges to the superview of the current view. However, you can select any view as a container or even a layout guide.

```swift
// Pin to superview
view.anchors.edges.pin()

// Pin to layout margins guide
view.anchors.edges.pin(to: container.layoutMarginsGuide)

// Pin to safe area
view.anchors.edges.pin(to: container.safeAreaLayoutGuide)
```

### Pin with Alignment

By default, ``pin(to:insets:axis:alignment:priority:)-(_,EdgeInsets,_,_,_)`` uses alignment ``Alignment/fill``, but there are many other alignments available. For example, with ``Alignment/center``, the view is centered in the container and the edges are pinned with "less than or equal" constraints making sure it doesn't overflow the container.

```swift
view.anchors.edges.pin(insets: 20, alignment: .center)
```

![Edges](edges-02.png)

Another useful alignment is ``Alignment/topLeading`` that pins the view to the corner.

```swift
view.anchors.edges.pin(insets: 20, alignment: .topLeading)
```

![Edges](edges-04.png)

In addition to the predefined alignments such as ``Alignment/fill`` and ``Alignment/topLeading``, you can also create custom alignments by providing a vertical and horizontal component separately.

```swift
anchors.edges.pin(
    insets: 20,
    alignment: Alignment(vertical: .center, horizontal: .leading)
)
```

![Edges](edges-05.png)

### Constraints Along the Axis

Sometimes, you just need to create constraints along the given axis and you can do that using the `axis` parameter.

```swift
view.anchors.edges.pin(insets: 20, axis: .horizontal, alignment: .center)
```

![Edges](edges-03.png)


## Topics

### Semantic Constraints

- ``pin(to:insets:axis:alignment:priority:)-(_,EdgeInsets,_,_,_)``
- ``pin(to:insets:axis:alignment:priority:)-(_,CGFloat,_,_,_)``

### Instance Properties

- ``absolute``

### Deprecated

- ``equal(_:insets:priority:)-(_,EdgeInsets,_)``
- ``equal(_:insets:priority:)-(_,CGFloat,_)``
- ``lessThanOrEqual(_:insets:priority:)-(_,EdgeInsets,_)``
- ``lessThanOrEqual(_:insets:priority:)-(_,CGFloat,_)``

### Nested Types

- ``Alignment``
- ``Axis``
