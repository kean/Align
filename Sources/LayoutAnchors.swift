/// The MIT License (MIT)
//
// Copyright (c) 2017-2026 Alexander Grebenyuk (github.com/kean).

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// Provides access to the layout anchors and anchor collections.
@MainActor public struct LayoutAnchors<T: LayoutItem> {
    /// The underlying item.
    public let item: T

    @inlinable public init(_ item: T) { self.item = item }

    // MARK: Anchors

    @inlinable public var top: Anchor<AnchorType.Edge, AnchorAxis.Vertical> { Anchor(item, .top) }
    @inlinable public var bottom: Anchor<AnchorType.Edge, AnchorAxis.Vertical> { Anchor(item, .bottom) }
    @inlinable public var left: Anchor<AnchorType.Edge, AnchorAxis.Horizontal> { Anchor(item, .left) }
    @inlinable public var right: Anchor<AnchorType.Edge, AnchorAxis.Horizontal> { Anchor(item, .right) }
    @inlinable public var leading: Anchor<AnchorType.Edge, AnchorAxis.Horizontal> { Anchor(item, .leading) }
    @inlinable public var trailing: Anchor<AnchorType.Edge, AnchorAxis.Horizontal> { Anchor(item, .trailing) }

    @inlinable public var centerX: Anchor<AnchorType.Center, AnchorAxis.Horizontal> { Anchor(item, .centerX) }
    @inlinable public var centerY: Anchor<AnchorType.Center, AnchorAxis.Vertical> { Anchor(item, .centerY) }

    @inlinable public var firstBaseline: Anchor<AnchorType.Baseline, AnchorAxis.Vertical> { Anchor(item, .firstBaseline) }
    @inlinable public var lastBaseline: Anchor<AnchorType.Baseline, AnchorAxis.Vertical> { Anchor(item, .lastBaseline) }

    @inlinable public var width: Anchor<AnchorType.Dimension, AnchorAxis.Horizontal> { Anchor(item, .width) }
    @inlinable public var height: Anchor<AnchorType.Dimension, AnchorAxis.Vertical> { Anchor(item, .height) }

    // MARK: Anchor Collections

    @inlinable public var edges: AnchorCollectionEdges { AnchorCollectionEdges(item: item) }
    @inlinable public var center: AnchorCollectionCenter { AnchorCollectionCenter(x: centerX, y: centerY) }
    @inlinable public var size: AnchorCollectionSize { AnchorCollectionSize(width: width, height: height) }
}
