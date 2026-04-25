///// The MIT License (MIT)
//
// Copyright (c) 2017-2026 Alexander Grebenyuk (github.com/kean).

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// Create multiple constraints at once by operating more than one edge at once.
@MainActor public struct AnchorCollectionEdges {
    @usableFromInline let item: LayoutItem
    @usableFromInline var isAbsolute = false

    @usableFromInline init(item: LayoutItem, isAbsolute: Bool = false) {
        self.item = item
        self.isAbsolute = isAbsolute
    }

    /// Use `left` and `right` edges instead of `leading` and `trailing`.
    @inlinable public var absolute: AnchorCollectionEdges {
        AnchorCollectionEdges(item: item, isAbsolute: true)
    }

#if os(iOS) || os(tvOS)
    public typealias Axis = NSLayoutConstraint.Axis
#else
    public typealias Axis = NSLayoutConstraint.Orientation
#endif

    // MARK: Core API (Deprecated)

    @available(*, deprecated, message: "Use pin(to:insets:priority:) instead")
    @inlinable @discardableResult public func equal(_ item2: LayoutItem, insets: EdgeInsets = .zero, priority: LayoutPriority? = nil) -> [NSLayoutConstraint] {
        pin(to: item2, insets: insets, priority: priority)
    }

    @available(*, deprecated, message: "Use pin(to:insets:alignment:priority:) with alignment .center instead")
    @inlinable @discardableResult public func lessThanOrEqual(_ item2: LayoutItem, insets: EdgeInsets = .zero, priority: LayoutPriority? = nil) -> [NSLayoutConstraint] {
        _pin(to: item2, insets: insets, axis: nil, alignment: .center, isCenteringEnabled: false, priority: priority)
    }

    @available(*, deprecated, message: "Use pin(to:insets:priority:) instead")
    @inlinable @discardableResult public func equal(_ item2: LayoutItem, insets: CGFloat, priority: LayoutPriority? = nil) -> [NSLayoutConstraint] {
        pin(to: item2, insets: EdgeInsets(top: insets, left: insets, bottom: insets, right: insets), priority: priority)
    }

    @available(*, deprecated, message: "Use pin(to:insets:alignment:priority:) with alignment .center instead")
    @inlinable @discardableResult public func lessThanOrEqual(_ item2: LayoutItem, insets: CGFloat, priority: LayoutPriority? = nil) -> [NSLayoutConstraint] {
        _pin(to: item2, insets: EdgeInsets(top: insets, left: insets, bottom: insets, right: insets), axis: nil, alignment: .center, isCenteringEnabled: false, priority: priority)
    }

    // MARK: Semantic API

    /// Pins the edges to the edges of the given item. By default, pins the edges
    /// to the superview.
    ///
    /// - parameter item2: The target view, by default, uses the superview.
    /// - parameter insets: Insets the receiver's edges by the given insets.
    /// - parameter axis: If provided, creates constraints only along the given
    /// axis. For example, if you pass axis `.horizontal`, only the `.leading`,
    /// `.trailing` (and `.centerX` if needed) attributes are used. `nil` by default
    /// - parameter alignment: `.fill` by default, see `Alignment` for a list of
    /// the available options.
    /// - parameter priority: The priority of the created constraints. Uses the
    /// system's default priority when `nil`.
    @inlinable @discardableResult public func pin(to item2: LayoutItem? = nil, insets: CGFloat, axis: Axis? = nil, alignment: Alignment = .fill, priority: LayoutPriority? = nil) -> [NSLayoutConstraint] {
        pin(to: item2, insets: EdgeInsets(top: insets, left: insets, bottom: insets, right: insets), axis: axis, alignment: alignment, priority: priority)
    }

    /// Pins the edges to the edges of the given item. By default, pins the edges
    /// to the superview.
    ///
    /// - parameter item2: The target view, by default, uses the superview.
    /// - parameter insets: Insets the receiver's edges by the given insets.
    /// - parameter axis: If provided, creates constraints only along the given
    /// axis. For example, if you pass axis `.horizontal`, only the `.leading`,
    /// `.trailing` (and `.centerX` if needed) attributes are used. `nil` by default
    /// - parameter alignment: `.fill` by default, see `Alignment` for a list of
    /// the available options.
    /// - parameter priority: The priority of the created constraints. Uses the
    /// system's default priority when `nil`.
    @inlinable @discardableResult public func pin(to item2: LayoutItem? = nil, insets: EdgeInsets = .zero, axis: Axis? = nil, alignment: Alignment = .fill, priority: LayoutPriority? = nil) -> [NSLayoutConstraint] {
        _pin(to: item2, insets: insets, axis: axis, alignment: alignment, isCenteringEnabled: true, priority: priority)
    }

    @usableFromInline func _pin(to item2: LayoutItem?, insets: EdgeInsets, axis: Axis?, alignment: Alignment, isCenteringEnabled: Bool, priority: LayoutPriority? = nil) -> [NSLayoutConstraint] {
        let item2 = item2 ?? item._requireSuperview()
        item._disableAutoresizingMask()
        let left: NSLayoutConstraint.Attribute = isAbsolute ? .left : .leading
        let right: NSLayoutConstraint.Attribute = isAbsolute ? .right : .trailing
        var constraints = [NSLayoutConstraint]()

        func constrain(attribute: NSLayoutConstraint.Attribute, relation: NSLayoutConstraint.Relation, constant: CGFloat) {
            let constraint = NSLayoutConstraint(item: item, attribute: attribute, relatedBy: relation, toItem: item2, attribute: attribute, multiplier: 1, constant: constant)
            Constraints.install(constraint, priority: priority)
            constraints.append(constraint)
        }

        if axis == nil || axis == .horizontal {
            constrain(attribute: left, relation: alignment.horizontal == .fill || alignment.horizontal == .leading ? .equal : .greaterThanOrEqual, constant: insets.left)
            constrain(attribute: right, relation: alignment.horizontal == .fill || alignment.horizontal == .trailing ? .equal : .lessThanOrEqual, constant: -insets.right)
            if alignment.horizontal == .center && isCenteringEnabled {
                constrain(attribute: .centerX, relation: .equal, constant: 0)
            }
        }
        if axis == nil || axis == .vertical {
            constrain(attribute: .top, relation: alignment.vertical == .fill || alignment.vertical == .top ? .equal : .greaterThanOrEqual, constant: insets.top)
            constrain(attribute: .bottom, relation: alignment.vertical == .fill || alignment.vertical == .bottom ? .equal : .lessThanOrEqual, constant: -insets.bottom)
            if alignment.vertical == .center && isCenteringEnabled {
                constrain(attribute: .centerY, relation: .equal, constant: 0)
            }
        }
        return constraints
    }

    public struct Alignment: Sendable {

        /// The alignment along the horizontal axis.
        public enum Horizontal: Sendable {
            /// Pin both leading and trailing edges to the superview.
            case fill
            /// Center the view in the container along the horizontal axis.
            case center
            /// Pin the leading edge to the superview and prevent the view from
            /// overflowing the container by pinning the trailing edge using
            /// "less than or equal" constraint.
            case leading
            /// Pin the trailing edge to the superview and prevent the view from
            /// overflowing the container by pinning the leading edge using
            /// "less than or equal" constraint.
            case trailing
        }

        /// The alignment along the vertical axis.
        public enum Vertical: Sendable {
            /// Pin both top and bottom edges to the superview.
            case fill
            /// Center the view in the container along the vertical axis.
            case center
            /// Pin the top edge to the superview and prevent the view from
            /// overflowing the container by pinning the bottom edge using
            /// "less than or equal" constraint.
            case top
            /// Pin the bottom edge to the superview and prevent the view from
            /// overflowing the container by pinning the top edge using
            /// "less than or equal" constraint.
            case bottom
        }
        /// The alignment along the horizontal axis.
        public let horizontal: Horizontal
        /// The alignment along the vertical axis.
        public let vertical: Vertical

        /// Initializes the alignment.
        public init(horizontal: Horizontal, vertical: Vertical) {
            (self.horizontal, self.vertical) = (horizontal, vertical)
        }

        /// The edges are pinned to the matching edges of the container with the
        /// given edge insets.
        public static let fill = Alignment(horizontal: .fill, vertical: .fill)
        /// The view is centered in the container and the edges are pinned using
        /// "less than or equal" constraints making sure it doesn't overflow the container.
        public static let center = Alignment(horizontal: .center, vertical: .center)
        /// The view is pinned to the top-leading corner of the container with the
        /// given edge insets and the remaining edges are pinned using "less than or
        /// equal" constraints making sure the view doesn't overflow the container.
        public static let topLeading = Alignment(horizontal: .leading, vertical: .top)
        /// The view is pinned to the top edge with the inset while the bottom
        /// edge is pinned using "less than or equal" constraint making sure the view
        /// doesn't overflow the container. The view is also centered horizontally.
        public static let top = Alignment(horizontal: .center, vertical: .top)
        /// The view is pinned to the top-trailing corner of the container with the
        /// given edge insets and the remaining edges are pinned using "less than or
        /// equal" constraints making sure the view doesn't overflow the container.
        public static let topTrailing = Alignment(horizontal: .trailing, vertical: .top)
        /// The view is pinned to the trailing edge with the inset while the leading
        /// edge is pinned using "less than or equal" constraint making sure the view
        /// doesn't overflow the container. The view is also centered vertically.
        public static let trailing = Alignment(horizontal: .trailing, vertical: .center)
        /// The view is pinned to the bottom-trailing corner of the container with the
        /// given edge insets and the remaining edges are pinned using "less than or
        /// equal" constraints making sure the view doesn't overflow the container.
        public static let bottomTrailing = Alignment(horizontal: .trailing, vertical: .bottom)
        /// The view is pinned to the bottom edge with the inset while the top
        /// edge is pinned using "less than or equal" constraint making sure the view
        /// doesn't overflow the container. The view is also centered horizontally.
        public static let bottom = Alignment(horizontal: .center, vertical: .bottom)
        /// The view is pinned to the bottom-leading corner of the container with the
        /// given edge insets and the remaining edges are pinned using "less than or
        /// equal" constraints making sure the view doesn't overflow the container.
        public static let bottomLeading = Alignment(horizontal: .leading, vertical: .bottom)
        /// The view is pinned to the leading edge with the inset while the trailing
        /// edge is pinned using "less than or equal" constraint making sure the view
        /// doesn't overflow the container. The view is also centered vertically.
        public static let leading = Alignment(horizontal: .leading, vertical: .center)
    }
}
