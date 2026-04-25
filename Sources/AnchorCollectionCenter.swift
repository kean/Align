///// The MIT License (MIT)
//
// Copyright (c) 2017-2026 Alexander Grebenyuk (github.com/kean).

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// Create multiple constraints at once by using both `centerX` and `centerY` anchors.
@MainActor public struct AnchorCollectionCenter {
    @usableFromInline let x: Anchor<AnchorType.Center, AnchorAxis.Horizontal>
    @usableFromInline let y: Anchor<AnchorType.Center, AnchorAxis.Vertical>

    @usableFromInline init(x: Anchor<AnchorType.Center, AnchorAxis.Horizontal>, y: Anchor<AnchorType.Center, AnchorAxis.Vertical>) {
        self.x = x
        self.y = y
    }

    // MARK: Core API

    @inlinable @discardableResult public func equal<Item: LayoutItem>(_ item2: Item, offset: CGPoint = .zero, priority: LayoutPriority? = nil) -> [NSLayoutConstraint] {
        [x.equal(item2.anchors.centerX, constant: offset.x, priority: priority), y.equal(item2.anchors.centerY, constant: offset.y, priority: priority)]
    }

    @inlinable @discardableResult public func greaterThanOrEqual<Item: LayoutItem>(_ item2: Item, offset: CGPoint = .zero, priority: LayoutPriority? = nil) -> [NSLayoutConstraint] {
        [x.greaterThanOrEqual(item2.anchors.centerX, constant: offset.x, priority: priority), y.greaterThanOrEqual(item2.anchors.centerY, constant: offset.y, priority: priority)]
    }

    @inlinable @discardableResult public func lessThanOrEqual<Item: LayoutItem>(_ item2: Item, offset: CGPoint = .zero, priority: LayoutPriority? = nil) -> [NSLayoutConstraint] {
        [x.lessThanOrEqual(item2.anchors.centerX, constant: offset.x, priority: priority), y.lessThanOrEqual(item2.anchors.centerY, constant: offset.y, priority: priority)]
    }

    // MARK: Semantic API

    /// Centers the view in the superview.
    @inlinable @discardableResult public func align(offset: CGPoint = .zero, priority: LayoutPriority? = nil) -> [NSLayoutConstraint] {
        [x.align(offset: offset.x, priority: priority), y.align(offset: offset.y, priority: priority)]
    }

    /// Makes the axes equal to the other collection of axes.
    @inlinable @discardableResult public func align<Item: LayoutItem>(with item: Item, priority: LayoutPriority? = nil) -> [NSLayoutConstraint] {
        [x.equal(item.anchors.centerX, priority: priority), y.equal(item.anchors.centerY, priority: priority)]
    }
}
