// The MIT License (MIT)
//
// Copyright (c) 2017-2020 Alexander Grebenyuk (github.com/kean).

#if os(iOS) || os(tvOS)
import UIKit

public protocol LayoutItem { // `UIView`, `UILayoutGuide`
    var superview: UIView? { get }
}

extension UIView: LayoutItem {}
extension UILayoutGuide: LayoutItem {
    public var superview: UIView? { owningView }
}
#elseif os(macOS)
import AppKit

public protocol LayoutItem { // `NSView`, `NSLayoutGuide`
    var superview: NSView? { get }
}

extension NSView: LayoutItem {}
extension NSLayoutGuide: LayoutItem {
    public var superview: NSView? { owningView }
}
#endif

public extension LayoutItem { // Align methods are available via `LayoutAnchors`
    @nonobjc var anchors: LayoutAnchors<Self> { LayoutAnchors(base: self) }
}

// MARK: - LayoutAnchors

public struct LayoutAnchors<Base> {
    public let base: Base
}

public extension LayoutAnchors where Base: LayoutItem {

    // MARK: Anchors

    var top: Anchor<AnchorType.Edge, AnchorAxis.Vertical> { Anchor(base, .top) }
    var bottom: Anchor<AnchorType.Edge, AnchorAxis.Vertical> { Anchor(base, .bottom) }
    var left: Anchor<AnchorType.Edge, AnchorAxis.Horizontal> { Anchor(base, .left) }
    var right: Anchor<AnchorType.Edge, AnchorAxis.Horizontal> { Anchor(base, .right) }
    var leading: Anchor<AnchorType.Edge, AnchorAxis.Horizontal> { Anchor(base, .leading) }
    var trailing: Anchor<AnchorType.Edge, AnchorAxis.Horizontal> { Anchor(base, .trailing) }

    var centerX: Anchor<AnchorType.Center, AnchorAxis.Horizontal> { Anchor(base, .centerX) }
    var centerY: Anchor<AnchorType.Center, AnchorAxis.Vertical> { Anchor(base, .centerY) }

    var firstBaseline: Anchor<AnchorType.Baseline, AnchorAxis.Vertical> { Anchor(base, .firstBaseline) }
    var lastBaseline: Anchor<AnchorType.Baseline, AnchorAxis.Vertical> { Anchor(base, .lastBaseline) }

    var width: Anchor<AnchorType.Dimension, AnchorAxis.Horizontal> { Anchor(base, .width) }
    var height: Anchor<AnchorType.Dimension, AnchorAxis.Vertical> { Anchor(base, .height) }

    // MARK: Anchor Collections

    var edges: AnchorCollectionEdges { AnchorCollectionEdges(item: base, edges: [.left, .right, .bottom, .top]) }
    var center: AnchorCollectionCenter { AnchorCollectionCenter(x: centerX, y: centerY) }
    var size: AnchorCollectionSize { AnchorCollectionSize(width: width, height: height) }
}

#if os(iOS) || os(tvOS)
public extension LayoutAnchors where Base: UIView {
    var margins: LayoutAnchors<UILayoutGuide> { base.layoutMarginsGuide.anchors }
    var safeArea: LayoutAnchors<UILayoutGuide> { base.safeAreaLayoutGuide.anchors }
}
#endif

// MARK: - Anchors

// phantom types
public enum AnchorAxis {
    public class Horizontal {}
    public class Vertical {}
}

public enum AnchorType {
    public class Dimension {}
    public class Alignment {}
    public class Center: Alignment {}
    public class Edge: Alignment {}
    public class Baseline: Alignment {}
}

/// An anchor represents one of the view's layout attributes (e.g. `left`,
/// `centerX`, `width`, etc). Use the anchor’s methods to construct constraints.
public struct Anchor<Type, Axis> { // type and axis are phantom types
    let item: LayoutItem
    let attribute: NSLayoutConstraint.Attribute
    let offset: CGFloat
    let multiplier: CGFloat

    init(_ item: LayoutItem, _ attribute: NSLayoutConstraint.Attribute, offset: CGFloat = 0, multiplier: CGFloat = 1) {
        self.item = item; self.attribute = attribute; self.offset = offset; self.multiplier = multiplier
    }

    /// Returns a new anchor offset by a given amount.
    ///
    /// - note: Consider using a convenience operator instead: `view.anchors.top + 10`.
    public func offsetting(by offset: CGFloat) -> Anchor<Type, Axis> {
        Anchor<Type, Axis>(item, attribute, offset: self.offset + offset, multiplier: self.multiplier)
    }

    /// Returns a new anchor with a given multiplier.
    ///
    /// - note: Consider using a convenience operator instead: `view.anchors.height * 2`.
    public func multiplied(by multiplier: CGFloat) -> Anchor<Type, Axis> {
        Anchor<Type, Axis>(item, attribute, offset: self.offset * multiplier, multiplier: self.multiplier * multiplier)
    }
}

public func + <Type, Axis>(anchor: Anchor<Type, Axis>, offset: CGFloat) -> Anchor<Type, Axis> {
    anchor.offsetting(by: offset)
}

public func - <Type, Axis>(anchor: Anchor<Type, Axis>, offset: CGFloat) -> Anchor<Type, Axis> {
    anchor.offsetting(by: -offset)
}

public func * <Type, Axis>(anchor: Anchor<Type, Axis>, multiplier: CGFloat) -> Anchor<Type, Axis> {
    anchor.multiplied(by: multiplier)
}

// MARK: - Anchors (AnchorType.Alignment)

public extension Anchor where Type: AnchorType.Alignment {
    @discardableResult func equal<Type: AnchorType.Alignment>(_ anchor: Anchor<Type, Axis>, constant: CGFloat = 0) -> NSLayoutConstraint {
        Constraints.constrain(self, anchor, constant: constant, relation: .equal)
    }

    @discardableResult func greaterThanOrEqual<Type: AnchorType.Alignment>(_ anchor: Anchor<Type, Axis>, constant: CGFloat = 0) -> NSLayoutConstraint {
        Constraints.constrain(self, anchor, constant: constant, relation: .greaterThanOrEqual)
    }

    @discardableResult func lessThanOrEqual<Type: AnchorType.Alignment>(_ anchor: Anchor<Type, Axis>, constant: CGFloat = 0) -> NSLayoutConstraint {
        Constraints.constrain(self, anchor, constant: constant, relation: .lessThanOrEqual)
    }
}

// MARK: - Anchors (AnchorType.Dimension)

public extension Anchor where Type: AnchorType.Dimension {
    @discardableResult func equal<Type: AnchorType.Dimension, Axis>(_ anchor: Anchor<Type, Axis>, constant: CGFloat = 0) -> NSLayoutConstraint {
        Constraints.constrain(self, anchor, constant: constant, relation: .equal)
    }

    @discardableResult func greaterThanOrEqual<Type: AnchorType.Dimension, Axis>(_ anchor: Anchor<Type, Axis>, constant: CGFloat = 0) -> NSLayoutConstraint {
        Constraints.constrain(self, anchor, constant: constant, relation: .greaterThanOrEqual)
    }

    @discardableResult func lessThanOrEqual<Type: AnchorType.Dimension, Axis>(_ anchor: Anchor<Type, Axis>, constant: CGFloat = 0) -> NSLayoutConstraint {
        Constraints.constrain(self, anchor, constant: constant, relation: .lessThanOrEqual)
    }
}

// MARK: - Anchors (AnchorType.Edge)

extension Anchor where Type: AnchorType.Edge {
    /// Pins the edge to the respected edges of the given container.
    @discardableResult public func pin(to container: LayoutItem? = nil, inset: CGFloat = 0) -> NSLayoutConstraint {
        _pin(to: container ?? item.superview!, attribute: attribute, inset: inset, relation: .equal)
    }

    // Pin the anchor to another layout item.
    private func _pin(to item2: Any?, attribute attr2: NSLayoutConstraint.Attribute, inset: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        let isInverted = [.trailing, .right, .bottom].contains(attribute)
        return Constraints.constrain(self, toItem: item2, attribute: attr2, constant: (isInverted ? -inset : inset), relation: (isInverted ? relation.inverted : relation))
    }

    /// Adds spacing between the current anchors.
    @discardableResult public func spacing<Type: AnchorType.Edge>(_ spacing: CGFloat, to anchor: Anchor<Type, Axis>, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let isInverted = (attribute == .bottom && anchor.attribute == .top) ||
            (attribute == .right && anchor.attribute == .left) ||
            (attribute == .trailing && anchor.attribute == .leading)
        return Constraints.constrain(self, anchor, constant: isInverted ? -spacing : spacing, relation: isInverted ? relation.inverted : relation)
    }
}

// MARK: - Anchors (AnchorType.Center)

extension Anchor where Type: AnchorType.Center {
    /// Aligns the axis with a superview axis.
    @discardableResult public func align(offset: CGFloat = 0) -> NSLayoutConstraint {
        Constraints.constrain(self, toItem: item.superview!, attribute: attribute, constant: offset)
    }
}

// MARK: - Anchors (AnchorType.Dimension)

extension Anchor where Type: AnchorType.Dimension {
    @discardableResult public func equal(_ constant: CGFloat) -> NSLayoutConstraint {
        Constraints.constrain(item: item, attribute: attribute, relatedBy: .equal, constant: constant)
    }

    @discardableResult public func greaterThanOrEqual(_ constant: CGFloat) -> NSLayoutConstraint {
        Constraints.constrain(item: item, attribute: attribute, relatedBy: .greaterThanOrEqual, constant: constant)
    }

    @discardableResult public func lessThanOrEqual(_ constant: CGFloat) -> NSLayoutConstraint {
        Constraints.constrain(item: item, attribute: attribute, relatedBy: .lessThanOrEqual, constant: constant)
    }
}

// MARK: - AnchorCollectionEdges

public struct Alignmment {
    public enum Horizontal {
        case fill, center, leading, trailing
    }
    public enum Vertical {
        case fill, center, top, bottom
    }

    public let horizontal: Horizontal
    public let vertical: Vertical

    public init(horizontal: Horizontal, vertical: Vertical) {
        (self.horizontal, self.vertical) = (horizontal, vertical)
    }

    public static let fill = Alignmment(horizontal: .fill, vertical: .fill)
    public static let center = Alignmment(horizontal: .center, vertical: .center)
    public static let topLeading = Alignmment(horizontal: .leading, vertical: .top)
    public static let leading = Alignmment(horizontal: .leading, vertical: .fill)
    public static let bottomLeading = Alignmment(horizontal: .leading, vertical: .bottom)
    public static let bottom = Alignmment(horizontal: .fill, vertical: .bottom)
    public static let bottomTrailing = Alignmment(horizontal: .trailing, vertical: .bottom)
    public static let trailing = Alignmment(horizontal: .trailing, vertical: .fill)
    public static let topTrailing = Alignmment(horizontal: .trailing, vertical: .top)
    public static let top = Alignmment(horizontal: .fill, vertical: .top)
}

public struct AnchorCollectionEdges {
    let item: LayoutItem
    let edges: [LayoutEdge]
    var isAbsolute = false

    // By default, edges use locale-specific `.leading` and `.trailing`
    public func absolute() -> AnchorCollectionEdges {
        AnchorCollectionEdges(item: item, edges: edges, isAbsolute: true)
    }

    #if os(iOS) || os(tvOS)
    public typealias Axis = NSLayoutConstraint.Axis
    #else
    public typealias Axis = NSLayoutConstraint.Orientation
    #endif

    @discardableResult public func pin(to item2: LayoutItem? = nil, insets: EdgeInsets = .zero, axis: Axis? = nil, alignment: Alignmment = .fill) -> [NSLayoutConstraint] {
        let item2 = item2 ?? item.superview!
        let left: NSLayoutConstraint.Attribute = isAbsolute ? .left : .leading
        let right: NSLayoutConstraint.Attribute = isAbsolute ? .right : .trailing
        var constraints = [NSLayoutConstraint]()

        func constrain(attribute: NSLayoutConstraint.Attribute, relation: NSLayoutConstraint.Relation, constant: CGFloat) {
            constraints.append(Constraints.constrain(item: item, attribute: attribute, relatedBy: relation, toItem: item2, attribute: attribute, multiplier: 1, constant: constant))
        }

        if axis == nil || axis == .horizontal {
            constrain(attribute: left, relation: alignment.horizontal == .fill || alignment.horizontal == .leading ? .equal : .greaterThanOrEqual, constant: insets.left)
            constrain(attribute: right, relation: alignment.horizontal == .fill || alignment.horizontal == .trailing ? .equal : .lessThanOrEqual, constant: -insets.right)
            if alignment.horizontal == .center {
                constrain(attribute: .centerX, relation: .equal, constant: 0)
            }
        }
        if axis == nil || axis == .vertical {
            constrain(attribute: .top, relation: alignment.vertical == .fill || alignment.vertical == .top ? .equal : .greaterThanOrEqual, constant: insets.top)
            constrain(attribute: .bottom, relation: alignment.vertical == .fill || alignment.vertical == .bottom ? .equal : .lessThanOrEqual, constant: -insets.bottom)
            if alignment.vertical == .center {
                constrain(attribute: .centerY, relation: .equal, constant: 0)
            }
        }
        return constraints
    }
}

// MARK: - AnchorCollectionCenter

public struct AnchorCollectionCenter {
    let x: Anchor<AnchorType.Center, AnchorAxis.Horizontal>
    let y: Anchor<AnchorType.Center, AnchorAxis.Vertical>

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

public struct AnchorCollectionSize {
    let width: Anchor<AnchorType.Dimension, AnchorAxis.Horizontal>
    let height: Anchor<AnchorType.Dimension, AnchorAxis.Vertical>

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

public final class Constraints {
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
        Constraints._stack.append(self)
        closure() // create constraints
        Constraints._stack.removeLast()
        if activate { NSLayoutConstraint.activate(constraints) }
    }

    /// Creates and automatically installs a constraint.
    static func constrain(item item1: Any, attribute attr1: NSLayoutConstraint.Attribute, relatedBy relation: NSLayoutConstraint.Relation = .equal, toItem item2: Any? = nil, attribute attr2: NSLayoutConstraint.Attribute? = nil, multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
        precondition(Thread.isMainThread, "Align APIs can only be used from the main thread")
        #if os(iOS) || os(tvOS)
        (item1 as? UIView)?.translatesAutoresizingMaskIntoConstraints = false
        #elseif os(macOS)
        (item1 as? NSView)?.translatesAutoresizingMaskIntoConstraints = false
        #endif
        let constraint = NSLayoutConstraint(item: item1, attribute: attr1, relatedBy: relation, toItem: item2, attribute: attr2 ?? .notAnAttribute, multiplier: multiplier, constant: constant)
        _install(constraint)
        return constraint
    }

    /// Creates and automatically installs a constraint between two anchors.
    static func constrain<T1, A1, T2, A2>(_ lhs: Anchor<T1, A1>, _ rhs: Anchor<T2, A2>, constant: CGFloat = 0, multiplier: CGFloat = 1, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        constrain(item: lhs.item, attribute: lhs.attribute, relatedBy: relation, toItem: rhs.item, attribute: rhs.attribute, multiplier: (multiplier / lhs.multiplier) * rhs.multiplier, constant: constant - lhs.offset + rhs.offset)
    }

    /// Creates and automatically installs a constraint between an anchor and
    /// a given item.
    static func constrain<T1, A1>(_ lhs: Anchor<T1, A1>, toItem item2: Any?, attribute attr2: NSLayoutConstraint.Attribute?, constant: CGFloat = 0, multiplier: CGFloat = 1, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        constrain(item: lhs.item, attribute: lhs.attribute, relatedBy: relation, toItem: item2, attribute: attr2, multiplier: multiplier / lhs.multiplier, constant: constant - lhs.offset)
    }

    private static var _stack = [Constraints]() // this is what enabled constraint auto-installing

    private static func _install(_ constraint: NSLayoutConstraint) {
        if let group = _stack.last {
            group.constraints.append(constraint)
        } else {
            constraint.isActive = true
        }
    }
}

extension Constraints {
    @discardableResult public convenience init<A: LayoutItem>(for a: A, _ closure: (LayoutAnchors<A>) -> Void) {
        self.init { closure(a.anchors) }
    }

    @discardableResult public convenience init<A: LayoutItem, B: LayoutItem>(for a: A, _ b: B, _ closure: (LayoutAnchors<A>, LayoutAnchors<B>) -> Void) {
        self.init { closure(a.anchors, b.anchors) }
    }

    @discardableResult public convenience init<A: LayoutItem, B: LayoutItem, C: LayoutItem>(for a: A, _ b: B, _ c: C, _ closure: (LayoutAnchors<A>, LayoutAnchors<B>, LayoutAnchors<C>) -> Void) {
        self.init { closure(a.anchors, b.anchors, c.anchors) }
    }

    @discardableResult public convenience init<A: LayoutItem, B: LayoutItem, C: LayoutItem, D: LayoutItem>(for a: A, _ b: B, _ c: C, _ d: D, _ closure: (LayoutAnchors<A>, LayoutAnchors<B>, LayoutAnchors<C>, LayoutAnchors<D>) -> Void) {
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

public enum LayoutEdge {
    case top, bottom, leading, trailing, left, right

    var attribute: NSLayoutConstraint.Attribute {
        switch self {
        case .top: return .top;          case .bottom: return .bottom
        case .leading: return .leading;  case .trailing: return .trailing
        case .left: return .left;        case .right: return .right
        }
    }
}

#if os(iOS) || os(tvOS)
extension NSLayoutConstraint.Attribute {
    var toMargin: NSLayoutConstraint.Attribute {
        switch self {
        case .top: return .topMargin;           case .bottom: return .bottomMargin
        case .leading: return .leadingMargin;   case .trailing: return .trailingMargin
        case .left: return .leftMargin          case .right: return .rightMargin
        default: return self
        }
    }
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

// MARK: - Deprecated

public extension LayoutItem {
    @available(*, deprecated, message: "Renamed to `anchors`")
    @nonobjc var al: LayoutAnchors<Self> { LayoutAnchors(base: self) }
}

public extension LayoutAnchors where Base: LayoutItem {
    @available(*, deprecated, message: "Please use `pin()` instead. Instead of selecting specific edges, pass an `axis` in the `pin()` method as a parameter. See README.md for more information.")
    func edges(_ edges: LayoutEdge...) -> AnchorCollectionEdges { AnchorCollectionEdges(item: base, edges: edges) }
}

extension Anchor where Type: AnchorType.Edge {
    @available(*, deprecated, message: "Please use `pin()` instead. Instead of selecting specific edges, pass an `axis` in the `pin()` method as a parameter. See README.md for more information.")
    @discardableResult public func pin(to container: LayoutItem? = nil, inset: CGFloat = 0, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        _pin(to: container ?? item.superview!, attribute: attribute, inset: inset, relation: relation)
    }

    @available(*, deprecated, message: "Please use `pin()` instead. Instead of selecting specific edges, pass an `axis` in the `pin()` method as a parameter. See README.md for more information.")
     @discardableResult public func pinToSuperview(inset: CGFloat = 0, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
         _pin(to: item.superview!, attribute: attribute, inset: inset, relation: relation)
     }

    #if os(iOS) || os(tvOS)
    @available(*, deprecated, message: "Please use `pin()` instead. Instead of selecting specific edges, pass an `axis` in the `pin()` method as a parameter. See README.md for more information.")
    @discardableResult public func pinToSuperviewMargin(inset: CGFloat = 0, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        _pin(to: item.superview!, attribute: attribute.toMargin, inset: inset, relation: relation)
    }

    @available(*, deprecated, message: "Please use `pin()` instead. Instead of selecting specific edges, pass an `axis` in the `pin()` method as a parameter. See README.md for more information.")
    @discardableResult public func pinToSafeArea(of vc: UIViewController, inset: CGFloat = 0, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        return _pin(to: vc.view.safeAreaLayoutGuide, attribute: attribute, inset: inset, relation: relation)
    }
    #endif
}

public extension AnchorCollectionEdges {
    private var anchors: [Anchor<AnchorType.Edge, Any>] { edges.map { Anchor(item, $0.attribute) } }

    /// Pins the edges of the view to the edges of the superview so the the view
    /// fills the available space in a container.
    @available(*, deprecated, message: "Please use `pin()` instead. `relation` was replaced with a new `alignment` option. See README.md for more information.")
    @discardableResult func pinToSuperview(insets: EdgeInsets = .zero, relation: NSLayoutConstraint.Relation = .equal) -> [NSLayoutConstraint] {
        anchors.map { $0.pinToSuperview(inset: insets.inset(for: $0.attribute), relation: relation) }
    }

    #if os(iOS) || os(tvOS)
    /// Pins the edges of the view to the margins of the superview so the the view
    /// fills the available space in a container.
    @available(*, deprecated, message: "Please use `pin(to: superview.layoutMarginsGuide)` instead. `relation` was replaced with a new `alignment` option. See README.md for more information.")
    @discardableResult func pinToSuperviewMargins(insets: EdgeInsets = .zero, relation: NSLayoutConstraint.Relation = .equal) -> [NSLayoutConstraint] {
        anchors.map { $0.pinToSuperviewMargin(inset: insets.inset(for: $0.attribute), relation: relation) }
    }

    /// Pins the edges to the safe area of the view controller.
    @available(*, deprecated, message: "Please use `pin(to: vc.view.safeAreaLayoutGuide)` instead. `relation` was replaced with a new `alignment` option. See README.md for more information.")
    @discardableResult func pinToSafeArea(of vc: UIViewController, insets: UIEdgeInsets = .zero, relation: NSLayoutConstraint.Relation = .equal) -> [NSLayoutConstraint] {
        anchors.map { $0.pinToSafeArea(of: vc, inset: insets.inset(for: $0.attribute), relation: relation) }
    }
    #endif
}

extension Anchor where Type: AnchorType.Alignment {
    @available(*, deprecated, message: "Please use `equal`, `greaterThanOrEqual`, `lessThanOrEqual` instead")
    @discardableResult public func align<Type: AnchorType.Alignment>(with anchor: Anchor<Type, Axis>, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        Constraints.constrain(self, anchor, relation: relation)
    }
}

public extension Anchor where Type: AnchorType.Center {
    @available(*, deprecated, message: "Please use `align`.")
    @discardableResult func alignWithSuperview(offset: CGFloat = 0, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        Constraints.constrain(self, toItem: item.superview!, attribute: attribute, constant: offset, relation: relation)
    }
}

public extension Anchor where Type: AnchorType.Dimension {
    @available(*, deprecated, message: "Please use `equal`, `greaterThanOrEqual`, `lessThanOrEqual` instead")
    @discardableResult func set(_ constant: CGFloat, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        Constraints.constrain(item: item, attribute: attribute, relatedBy: relation, constant: constant)
    }

    @available(*, deprecated, message: "Please use `equal`, `greaterThanOrEqual`, `lessThanOrEqual` instead")
    @discardableResult func match<Axis>(_ anchor: Anchor<AnchorType.Dimension, Axis>, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        Constraints.constrain(self, anchor, relation: relation)
    }
}

// MARK: - AnchorCollectionSize

public extension AnchorCollectionSize {
    @available(*, deprecated, message: "Please use `equal`, `greaterThanOrEqual`, `lessThanOrEqual` instead")
    @discardableResult func set(_ size: CGSize, relation: NSLayoutConstraint.Relation = .equal) -> [NSLayoutConstraint] {
        [width.set(size.width, relation: relation), height.set(size.height, relation: relation)]
    }

    @available(*, deprecated, message: "Please use `equal`, `greaterThanOrEqual`, `lessThanOrEqual` instead")
    @discardableResult func match(_ anchors: AnchorCollectionSize, insets: CGSize = .zero, multiplier: CGFloat = 1, relation: NSLayoutConstraint.Relation = .equal) -> [NSLayoutConstraint] {
        [width.match(anchors.width * multiplier - insets.width, relation: relation),
         height.match(anchors.height * multiplier - insets.height, relation: relation)]
    }
}

public extension AnchorCollectionCenter {
    @available(*, deprecated, message: "Please use `align` instead")
    @discardableResult func alignWithSuperview() -> [NSLayoutConstraint] {
        [x.align(), y.align()]
    }

    @available(*, deprecated, message: "Please use `align` instead")
    @discardableResult func align(with anchors: AnchorCollectionCenter) -> [NSLayoutConstraint] {
        [x.equal(anchors.x), y.equal(anchors.y)]
    }
}
