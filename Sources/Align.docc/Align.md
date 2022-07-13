# ``Align``

Align introduces a better alternative to Auto Layout anchors.

![Logo](logo.png)

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

## Getting Started

The entire library fits in a single file with around 300 lines of code. The best way to install it is by using Swift Package Manager, buy you can also simply drag-n-drop it into your app. If you install it as a package, you can avoid having to import it in every file by re-exposing its APIs in your app target:

```swift
import Align

extension LayoutItem {
    var anchors: Align.LayoutAnchors<Self> { Align.LayoutAnchors(self) }
}
```

## Overview

The Align APIs for creating constraints in the following quadrant:

![02](02.png)

**Core API** allows you to create constraints by setting relations between one or more anchors, there APIs are similar to what `NSLayoutAnchor` provides. **Semantic API** is a high-level API that focus on your goals, such as pinning edges to the container, aligning the view, setting spacing between views, etc.

Both of these types of APIs are designed to be easily discoverable using Xcode code completions. There is also a [**cheat sheet**](https://github.com/kean/Align/blob/master/Docs/align-cheat-sheet.pdf) available listing all APIs in one place.

## Requirements

| Align          | Swift       | Xcode             | Platforms                          |
|----------------|-------------|-------------------|------------------------------------|
| Align 3.0      | Swift 5.6   | Xcode 13.3        | iOS 12.0 / tvOS 12.0 / macOS 10.14 |
| Align 2.0      | Swift 5.1   | Xcode 11.0        | iOS 11.0 / tvOS 11.0 / macOS 10.13 |
| Align 1.1      | Swift 4.2   | Xcode 10.1        | iOS 10.0 / tvOS 10.0               |
| Align 1.0      | Swift 4.0   | Xcode 9.2         | iOS 9.0 / tvOS 9.0                 |

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
