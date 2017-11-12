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

    public var center: CenterAnchors { return CenterAnchors(centerX: centerX, centerY: centerY) }
    public var size: SizeAnchors { return SizeAnchors(width: width, height: height) }
}

extension LayoutProxy where Base: LayoutItem {
    // MARK: Fill

    /// Pins the edges of the view to the same edges of its superview.
    @discardableResult public func fillSuperview(alongAxis axis: UILayoutConstraintAxis? = nil, insets: CGFloat, relation: NSLayoutRelation = .equal) -> [NSLayoutConstraint] {
        let insets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        return fill(base.superview!, alongAxis: axis, insets: insets, relation: relation)
    }

    /// Pins the edges of the view to the same edges of its superview.
    @discardableResult public func fillSuperview(alongAxis axis: UILayoutConstraintAxis? = nil, insets: UIEdgeInsets = .zero, relation: NSLayoutRelation = .equal) -> [NSLayoutConstraint] {
        return fill(base.superview!, alongAxis: axis, insets: insets, relation: relation)
    }

    /// Pins the edges of the view to the corresponding margins of its superview.
    @discardableResult public func fillSuperviewMargins(alongAxis axis: UILayoutConstraintAxis? = nil, insets: UIEdgeInsets = .zero, relation: NSLayoutRelation = .equal) -> [NSLayoutConstraint] {
        return fill(base.superview!.layoutMarginsGuide, alongAxis: axis, insets: insets, relation: relation)
    }

    /// Pins the edges of the view to the same edges of the given item.
    @discardableResult public func fill(_ container: LayoutItem, alongAxis axis: UILayoutConstraintAxis? = nil, insets: UIEdgeInsets = .zero, relation: NSLayoutRelation = .equal) -> [NSLayoutConstraint] {
        return attributes(for: axis).map {
            return _pin(Anchor<Any, Any>(base, $0), to: container, inset: insets.inset(for: $0), relation: relation.inverted) // invert because the meaning or relation is diff
        }
    }

    private func attributes(for axis: UILayoutConstraintAxis?) -> [NSLayoutAttribute] {
        guard let axis = axis else { return [.left, .right, .top, .bottom] } // all
        return (axis == .horizontal) ? [.left, .right] : [.top, .bottom]
    }

    // MARK: Center

    /// Centers in the superview.
    @discardableResult public func centerInSuperview() -> [NSLayoutConstraint] {
        return [centerX.alignWithSuperview(), centerY.alignWithSuperview()]
    }

    @discardableResult public func centerInSuperview(alongAxis axis: UILayoutConstraintAxis) -> NSLayoutConstraint {
        return axis == .horizontal ? centerX.alignWithSuperview() : centerY.alignWithSuperview()
    }
}

extension LayoutProxy where Base: UIView {
    public var margins: LayoutProxy<UILayoutGuide> { return base.layoutMarginsGuide.al }

    @available(iOS 11.0, tvOS 11.0, *)
    public var safeArea: LayoutProxy<UILayoutGuide> { return base.safeAreaLayoutGuide.al }
}


// MARK: Anchors

// phantom types
public class AnchorAxisHorizontal {}
public class AnchorAxisVertical {}

public class AnchorTypeDimension {}
public class AnchorTypeCenter: AnchorTypeAlignment {}
public class AnchorTypeEdge: AnchorTypeAlignment {}
public class AnchorTypeBaseline: AnchorTypeAlignment {}

public protocol AnchorTypeAlignment {} // center or edge

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
    /// Aligns the anchors.
    @discardableResult public func align<Type: AnchorTypeAlignment>(with anchor: Anchor<Type, Axis>, offset: CGFloat = 0, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        return _constrain(self, anchor, offset: offset, multiplier: multiplier, relation: relation)
    }

    /// Returns the anchor for the same axis, but offset by a given amount.
    @discardableResult public func offsetting(by offset: CGFloat) -> Anchor<Type, Axis> {
        return Anchor<Type, Axis>(item, attribute, offset)
    }
}

extension Anchor where Type: AnchorTypeEdge {
    /// Pins the edge to the same edge of the superview.
    @discardableResult public func pinToSuperview(inset: CGFloat = 0, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        return _pin(self, to: item.superview!, inset: inset, relation: relation)
    }

    /// Pins the edge to the respected margin of the superview.
    @discardableResult public func pinToSuperviewMargin(inset: CGFloat = 0, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        return _pin(self, to: item.superview!.layoutMarginsGuide, inset: inset, relation: relation)
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

    @discardableResult public func same<Axis>(as anchor: Anchor<AnchorTypeDimension, Axis>, offset: CGFloat = 0, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        return _constrain(self, anchor, offset: offset, multiplier: multiplier, relation: relation)
    }
}

private func _constrain<T1, A1, T2, A2>(_ lhs: Anchor<T1, A1>, _ rhs: Anchor<T2, A2>, offset: CGFloat = 0, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
    return _constrain(item: lhs.item, attribute: lhs.attribute, toItem: rhs.item, attribute: rhs.attribute, relation: relation, multiplier: multiplier, constant: offset - lhs.offset + rhs.offset)
}

private func _pin<T, A>(_ anchor: Anchor<T, A>, to item2: LayoutItem, inset: CGFloat = 0, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
    let isInverted = inverted.contains(anchor.attribute)
    return _constrain(anchor, Anchor<T, A>(item2, anchor.attribute), offset: (isInverted ? -inset : inset), relation: (isInverted ? relation.inverted : relation))
}

private let inverted: Set<NSLayoutAttribute> = [.trailing, .right, .bottom, .trailingMargin, .rightMargin, .bottomMargin]

public struct CenterAnchors {
    internal var centerX: Anchor<AnchorTypeCenter, AnchorAxisHorizontal>
    internal var centerY: Anchor<AnchorTypeCenter, AnchorAxisVertical>

    /// Makes the axis equal to the other collection of axis.
    @discardableResult public func align(with anchors: CenterAnchors) -> [NSLayoutConstraint] {
        return [centerX.align(with: anchors.centerX), centerY.align(with: anchors.centerY)]
    }
}

public struct SizeAnchors {
    internal var width: Anchor<AnchorTypeDimension, AnchorAxisHorizontal>
    internal var height: Anchor<AnchorTypeDimension, AnchorAxisVertical>

    /// Set the size of item.
    @discardableResult public func set(_ size: CGSize, relation: NSLayoutRelation = .equal) -> [NSLayoutConstraint] {
        return [width.set(size.width, relation: relation), height.set(size.height, relation: relation)]
    }

    /// Makes the size of the item equal to the size of the other item.
    @discardableResult public func same(as anchors: SizeAnchors, insets: CGSize = .zero, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal) -> [NSLayoutConstraint] {
        return [width.same(as: anchors.width, offset: -insets.width, multiplier: multiplier, relation: relation),
                height.same(as: anchors.height, offset: -insets.height, multiplier: multiplier, relation: relation)]
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
    @nonobjc public convenience init(width: CGFloat) {
        self.init(dimension: .width(width))
    }

    @nonobjc public convenience init(minWidth: CGFloat) {
        self.init(dimension: .width(minWidth), isFlexible: true)
    }

    @nonobjc public convenience init(height: CGFloat) {
        self.init(dimension: .height(height))
    }

    @nonobjc public convenience init(minHeight: CGFloat) {
        self.init(dimension: .height(minHeight), isFlexible: true)
    }

    private enum Dimension {
        case width(CGFloat), height(CGFloat)
    }

    private init(dimension: Dimension, isFlexible: Bool = false) {
        super.init(frame: .zero)
        Constraints(id: "Yalta.Spacer", with: self) {
            switch dimension {
            case let .width(constant):
                $0.width.set(constant, relation: isFlexible ? .greaterThanOrEqual : .equal)
                if isFlexible { $0.width.set(constant).priority = UILayoutPriority(42) } // disambiguate
                $0.height.set(0).priority = UILayoutPriority(42)  // disambiguate
            case let .height(constant):
                $0.height.set(constant, relation: isFlexible ? .greaterThanOrEqual : .equal)
                if isFlexible { $0.height.set(constant).priority = UILayoutPriority(42) } // disambiguate
                $0.width.set(0).priority = UILayoutPriority(42) // disambiguate
            }
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public class var layerClass: Swift.AnyClass {
        return CATransformLayer.self
    }

    override public var backgroundColor: UIColor? {
        get { return nil }
        set { return }
    }
}


// MARK: Constraints

public final class Constraints {
    let id: String?
    internal(set) var constraints = [NSLayoutConstraint]()

    /// All of the constraints created in the given closure are automatically
    /// activated. This is more efficient then installing them
    /// one-be-one. More importantly, it allows to make changes to the constraints
    /// before they are installed (e.g. change `priority`).
    @discardableResult public init(id: String? = nil, closure: () -> Void) {
        self.id = id

        _stack.append(self)
        closure() // create constraints
        _stack.removeLast()
        NSLayoutConstraint.activate(constraints)
    }

    @discardableResult public convenience init<A: LayoutItem>(id: String? = nil, with a: A, closure: (LayoutProxy<A>) -> Void) {
        self.init(id: id) { closure(a.al) }
    }

    @discardableResult public convenience init<A: LayoutItem, B: LayoutItem>(id: String? = nil, with a: A, _ b: B, closure: (LayoutProxy<A>, LayoutProxy<B>) -> Void) {
        self.init(id: id) { closure(a.al, b.al) }
    }

    @discardableResult public convenience init<A: LayoutItem, B: LayoutItem, C: LayoutItem>(id: String? = nil, with a: A, _ b: B, _ c: C, closure: (LayoutProxy<A>, LayoutProxy<B>, LayoutProxy<C>) -> Void) {
        self.init(id: id) { closure(a.al, b.al, c.al) }
    }

    @discardableResult public convenience init<A: LayoutItem, B: LayoutItem, C: LayoutItem, D: LayoutItem>(id: String? = nil, with a: A, _ b: B, _ c: C, _ d: D, closure: (LayoutProxy<A>, LayoutProxy<B>, LayoutProxy<C>, LayoutProxy<D>) -> Void) {
        self.init(id: id) { closure(a.al, b.al, c.al, d.al) }
    }

    @discardableResult public convenience init<A: LayoutItem, B: LayoutItem, C: LayoutItem, D: LayoutItem, E: LayoutItem>(id: String? = nil, with a: A, _ b: B, _ c: C, _ d: D, _ e: E, closure: (LayoutProxy<A>, LayoutProxy<B>, LayoutProxy<C>, LayoutProxy<D>, LayoutProxy<E>) -> Void) {
        self.init(id: id) { closure(a.al, b.al, c.al, d.al, e.al) }
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
        constraint.identifier = group.id
        group.constraints.append(constraint)
    }
}


// MARK: Helpers

public struct LayoutProxy<Base> {
    internal let base: Base
}

internal extension NSLayoutRelation {
    var inverted: NSLayoutRelation {
        switch self {
        case .greaterThanOrEqual: return .lessThanOrEqual
        case .lessThanOrEqual: return .greaterThanOrEqual
        case .equal: return .equal
        }
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
