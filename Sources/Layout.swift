// The MIT License (MIT)
//
// Copyright (c) 2017 Alexander Grebenyuk (github.com/kean).

import UIKit


// MARK: Compatible Types

public struct LayoutCompatible<Base> {
    internal let base: Base
}

extension UIView {
    @nonobjc public var al: LayoutCompatible<UIView> { return LayoutCompatible(base: self) }
}

extension UILayoutGuide {
    @nonobjc public var al: LayoutCompatible<UILayoutGuide> { return LayoutCompatible(base: self) }
}

extension LayoutCompatible where Base: AnchorCompatible {
    // MARK: Anchors

    public var top: Anchor<AnchorTypeEdge, AnchorAxisY> { return Anchor(item: base, attribute: .top) }
    public var bottom: Anchor<AnchorTypeEdge, AnchorAxisY> { return Anchor(item: base, attribute: .bottom) }
    public var left: Anchor<AnchorTypeEdge, AnchorAxisX> { return Anchor(item: base, attribute: .left) }
    public var right: Anchor<AnchorTypeEdge, AnchorAxisX> { return Anchor(item: base, attribute: .right) }
    public var leading: Anchor<AnchorTypeEdge, AnchorAxisX> { return Anchor(item: base, attribute: .leading) }
    public var trailing: Anchor<AnchorTypeEdge, AnchorAxisX> { return Anchor(item: base, attribute: .trailing) }

    public var centerX: Anchor<AnchorTypeCenter, AnchorAxisX> { return Anchor(item: base, attribute: .centerX) }
    public var centerY: Anchor<AnchorTypeCenter, AnchorAxisY> { return Anchor(item: base, attribute: .centerY) }

    public var width: Anchor<AnchorTypeDimension, AnchorAxisX> { return Anchor(item: base, attribute: .width) }
    public var height: Anchor<AnchorTypeDimension, AnchorAxisY> { return Anchor(item: base, attribute: .height) }

    // MARK: Collections

    public func edges(_ edges: Layout.Edge...) -> EdgesCollection { return EdgesCollection(item: base, edges: edges) }
    public var edges: EdgesCollection { return EdgesCollection(item: base, edges: [.leading, .trailing, .bottom, .top]) }
    public var axis: AxisCollection { return AxisCollection(centerX: centerX, centerY: centerY) }
    public var size: DimensionsCollection { return DimensionsCollection(width: width, height: height) }
}

extension LayoutCompatible where Base: UIView {
    public var margins: LayoutCompatible<UILayoutGuide> { return base.layoutMarginsGuide.al }

    @available(iOS 11.0, tvOS 11.0, *)
    public var safeArea: LayoutCompatible<UILayoutGuide> { return base.safeAreaLayoutGuide.al }
}

public protocol AnchorCompatible {
    var superview: UIView? { get }
}

extension UIView: AnchorCompatible {}
extension UILayoutGuide: AnchorCompatible {
    public var superview: UIView? { return self.owningView }
}


// MARK: Anchors

// phantom types
public class AnchorAxisX {}
public class AnchorAxisY {}

public class AnchorTypeDimension {}
public class AnchorTypeCenter: AnchorTypeAlignment {}
public class AnchorTypeEdge: AnchorTypeAlignment {}

public protocol AnchorTypeAlignment {} // center or edge

public struct Anchor<Type, Axis> { // type and axis are phantom types
    internal let item: AnchorCompatible
    internal let attribute: NSLayoutAttribute
    internal let offset: CGFloat

    init(item: AnchorCompatible, attribute: NSLayoutAttribute, offset: CGFloat = 0) {
        self.item = item
        self.attribute = attribute
        self.offset = offset
    }
}

extension Anchor where Type: AnchorTypeAlignment {
    @discardableResult
    public func equal<Type: AnchorTypeAlignment>(_ anchor: Anchor<Type, Axis>, offset: CGFloat = 0, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        return _equal(self, anchor, offset: offset, relation: relation)
    }

    /// Returns the anchor for the same axis, but offset by a given amount.
    @discardableResult
    public func offset(by offset: CGFloat) -> Anchor<Type, Axis> {
        return Anchor<Type, Axis>(item: item, attribute: attribute, offset: offset)
    }

    /// Pins the anchor to the same anchor of the superview.
    @discardableResult
    public func pinToSuperview(inset: CGFloat = 0, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        return pin(to: item.superview!, margin: false, inset: inset, relation: relation)
    }

    /// Pins the anchor to the same margin anchor of the superview.
    @discardableResult
    public func pinToSuperviewMargin(inset: CGFloat = 0, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        return pin(to: item.superview!, margin: true, inset: inset, relation: relation)
    }

    /// Pins the anchor to the same anchor (or margin anchor) of the given view.
    /// Kept `internal` for now, I'm not sure how useful it is yet apart from
    /// `EdgesCollection` so I decided to reduce the API surface instead.
    @discardableResult
    internal func pin(to item2: AnchorCompatible, margin: Bool = false, inset: CGFloat = 0, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        return _pin(self, to: item2, margin: margin, inset: inset, relation: relation)
    }
}

extension Anchor where Type: AnchorTypeDimension {
    @discardableResult
    public func equal<Axis>(_ anchor: Anchor<AnchorTypeDimension, Axis>, offset: CGFloat = 0, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        return _equal(self, anchor, offset: offset, multiplier: multiplier, relation: relation)
    }

    /// Sets the dimension to a specific size.
    @discardableResult
    public func equal(_ constant: CGFloat, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        return Layout.constraint(item: item, attribute: attribute, relation: relation, constant: constant)
    }
}

// Internally we can combine any anchors, but publicly it's controlled by anchor types.
private func _equal<T1, A1, T2, A2>(_ lhs: Anchor<T1, A1>, _ rhs: Anchor<T2, A2>, offset: CGFloat = 0, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
    return Layout.constraint(item: lhs.item, attribute: lhs.attribute, toItem: rhs.item, attribute: rhs.attribute, relation: relation, multiplier: multiplier, constant: offset - lhs.offset + rhs.offset)
}

/// Pins the anchor to the same anchor (or margin anchor) of the given view.
/// Kept `internal` for now, I'm not sure how useful it is yet apart from
/// `EdgesCollection` so I decided to reduce the API surface instead.
@discardableResult
private func _pin<T, A>(_ anchor: Anchor<T, A>, to item2: AnchorCompatible, margin: Bool = false, inset: CGFloat = 0, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
    let isInverted = inverted.contains(anchor.attribute)
    let other = Anchor<T, A>(item: item2, attribute: (margin ? anchor.attribute.toMargin : anchor.attribute)) // other anchor
    return _equal(anchor, other, offset: (isInverted ? -inset : inset), relation: (isInverted ? relation.inverted : relation))
}

private let inverted: Set<NSLayoutAttribute> = [.trailing, .right, .bottom, .trailingMargin, .rightMargin, .bottomMargin]


// MARK: Collections

public struct EdgesCollection {
    internal let item: AnchorCompatible
    internal let edges: [Layout.Edge]

    /// Pins the edges of the view to the same edges of its superview.
    @discardableResult
    public func pinToSuperview(insets: UIEdgeInsets = .zero, relation: NSLayoutRelation = .equal) -> [NSLayoutConstraint] {
        return pin(to: item.superview!.al, margin: false, insets: insets, relation: relation)
    }

    /// Pins the edges of the view to the corresponding margins of its superview.
    @discardableResult
    public func pinToSuperviewMargins(insets: UIEdgeInsets = .zero, relation: NSLayoutRelation = .equal) -> [NSLayoutConstraint] {
        return pin(to: item.superview!.al, margin: true, insets: insets, relation: relation)
    }

    /// Pins the edges of the view to the same edges of the given view.
    @discardableResult
    public func pin<Item>(to item2: LayoutCompatible<Item>, insets: UIEdgeInsets = .zero, relation: NSLayoutRelation = .equal) -> [NSLayoutConstraint] where Item: AnchorCompatible {
        return pin(to: item2, margin: false, insets: insets, relation: relation)
    }

    /// Pins the edges of the view to the same edges (or margins) of the given view.
    @discardableResult
    private func pin<Item>(to item2: LayoutCompatible<Item>, margin: Bool = false, insets: UIEdgeInsets = .zero, relation: NSLayoutRelation = .equal) -> [NSLayoutConstraint] where Item: AnchorCompatible {
        return edges.map {
            let anchor = Anchor<Any, Any>(item: item, attribute: $0.toAttribute) // anchor for edge
            return _pin(anchor, to: item2.base, margin: margin, inset: insets.insetForEdge($0), relation: relation)
        }
    }
}

public struct AxisCollection {
    internal var centerX: Anchor<AnchorTypeCenter, AnchorAxisX>
    internal var centerY: Anchor<AnchorTypeCenter, AnchorAxisY>

    /// Centers the axis in the superview.
    @discardableResult
    public func centerInSuperview() -> [NSLayoutConstraint] {
        return [centerX.pinToSuperview(), centerY.pinToSuperview()]
    }

    /// Centers the axis in the superview margins.
    @discardableResult
    public func centerInSuperviewMargins() -> [NSLayoutConstraint] {
        return [centerX.pinToSuperviewMargin(), centerY.pinToSuperviewMargin()]
    }

    /// Makes the axis equal to the other collection of axis.
    @discardableResult
    public func equal(to collection: AxisCollection) -> [NSLayoutConstraint] {
        return [centerX.equal(collection.centerX), centerY.equal(collection.centerY)]
    }
}

public struct DimensionsCollection {
    internal var width: Anchor<AnchorTypeDimension, AnchorAxisX>
    internal var height: Anchor<AnchorTypeDimension, AnchorAxisY>

    /// Set the size of item.
    @discardableResult
    public func equal(_ size: CGSize, relation: NSLayoutRelation = .equal) -> [NSLayoutConstraint] {
        return [width.equal(size.width, relation: relation),
                height.equal(size.height, relation: relation)]
    }

    /// Makes the size of the item equal to the size of the other item.
    @discardableResult
    public func equal(_ collection: DimensionsCollection, insets: CGSize = .zero, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal) -> [NSLayoutConstraint] {
        return [width.equal(collection.width, offset: -insets.width, multiplier: multiplier, relation: relation),
                height.equal(collection.height, offset: -insets.height, multiplier: multiplier, relation: relation)]
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
        Layout.make(id: "Yalta.Spacer") {
            switch dimension {
            case let .width(constant):
                al.width.equal(constant, relation: isFlexible ? .greaterThanOrEqual : .equal)
                if isFlexible { al.width.equal(0).priority = UILayoutPriority(42) } // disambiguate
                al.height.equal(0).priority = UILayoutPriority(42)  // disambiguate
            case let .height(constant):
                al.height.equal(constant, relation: isFlexible ? .greaterThanOrEqual : .equal)
                if isFlexible { al.height.equal(0).priority = UILayoutPriority(42) } // disambiguate
                al.width.equal(0).priority = UILayoutPriority(42) // disambiguate
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


// MARK: Layout

public final class Layout { // this is what enabled autoinstalling
    private static let shared = Layout()
    private init() {}

    private final class Context { // context in which constraits get created.
        let priority: UILayoutPriority?
        let id: String?
        var constraints = [NSLayoutConstraint]()

        init(priority: UILayoutPriority?, id: String?) {
            self.priority = priority
            self.id = id
        }
    }

    private var stack = [Context]()

    /// All of the constraints created in the given closure are automatically
    /// activated. This is more efficient then installing them
    /// one-be-one. More importantly, it allows to make changes to the constraints
    /// before they are installed (e.g. change `priority`).
    @discardableResult
    public static func make(priority: UILayoutPriority? = nil, id: String? = nil, _ closure: () -> Void) -> [NSLayoutConstraint] {
        let context = Context(priority: priority, id: id)
        Layout.shared.stack.append(context)
        closure()
        let constraints = Layout.shared.stack.removeLast().constraints

        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    private func install(_ constraint: NSLayoutConstraint) {
        if stack.isEmpty { // no longer batching updates
            NSLayoutConstraint.activate([constraint])
        } else { // remember which constaints to install when batch is completed
            let context = stack.last!
            if let priority = context.priority { constraint.priority = priority }
            constraint.identifier = context.id
            context.constraints.append(constraint)
        }
    }

    /// A convenient way to add custom constraints.
    @discardableResult
    internal static func constraint(item item1: Any, attribute attr1: NSLayoutAttribute, toItem item2: Any? = nil, attribute attr2: NSLayoutAttribute? = nil, relation: NSLayoutRelation = .equal, multiplier: CGFloat = 1, constant: CGFloat = 0, priority: UILayoutPriority? = nil, identifier: String? = nil) -> NSLayoutConstraint {
        assert(Thread.isMainThread, "Yalta APIs can only be used from the main thread")
        (item1 as? UIView)?.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint( item: item1, attribute: attr1, relatedBy: relation, toItem: item2, attribute: attr2 ?? .notAnAttribute, multiplier: multiplier, constant: constant)
        if let priority = priority { constraint.priority = priority }
        constraint.identifier = identifier
        Layout.shared.install(constraint)
        return constraint
    }
}


// MARK: Attributes

extension Layout {
    public enum Edge {
        case top, bottom, leading, trailing, left, right

        public var toAttribute: NSLayoutAttribute {
            switch self {
            case .top: return .top;          case .bottom: return .bottom
            case .leading: return .leading;  case .trailing: return .trailing
            case .left: return .left;        case .right: return .right
            }
        }
    }
}

internal extension NSLayoutAttribute {
    var toMargin: NSLayoutAttribute {
        switch self {
        case .top: return .topMargin;          case .bottom: return .bottomMargin
        case .leading: return .leadingMargin;  case .trailing: return .trailingMargin
        case .left: return .leftMargin;        case .right: return .rightMargin
        case .centerX: return .centerXWithinMargins; case .centerY: return .centerYWithinMargins
        default: return self
        }
    }
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
    func insetForEdge(_ edge: Layout.Edge) -> CGFloat {
        switch edge {
        case .top: return top; case .bottom: return bottom
        case .left, .leading: return left
        case .right, .trailing: return right
        }
    }
}
