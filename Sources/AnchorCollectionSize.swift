///// The MIT License (MIT)
//
// Copyright (c) 2017-2026 Alexander Grebenyuk (github.com/kean).

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// Create multiple constraints at once by using both `width` and `height` anchors.
@MainActor public struct AnchorCollectionSize {
    @usableFromInline let width: Anchor<AnchorType.Dimension, AnchorAxis.Horizontal>
    @usableFromInline let height: Anchor<AnchorType.Dimension, AnchorAxis.Vertical>

    @usableFromInline init(width: Anchor<AnchorType.Dimension, AnchorAxis.Horizontal>, height: Anchor<AnchorType.Dimension, AnchorAxis.Vertical>) {
        self.width = width
        self.height = height
    }

    // MARK: Core API

    /// Set the size of item.
    @inlinable @discardableResult public func equal(_ size: CGSize, priority: LayoutPriority? = nil) -> [NSLayoutConstraint] {
        [width.equal(size.width, priority: priority), height.equal(size.height, priority: priority)]
    }

    /// Set the size of item.
    @inlinable @discardableResult public func greaterThanOrEqual(_ size: CGSize, priority: LayoutPriority? = nil) -> [NSLayoutConstraint] {
        [width.greaterThanOrEqual(size.width, priority: priority), height.greaterThanOrEqual(size.height, priority: priority)]
    }

    /// Set the size of item.
    @inlinable @discardableResult public func lessThanOrEqual(_ size: CGSize, priority: LayoutPriority? = nil) -> [NSLayoutConstraint] {
        [width.lessThanOrEqual(size.width, priority: priority), height.lessThanOrEqual(size.height, priority: priority)]
    }

    /// Makes the size of the item equal to the size of the other item.
    @inlinable @discardableResult public func equal<Item: LayoutItem>(_ item: Item, insets: CGSize = .zero, multiplier: CGFloat = 1, priority: LayoutPriority? = nil) -> [NSLayoutConstraint] {
        [width.equal(item.anchors.width * multiplier - insets.width, priority: priority), height.equal(item.anchors.height * multiplier - insets.height, priority: priority)]
    }

    @inlinable @discardableResult public func greaterThanOrEqual<Item: LayoutItem>(_ item: Item, insets: CGSize = .zero, multiplier: CGFloat = 1, priority: LayoutPriority? = nil) -> [NSLayoutConstraint] {
        [width.greaterThanOrEqual(item.anchors.width * multiplier - insets.width, priority: priority), height.greaterThanOrEqual(item.anchors.height * multiplier - insets.height, priority: priority)]
    }

    @inlinable @discardableResult public func lessThanOrEqual<Item: LayoutItem>(_ item: Item, insets: CGSize = .zero, multiplier: CGFloat = 1, priority: LayoutPriority? = nil) -> [NSLayoutConstraint] {
        [width.lessThanOrEqual(item.anchors.width * multiplier - insets.width, priority: priority), height.lessThanOrEqual(item.anchors.height * multiplier - insets.height, priority: priority)]
    }
}
