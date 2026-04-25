// The MIT License (MIT)
//
// Copyright (c) 2017-2026 Alexander Grebenyuk (github.com/kean).

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

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
///
/// Nesting is supported: each constraint is collected by the innermost group,
/// and each group honors its own `activate:` flag independently.
public struct Constraints: RandomAccessCollection {
    public typealias Element = NSLayoutConstraint
    public typealias Index = Int

    public subscript(position: Int) -> NSLayoutConstraint { constraints[position] }
    public var startIndex: Int { constraints.startIndex }
    public var endIndex: Int { constraints.endIndex }
    public func index(after i: Int) -> Int { i + 1 }

    /// Returns all of the created constraints.
    public private(set) var constraints: [NSLayoutConstraint]

    /// All of the constraints created in the given closure are automatically
    /// activated at the same time. This is more efficient than installing them
    /// one-by-one. More importantly, it allows to make changes to the constraints
    /// before they are installed (e.g. change `priority`).
    ///
    /// - parameter activate: Set to `false` to disable automatic activation of
    /// constraints.
    /// - parameter closure: A closure in which constraints are created. The
    /// constraints are collected and activated together when the closure returns.
    @MainActor @discardableResult public init(activate: Bool = true, _ closure: () -> Void) {
        Constraints.stack.append([])
        closure() // create constraints
        self.constraints = Constraints.stack.removeLast()
        if activate { NSLayoutConstraint.activate(constraints) }
    }

    // MARK: Activate

    /// Activates each constraint in the receiver.
    @MainActor public func activate() {
        NSLayoutConstraint.activate(constraints)
    }

    /// Deactivates each constraint in the receiver.
    @MainActor public func deactivate() {
        NSLayoutConstraint.deactivate(constraints)
    }

    // MARK: Adding Constraints

    /// Creates and automatically installs a constraint.
    @MainActor @usableFromInline static func add(item item1: LayoutItem, attribute attr1: NSLayoutConstraint.Attribute, relatedBy relation: NSLayoutConstraint.Relation = .equal, toItem item2: LayoutItem? = nil, attribute attr2: NSLayoutConstraint.Attribute? = nil, multiplier: CGFloat = 1, constant: CGFloat = 0, priority: LayoutPriority? = nil) -> NSLayoutConstraint {
        item1._disableAutoresizingMask()
        let constraint = NSLayoutConstraint(item: item1, attribute: attr1, relatedBy: relation, toItem: item2, attribute: attr2 ?? .notAnAttribute, multiplier: multiplier, constant: constant)
        install(constraint, priority: priority)
        return constraint
    }

    /// Creates and automatically installs a constraint between two anchors.
    @MainActor @usableFromInline static func add<T1, A1, T2, A2>(_ lhs: consuming Anchor<T1, A1>, _ rhs: consuming Anchor<T2, A2>, constant: CGFloat = 0, multiplier: CGFloat = 1, relation: NSLayoutConstraint.Relation = .equal, priority: LayoutPriority? = nil) -> NSLayoutConstraint {
        add(item: lhs.item, attribute: lhs.attribute, relatedBy: relation, toItem: rhs.item, attribute: rhs.attribute, multiplier: (multiplier / lhs.multiplier) * rhs.multiplier, constant: constant - lhs.offset + rhs.offset, priority: priority)
    }

    /// Creates and automatically installs a constraint between an anchor and
    /// a given item.
    @MainActor @usableFromInline static func add<T1, A1>(_ lhs: consuming Anchor<T1, A1>, toItem item2: LayoutItem?, attribute attr2: NSLayoutConstraint.Attribute?, constant: CGFloat = 0, multiplier: CGFloat = 1, relation: NSLayoutConstraint.Relation = .equal, priority: LayoutPriority? = nil) -> NSLayoutConstraint {
        add(item: lhs.item, attribute: lhs.attribute, relatedBy: relation, toItem: item2, attribute: attr2, multiplier: multiplier / lhs.multiplier, constant: constant - lhs.offset, priority: priority)
    }

    @MainActor static var stack: [[NSLayoutConstraint]] = [] // this is what enables constraint auto-installing

    @MainActor @usableFromInline static func install(_ constraint: NSLayoutConstraint, priority: LayoutPriority? = nil) {
        if let priority { constraint.priority = priority }
        if !stack.isEmpty {
            stack[stack.count - 1].append(constraint)
        } else {
            constraint.isActive = true
        }
    }
}

extension Constraints {
    @MainActor @discardableResult
    public init<each Item: LayoutItem>(for item: repeat each Item, closure: (repeat LayoutAnchors<each Item>) -> Void) {
        self.init { closure(repeat (each item).anchors) }
    }
}

// MARK: - Misc

#if os(iOS) || os(tvOS)
public typealias EdgeInsets = UIEdgeInsets
public typealias LayoutPriority = UILayoutPriority
#elseif os(macOS)
public typealias EdgeInsets = NSEdgeInsets
public typealias LayoutPriority = NSLayoutConstraint.Priority

public extension NSEdgeInsets {
    static let zero = NSEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
}
#endif

extension NSLayoutConstraint.Relation {
    @usableFromInline var inverted: NSLayoutConstraint.Relation {
        switch self {
        case .greaterThanOrEqual: return .lessThanOrEqual
        case .lessThanOrEqual: return .greaterThanOrEqual
        case .equal: return self
        @unknown default: return self
        }
    }
}

// MARK: - Preview

#if DEBUG && (os(iOS) || os(tvOS))
import SwiftUI

@available(iOS 17.0, tvOS 17.0, *)
#Preview {
    // A scrolling gallery of common Align layouts, one per titled card.
    let cards = UIStackView()
    cards.axis = .vertical
    cards.spacing = 24
    cards.layoutMargins = UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
    cards.isLayoutMarginsRelativeArrangement = true

    // Pin all four edges with an inset.
    cards.addArrangedSubview(demoCard("Pin edges with insets") { canvas in
        let box = UIView(); box.backgroundColor = .systemBlue
        canvas.addSubview(box)

        box.anchors.edges.pin(insets: 12)
    })

    // Center the view and set an explicit size.
    cards.addArrangedSubview(demoCard("Center with fixed size") { canvas in
        let box = UIView(); box.backgroundColor = .systemPink
        canvas.addSubview(box)

        box.anchors.center.align()
        box.anchors.size.equal(CGSize(width: 120, height: 44))
    })

    // Place `b` 12pt to the right of `a`, matching its size.
    cards.addArrangedSubview(demoCard("Anchor-to-anchor spacing") { canvas in
        let a = UIView(), b = UIView()
        a.backgroundColor = .systemOrange
        b.backgroundColor = .systemGreen
        canvas.addSubview(a)
        canvas.addSubview(b)

        a.anchors.leading.pin(inset: 16)
        a.anchors.centerY.align()
        a.anchors.size.equal(CGSize(width: 60, height: 44))
        b.anchors.leading.spacing(12, to: a.anchors.trailing)
        b.anchors.centerY.equal(a.anchors.centerY)
        b.anchors.size.equal(a)
    })

    let scroll = UIScrollView()
    scroll.backgroundColor = .systemBackground
    scroll.addSubview(cards)

    // Match the content width to the scroll view so it scrolls vertically only.
    cards.anchors.edges.pin()
    cards.anchors.width.equal(scroll.anchors.width)
    return scroll
}

@MainActor private func demoCard(_ title: String, _ build: (UIView) -> Void) -> UIView {
    let label = UILabel()
    label.font = .systemFont(ofSize: 13, weight: .semibold)
    label.textColor = .secondaryLabel
    label.text = title
    let canvas = UIView()
    canvas.backgroundColor = .secondarySystemBackground
    canvas.anchors.height.equal(120)
    build(canvas)
    let stack = UIStackView(arrangedSubviews: [label, canvas])
    stack.axis = .vertical; stack.spacing = 6
    return stack
}
#endif
