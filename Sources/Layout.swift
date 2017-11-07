// The MIT License (MIT)
//
// Copyright (c) 2017 Alexander Grebenyuk (github.com/kean).

import UIKit


public final class Layout {
    public static let shared = Layout()
    private init() {}

    /// A `Layout` wrapper on top of a `View.
    public struct View {
        let view: UIView
    }

    // MARK: Batch

    private var stack = [[NSLayoutConstraint]]()

    /// All of the constraints created in the block using Yale APIs are then
    /// automatically activated at the same time. This may be fore efficient
    /// then installing the one-be-one. But more importantly it allows you
    /// to make changes to constraints before they are installed (e.g.
    /// change the `priority` which can only be done before activation).
    @discardableResult
    public static func perform(_ closure: () -> Void) -> [NSLayoutConstraint] {
        let constraints = Layout.shared.create(closure)
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    private func create(_ closure: () -> Void) -> [NSLayoutConstraint] {
        stack.append([])
        closure()
        return stack.removeLast()
    }

    private func install(constraints: [NSLayoutConstraint]) {
        if stack.isEmpty { // no longer batching updates
            NSLayoutConstraint.activate(constraints)
        } else {
            // remember which constaints to install when batch is completed
            stack[stack.endIndex-1].append(contentsOf: constraints)
        }
    }
}

// MARK: Constraints

// MARK: Constraint

extension Layout {
    /// A convenient way to add custom constraints.
    @discardableResult
    public static func constraint(item item1: Any,
                                  attribute attr1: NSLayoutAttribute,
                                  toItem item2: Any? = nil,
                                  attribute attr2: NSLayoutAttribute? = nil,
                                  relation: NSLayoutRelation = .equal,
                                  multiplier: CGFloat = 1,
                                  constant: CGFloat = 0,
                                  priority: UILayoutPriority? = nil,
                                  identifier: String? = nil) -> NSLayoutConstraint {
        assert(Thread.isMainThread, "Yale APIs can only be used from the main thread")

        let constraint = NSLayoutConstraint(
            item: item1,
            attribute: attr1,
            relatedBy: relation,
            toItem: item2,
            attribute: attr2 ?? .notAnAttribute,
            multiplier: multiplier,
            constant: constant
        )
        if let priority = priority {
            constraint.priority = priority
        }
        constraint.identifier = identifier

        (item1 as? UIView)?.translatesAutoresizingMaskIntoConstraints = false

        Layout.shared.install(constraints: [constraint])

        return constraint
    }
}


// MARK: VFL

extension Layout {
    /// A convenient way to create constraints using VFL (Visual Format Language).
    @discardableResult
    public func vfl(_ format: String,
                    options: NSLayoutFormatOptions = [],
                    metrics: [String : Double]? = nil,
                    views: [String: UIView]) -> [NSLayoutConstraint] {
        views.values.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        let constraints = NSLayoutConstraint.constraints(withVisualFormat: format, options: options, metrics: metrics, views: views)
        install(constraints: constraints)
        return constraints
    }
}
