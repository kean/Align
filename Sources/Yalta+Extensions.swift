// The MIT License (MIT)
//
// Copyright (c) 2017 Alexander Grebenyuk (github.com/kean).

import UIKit



// MARK: UIView + Constraints

public extension UIView {
    @discardableResult @nonobjc public func addSubview<A: UIView>(_ a: A, constraints: (LayoutProxy<A>) -> Void) -> Constraints {
        addSubview(a)
        return Constraints(for: a, constraints)
    }

    @discardableResult @nonobjc public func addSubview<A: UIView, B: UIView>(_ a: A, _ b: B, constraints: (LayoutProxy<A>, LayoutProxy<B>) -> Void) -> Constraints {
        [a, b].forEach { addSubview($0) }
        return Constraints(for: a, b, constraints)
    }

    @discardableResult @nonobjc public func addSubview<A: UIView, B: UIView, C: UIView>(_ a: A, _ b: B, _ c: C, constraints: (LayoutProxy<A>, LayoutProxy<B>, LayoutProxy<C>) -> Void) -> Constraints {
        [a, b, c].forEach { addSubview($0) }
        return Constraints(for: a, b, c, constraints)
    }

    @discardableResult @nonobjc public func addSubview<A: UIView, B: UIView, C: UIView, D: UIView>(_ a: A, _ b: B, _ c: C, _ d: D, constraints: (LayoutProxy<A>, LayoutProxy<B>, LayoutProxy<C>, LayoutProxy<D>) -> Void) -> Constraints {
        [a, b, c, d].forEach { addSubview($0) }
        return Constraints(for: a, b, c, d, constraints)
    }
}


// MARK: Constraints + Arity

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


// MARK: Operators

public func + <Type, Axis>(anchor: Anchor<Type, Axis>, offset: CGFloat) -> Anchor<Type, Axis> {
    return anchor.offsetting(by: offset)
}

public func - <Type, Axis>(anchor: Anchor<Type, Axis>, offset: CGFloat) -> Anchor<Type, Axis> {
    return anchor.offsetting(by: -offset)
}


// MARK: Insets

public typealias Insets = UIEdgeInsets
public extension UIEdgeInsets {
    public init(_ all: CGFloat) { self = UIEdgeInsetsMake(all, all, all, all) }
}
