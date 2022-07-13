<img width="918" alt="Screen Shot 2020-06-15 at 23 06 32" src="https://user-images.githubusercontent.com/1567433/84727379-e01bed00-af5c-11ea-834d-149a991c166a.png">

<p align="left">
<img src="https://img.shields.io/badge/platforms-iOS%2C%20tvOS%2C%20macOS-lightgrey.svg">
</p>

Align introduces a better alternative to Auto Layout [anchors](https://developer.apple.com/documentation/uikit/nslayoutanchor).

- **Semantic**. Align APIs focus on your goals, not the math behind Auto Layout constraints.  
- **Powerful**. Create multiple constraints with a single line of code.  
- **Type Safe**. Makes it impossible to create invalid constraints, at compile time.  
- **Fluent**. Concise and clear API that follows [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/).  
- **Simple**. Stop worrying about `translatesAutoresizingMaskIntoConstraints` and constraints activation.  

To give you a taste of what the *semantic* APIs look like, here is an example:

```swift
view.anchors.edges.pin(insets: 20, alignment: .center)
```

<img src="https://user-images.githubusercontent.com/1567433/84931836-5cb7e400-b0a1-11ea-8342-ce76b151fcad.png" alt="pin edges with center alignment" width="360px"/>

## Documentation

The [documentation](https://kean-docs.github.io/align/documentation/align/) for Align is created using DocC and covers all of its APIs in a clear visual way.

<a href="https://kean-docs.github.io/align/documentation/align/">
<img alt="Screen Shot 2022-07-13 at 10 08 57 AM" src="https://user-images.githubusercontent.com/1567433/178755429-9420d25e-dad1-4e61-9a22-04139c5746e6.png"  width="644px">
</a>

There is also a [**cheat sheet**](https://github.com/kean/Align/blob/master/Docs/align-cheat-sheet.pdf) available that lists all of the available APIs.

## Requirements

| Align          | Swift       | Xcode             | Platforms                          |
|----------------|-------------|-------------------|------------------------------------|
| Align 3.0      | Swift 5.6   | Xcode 13.3        | iOS 12.0 / tvOS 12.0 / macOS 10.14 |
| Align 2.0      | Swift 5.1   | Xcode 11.0        | iOS 11.0 / tvOS 11.0 / macOS 10.13 | 

## Why Align

Align strives for clarity and simplicity by following [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/). Although most of the APIs are compact, it is a *non-goal* to enable the most concise syntax possible.

Align is for someone who:

- Prefers fluent API that follows [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- [Doesn't want](http://chris.eidhof.nl/post/micro-autolayout-dsl/) to depend on big, complex libraries
- Prefers to have as little extensions for native classes as possible, `Align` only adds one property
- Doesn't overuse operator overloads, prefers [fast compile times](https://github.com/robb/Cartography/issues/215)
- Likes [NSLayoutAnchor](https://developer.apple.com/library/ios/documentation/AppKit/Reference/NSLayoutAnchor_ClassReference/index.html) but wishes it had simpler, more fluent API which didn't require manually activating constraints
