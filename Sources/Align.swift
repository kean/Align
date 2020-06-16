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

    @available(*, deprecated, message: "Renamed to `anchors`")
    @nonobjc var al: LayoutAnchors<Self> { LayoutAnchors(base: self) }
}

// MARK: - LayoutAnchors

public struct LayoutAnchors<Base> {
    public let base: Base
}

extension LayoutAnchors where Base: LayoutItem {

    // MARK: Anchors

    public var top: Anchor<AnchorType.Edge, AnchorAxis.Vertical> { Anchor(base, .top) }
    public var bottom: Anchor<AnchorType.Edge, AnchorAxis.Vertical> { Anchor(base, .bottom) }
    public var left: Anchor<AnchorType.Edge, AnchorAxis.Horizontal> { Anchor(base, .left) }
    public var right: Anchor<AnchorType.Edge, AnchorAxis.Horizontal> { Anchor(base, .right) }
    public var leading: Anchor<AnchorType.Edge, AnchorAxis.Horizontal> { Anchor(base, .leading) }
    public var trailing: Anchor<AnchorType.Edge, AnchorAxis.Horizontal> { Anchor(base, .trailing) }

    public var centerX: Anchor<AnchorType.Center, AnchorAxis.Horizontal> { Anchor(base, .centerX) }
    public var centerY: Anchor<AnchorType.Center, AnchorAxis.Vertical> { Anchor(base, .centerY) }

    public var firstBaseline: Anchor<AnchorType.Baseline, AnchorAxis.Vertical> { Anchor(base, .firstBaseline) }
    public var lastBaseline: Anchor<AnchorType.Baseline, AnchorAxis.Vertical> { Anchor(base, .lastBaseline) }

    public var width: Anchor<AnchorType.Dimension, AnchorAxis.Horizontal> { Anchor(base, .width) }
    public var height: Anchor<AnchorType.Dimension, AnchorAxis.Vertical> { Anchor(base, .height) }

    // MARK: Anchor Collections

    public func edges(_ edges: LayoutEdge...) -> AnchorCollectionEdges { AnchorCollectionEdges(item: base, edges: edges) }
    public var edges: AnchorCollectionEdges { AnchorCollectionEdges(item: base, edges: [.left, .right, .bottom, .top]) }
    public var center: AnchorCollectionCenter { AnchorCollectionCenter(x: centerX, y: centerY) }
    public var size: AnchorCollectionSize { AnchorCollectionSize(width: width, height: height) }
}

#if os(iOS) || os(tvOS)
extension LayoutAnchors where Base: UIView {
    public var margins: LayoutAnchors<UILayoutGuide> { base.layoutMarginsGuide.anchors }
    public var safeArea: LayoutAnchors<UILayoutGuide> { base.safeAreaLayoutGuide.anchors }
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
    /// Includes `center`, `edge` and `baselines` anchors.
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
    func offsetting(by offset: CGFloat) -> Anchor<Type, Axis> {
        Anchor<Type, Axis>(item, attribute, offset: self.offset + offset, multiplier: self.multiplier)
    }

    /// Returns a new anchor with a given multiplier.
    func multiplied(by multiplier: CGFloat) -> Anchor<Type, Axis> {
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

extension Anchor where Type: AnchorType.Alignment {
    /// Aligns two anchors.
    @discardableResult public func align<Type: AnchorType.Alignment>(with anchor: Anchor<Type, Axis>, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        Constraints.constrain(self, anchor, relation: relation)
    }
}

// MARK: - Anchors (AnchorType.Edge)

extension Anchor where Type: AnchorType.Edge {
    /// Pins the edge to the same edge of the superview.
    @discardableResult public func pinToSuperview(inset: CGFloat = 0) -> NSLayoutConstraint {
        _pin(to: item.superview!, attribute: attribute, inset: inset)
    }

    /// Pins the edge to the respected edges of the given container.
    @discardableResult public func pin(to container: LayoutItem, inset: CGFloat = 0) -> NSLayoutConstraint {
        _pin(to: container, attribute: attribute, inset: inset)
    }

    #if os(iOS) || os(tvOS)
    /// Pins the edge to the respected margin of the superview.
    @discardableResult public func pinToSuperviewMargin(inset: CGFloat = 0) -> NSLayoutConstraint {
        _pin(to: item.superview!, attribute: attribute.toMargin, inset: inset)
    }

    /// Pins the edge to the safe area of the view controller.
    @discardableResult public func pinToSafeArea(of vc: UIViewController, inset: CGFloat = 0) -> NSLayoutConstraint {
        let (item2, attr2) = (vc.view.safeAreaLayoutGuide, self.attribute)
        return _pin(to: item2, attribute: attr2, inset: inset)
    }
    #endif

    // Pin the anchor to another layout item.
    private func _pin(to item2: Any?, attribute attr2: NSLayoutConstraint.Attribute, inset: CGFloat) -> NSLayoutConstraint {
        // Invert attribute and relation in certain cases. The `pin` semantics
        // are inspired by https://github.com/PureLayout/PureLayout
        let isInverted = [.trailing, .right, .bottom].contains(attribute)
        return Constraints.constrain(self, toItem: item2, attribute: attr2, offset: (isInverted ? -inset : inset))
    }
}

// MARK: - Anchors (AnchorType.Center)

extension Anchor where Type: AnchorType.Center {
    /// Aligns the axis with a superview axis.
    @discardableResult public func alignWithSuperview(offset: CGFloat = 0, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        align(with: Anchor<Type, Axis>(self.item.superview!, self.attribute) + offset, relation: relation)
    }
}

// MARK: - Anchors (AnchorType.Dimension)

extension Anchor where Type: AnchorType.Dimension {
    /// Sets the dimension to a specific size.
    @discardableResult public func set(_ constant: CGFloat, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        Constraints.constrain(item: item, attribute: attribute, relatedBy: relation, constant: constant)
    }

    @discardableResult public func match<Axis>(_ anchor: Anchor<AnchorType.Dimension, Axis>, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        Constraints.constrain(self, anchor, relation: relation)
    }
}

// MARK: - AnchorCollectionEdges

public struct AnchorCollectionEdges {
    let item: LayoutItem
    let edges: [LayoutEdge]
    private var anchors: [Anchor<AnchorType.Edge, Any>] { edges.map { Anchor(item, $0.attribute) } }

    /// Pins the edges of the view to the edges of the superview so the the view
    /// fills the available space in a container.
    @discardableResult public func pinToSuperview(insets: EdgeInsets = .zero) -> [NSLayoutConstraint] {
        anchors.map { $0.pinToSuperview(inset: insets.inset(for: $0.attribute)) }
    }

    /// Pins the edges of the view to the edges of the given view so the the
    /// view fills the available space in a container.
    @discardableResult public func pin(to item2: LayoutItem, insets: EdgeInsets = .zero) -> [NSLayoutConstraint] {
        anchors.map { $0.pin(to: item2, inset: insets.inset(for: $0.attribute)) }
    }

    /// Pins the edges of the view to the edges of the superview so the the view
    /// fills the available space in a container.
    @discardableResult public func pinToSuperview(insets: CGFloat) -> [NSLayoutConstraint] {
        anchors.map { $0.pinToSuperview(inset: insets) }
    }

    /// Pins the edges of the view to the edges of the given view so the the
    /// view fills the available space in a container.
    @discardableResult public func pin(to item2: LayoutItem, insets: CGFloat) -> [NSLayoutConstraint] {
        anchors.map { $0.pin(to: item2, inset: insets) }
    }

    #if os(iOS) || os(tvOS)
    /// Pins the edges of the view to the margins of the superview so the the view
    /// fills the available space in a container.
    @discardableResult public func pinToSuperviewMargins(insets: EdgeInsets = .zero) -> [NSLayoutConstraint] {
        anchors.map { $0.pinToSuperviewMargin(inset: insets.inset(for: $0.attribute)) }
    }

    /// Pins the edges of the view to the margins of the superview so the the view
    /// fills the available space in a container.
    @discardableResult public func pinToSuperviewMargins( insets: CGFloat) -> [NSLayoutConstraint] {
        anchors.map { $0.pinToSuperviewMargin(inset: insets) }
    }

    /// Pins the edges to the safe area of the view controller.
    /// Falls back to layout guides on iOS 10.
    @discardableResult public func pinToSafeArea(of vc: UIViewController, insets: UIEdgeInsets = .zero) -> [NSLayoutConstraint] {
        anchors.map { $0.pinToSafeArea(of: vc, inset: insets.inset(for: $0.attribute)) }
    }

    /// Pins the edges to the safe area of the view controller.
    /// Falls back to layout guides on iOS 10.
    @discardableResult public func pinToSafeArea(of vc: UIViewController, insets: CGFloat) -> [NSLayoutConstraint] {
        anchors.map { $0.pinToSafeArea(of: vc, inset: insets) }
    }
    #endif
}

// MARK: - AnchorCollectionCenter

public struct AnchorCollectionCenter {
    let x: Anchor<AnchorType.Center, AnchorAxis.Horizontal>
    let y: Anchor<AnchorType.Center, AnchorAxis.Vertical>

    /// Centers the view in the superview.
    @discardableResult public func alignWithSuperview() -> [NSLayoutConstraint] {
        [x.alignWithSuperview(), y.alignWithSuperview()]
    }

    /// Makes the axis equal to the other collection of axis.
    @discardableResult public func align(with anchors: AnchorCollectionCenter) -> [NSLayoutConstraint] {
        [x.align(with: anchors.x), y.align(with: anchors.y)]
    }
}

// MARK: - AnchorCollectionSize

public struct AnchorCollectionSize {
    let width: Anchor<AnchorType.Dimension, AnchorAxis.Horizontal>
    let height: Anchor<AnchorType.Dimension, AnchorAxis.Vertical>

    /// Set the size of item.
    @discardableResult public func set(_ size: CGSize, relation: NSLayoutConstraint.Relation = .equal) -> [NSLayoutConstraint] {
        [width.set(size.width, relation: relation), height.set(size.height, relation: relation)]
    }

    /// Makes the size of the item equal to the size of the other item.
    @discardableResult public func match(_ anchors: AnchorCollectionSize, insets: CGSize = .zero, multiplier: CGFloat = 1, relation: NSLayoutConstraint.Relation = .equal) -> [NSLayoutConstraint] {
        [width.match(anchors.width * multiplier - insets.width, relation: relation),
         height.match(anchors.height * multiplier - insets.height, relation: relation)]
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
    static func constrain<T1, A1, T2, A2>(_ lhs: Anchor<T1, A1>, _ rhs: Anchor<T2, A2>, offset: CGFloat = 0, multiplier: CGFloat = 1, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        constrain(item: lhs.item, attribute: lhs.attribute, relatedBy: relation, toItem: rhs.item, attribute: rhs.attribute, multiplier: (multiplier / lhs.multiplier) * rhs.multiplier, constant: offset - lhs.offset + rhs.offset)
    }

    /// Creates and automatically installs a constraint between an anchor and
    /// a given item.
    static func constrain<T1, A1>(_ lhs: Anchor<T1, A1>, toItem item2: Any?, attribute attr2: NSLayoutConstraint.Attribute?, offset: CGFloat = 0, multiplier: CGFloat = 1, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        constrain(item: lhs.item, attribute: lhs.attribute, relatedBy: relation, toItem: item2, attribute: attr2, multiplier: multiplier / lhs.multiplier, constant: offset - lhs.offset)
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

extension EdgeInsets {
    func inset(for attribute: NSLayoutConstraint.Attribute) -> CGFloat {
        switch attribute {
        case .top: return top; case .bottom: return bottom
        case .left, .leading: return left
        case .right, .trailing: return right
        default: return 0
        }
    }
}
