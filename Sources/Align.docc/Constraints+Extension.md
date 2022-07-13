# ``Align/Constraints``

By default, Align automatically activates created constraints. Using `Constraints` API, constraints are activated all of the same time when you exit from the closure. It gives you a chance to change the `priority` of the constraints.

```swift
Constraints(for: title, subtitle) { title, subtitle in
    // Align one anchor with another
    subtitle.top.spacing(10, to: title.bottom + 10)

    // Manipulate dimensions
    title.width.equal(100)

    // Change a priority of constraints inside a group:
    subtitle.bottom.pin().priority = UILayoutPriority(999)
}
```

`Constraints` also give you easy access to Align anchors (notice, there is no `.anchors` call in the example). And if you want to not activate the constraints, there is an option for that:

```swift
Constraints(activate: false) {
    // Create your constraints here
}
```

## Topics

### Initializers

- ``init(activate:_:)``

### Variadic Initializers

The following initializers provide convenient access to the views and their anchors.

- ``init(for:_:)``
- ``init(for:_:_:)``
- ``init(for:_:_:_:)``
- ``init(for:_:_:_:_:)``

### Accessing Underlying Constraints

- ``constraints``
- ``activate()``
- ``deactivate()``

### Collection Conformance

- ``startIndex``
- ``endIndex``
- ``index(after:)``
