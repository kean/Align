# ``Align``

The best way to create constraints in code.

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

The entire library fits in a single file with around 330 lines of code. The best way to install it is by using Swift Package Manager, but you can also simply drag-n-drop it into your app. If you install it as a package, you can avoid having to import it in every file by re-exposing its APIs in your app target:

```swift
import Align

extension LayoutItem {
    var anchors: Align.LayoutAnchors<Self> { Align.LayoutAnchors(self) }
}
```

## Overview

The Align APIs for creating constraints fall into two categories:

![02](02.png)

**Core API** lets you create constraints by setting relations between one or more anchors. These APIs are similar to what `NSLayoutAnchor` provides. **Semantic API** is a high-level API that focuses on your goals, such as pinning edges to the container, aligning the view, setting spacing between views, etc.

Both APIs are designed to be easily discoverable using Xcode code completions. There is also a [**cheat sheet**](https://github.com/kean/Align/blob/master/Sources/Align.docc/Resources/align-cheat-sheet.pdf) available listing all APIs in one place.

## Requirements

| Align          | Swift       | Xcode             | Platforms                                  |
|----------------|-------------|-------------------|--------------------------------------------|
| Align 4.0      | Swift 6.0   | Xcode 16          | iOS 15, tvOS 15, macOS 13, visionOS 1      |
| Align 3.3      | Swift 5.10  | Xcode 15.3        | iOS 14, tvOS 14, macOS 10.16               |

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
