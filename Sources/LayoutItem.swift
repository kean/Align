/// The MIT License (MIT)
//
// Copyright (c) 2017-2026 Alexander Grebenyuk (github.com/kean).

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// A type that has layout anchors: either a view or a layout guide.
@MainActor public protocol LayoutItem {
#if os(iOS) || os(tvOS)
    @_spi(Align) var superview: UIView? { get }
#else
    @_spi(Align) var superview: NSView? { get }
#endif

    @_spi(Align) func _disableAutoresizingMask()
}

extension LayoutItem {
    @_spi(Align) public func _disableAutoresizingMask() {}

    /// Wraps the SPI `superview` lookup so callers in `@inlinable` bodies don't
    /// have to reach for SPI directly. The body stays in the framework (this is
    /// `@usableFromInline`, not `@inlinable`), so the SPI access stays private.
    @usableFromInline func _requireSuperview() -> LayoutItem {
        guard let superview = superview else {
            preconditionFailure("Align: \(self) has no superview; pass an explicit container")
        }
        return superview
    }
}

#if os(iOS) || os(tvOS)
extension UIView: LayoutItem {
    @_spi(Align) public func _disableAutoresizingMask() {
        guard translatesAutoresizingMaskIntoConstraints else { return }
        translatesAutoresizingMaskIntoConstraints = false
    }
}
extension UILayoutGuide: LayoutItem {
    @_spi(Align) public var superview: UIView? { owningView }
}
#elseif os(macOS)
extension NSView: LayoutItem {
    @_spi(Align) public func _disableAutoresizingMask() {
        guard translatesAutoresizingMaskIntoConstraints else { return }
        translatesAutoresizingMaskIntoConstraints = false
    }
}
extension NSLayoutGuide: LayoutItem {
    @_spi(Align) public var superview: NSView? { owningView }
}
#endif

extension LayoutItem { // Align methods are available via `LayoutAnchors`
    /// Provides access to the layout anchors and anchor collections.
    @nonobjc @inlinable public var anchors: LayoutAnchors<Self> { LayoutAnchors(self) }
}
