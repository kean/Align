[Changelog](https://github.com/kean/Align/releases) for all versions

# Align 2

## Align 2.0.0

*June 15, 2020*

- Add `constraints` property to `Constraints` type to allow access to all of the constraints created using it
- Add `activate` parameter to `Constraints` initiliazer to optionally disable automatic activation of constraints
- Add a convenience `pinTo` family of methods to `AnchorCollectionEdges` that takes `CGFloat` as insets
- Remove `addSubview` family of APIs
- Migrate to Swift 5.1
- Increase minimum required platform versions

# Align 1

## Align 1.2.1

- Add support for Swift Package Manager 5.0

## Align 1.2

- Rebrand

## Align 1.1

- Add Swift 5.0 support
- Remove Swift 4.0 and Swift 4.1 support
- Remove iOS 9, tvOS 9 support

## Align 1.0

Updated to Swift 4.2 (required) and Xcode 10.

## Align 0.6

A minor update to make Align a bit more ergonomic.

- Add iOS 9 and tvOS 9 compatibility (used to require iOS 10 and tvOS 10).
- Add operators for setting multipliers: `subtitle.height.match(title.height * 2)`.
- Deprecated `align(with:)` and `match(:)` method that had `offset` and `multiplier` parameters. Operators are the preferred way to set those (more compact and more obvious what they mean).
- Move phantom types (e.g. `AnchorAxisVertical`) into namespaces to reduce clutter in a global namespace.

## Align 0.5.1

- Improve documentation
- Improve some minor implementation details
- Update project to Xcode 9.3 recommended settings

## Align 0.5

- Remove Stacks and Spacers ([gist](https://gist.github.com/kean/e77bac3625124b1de559a241a72d1e09))
- Remove Insets

## Align 0.4

- `pinToSuperviewMargins` methods now use margin attributes (e.g. `.topMargin`) and not `layoutMarginsGuide` to workaround issues on iOS 10 where layout guides are unpredictable https://stackoverflow.com/questions/32694124/auto-layout-layoutmarginsguide
- Add `pinToSafeArea(of:)` family of methods which use `safeAreaLayoutGuide` on iOS 11 and fall back to `topLayoutGuide` and `bottomLayoutGuide` on iOS 10
- `addSubview` methods are no longer generic which allows for more extra flexibility when adding constraints (e.g. you can create and operate on an array of layout proxies)


## Align 0.3.1

Small update that focuses on improving  `offsetting(by:)` method.

- `offsetting(by:)` method now available for all anchors
- Add an operator that wraps `offsetting(by:)` method (which wasn't very covnenient by itself)
- [Fix] Offsetting anchor which already has an offset now works correctly
- Split the project into two files


## Align 0.3

-  With new `addSubview(_:constraints:)` method you define a view hierarchy and layout views at the same time. It encourages splitting layout code into logical blocks and prevents programmer errors (e.g. trying to add constraints to views not in view hierarchy).

- Remove standalone `fillSuperview(..)` and `centerInSuperview()` family of functions. There were multiple cons of having them (e.g. more terminology to learn, hard to document and explain, inconsistent with `center` and `size` manipulations, were not allowing to pin in a corner).

Now you can manipulate multiple edges at the same time instead:

```swift
view.addSubview(stack) {
    $0.edges.pinToSuperview() // pins the edges to fill the superview
    $0.edges.pinToSuperview(insets: Insets(10)) // with insets
    $0.edges.pinToSuperviewMargins() // or margins

    $0.edges(.left, .right).pinToSuperview() // fill along horizontal axis
    $0.centerY.alignWithSuperview() // center along vertical axis
}
```

This is a much simpler model which removes entire layer of standalone methods available on `LayoutItems`. Now you always select either an `anchor` or `collections of anchors`, then use their methods to add constraints. Much simpler.

- Make LayoutAnchors's `base` public to enable adding custom extensions on top of it.


## Align 0.2

- Redesigned Align API which now follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/). Although most of the APIs are compact, it is a *non-goal* to enable the most concise syntax possible. Instead Align provides a fluent APIs that form grammatical phrases.
- Full test coverage
- Add a new comprehensive overview, [full guide](https://github.com/kean/Align/blob/master/Docs/AlignGuide.md), and [installation guide](https://github.com/kean/Align/blob/master/Docs/InstallationGuide.md)


## Align 0.1.1

- Revert to original `Spacer` design


## Align 0.1

- Initial version
