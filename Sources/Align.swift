// The MIT License (MIT)
//
// Copyright (c) 2017-2024 Alexander Grebenyuk (github.com/kean).

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// A type that has layout anchors: either a view or a layout guide.
@MainActor public protocol LayoutItem {
#if os(iOS) || os(tvOS)
    var superview: UIView? { get }
#else
    var superview: NSView? { get }
#endif
}

#if os(iOS) || os(tvOS)
extension UIView: LayoutItem {}
extension UILayoutGuide: LayoutItem {
    public var superview: UIView? { owningView }
}
#elseif os(macOS)
extension NSView: LayoutItem {}
extension NSLayoutGuide: LayoutItem {
    public var superview: NSView? { owningView }
}
#endif

extension LayoutItem { // Align methods are available via `LayoutAnchors`
    /// Provides access to the layout anchors and anchor collections.
    @nonobjc public var anchors: LayoutAnchors<Self> { LayoutAnchors(self) }
}

// MARK: - LayoutAnchors

/// Provides access to the layout anchors and anchor collections.
@MainActor public struct LayoutAnchors<T: LayoutItem> {
    /// The underlying item.
    public let item: T

    public init(_ item: T) { self.item = item }

    // MARK: Anchors

    public var top: Anchor<AnchorType.Edge, AnchorAxis.Vertical> { Anchor(item, .top) }
    public var bottom: Anchor<AnchorType.Edge, AnchorAxis.Vertical> { Anchor(item, .bottom) }
    public var left: Anchor<AnchorType.Edge, AnchorAxis.Horizontal> { Anchor(item, .left) }
    public var right: Anchor<AnchorType.Edge, AnchorAxis.Horizontal> { Anchor(item, .right) }
    public var leading: Anchor<AnchorType.Edge, AnchorAxis.Horizontal> { Anchor(item, .leading) }
    public var trailing: Anchor<AnchorType.Edge, AnchorAxis.Horizontal> { Anchor(item, .trailing) }

    public var centerX: Anchor<AnchorType.Center, AnchorAxis.Horizontal> { Anchor(item, .centerX) }
    public var centerY: Anchor<AnchorType.Center, AnchorAxis.Vertical> { Anchor(item, .centerY) }

    public var firstBaseline: Anchor<AnchorType.Baseline, AnchorAxis.Vertical> { Anchor(item, .firstBaseline) }
    public var lastBaseline: Anchor<AnchorType.Baseline, AnchorAxis.Vertical> { Anchor(item, .lastBaseline) }

    public var width: Anchor<AnchorType.Dimension, AnchorAxis.Horizontal> { Anchor(item, .width) }
    public var height: Anchor<AnchorType.Dimension, AnchorAxis.Vertical> { Anchor(item, .height) }

    // MARK: Anchor Collections

    public var edges: AnchorCollectionEdges { AnchorCollectionEdges(item: item) }
    public var center: AnchorCollectionCenter { AnchorCollectionCenter(x: centerX, y: centerY) }
    public var size: AnchorCollectionSize { AnchorCollectionSize(width: width, height: height) }
}

// MARK: - Anchors

/// A type that represents a layout axis.
public enum AnchorAxis {
    public class Horizontal {}
    public class Vertical {}
}

/// Represents an anchor type.
public enum AnchorType {
    public class Dimension {}
    public class Alignment {}
    public class Center: Alignment {}
    public class Edge: Alignment {}
    public class Baseline: Alignment {}
}

/// An anchor represents one of the view's layout attributes.
///
/// Instead of creating `NSLayoutConstraint` objects directly, start with a `UIView`
/// or `UILayoutGuide` and select one of its anchors. For example, `view.anchors.top`
/// is represted by `Anchor<AnchorType.Edge, AnchorAxis.Vertical>`. Then use the
/// anchor’s methods to construct your constraint.
///
/// ```swift
/// // Align two views along one of the edges
/// a.anchors.leading.equal(b.anchors.leading)
/// ```
///
/// When you create constraints using `Anchor` APIs, the constraints are activated
/// automatically and the target view has `translatesAutoresizingMaskIntoConstraints`
/// set to `false`. If you want to activate all the constraints at the same or
/// create them without activation, use `Constraints` type.
///
/// - tip: `UIView` does not provide anchor properties for the layout margin attributes.
/// Instead, call `view.layoutMarginsGuide.anchors`.
@MainActor public struct Anchor<Type, Axis> { // type and axis are phantom types
    let item: LayoutItem
    let attribute: NSLayoutConstraint.Attribute
    let offset: CGFloat
    let multiplier: CGFloat

    init(_ item: LayoutItem, _ attribute: NSLayoutConstraint.Attribute, offset: CGFloat = 0, multiplier: CGFloat = 1) {
        self.item = item; self.attribute = attribute; self.offset = offset; self.multiplier = multiplier
    }

    /// Returns a new anchor offset by a given amount.
    ///
    /// - tip: Consider using a convenience operator instead: `view.anchors.top + 10`.
    public func offsetting(by offset: CGFloat) -> Anchor {
        Anchor(item, attribute, offset: self.offset + offset, multiplier: self.multiplier)
    }

    /// Returns a new anchor with an constant multiplied by the given amount.
    ///
    /// - tip: Consider using a convenience operator instead: `view.anchors.height * 2`.
    public func multiplied(by multiplier: CGFloat) -> Anchor {
        Anchor(item, attribute, offset: self.offset * multiplier, multiplier: self.multiplier * multiplier)
    }
}

/// Returns a new anchor offset by a given amount.
@MainActor public func + <Type, Axis>(anchor: Anchor<Type, Axis>, offset: CGFloat) -> Anchor<Type, Axis> {
    anchor.offsetting(by: offset)
}

/// Returns a new anchor offset by a given amount.
@MainActor public func - <Type, Axis>(anchor: Anchor<Type, Axis>, offset: CGFloat) -> Anchor<Type, Axis> {
    anchor.offsetting(by: -offset)
}

/// Returns a new anchor with an constant multiplied by the given amount.
@MainActor public func * <Type, Axis>(anchor: Anchor<Type, Axis>, multiplier: CGFloat) -> Anchor<Type, Axis> {
    anchor.multiplied(by: multiplier)
}

// MARK: - Anchors (AnchorType.Alignment)

@MainActor public extension Anchor where Type: AnchorType.Alignment {
    @discardableResult func equal<OtherType: AnchorType.Alignment>(_ anchor: Anchor<OtherType, Axis>, constant: CGFloat = 0) -> NSLayoutConstraint {
        Constraints.add(self, anchor, constant: constant, relation: .equal)
    }

    @discardableResult func greaterThanOrEqual<OtherType: AnchorType.Alignment>(_ anchor: Anchor<OtherType, Axis>, constant: CGFloat = 0) -> NSLayoutConstraint {
        Constraints.add(self, anchor, constant: constant, relation: .greaterThanOrEqual)
    }

    @discardableResult func lessThanOrEqual<OtherType: AnchorType.Alignment>(_ anchor: Anchor<OtherType, Axis>, constant: CGFloat = 0) -> NSLayoutConstraint {
        Constraints.add(self, anchor, constant: constant, relation: .lessThanOrEqual)
    }
}

// MARK: - Anchors (AnchorType.Dimension)

@MainActor public extension Anchor where Type: AnchorType.Dimension {
    @discardableResult func equal<OtherType: AnchorType.Dimension, OtherAxis>(_ anchor: Anchor<OtherType, OtherAxis>, constant: CGFloat = 0) -> NSLayoutConstraint {
        Constraints.add(self, anchor, constant: constant, relation: .equal)
    }

    @discardableResult func greaterThanOrEqual<OtherType: AnchorType.Dimension, OtherAxis>(_ anchor: Anchor<OtherType, OtherAxis>, constant: CGFloat = 0) -> NSLayoutConstraint {
        Constraints.add(self, anchor, constant: constant, relation: .greaterThanOrEqual)
    }

    @discardableResult func lessThanOrEqual<OtherType: AnchorType.Dimension, OtherAxis>(_ anchor: Anchor<OtherType, OtherAxis>, constant: CGFloat = 0) -> NSLayoutConstraint {
        Constraints.add(self, anchor, constant: constant, relation: .lessThanOrEqual)
    }
}

// MARK: - Anchors (AnchorType.Dimension)

@MainActor public extension Anchor where Type: AnchorType.Dimension {
    @discardableResult func equal(_ constant: CGFloat) -> NSLayoutConstraint {
        Constraints.add(item: item, attribute: attribute, relatedBy: .equal, constant: constant)
    }

    @discardableResult func greaterThanOrEqual(_ constant: CGFloat) -> NSLayoutConstraint {
        Constraints.add(item: item, attribute: attribute, relatedBy: .greaterThanOrEqual, constant: constant)
    }

    @discardableResult func lessThanOrEqual(_ constant: CGFloat) -> NSLayoutConstraint {
        Constraints.add(item: item, attribute: attribute, relatedBy: .lessThanOrEqual, constant: constant)
    }

    /// Clamps the dimension of a view to the given limiting range.
    @discardableResult func clamp(to limits: ClosedRange<CGFloat>) -> [NSLayoutConstraint] {
        [greaterThanOrEqual(limits.lowerBound), lessThanOrEqual(limits.upperBound)]
    }
}

// MARK: - Anchors (AnchorType.Edge)

@MainActor public extension Anchor where Type: AnchorType.Edge {
    /// Pins the edge to the respected edges of the given container.
    @discardableResult func pin(to container: LayoutItem? = nil, inset: CGFloat = 0) -> NSLayoutConstraint {
        let isInverted = [.trailing, .right, .bottom].contains(attribute)
        return Constraints.add(self, toItem: container ?? item.superview!, attribute: attribute, constant: (isInverted ? -inset : inset))
    }

    /// Adds spacing between the current anchors.
    @discardableResult func spacing<OtherType: AnchorType.Edge>(_ spacing: CGFloat, to anchor: Anchor<OtherType, Axis>, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let isInverted = (attribute == .bottom && anchor.attribute == .top) ||
        (attribute == .right && anchor.attribute == .left) ||
        (attribute == .trailing && anchor.attribute == .leading)
        return Constraints.add(self, anchor, constant: isInverted ? -spacing : spacing, relation: isInverted ? relation.inverted : relation)
    }
}

// MARK: - Anchors (AnchorType.Center)

@MainActor public extension Anchor where Type: AnchorType.Center {
    /// Aligns the axis with a superview axis.
    @discardableResult func align(offset: CGFloat = 0) -> NSLayoutConstraint {
        Constraints.add(self, toItem: item.superview!, attribute: attribute, constant: offset)
    }
}

// MARK: - AnchorCollectionEdges

/// Create multiple constraints at once by operating more than one edge at once.
@MainActor public struct AnchorCollectionEdges {
    let item: LayoutItem
    var isAbsolute = false

    /// Use `left` and `right` edges instead of `leading` and `trailing`.
    public func absolute() -> AnchorCollectionEdges {
        AnchorCollectionEdges(item: item, isAbsolute: true)
    }

#if os(iOS) || os(tvOS)
    public typealias Axis = NSLayoutConstraint.Axis
#else
    public typealias Axis = NSLayoutConstraint.Orientation
#endif

    // MARK: Core API

    @discardableResult public func equal(_ item2: LayoutItem, insets: EdgeInsets = .zero) -> [NSLayoutConstraint] {
        pin(to: item2, insets: insets)
    }

    @discardableResult public func lessThanOrEqual(_ item2: LayoutItem, insets: EdgeInsets = .zero) -> [NSLayoutConstraint] {
        pin(to: item2, insets: insets, axis: nil, alignment: .center, isCenteringEnabled: false)
    }

    @discardableResult public func equal(_ item2: LayoutItem, insets: CGFloat) -> [NSLayoutConstraint] {
        pin(to: item2, insets: EdgeInsets(top: insets, left: insets, bottom: insets, right: insets))
    }

    @discardableResult public func lessThanOrEqual(_ item2: LayoutItem, insets: CGFloat) -> [NSLayoutConstraint] {
        pin(to: item2, insets: EdgeInsets(top: insets, left: insets, bottom: insets, right: insets), axis: nil, alignment: .center, isCenteringEnabled: false)
    }

    // MARK: Semantic API

    /// Pins the edges to the edges of the given item. By default, pins the edges
    /// to the superview.
    ///
    /// - parameter target: The target view, by default, uses the superview.
    /// - parameter insets: Insets the receiver's edges by the given insets.
    /// - parameter axis: If provided, creates constraints only along the given
    /// axis. For example, if you pass axis `.horizontal`, only the `.leading`,
    /// `.trailing` (and `.centerX` if needed) attributes are used. `nil` by default
    /// - parameter alignment: `.fill` by default, see `Alignment` for a list of
    /// the available options.
    @discardableResult public func pin(to item2: LayoutItem? = nil, insets: CGFloat, axis: Axis? = nil, alignment: Alignment = .fill) -> [NSLayoutConstraint] {
        pin(to: item2, insets: EdgeInsets(top: insets, left: insets, bottom: insets, right: insets), axis: axis, alignment: alignment)
    }

    /// Pins the edges to the edges of the given item. By default, pins the edges
    /// to the superview.
    ///
    /// - parameter target: The target view, by default, uses the superview.
    /// - parameter insets: Insets the receiver's edges by the given insets.
    /// - parameter axis: If provided, creates constraints only along the given
    /// axis. For example, if you pass axis `.horizontal`, only the `.leading`,
    /// `.trailing` (and `.centerX` if needed) attributes are used. `nil` by default
    /// - parameter alignment: `.fill` by default, see `Alignment` for a list of
    /// the available options.
    @discardableResult public func pin(to item2: LayoutItem? = nil, insets: EdgeInsets = .zero, axis: Axis? = nil, alignment: Alignment = .fill) -> [NSLayoutConstraint] {
        pin(to: item2, insets: insets, axis: axis, alignment: alignment, isCenteringEnabled: true)
    }

    private func pin(to item2: LayoutItem?, insets: EdgeInsets, axis: Axis?, alignment: Alignment, isCenteringEnabled: Bool) -> [NSLayoutConstraint] {
        let item2 = item2 ?? item.superview!
        let left: NSLayoutConstraint.Attribute = isAbsolute ? .left : .leading
        let right: NSLayoutConstraint.Attribute = isAbsolute ? .right : .trailing
        var constraints = [NSLayoutConstraint]()

        func constrain(attribute: NSLayoutConstraint.Attribute, relation: NSLayoutConstraint.Relation, constant: CGFloat) {
            constraints.append(Constraints.add(item: item, attribute: attribute, relatedBy: relation, toItem: item2, attribute: attribute, multiplier: 1, constant: constant))
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
            /// Center the view in the container along the vertical axis.
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
        /// The view is pinned to the bottom-trailing corner of the container with the
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
    let x: Anchor<AnchorType.Center, AnchorAxis.Horizontal>
    let y: Anchor<AnchorType.Center, AnchorAxis.Vertical>

    // MARK: Core API

    @discardableResult public func equal<Item: LayoutItem>(_ item2: Item, offset: CGPoint = .zero) -> [NSLayoutConstraint] {
        [x.equal(item2.anchors.centerX, constant: offset.x), y.equal(item2.anchors.centerY, constant: offset.y)]
    }

    @discardableResult public func greaterThanOrEqual<Item: LayoutItem>(_ item2: Item, offset: CGPoint = .zero) -> [NSLayoutConstraint] {
        [x.greaterThanOrEqual(item2.anchors.centerX, constant: offset.x), y.greaterThanOrEqual(item2.anchors.centerY, constant: offset.y)]
    }

    @discardableResult public func lessThanOrEqual<Item: LayoutItem>(_ item2: Item, offset: CGPoint = .zero) -> [NSLayoutConstraint] {
        [x.lessThanOrEqual(item2.anchors.centerX, constant: offset.x), y.lessThanOrEqual(item2.anchors.centerY, constant: offset.y)]
    }

    // MARK: Semantic API

    /// Centers the view in the superview.
    @discardableResult public func align() -> [NSLayoutConstraint] {
        [x.align(), y.align()]
    }

    /// Makes the axis equal to the other collection of axis.
    @discardableResult public func align<Item: LayoutItem>(with item: Item) -> [NSLayoutConstraint] {
        [x.equal(item.anchors.centerX), y.equal(item.anchors.centerY)]
    }
}

// MARK: - AnchorCollectionSize

/// Create multiple constraints at once by using both `width` and `height` anchors.
@MainActor public struct AnchorCollectionSize {
    let width: Anchor<AnchorType.Dimension, AnchorAxis.Horizontal>
    let height: Anchor<AnchorType.Dimension, AnchorAxis.Vertical>

    // MARK: Core API

    /// Set the size of item.
    @discardableResult public func equal(_ size: CGSize) -> [NSLayoutConstraint] {
        [width.equal(size.width), height.equal(size.height)]
    }

    /// Set the size of item.
    @discardableResult public func greaterThanOrEqul(_ size: CGSize) -> [NSLayoutConstraint] {
        [width.greaterThanOrEqual(size.width), height.greaterThanOrEqual(size.height)]
    }

    /// Set the size of item.
    @discardableResult public func lessThanOrEqual(_ size: CGSize) -> [NSLayoutConstraint] {
        [width.lessThanOrEqual(size.width), height.lessThanOrEqual(size.height)]
    }

    /// Makes the size of the item equal to the size of the other item.
    @discardableResult public func equal<Item: LayoutItem>(_ item: Item, insets: CGSize = .zero, multiplier: CGFloat = 1) -> [NSLayoutConstraint] {
        [width.equal(item.anchors.width * multiplier - insets.width), height.equal(item.anchors.height * multiplier - insets.height)]
    }

    @discardableResult public func greaterThanOrEqual<Item: LayoutItem>(_ item: Item, insets: CGSize = .zero, multiplier: CGFloat = 1) -> [NSLayoutConstraint] {
        [width.greaterThanOrEqual(item.anchors.width * multiplier - insets.width), height.greaterThanOrEqual(item.anchors.height * multiplier - insets.height)]
    }

    @discardableResult public func lessThanOrEqual<Item: LayoutItem>(_ item: Item, insets: CGSize = .zero, multiplier: CGFloat = 1) -> [NSLayoutConstraint] {
        [width.lessThanOrEqual(item.anchors.width * multiplier - insets.width), height.lessThanOrEqual(item.anchors.height * multiplier - insets.height)]
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
@MainActor public final class Constraints: Collection {
    public typealias Element = NSLayoutConstraint
    public typealias Index = Int

    public nonisolated subscript(position: Int) -> NSLayoutConstraint {
        get { MainActor.assumeIsolated { constraints[position] } }
    }
    public nonisolated var startIndex: Int { MainActor.assumeIsolated { constraints.startIndex } }
    public nonisolated var endIndex: Int { MainActor.assumeIsolated { constraints.endIndex } }
    public nonisolated func index(after i: Int) -> Int { i + 1 }

    /// Returns all of the created constraints.
    public private(set) var constraints = [NSLayoutConstraint]()

    /// All of the constraints created in the given closure are automatically
    /// activated at the same time. This is more efficient then installing them
    /// one-be-one. More importantly, it allows to make changes to the constraints
    /// before they are installed (e.g. change `priority`).
    ///
    /// - parameter activate: Set to `false` to disable automatic activation of
    /// constraints.
    @discardableResult public init(activate: Bool = true, _ closure: () -> Void) {
        Constraints.stack.append(self)
        closure() // create constraints
        Constraints.stack.removeLast()
        if activate { NSLayoutConstraint.activate(constraints) }
    }

    // MARK: Activate

    /// Activates each constraint in the receiver.
    public func activate() {
        NSLayoutConstraint.activate(constraints)
    }

    /// Deactivates each constraint in the receiver.
    public func deactivate() {
        NSLayoutConstraint.deactivate(constraints)
    }

    // MARK: Adding Constraints

    /// Creates and automatically installs a constraint.
    static func add(item item1: Any, attribute attr1: NSLayoutConstraint.Attribute, relatedBy relation: NSLayoutConstraint.Relation = .equal, toItem item2: Any? = nil, attribute attr2: NSLayoutConstraint.Attribute? = nil, multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
#if os(iOS) || os(tvOS)
        (item1 as? UIView)?.translatesAutoresizingMaskIntoConstraints = false
#elseif os(macOS)
        (item1 as? NSView)?.translatesAutoresizingMaskIntoConstraints = false
#endif
        let constraint = NSLayoutConstraint(item: item1, attribute: attr1, relatedBy: relation, toItem: item2, attribute: attr2 ?? .notAnAttribute, multiplier: multiplier, constant: constant)
        install(constraint)
        return constraint
    }

    /// Creates and automatically installs a constraint between two anchors.
    static func add<T1, A1, T2, A2>(_ lhs: Anchor<T1, A1>, _ rhs: Anchor<T2, A2>, constant: CGFloat = 0, multiplier: CGFloat = 1, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        add(item: lhs.item, attribute: lhs.attribute, relatedBy: relation, toItem: rhs.item, attribute: rhs.attribute, multiplier: (multiplier / lhs.multiplier) * rhs.multiplier, constant: constant - lhs.offset + rhs.offset)
    }

    /// Creates and automatically installs a constraint between an anchor and
    /// a given item.
    static func add<T1, A1>(_ lhs: Anchor<T1, A1>, toItem item2: Any?, attribute attr2: NSLayoutConstraint.Attribute?, constant: CGFloat = 0, multiplier: CGFloat = 1, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        add(item: lhs.item, attribute: lhs.attribute, relatedBy: relation, toItem: item2, attribute: attr2, multiplier: multiplier / lhs.multiplier, constant: constant - lhs.offset)
    }

    private static var stack = [Constraints]() // this is what enabled constraint auto-installing

    private static func install(_ constraint: NSLayoutConstraint) {
        if let group = stack.last {
            group.constraints.append(constraint)
        } else {
            constraint.isActive = true
        }
    }
}

public extension Constraints {
    @discardableResult convenience init<A: LayoutItem>(for a: A, _ closure: (LayoutAnchors<A>) -> Void) {
        self.init { closure(a.anchors) }
    }

    @discardableResult convenience init<A: LayoutItem, B: LayoutItem>(for a: A, _ b: B, _ closure: (LayoutAnchors<A>, LayoutAnchors<B>) -> Void) {
        self.init { closure(a.anchors, b.anchors) }
    }

    @discardableResult convenience init<A: LayoutItem, B: LayoutItem, C: LayoutItem>(for a: A, _ b: B, _ c: C, _ closure: (LayoutAnchors<A>, LayoutAnchors<B>, LayoutAnchors<C>) -> Void) {
        self.init { closure(a.anchors, b.anchors, c.anchors) }
    }

    @discardableResult convenience init<A: LayoutItem, B: LayoutItem, C: LayoutItem, D: LayoutItem>(for a: A, _ b: B, _ c: C, _ d: D, _ closure: (LayoutAnchors<A>, LayoutAnchors<B>, LayoutAnchors<C>, LayoutAnchors<D>) -> Void) {
        self.init { closure(a.anchors, b.anchors, c.anchors, d.anchors) }
    }
}

// MARK: - Misc

#if os(iOS) || os(tvOS)
public typealias EdgeInsets = UIEdgeInsets
#elseif os(macOS)
public typealias EdgeInsets = NSEdgeInsets

public extension NSEdgeInsets {
    static let zero = NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
}
#endif

extension NSLayoutConstraint.Relation {
    var inverted: NSLayoutConstraint.Relation {
        switch self {
        case .greaterThanOrEqual: return .lessThanOrEqual
        case .lessThanOrEqual: return .greaterThanOrEqual
        case .equal: return self
        @unknown default: return self
        }
    }
}

extension EdgeInsets {
    func inset(for attribute: NSLayoutConstraint.Attribute, edge: Bool = false) -> CGFloat {
        switch attribute {
        case .top: return top; case .bottom: return edge ? -bottom : bottom
        case .left, .leading: return left
        case .right, .trailing: return edge ? -right : right
        default: return 0
        }
    }
}
