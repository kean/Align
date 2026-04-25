// The MIT License (MIT)
//
// Copyright (c) 2017-2026 Alexander Grebenyuk (github.com/kean).

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

// MARK: - AnchorCollectionEdges

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

    // MARK: Core API

    @inlinable @discardableResult public func equal(_ item2: LayoutItem, insets: EdgeInsets = .zero, priority: LayoutPriority? = nil) -> [NSLayoutConstraint] {
        pin(to: item2, insets: insets, priority: priority)
    }

    @inlinable @discardableResult public func lessThanOrEqual(_ item2: LayoutItem, insets: EdgeInsets = .zero, priority: LayoutPriority? = nil) -> [NSLayoutConstraint] {
        _pin(to: item2, insets: insets, axis: nil, alignment: .center, isCenteringEnabled: false, priority: priority)
    }

    @inlinable @discardableResult public func equal(_ item2: LayoutItem, insets: CGFloat, priority: LayoutPriority? = nil) -> [NSLayoutConstraint] {
        pin(to: item2, insets: EdgeInsets(top: insets, left: insets, bottom: insets, right: insets), priority: priority)
    }

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

// MARK: - AnchorCollectionCenter

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

// MARK: - AnchorCollectionSize

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

// MARK: - Constraints

/// Allows you to access the underlying constraints.
///
/// By default, Align automatically activates created constraints. Using
/// ``Constraints`` API, constraints are activated all of the same time when you
/// exit from the closure. It gives you a chance to change the `priority` of
/// the created constraints.
///
/// ```swift
/// Constraints(for: title, subtitle) { title, subtitle in
///     // Align one anchor with another
///     subtitle.top.spacing(10, to: title.bottom + 10)
///
///     // Manipulate dimensions
///     title.width.equal(100)
///
///     // Change a priority of constraints inside a group:
///     subtitle.bottom.pin().priority = UILayoutPriority(999)
/// }
/// ```
///
/// ``Constraints`` also give you easy access to Align anchors (notice, there
/// is no `.anchors` call in the example). And if you want to not activate the
/// constraints, there is an option for that:
///
/// ```swift
/// Constraints(activate: false) {
///     // Create your constraints here
/// }
/// ```
///
/// Nesting is supported: each constraint is collected by the innermost group,
/// and each group honors its own `activate:` flag independently.
public struct Constraints: RandomAccessCollection {
    public typealias Element = NSLayoutConstraint
    public typealias Index = Int

    public subscript(position: Int) -> NSLayoutConstraint { constraints[position] }
    public var startIndex: Int { constraints.startIndex }
    public var endIndex: Int { constraints.endIndex }
    public func index(after i: Int) -> Int { i + 1 }

    /// Returns all of the created constraints.
    public private(set) var constraints: [NSLayoutConstraint]

    /// All of the constraints created in the given closure are automatically
    /// activated at the same time. This is more efficient than installing them
    /// one-by-one. More importantly, it allows to make changes to the constraints
    /// before they are installed (e.g. change `priority`).
    ///
    /// - parameter activate: Set to `false` to disable automatic activation of
    /// constraints.
    /// - parameter closure: A closure in which constraints are created. The
    /// constraints are collected and activated together when the closure returns.
    @MainActor @discardableResult public init(activate: Bool = true, _ closure: () -> Void) {
        Constraints.stack.append([])
        closure() // create constraints
        self.constraints = Constraints.stack.removeLast()
        if activate { NSLayoutConstraint.activate(constraints) }
    }

    // MARK: Activate

    /// Activates each constraint in the receiver.
    @MainActor public func activate() {
        NSLayoutConstraint.activate(constraints)
    }

    /// Deactivates each constraint in the receiver.
    @MainActor public func deactivate() {
        NSLayoutConstraint.deactivate(constraints)
    }

    // MARK: Adding Constraints

    /// Creates and automatically installs a constraint.
    @MainActor @usableFromInline static func add(item item1: LayoutItem, attribute attr1: NSLayoutConstraint.Attribute, relatedBy relation: NSLayoutConstraint.Relation = .equal, toItem item2: LayoutItem? = nil, attribute attr2: NSLayoutConstraint.Attribute? = nil, multiplier: CGFloat = 1, constant: CGFloat = 0, priority: LayoutPriority? = nil) -> NSLayoutConstraint {
        item1._disableAutoresizingMask()
        let constraint = NSLayoutConstraint(item: item1, attribute: attr1, relatedBy: relation, toItem: item2, attribute: attr2 ?? .notAnAttribute, multiplier: multiplier, constant: constant)
        install(constraint, priority: priority)
        return constraint
    }

    /// Creates and automatically installs a constraint between two anchors.
    @MainActor @usableFromInline static func add<T1, A1, T2, A2>(_ lhs: consuming Anchor<T1, A1>, _ rhs: consuming Anchor<T2, A2>, constant: CGFloat = 0, multiplier: CGFloat = 1, relation: NSLayoutConstraint.Relation = .equal, priority: LayoutPriority? = nil) -> NSLayoutConstraint {
        add(item: lhs.item, attribute: lhs.attribute, relatedBy: relation, toItem: rhs.item, attribute: rhs.attribute, multiplier: (multiplier / lhs.multiplier) * rhs.multiplier, constant: constant - lhs.offset + rhs.offset, priority: priority)
    }

    /// Creates and automatically installs a constraint between an anchor and
    /// a given item.
    @MainActor @usableFromInline static func add<T1, A1>(_ lhs: consuming Anchor<T1, A1>, toItem item2: LayoutItem?, attribute attr2: NSLayoutConstraint.Attribute?, constant: CGFloat = 0, multiplier: CGFloat = 1, relation: NSLayoutConstraint.Relation = .equal, priority: LayoutPriority? = nil) -> NSLayoutConstraint {
        add(item: lhs.item, attribute: lhs.attribute, relatedBy: relation, toItem: item2, attribute: attr2, multiplier: multiplier / lhs.multiplier, constant: constant - lhs.offset, priority: priority)
    }

    @MainActor static var stack: [[NSLayoutConstraint]] = [] // this is what enables constraint auto-installing

    @MainActor @usableFromInline static func install(_ constraint: NSLayoutConstraint, priority: LayoutPriority? = nil) {
        if let priority { constraint.priority = priority }
        if !stack.isEmpty {
            stack[stack.count - 1].append(constraint)
        } else {
            constraint.isActive = true
        }
    }
}

extension Constraints {
    @MainActor @discardableResult
    public init<each Item: LayoutItem>(for item: repeat each Item, closure: (repeat LayoutAnchors<each Item>) -> Void) {
        self.init { closure(repeat (each item).anchors) }
    }
}

// MARK: - Misc

#if os(iOS) || os(tvOS)
public typealias EdgeInsets = UIEdgeInsets
public typealias LayoutPriority = UILayoutPriority
#elseif os(macOS)
public typealias EdgeInsets = NSEdgeInsets
public typealias LayoutPriority = NSLayoutConstraint.Priority

public extension NSEdgeInsets {
    static let zero = NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
}
#endif

extension NSLayoutConstraint.Relation {
    @usableFromInline var inverted: NSLayoutConstraint.Relation {
        switch self {
        case .greaterThanOrEqual: return .lessThanOrEqual
        case .lessThanOrEqual: return .greaterThanOrEqual
        case .equal: return self
        @unknown default: return self
        }
    }
}

// MARK: - Preview

#if DEBUG && (os(iOS) || os(tvOS))
import SwiftUI

@available(iOS 17.0, tvOS 17.0, *)
#Preview {
    // A scrolling gallery of common Align layouts, one per titled card.
    let cards = UIStackView()
    cards.axis = .vertical
    cards.spacing = 24
    cards.layoutMargins = UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
    cards.isLayoutMarginsRelativeArrangement = true

    // Pin all four edges with an inset.
    cards.addArrangedSubview(demoCard("Pin edges with insets") { canvas in
        let box = UIView(); box.backgroundColor = .systemBlue
        canvas.addSubview(box)

        box.anchors.edges.pin(insets: 12)
    })

    // Center the view and set an explicit size.
    cards.addArrangedSubview(demoCard("Center with fixed size") { canvas in
        let box = UIView(); box.backgroundColor = .systemPink
        canvas.addSubview(box)

        box.anchors.center.align()
        box.anchors.size.equal(CGSize(width: 120, height: 44))
    })

    // Place `b` 12pt to the right of `a`, matching its size.
    cards.addArrangedSubview(demoCard("Anchor-to-anchor spacing") { canvas in
        let a = UIView(), b = UIView()
        a.backgroundColor = .systemOrange
        b.backgroundColor = .systemGreen
        canvas.addSubview(a)
        canvas.addSubview(b)

        a.anchors.leading.pin(inset: 16)
        a.anchors.centerY.align()
        a.anchors.size.equal(CGSize(width: 60, height: 44))
        b.anchors.leading.spacing(12, to: a.anchors.trailing)
        b.anchors.centerY.equal(a.anchors.centerY)
        b.anchors.size.equal(a)
    })

    let scroll = UIScrollView()
    scroll.backgroundColor = .systemBackground
    scroll.addSubview(cards)

    // Match the content width to the scroll view so it scrolls vertically only.
    cards.anchors.edges.pin()
    cards.anchors.width.equal(scroll.anchors.width)
    return scroll
}

@MainActor private func demoCard(_ title: String, _ build: (UIView) -> Void) -> UIView {
    let label = UILabel()
    label.font = .systemFont(ofSize: 13, weight: .semibold)
    label.textColor = .secondaryLabel
    label.text = title
    let canvas = UIView()
    canvas.backgroundColor = .secondarySystemBackground
    canvas.anchors.height.equal(120)
    build(canvas)
    let stack = UIStackView(arrangedSubviews: [label, canvas])
    stack.axis = .vertical; stack.spacing = 6
    return stack
}
#endif
