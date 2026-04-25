///// The MIT License (MIT)
//
// Copyright (c) 2017-2026 Alexander Grebenyuk (github.com/kean).

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// A type that represents a layout axis.
public enum AnchorAxis {
    public enum Horizontal {}
    public enum Vertical {}
}

/// A marker protocol identifying the kind of attribute an `Anchor` represents.
@_marker public protocol AnchorKind {}

/// A marker protocol for anchor kinds that can be aligned with one another
/// (edges, centers, and baselines).
@_marker public protocol AlignmentAnchorKind: AnchorKind {}

/// Represents an anchor type.
public enum AnchorType {
    public enum Edge: AlignmentAnchorKind {}
    public enum Center: AlignmentAnchorKind {}
    public enum Baseline: AlignmentAnchorKind {}
    public enum Dimension: AnchorKind {}
}

/// An anchor represents one of the view's layout attributes.
///
/// Instead of creating `NSLayoutConstraint` objects directly, start with a `UIView`
/// or `UILayoutGuide` and select one of its anchors. For example, `view.anchors.top`
/// is represented by `Anchor<AnchorType.Edge, AnchorAxis.Vertical>`. Then use the
/// anchor’s methods to construct your constraint.
///
/// ```swift
/// // Align two views along one of the edges
/// a.anchors.leading.equal(b.anchors.leading)
/// ```
///
/// When you create constraints using `Anchor` APIs, the constraints are activated
/// automatically and the target view has `translatesAutoresizingMaskIntoConstraints`
/// set to `false`. If you want to activate all the constraints at the same time,
/// or create them without activation, use `Constraints` type.
///
/// - tip: `UIView` does not provide anchor properties for the layout margin attributes.
/// Instead, call `view.layoutMarginsGuide.anchors`.
@MainActor public struct Anchor<Type, Axis> { // type and axis are phantom types
    @usableFromInline let item: LayoutItem
    @usableFromInline let attribute: NSLayoutConstraint.Attribute
    @usableFromInline let offset: CGFloat
    @usableFromInline let multiplier: CGFloat

    @inlinable init(_ item: LayoutItem, _ attribute: NSLayoutConstraint.Attribute, offset: CGFloat = 0, multiplier: CGFloat = 1) {
        self.item = item; self.attribute = attribute; self.offset = offset; self.multiplier = multiplier
    }

    /// Returns a new anchor offset by a given amount.
    ///
    /// - tip: Consider using a convenience operator instead: `view.anchors.top + 10`.
    @inlinable public consuming func offsetting(by offset: CGFloat) -> Anchor {
        Anchor(item, attribute, offset: self.offset + offset, multiplier: self.multiplier)
    }

    /// Returns a new anchor with a constant multiplied by the given amount.
    ///
    /// - tip: Consider using a convenience operator instead: `view.anchors.height * 2`.
    @inlinable public consuming func multiplied(by multiplier: CGFloat) -> Anchor {
        Anchor(item, attribute, offset: self.offset * multiplier, multiplier: self.multiplier * multiplier)
    }
}

/// Returns a new anchor offset by a given amount.
@MainActor @inlinable public func + <Type, Axis>(anchor: consuming Anchor<Type, Axis>, offset: CGFloat) -> Anchor<Type, Axis> {
    anchor.offsetting(by: offset)
}

/// Returns a new anchor offset by a given amount.
@MainActor @inlinable public func - <Type, Axis>(anchor: consuming Anchor<Type, Axis>, offset: CGFloat) -> Anchor<Type, Axis> {
    anchor.offsetting(by: -offset)
}

/// Returns a new anchor with a constant multiplied by the given amount.
@MainActor @inlinable public func * <Type, Axis>(anchor: consuming Anchor<Type, Axis>, multiplier: CGFloat) -> Anchor<Type, Axis> {
    anchor.multiplied(by: multiplier)
}

// MARK: - Anchors (AlignmentAnchorKind)

@MainActor public extension Anchor where Type: AlignmentAnchorKind {
    @inlinable @discardableResult consuming func equal<OtherType: AlignmentAnchorKind>(_ anchor: consuming Anchor<OtherType, Axis>, constant: CGFloat = 0, priority: LayoutPriority? = nil) -> NSLayoutConstraint {
        Constraints.add(self, anchor, constant: constant, relation: .equal, priority: priority)
    }

    @inlinable @discardableResult consuming func greaterThanOrEqual<OtherType: AlignmentAnchorKind>(_ anchor: consuming Anchor<OtherType, Axis>, constant: CGFloat = 0, priority: LayoutPriority? = nil) -> NSLayoutConstraint {
        Constraints.add(self, anchor, constant: constant, relation: .greaterThanOrEqual, priority: priority)
    }

    @inlinable @discardableResult consuming func lessThanOrEqual<OtherType: AlignmentAnchorKind>(_ anchor: consuming Anchor<OtherType, Axis>, constant: CGFloat = 0, priority: LayoutPriority? = nil) -> NSLayoutConstraint {
        Constraints.add(self, anchor, constant: constant, relation: .lessThanOrEqual, priority: priority)
    }
}

// MARK: - Anchors (AnchorType.Dimension)

@MainActor public extension Anchor where Type == AnchorType.Dimension {
    @inlinable @discardableResult consuming func equal<OtherAxis>(_ anchor: consuming Anchor<AnchorType.Dimension, OtherAxis>, constant: CGFloat = 0, priority: LayoutPriority? = nil) -> NSLayoutConstraint {
        Constraints.add(self, anchor, constant: constant, relation: .equal, priority: priority)
    }

    @inlinable @discardableResult consuming func greaterThanOrEqual<OtherAxis>(_ anchor: consuming Anchor<AnchorType.Dimension, OtherAxis>, constant: CGFloat = 0, priority: LayoutPriority? = nil) -> NSLayoutConstraint {
        Constraints.add(self, anchor, constant: constant, relation: .greaterThanOrEqual, priority: priority)
    }

    @inlinable @discardableResult consuming func lessThanOrEqual<OtherAxis>(_ anchor: consuming Anchor<AnchorType.Dimension, OtherAxis>, constant: CGFloat = 0, priority: LayoutPriority? = nil) -> NSLayoutConstraint {
        Constraints.add(self, anchor, constant: constant, relation: .lessThanOrEqual, priority: priority)
    }

    @inlinable @discardableResult consuming func equal(_ constant: CGFloat, priority: LayoutPriority? = nil) -> NSLayoutConstraint {
        Constraints.add(item: item, attribute: attribute, relatedBy: .equal, constant: constant, priority: priority)
    }

    @inlinable @discardableResult consuming func greaterThanOrEqual(_ constant: CGFloat, priority: LayoutPriority? = nil) -> NSLayoutConstraint {
        Constraints.add(item: item, attribute: attribute, relatedBy: .greaterThanOrEqual, constant: constant, priority: priority)
    }

    @inlinable @discardableResult consuming func lessThanOrEqual(_ constant: CGFloat, priority: LayoutPriority? = nil) -> NSLayoutConstraint {
        Constraints.add(item: item, attribute: attribute, relatedBy: .lessThanOrEqual, constant: constant, priority: priority)
    }

    /// Clamps the dimension of a view to the given limiting range.
    @inlinable @discardableResult consuming func clamp(to limits: ClosedRange<CGFloat>, priority: LayoutPriority? = nil) -> [NSLayoutConstraint] {
        [(copy self).greaterThanOrEqual(limits.lowerBound, priority: priority), lessThanOrEqual(limits.upperBound, priority: priority)]
    }
}

// MARK: - Anchors (AnchorType.Edge)

// Public surface below is `@inlinable` so anchor expressions can be optimized
// across module boundaries. SPI access (`superview`, `_disableAutoresizingMask`)
// is funneled through `@usableFromInline` helpers (`_requireSuperview`,
// `Constraints.add/install`) whose bodies stay inside the framework.

@MainActor public extension Anchor where Type == AnchorType.Edge {
    /// Pins the edge to the respected edges of the given container.
    @inlinable @discardableResult consuming func pin(to container: LayoutItem? = nil, inset: CGFloat = 0, relation: NSLayoutConstraint.Relation = .equal, priority: LayoutPriority? = nil) -> NSLayoutConstraint {
        let isInverted: Bool = switch attribute {
        case .trailing, .right, .bottom: true
        default: false
        }
        let target = container ?? item._requireSuperview()
        return Constraints.add(self, toItem: target, attribute: attribute, constant: (isInverted ? -inset : inset), relation: isInverted ? relation.inverted : relation, priority: priority)
    }

    /// Adds spacing between the current anchors.
    @inlinable @discardableResult consuming func spacing(_ spacing: CGFloat, to anchor: consuming Anchor<AnchorType.Edge, Axis>, relation: NSLayoutConstraint.Relation = .equal, priority: LayoutPriority? = nil) -> NSLayoutConstraint {
        let isInverted = (attribute == .bottom && anchor.attribute == .top) ||
        (attribute == .right && anchor.attribute == .left) ||
        (attribute == .trailing && anchor.attribute == .leading)
        return Constraints.add(self, anchor, constant: isInverted ? -spacing : spacing, relation: isInverted ? relation.inverted : relation, priority: priority)
    }
}

// MARK: - Anchors (AnchorType.Center)

@MainActor public extension Anchor where Type == AnchorType.Center {
    /// Aligns the axis with a superview axis.
    @inlinable @discardableResult consuming func align(offset: CGFloat = 0, priority: LayoutPriority? = nil) -> NSLayoutConstraint {
        Constraints.add(self, toItem: item._requireSuperview(), attribute: attribute, constant: offset, priority: priority)
    }
}
