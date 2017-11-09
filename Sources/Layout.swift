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

    public var top: Anchor<AxisY> { return Anchor(item: base, attribute: .top) }
    public var bottom: Anchor<AxisY> { return Anchor(item: base, attribute: .bottom) }
    public var centerY: Anchor<AxisY> { return Anchor(item: base, attribute: .centerY) }

    public var left: Anchor<AxisX> { return Anchor(item: base, attribute: .left) }
    public var right: Anchor<AxisX> { return Anchor(item: base, attribute: .right) }
    public var leading: Anchor<AxisX> { return Anchor(item: base, attribute: .leading) }
    public var trailing: Anchor<AxisX> { return Anchor(item: base, attribute: .trailing) }
    public var centerX: Anchor<AxisX> { return Anchor(item: base, attribute: .centerX) }

    public var width: DimensionAnchor { return DimensionAnchor(item: base, attribute: .width) }
    public var height: DimensionAnchor { return DimensionAnchor(item: base, attribute: .height) }

    // MARK: Collections

    public func edges(_ edges: Layout.Edge...) -> EdgesCollection { return EdgesCollection(item: base, edges: edges) }
    public var edges: EdgesCollection { return EdgesCollection(item: base, edges: [.leading, .trailing, .bottom, .top]) }
    public var axis: AxisCollection { return AxisCollection(item: base) }
    public var size: DimensionsCollection { return DimensionsCollection(item: base) }
}

extension LayoutCompatible where Base: UIView {
    public var margins: LayoutCompatible<UILayoutGuide> { return base.layoutMarginsGuide.al }

    @available(iOSApplicationExtension 11.0, *)
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

public struct AxisX {} // phantom type
public struct AxisY {} // phantom type

public struct Anchor<Axis> { // axis is a phantom type
    internal let item: AnchorCompatible
    internal let attribute: NSLayoutAttribute
    internal let offset: CGFloat

    init(item: AnchorCompatible, attribute: NSLayoutAttribute, offset: CGFloat = 0) {
        self.item = item
        self.attribute = attribute
        self.offset = offset
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
        let isInverted = inverted.contains(attribute)
        return equal(Anchor<Axis>(item: item2, attribute: margin ? attribute.toMargin : attribute), offset: (isInverted ? -inset : inset), relation: (isInverted ? relation.inverted : relation))
    }

    /// Pins the anchor to the other anchor.
    @discardableResult
    public func equal(_ anchor: Anchor<Axis>, offset: CGFloat = 0, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        return Layout.constraint(item: item, attribute: attribute, toItem: anchor.item, attribute: anchor.attribute, relation: relation, multiplier: 1, constant: offset - self.offset + anchor.offset)
    }

    /// Returns the anchor for the same axis, but offset by a given ammount.
    @discardableResult
    public func offset(by offset: CGFloat) -> Anchor<Axis> {
        return Anchor<Axis>(item: item, attribute: attribute, offset: offset)
    }
}

internal let inverted: Set<NSLayoutAttribute> = [.trailing, .right, .bottom, .trailingMargin, .rightMargin, .bottomMargin]


// MARK: DimensionAnchor

public struct DimensionAnchor {
    internal let item: Any
    internal let attribute: NSLayoutAttribute

    /// Sets the dimension to a specific size.
    @discardableResult
    public func equal(_ constant: CGFloat, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        return Layout.constraint(item: item, attribute: attribute, relation: relation, constant: constant)
    }

    /// Makes the dimension equal to the other anchor.
    @discardableResult
    public func equal(_ anchor: DimensionAnchor, offset: CGFloat = 0, multiplier: CGFloat = 1, relation: NSLayoutRelation = .equal) -> NSLayoutConstraint {
        return Layout.constraint(item: item, attribute: attribute, toItem: anchor.item, attribute: anchor.attribute, relation: relation, multiplier: multiplier, constant: offset)
    }
}


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
            let anchor = Anchor<Any>(item: item, attribute: $0.toAttribute)
            return anchor.pin(to: item2.base, margin: margin, inset: insets.insetForEdge($0), relation: relation)
        }
    }
}

public struct AxisCollection {
    internal let item: AnchorCompatible
    private var attributes: [NSLayoutAttribute] { return [.centerX, .centerY] }
    private var anchors: [Anchor<Any>] { return attributes.map { Anchor<Any>(item: item, attribute: $0) } }

    /// Centers the axis in the superview.
    @discardableResult
    public func centerInSuperview() -> [NSLayoutConstraint] {
        return anchors.map { $0.pinToSuperview() }
    }

    /// Centers the axis in the superview margins.
    @discardableResult
    public func centerInSuperviewMargins() -> [NSLayoutConstraint] {
        return anchors.map { $0.pinToSuperviewMargin() }
    }

    /// Makes the axis equal to the other collection of axis.
    @discardableResult
    public func equal(to collection: AxisCollection) -> [NSLayoutConstraint] {
        return anchors.map {
            $0.equal(Anchor<Any>(item: collection.item, attribute: $0.attribute))
        }
    }
}

public struct DimensionsCollection {
    internal let item: AnchorCompatible

    internal var width: DimensionAnchor { return DimensionAnchor(item: item, attribute: .width) }
    internal var height: DimensionAnchor { return DimensionAnchor(item: item, attribute: .height) }

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


// MARK: Stack

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

// MARK: Spacer

public final class Spacer: UIView { // using `UIView` and not `UILayoutGuide` to support stack views
    @nonobjc public init(width: CGFloat) {
        super.init(frame: .zero)
        Layout.make(id: "Yalta.Spacer") {
            al.width.equal(width).priority = UILayoutPriority(999)
        }
    }

    @nonobjc public init(minWidth: CGFloat) {
        super.init(frame: .zero)
        Layout.make(id: "Yalta.Spacer") {
            al.width.equal(minWidth, relation: .greaterThanOrEqual).priority = UILayoutPriority(999)
        }
    }

    @nonobjc public init(height: CGFloat) {
        super.init(frame: .zero)
        Layout.make(id: "Yalta.Spacer") {
            al.height.equal(height).priority = UILayoutPriority(999)
        }
    }

    @nonobjc public init(minHeight: CGFloat) {
        super.init(frame: .zero)
        Layout.make(id: "Yalta.Spacer") {
            al.height.equal(minHeight, relation: .greaterThanOrEqual).priority = UILayoutPriority(999)
        }
    }

    public override var intrinsicContentSize: CGSize {
        return CGSize(width: 1, height: 1)
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


public final class Layout {
    private static let shared = Layout()
    private init() {}

    /// Context in which constraits get created.
    private final class Context {
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
    /// activated at the same time. This is more efficient then installing them
    /// one-be-one. More importantly, it allows to make changes to the constraints
    /// before they are installed (e.g. change `priority`).
    /// - parameter priority: The priority to be set to all constraints created
    /// inside the closure. `nil` by default.
    /// - parameter id: The identifier to be set to all constraints created
    /// inside the closure. `nil` by default.
    @discardableResult
    public static func make(priority: UILayoutPriority? = nil, id: String? = nil, _ closure: () -> Void) -> [NSLayoutConstraint] {
        let layout = Layout.shared
        let context = Context(priority: priority, id: id)

        layout.stack.append(context)
        closure()
        let constraints = layout.stack.removeLast().constraints

        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    private func install(constraints: [NSLayoutConstraint]) {
        if stack.isEmpty { // no longer batching updates
            NSLayoutConstraint.activate(constraints)
        } else {
            // remember which constaints to install when batch is completed
            let context = stack.last!
            constraints.forEach {
                if let priority = context.priority { $0.priority = priority }
                $0.identifier = context.id
            }
            context.constraints.append(contentsOf: constraints)
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
        Layout.shared.install(constraints: [constraint])
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
