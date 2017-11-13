// The MIT License (MIT)
//
// Copyright (c) 2017 Alexander Grebenyuk (github.com/kean).

import UIKit


public protocol LayoutItem { // `UIView`, `UILayoutGuide`
    var superview: UIView? { get }
}

extension UIView: LayoutItem {}
extension UILayoutGuide: LayoutItem {
    public var superview: UIView? { return self.owningView }
}

public extension LayoutItem { // Yalta methods available via `LayoutProxy`
    @nonobjc public var al: LayoutProxy<Self> { return LayoutProxy(base: self) }
}

extension LayoutProxy where Base: LayoutItem {
    // MARK: Anchors

    public var top: Anchor<AnchorTypeEdge, AnchorAxisVertical> { return Anchor(base, .top) }
    public var bottom: Anchor<AnchorTypeEdge, AnchorAxisVertical> { return Anchor(base, .bottom) }
    public var left: Anchor<AnchorTypeEdge, AnchorAxisHorizontal> { return Anchor(base, .left) }
    public var right: Anchor<AnchorTypeEdge, AnchorAxisHorizontal> { return Anchor(base, .right) }
    public var leading: Anchor<AnchorTypeEdge, AnchorAxisHorizontal> { return Anchor(base, .leading) }
    public var trailing: Anchor<AnchorTypeEdge, AnchorAxisHorizontal> { return Anchor(base, .trailing) }

    public var centerX: Anchor<AnchorTypeCenter, AnchorAxisHorizontal> { return Anchor(base, .centerX) }
    public var centerY: Anchor<AnchorTypeCenter, AnchorAxisVertical> { return Anchor(base, .centerY) }

    public var firstBaseline: Anchor<AnchorTypeBaseline, AnchorAxisVertical> { return Anchor(base, .firstBaseline) }
    public var lastBaseline: Anchor<AnchorTypeBaseline, AnchorAxisVertical> { return Anchor(base, .lastBaseline) }

    public var width: Anchor<AnchorTypeDimension, AnchorAxisHorizontal> { return Anchor(base, .width) }
    public var height: Anchor<AnchorTypeDimension, AnchorAxisVertical> { return Anchor(base, .height) }

    public var center: AnchorCollectionCenter { return AnchorCollectionCenter(centerX: centerX, centerY: centerY) }
    public var size: AnchorCollectionSize { return AnchorCollectionSize(width: width, height: height) }
}

extension LayoutProxy where Base: UIView {
    public var margins: LayoutProxy<UILayoutGuide> { return base.layoutMarginsGuide.al }

    @available(iOS 11.0, tvOS 11.0, *)
    public var safeArea: LayoutProxy<UILayoutGuide> { return base.safeAreaLayoutGuide.al }
}

extension LayoutProxy where Base: LayoutItem {
    // MARK: Fill

    /// Aligns the edges of the view to the edges of the superview so the the view
    /// fills the available space in a container.
    @discardableResult public func fillSuperview(alongAxis axis: UILayoutConstraintAxis? = nil, insets: UIEdgeInsets = .zero, relation: NSLayoutRelation = .equal) -> [NSLayoutConstraint] {
        return fill(base.superview!, alongAxis: axis, insets: insets, relation: relation)
    }

    /// Aligns the edges of the view to the margins of the superview so the the view
    /// fills the available space in a container.
    @discardableResult public func fillSuperviewMargins(alongAxis axis: UILayoutConstraintAxis? = nil, insets: UIEdgeInsets = .zero, relation: NSLayoutRelation = .equal) -> [NSLayoutConstraint] {
        return fill(base.superview!.layoutMarginsGuide, alongAxis: axis, insets: insets, relation: relation)
    }

    /// Aligns the edges of the view to the edges of the given view so the the
    /// view fills the available space in a container.
    @discardableResult public func fill(_ container: LayoutItem, alongAxis axis: UILayoutConstraintAxis? = nil, insets: UIEdgeInsets = .zero, relation: NSLayoutRelation = .equal) -> [NSLayoutConstraint] {
        let anchors = _attributes(for: axis).map { Anchor<AnchorTypeEdge, Any>(base, $0) }
        return anchors.map { $0.pin(to: container, inset: insets.inset(for: $0.attribute), relation: relation.inverted) }
    }

    private func _attributes(for axis: UILayoutConstraintAxis?) -> [NSLayoutAttribute] {
        guard let axis = axis else { return [.left, .right, .top, .bottom] } // all
        return (axis == .horizontal) ? [.left, .right] : [.top, .bottom]
    }

    // MARK: Center

    /// Centers the view in the superview.
    @discardableResult public func centerInSuperview() -> [NSLayoutConstraint] {
        return [centerX.alignWithSuperview(), centerY.alignWithSuperview()]
    }

    /// Centers the view in the superview along the given axis.
    @discardableResult public func centerInSuperview(alongAxis axis: UILayoutConstraintAxis) -> NSLayoutConstraint {
        return axis == .horizontal ? centerX.alignWithSuperview() : centerY.alignWithSuperview()
    }
}


// MARK: Anchors

public class AnchorAxisHorizontal {} // phantom types
public class AnchorAxisVertical {}

public class AnchorTypeDimension {}
public class AnchorTypeCenter: AnchorTypeAlignment {}
public class AnchorTypeEdge: AnchorTypeAlignment {}
public class AnchorTypeBaseline: AnchorTypeAlignment {}

/// Includes `center`, `edge` and `baselines` anchors.
public protocol AnchorTypeAlignment {}

/// A type that represents one of the view's layout attributes (e.g. `left`,
/// `centerX`, `width`, etc). Use the anchor’s methods to construct constraints.
public struct Anchor<Type, Axis> { // type and axis are phantom types
    internal let item: LayoutItem
    internal let attribute: NSLayoutAttribute
    internal let offset: CGFloat

    init(_ item: LayoutItem, _ attribute: NSLayoutAttribute, _ offset: CGFloat = 0) {
        self.item = item
        self.attribute = attribute
        self.offset = offset
    }
}

extension Anchor where Type: AnchorTypeAlignment {
    /// Aligns two anchors.
    @discardableResult public func align<Type: AnchorTypeAlignment>(with anchor: Anchor<Type, Axis>, offset: CGFloat = 0, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        return _constrain(self, anchor, offset: offset, multiplier: multiplier, relation: relation)
    }

    /// Returns a new anchor offset by a given amount.
    @discardableResult public func offsetting(by offset: CGFloat) -> Anchor<Type, Axis> {
        return Anchor<Type, Axis>(item, attribute, offset)
    }
}

extension Anchor where Type: AnchorTypeEdge {
    /// Pins the edge to the same edge of the superview.
    @discardableResult public func pinToSuperview(inset: CGFloat = 0, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        return pin(to: item.superview!, inset: inset, relation: relation)
    }

    /// Pins the edge to the respected margin of the superview.
    @discardableResult public func pinToSuperviewMargin(inset: CGFloat = 0, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        return pin(to: item.superview!.layoutMarginsGuide, inset: inset, relation: relation)
    }

    internal func pin(to container: LayoutItem, inset: CGFloat = 0, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        let inverted: Set<NSLayoutAttribute> = [.trailing, .right, .bottom, .trailingMargin, .rightMargin, .bottomMargin]
        let isInverted = inverted.contains(attribute)
        return _constrain(self, Anchor<Type, Any>(container, attribute), offset: (isInverted ? -inset : inset), relation: (isInverted ? relation.inverted : relation))
    }
}

extension Anchor where Type: AnchorTypeCenter {
    /// Aligns the axis with a superview axis.
    @discardableResult public func alignWithSuperview(offset: CGFloat = 0, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        return align(with: Anchor<Type, Axis>(self.item.superview!, self.attribute), offset: offset, relation: relation)
    }
}

extension Anchor where Type: AnchorTypeDimension {
    /// Sets the dimension to a specific size.
    @discardableResult public func set(_ constant: CGFloat, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        return _constrain(item: item, attribute: attribute, relation: relation, constant: constant)
    }

    @discardableResult public func match<Axis>(_ anchor: Anchor<AnchorTypeDimension, Axis>, offset: CGFloat = 0, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        return _constrain(self, anchor, offset: offset, multiplier: multiplier, relation: relation)
    }
}

private func _constrain<T1, A1, T2, A2>(_ lhs: Anchor<T1, A1>, _ rhs: Anchor<T2, A2>, offset: CGFloat = 0, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
    return _constrain(item: lhs.item, attribute: lhs.attribute, toItem: rhs.item, attribute: rhs.attribute, relation: relation, multiplier: multiplier, constant: offset - lhs.offset + rhs.offset)
}


// MARK: Anchor Collections

public struct AnchorCollectionCenter {
    internal var centerX: Anchor<AnchorTypeCenter, AnchorAxisHorizontal>
    internal var centerY: Anchor<AnchorTypeCenter, AnchorAxisVertical>

    /// Makes the axis equal to the other collection of axis.
    @discardableResult public func align(with anchors: AnchorCollectionCenter) -> [NSLayoutConstraint] {
        return [centerX.align(with: anchors.centerX), centerY.align(with: anchors.centerY)]
    }
}

public struct AnchorCollectionSize {
    internal var width: Anchor<AnchorTypeDimension, AnchorAxisHorizontal>
    internal var height: Anchor<AnchorTypeDimension, AnchorAxisVertical>

    /// Set the size of item.
    @discardableResult public func set(_ size: CGSize, relation: NSLayoutRelation = .equal) -> [NSLayoutConstraint] {
        return [width.set(size.width, relation: relation), height.set(size.height, relation: relation)]
    }

    /// Makes the size of the item equal to the size of the other item.
    @discardableResult public func match(_ anchors: AnchorCollectionSize, insets: CGSize = .zero, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal) -> [NSLayoutConstraint] {
        return [width.match(anchors.width, offset: -insets.width, multiplier: multiplier, relation: relation),
                height.match(anchors.height, offset: -insets.height, multiplier: multiplier, relation: relation)]
    }
}


// MARK: Stack and Spacer

public typealias Stack = UIStackView

public extension Stack {
    @nonobjc public convenience init(_ views: UIView..., with: (UIStackView) -> Void = { _ in }) {
        self.init(arrangedSubviews: views)
        with(self)
    }

    @nonobjc public convenience init(_ views: [UIView], axis: UILayoutConstraintAxis = .horizontal, spacing: CGFloat = 0, alignment: UIStackViewAlignment = .fill, distribution: UIStackViewDistribution = .fill) {
        self.init(arrangedSubviews: views)
        self.axis = axis
        self.spacing = spacing
        self.alignment = alignment
        self.distribution = distribution
    }
}

public final class Spacer: UIView { // using `UIView` and not `UILayoutGuide` to support stack views
    @nonobjc public convenience init(width: CGFloat) { self.init(.width(width)) }
    @nonobjc public convenience init(minWidth: CGFloat) { self.init(.width(minWidth), isFlexible: true) }
    @nonobjc public convenience init(height: CGFloat) { self.init(.height(height)) }
    @nonobjc public convenience init(minHeight: CGFloat) { self.init(.height(minHeight), isFlexible: true) }

    private enum Dimension {
        case width(CGFloat), height(CGFloat)
    }

    private init(_ dimension: Dimension, isFlexible: Bool = false) {
        super.init(frame: .zero)
        Constraints(for: self) {
            switch dimension {
            case let .width(width):
                $0.width.set(width, relation: isFlexible ? .greaterThanOrEqual : .equal)
                if isFlexible { $0.width.set(width).priority = UILayoutPriority(42) } // disambiguate
                $0.height.set(0).priority = UILayoutPriority(42)  // disambiguate
            case let .height(height):
                $0.height.set(height, relation: isFlexible ? .greaterThanOrEqual : .equal)
                if isFlexible { $0.height.set(height).priority = UILayoutPriority(42) } // disambiguate
                $0.width.set(0).priority = UILayoutPriority(42) // disambiguate
            }
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // don't draw anything
    override public class var layerClass: AnyClass { return CATransformLayer.self }
    override public var backgroundColor: UIColor? { get { return nil } set { return } }
}


// MARK: Constraints

public final class Constraints {
    internal(set) var constraints = [NSLayoutConstraint]()

    /// All of the constraints created in the given closure are automatically
    /// activated. This is more efficient then installing them
    /// one-be-one. More importantly, it allows to make changes to the constraints
    /// before they are installed (e.g. change `priority`).
    @discardableResult public init(_ closure: () -> Void) {
        _stack.append(self)
        closure() // create constraints
        _stack.removeLast()
        NSLayoutConstraint.activate(constraints)
    }

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

    @discardableResult public convenience init<A: LayoutItem, B: LayoutItem, C: LayoutItem, D: LayoutItem, E: LayoutItem>(for a: A, _ b: B, _ c: C, _ d: D, _ e: E, _ closure: (LayoutProxy<A>, LayoutProxy<B>, LayoutProxy<C>, LayoutProxy<D>, LayoutProxy<E>) -> Void) {
        self.init { closure(a.al, b.al, c.al, d.al, e.al) }
    }
}

private func _constrain(item item1: Any, attribute attr1: NSLayoutAttribute, toItem item2: Any? = nil, attribute attr2: NSLayoutAttribute? = nil, relation: NSLayoutRelation = .equal, multiplier: CGFloat = 1, constant: CGFloat = 0) -> NSLayoutConstraint {
    precondition(Thread.isMainThread, "Yalta APIs can only be used from the main thread")
    (item1 as? UIView)?.translatesAutoresizingMaskIntoConstraints = false
    let constraint = NSLayoutConstraint(item: item1, attribute: attr1, relatedBy: relation, toItem: item2, attribute: attr2 ?? .notAnAttribute, multiplier: multiplier, constant: constant)
    _install(constraint)
    return constraint
}

private var _stack = [Constraints]() // this is what enabled constraint auto-installing

private func _install(_ constraint: NSLayoutConstraint) {
    if _stack.isEmpty { // not creating a group of constraints
        constraint.isActive = true
    } else { // remember which constaints to install when group is completed
        let group = _stack.last!
        group.constraints.append(constraint)
    }
}

public typealias Insets = UIEdgeInsets
public extension UIEdgeInsets {
    public init(_ all: CGFloat) { self = UIEdgeInsetsMake(all, all, all, all) }
}

public struct LayoutProxy<Base> {
    internal let base: Base
}

internal extension NSLayoutRelation {
    var inverted: NSLayoutRelation {
        if self == .greaterThanOrEqual { return .lessThanOrEqual }
        if self == .lessThanOrEqual { return .greaterThanOrEqual }
        return self
    }
}

internal extension UIEdgeInsets {
    func inset(for attribute: NSLayoutAttribute) -> CGFloat {
        switch attribute {
        case .top: return top; case .bottom: return bottom
        case .left, .leading: return left
        case .right, .trailing: return right
        default: return 0
        }
    }
}
