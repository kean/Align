![logo](https://user-images.githubusercontent.com/1567433/178810472-8b5f687e-ed7f-491c-99ed-e86e563462ef.png)

<p align="left">
<img src="https://img.shields.io/badge/Swift-5.10-orange.svg">
<img src="https://img.shields.io/badge/platforms-iOS%20%7C%20tvOS%20%7C%20macOS-lightgrey.svg?colorA=28a745">
<img src="https://img.shields.io/badge/SPM-supported-brightgreen.svg">
<img src="https://img.shields.io/badge/license-MIT-blue.svg">
</p>

The best way to create constraints in code.

- **Semantic**. Align APIs focus on your goals, not the math behind Auto Layout constraints.  
- **Powerful**. Create multiple constraints with a single line of code.  
- **Type Safe**. Makes it impossible to create invalid constraints, at compile time.  
- **Fluent**. Concise and clear API that follows [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/).  
- **Simple**. Stop worrying about `translatesAutoresizingMaskIntoConstraints` and constraints activation.  

The same constraint, with and without Align:

```swift
// NSLayoutAnchor
view.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
    view.topAnchor.constraint(equalTo: superview.topAnchor, constant: 20),
    view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 20),
    view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -20),
    view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -20)
])

// Align
view.anchors.edges.pin(insets: 20)
```

More examples:

```swift
// Core API
view.anchors.top.equal(superview.top)
view.anchors.width.equal(view.anchors.height * 2)

// Semantic API
view.anchors.edges.pin(to: superview.safeAreaLayoutGuide, insets: 20)
view.anchors.width.clamp(to: 10...40)
```

And here's something a bit more powerful:

```swift
view.anchors.edges.pin(insets: 20, alignment: .center)
```

<img src="https://user-images.githubusercontent.com/1567433/84931836-5cb7e400-b0a1-11ea-8342-ce76b151fcad.png" alt="pin edges with center alignment" width="331px"/>

## Documentation

The [**documentation**](https://kean-docs.github.io/align/documentation/align/) for Align is created using DocC and covers all of its APIs in a clear visual way. There is also a [**cheat sheet**](https://github.com/kean/Align/blob/master/Sources/Align.docc/Resources/align-cheat-sheet.pdf) available that lists all of the available APIs.

<a href="https://kean-docs.github.io/align/documentation/align/">
<img alt="Screen Shot 2022-07-13 at 10 08 57 AM" src="https://user-images.githubusercontent.com/1567433/178755429-9420d25e-dad1-4e61-9a22-04139c5746e6.png"  width="858px">
</a>

## Requirements

| Align          | Swift       | Xcode             | Platforms                                  |
|----------------|-------------|-------------------|--------------------------------------------|
| Align 4.0      | Swift 6.0   | Xcode 16          | iOS 15, tvOS 15, macOS 13, visionOS 1      |
| Align 3.3      | Swift 5.10  | Xcode 15.3        | iOS 14, tvOS 14, macOS 10.16               |

## Why Align

Align strives for clarity and simplicity by following [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/). Although most of the APIs are compact, it is a *non-goal* to enable the most concise syntax possible.

What you get with Align:

- **Fluent, high-level API** for everyday Auto Layout
- **Lightweight** – ~330 lines, zero dependencies
- **Minimal surface area** – a single new property, `anchors`, on every view and layout guide
- **Fast to compile** – built on [`NSLayoutAnchor`](https://developer.apple.com/library/ios/documentation/AppKit/Reference/NSLayoutAnchor_ClassReference/index.html), with no [operator-overload soup](https://github.com/robb/Cartography/issues/215)
- **No ceremony** – constraints are activated for you, and `translatesAutoresizingMaskIntoConstraints` is handled automatically
