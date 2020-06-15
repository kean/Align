// The MIT License (MIT)
//
// Copyright (c) 2017-2019 Alexander Grebenyuk (github.com/kean).

import UIKit

public protocol LayoutItem { // `UIView`, `UILayoutGuide`
    var superview: UIView? { get }
}

extension UIView: LayoutItem {}
extension UILayoutGuide: LayoutItem {
    public var superview: UIView? { owningView }
}

public extension LayoutItem { // Align methods are available via `LayoutProxy`
    @nonobjc var al: LayoutProxy<Self> { LayoutProxy(base: self) }

    func al(_ closure: (LayoutProxy<Self>) -> Void) {
        closure(LayoutProxy(base: self))
    }
}

// MARK: - LayoutProxy

public struct LayoutProxy<Base> {
    public let base: Base
}

extension LayoutProxy where Base: LayoutItem {

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

extension LayoutProxy where Base: UIView {
    public var margins: LayoutProxy<UILayoutGuide> { base.layoutMarginsGuide.al }
    public var safeArea: LayoutProxy<UILayoutGuide> { base.safeAreaLayoutGuide.al }
}

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
    @discardableResult public func pinToSuperview(inset: CGFloat = 0, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        _pin(to: item.superview!, attribute: attribute, inset: inset, relation: relation)
    }

    /// Pins the edge to the respected margin of the superview.
    @discardableResult public func pinToSuperviewMargin(inset: CGFloat = 0, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        _pin(to: item.superview!, attribute: attribute.toMargin, inset: inset, relation: relation)
    }

    /// Pins the edge to the respected edges of the given container.
    @discardableResult public func pin(to container: LayoutItem, inset: CGFloat = 0, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        _pin(to: container, attribute: attribute, inset: inset, relation: relation)
    }

    /// Pins the edge to the safe area of the view controller.
    @discardableResult public func pinToSafeArea(of vc: UIViewController, inset: CGFloat = 0, relation: NSLayoutConstraint.Relation = .equal) -> NSLayoutConstraint {
        let (item2, attr2) = (vc.view.safeAreaLayoutGuide, self.attribute)
        return _pin(to: item2, attribute: attr2, inset: inset, relation: relation)
    }

    // Pin the anchor to another layout item.
    private func _pin(to item2: Any?, attribute attr2: NSLayoutConstraint.Attribute, inset: CGFloat, relation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        // Invert attribute and relation in certain cases. The `pin` semantics
        // are inspired by https://github.com/PureLayout/PureLayout
        let isInverted = [.trailing, .right, .bottom].contains(attribute)
        return Constraints.constrain(self, toItem: item2, attribute: attr2, offset: (isInverted ? -inset : inset), relation: (isInverted ? relation.inverted : relation))
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
    @discardableResult public func pinToSuperview(insets: UIEdgeInsets = .zero, relation: NSLayoutConstraint.Relation = .equal) -> [NSLayoutConstraint] {
        anchors.map { $0.pinToSuperview(inset: insets.inset(for: $0.attribute), relation: relation) }
    }

    /// Pins the edges of the view to the margins of the superview so the the view
    /// fills the available space in a container.
    @discardableResult public func pinToSuperviewMargins(insets: UIEdgeInsets = .zero, relation: NSLayoutConstraint.Relation = .equal) -> [NSLayoutConstraint] {
        anchors.map { $0.pinToSuperviewMargin(inset: insets.inset(for: $0.attribute), relation: relation) }
    }

    /// Pins the edges of the view to the edges of the given view so the the
    /// view fills the available space in a container.
    @discardableResult public func pin(to item2: LayoutItem, insets: UIEdgeInsets = .zero, relation: NSLayoutConstraint.Relation = .equal) -> [NSLayoutConstraint] {
        anchors.map { $0.pin(to: item2, inset: insets.inset(for: $0.attribute), relation: relation) }
    }

    /// Pins the edges to the safe area of the view controller.
    /// Falls back to layout guides on iOS 10.
    @discardableResult public func pinToSafeArea(of vc: UIViewController, insets: UIEdgeInsets = .zero, relation: NSLayoutConstraint.Relation = .equal) -> [NSLayoutConstraint] {
        anchors.map { $0.pinToSafeArea(of: vc, inset: insets.inset(for: $0.attribute), relation: relation) }
    }
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
    var constraints = [NSLayoutConstraint]()

    /// All of the constraints created in the given closure are automatically
    /// activated at the same time. This is more efficient then installing them
    /// one-be-one. More importantly, it allows to make changes to the constraints
    /// before they are installed (e.g. change `priority`).
    @discardableResult public init(_ closure: () -> Void) {
        Constraints._stack.append(self)
        closure() // create constraints
        Constraints._stack.removeLast()
        NSLayoutConstraint.activate(constraints)
    }

    /// Creates and automatically installs a constraint.
    static func constrain(item item1: Any, attribute attr1: NSLayoutConstraint.Attribute, relatedBy relation: NSLayoutConstraint.Relation = .equal, toItem item2: Any? = nil, attribute attr2: NSLayoutConstraint.Attribute? = nil, multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
        precondition(Thread.isMainThread, "Align APIs can only be used from the main thread")
        (item1 as? UIView)?.translatesAutoresizingMaskIntoConstraints = false
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

// MARK: - Constraints (Arity)

extension Constraints {
    @discardableResult public convenience init<A: LayoutItem>(for a: A, _ closure: (LayoutProxy<A>) -> Void) {
        self.init { closure(a.al) }
    }

    @discardableResult public convenience init<A: LayoutItem, B: LayoutItem>(for a: A, _ b: B, _ closure: (LayoutProxy<A>, LayoutProxy<B>) -> Void) {
        self.init { closure(a.al, b.al) }
    }

    @discardableResult public convenience init<A: LayoutItem, B: LayoutItem, C: LayoutItem>(for a: A, _ b: B, _ c: C, _ closure: (LayoutProxy<A>, LayoutProxy<B>, LayoutProxy<C>) -> Void) {
        self.init { closure(a.al, b.al, c.al) }
    }

    @discardableResult public convenience init<A: LayoutItem, B: LayoutItem, C: LayoutItem, D: LayoutItem>(for a: A, _ b: B, _ c: C, _ d: D, _ closure: (LayoutProxy<A>, LayoutProxy<B>, LayoutProxy<C>, LayoutProxy<D>) -> Void) {
        self.init { closure(a.al, b.al, c.al, d.al) }
    }
}

// MARK: - Misc

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

extension UIEdgeInsets {
    func inset(for attribute: NSLayoutConstraint.Attribute) -> CGFloat {
        switch attribute {
        case .top: return top; case .bottom: return bottom
        case .left, .leading: return left
        case .right, .trailing: return right
        default: return 0
        }
    }
}
