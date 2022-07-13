# ``Align``

Align introduces a better alternative to Auto Layout anchors.

- **Semantic**. Align APIs focus on your goals, not the math behind Auto Layout constraints.  
- **Powerful**. Create multiple constraints with a single line of code.  
- **Type Safe**. Makes it impossible to create invalid constraints, at compile time.  
- **Fluent**. Concise and clear API that follows [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/).  
- **Simple**. Stop worrying about `translatesAutoresizingMaskIntoConstraints` and constraints activation.  

To give you a taste of what the *semantic* APIs look like, here is an example:

```swift
view.anchors.edges.pin(insets: 20, alignment: .center)
```

![01](01.png)

## Requirements

| Align          | Swift       | Xcode             | Platforms                          |
|----------------|-------------|-------------------|------------------------------------|
| Align 3.0      | Swift 5.6   | Xcode 13.3        | iOS 12.0 / tvOS 12.0 / macOS 10.14 |
| Align 2.0      | Swift 5.1   | Xcode 11.0        | iOS 11.0 / tvOS 11.0 / macOS 10.13 |
| Align 1.1-1.2  | Swift 4.2   | Xcode 10.1 – 10.2 | iOS 10.0 / tvOS 10.0               |
| Align 1.0      | Swift 4.0   | Xcode 9.2 – 10.1  | iOS 9.0 / tvOS 9.0                 |

## Topics

### Essentials

- ``LayoutItem``
- ``LayoutAnchors``
- ``Anchor``

### Manipulating Multiple Anchors

- ``AnchorCollectionEdges``
- ``AnchorCollectionCenter``
- ``AnchorCollectionSize``

### Managing Constraints

- ``Constraints``
