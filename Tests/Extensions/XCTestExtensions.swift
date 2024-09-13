// The MIT License (MIT)
//
// Copyright (c) 2017-2024 Alexander Grebenyuk (github.com/kean).

import XCTest

func test(_ title: String? = nil, _ closure: () -> Void) {
    closure()
}

func test<T>(_ title: String? = nil, with element: T, _ closure: (T) -> Void) {
    closure(element)
}

// MARK: Asserts

@MainActor
public func XCTAssertEqualConstraints(_ expected: [NSLayoutConstraint], _ received: [NSLayoutConstraint], file: StaticString = #filePath, line: UInt = #line) {
    XCTAssertEqual(expected.count, received.count, file: file, line: line)

    var received = received
    for c in expected {
        let idx = received.firstIndex(where: {
            Constraint($0) == Constraint(c)
        })
        XCTAssertNotNil(idx, "Failed to find constraints: \(c)\n\nExpected: \(expected)\n\nReceived: \(received)", file: file, line: line)
        if let idx = idx {
            received.remove(at: idx)
        }
    }
}

@MainActor
public func XCTAssertEqualConstraints(_ expected: NSLayoutConstraint, _ received: NSLayoutConstraint, file: StaticString = #filePath, line: UInt = #line) {
    XCTAssertEqualConstraints(Constraint(expected), Constraint(received), file: file, line: line)
}

@MainActor
private func XCTAssertEqualConstraints<T: Equatable>(_ expected: T, _ received: T, file: StaticString = #filePath, line: UInt = #line) {
    print(diff(expected, received))
    XCTAssertTrue(expected == received, "Found difference for " + diff(expected, received).joined(separator: ", "), file: file, line: line)
}

// MARK: Constraints

extension NSLayoutConstraint {
    @nonobjc convenience init(item item1: Any, attribute attr1: NSLayoutConstraint.Attribute, relation: NSLayoutConstraint.Relation = .equal, toItem item2: Any? = nil, attribute attr2: NSLayoutConstraint.Attribute? = nil, multiplier: CGFloat = 1, constant: CGFloat = 0, priority: Float? = nil, id: String? = nil) {
        self.init(item: item1, attribute: attr1, relatedBy: relation, toItem: item2, attribute: attr2 ?? .notAnAttribute, multiplier: multiplier, constant: constant)
        if let priority = priority { self.priority = LayoutPriority(priority) }
        if let id = id { self.identifier = id }
    }
}

@MainActor
private struct Constraint {
    let firstItem: AnyObject?
    let firstAttribute: String
    let secondItem: AnyObject?
    let secondAttribute: String
    let relation: NSLayoutConstraint.Relation.RawValue
    let multiplier: CGFloat
    let constant: CGFloat
    let priority: LayoutPriority.RawValue
    let identifier: String?

    init(_ c: NSLayoutConstraint) {
        firstItem = c.firstItem
        firstAttribute = c.firstAttribute.toString
        secondItem = c.secondItem
        secondAttribute = c.secondAttribute.toString
        relation = c.relation.rawValue
        multiplier = c.multiplier
        constant = c.constant
        priority = c.priority.rawValue
        identifier = c.identifier
    }
}

#if swift(>=6.0)
extension Constraint: @preconcurrency Equatable {
    static func ==(lhs: Constraint, rhs: Constraint) -> Bool {
        return lhs.firstItem === rhs.firstItem &&
            lhs.firstAttribute == rhs.firstAttribute &&
            lhs.relation == rhs.relation &&
            lhs.secondItem === rhs.secondItem &&
            lhs.secondAttribute == rhs.secondAttribute &&
            lhs.multiplier == rhs.multiplier &&
            lhs.constant == rhs.constant &&
            lhs.priority == rhs.priority &&
            lhs.identifier == rhs.identifier
    }
}
#else
extension Constraint: Equatable {
    static func ==(lhs: Constraint, rhs: Constraint) -> Bool {
        return lhs.firstItem === rhs.firstItem &&
            lhs.firstAttribute == rhs.firstAttribute &&
            lhs.relation == rhs.relation &&
            lhs.secondItem === rhs.secondItem &&
            lhs.secondAttribute == rhs.secondAttribute &&
            lhs.multiplier == rhs.multiplier &&
            lhs.constant == rhs.constant &&
            lhs.priority == rhs.priority &&
            lhs.identifier == rhs.identifier
    }
}
#endif

// MARK: Helpers

extension NSLayoutConstraint.Attribute {
    var toString: String {
        switch self {
        case .width: return "width"
        case .height: return "height"
        case .bottom: return "bottom"
        case .top: return "top"
        case .left: return "left"
        case .right: return "right"
        case .leading: return "leading"
        case .trailing: return "trailing"
        case .centerX: return "centerX"
        case .centerY: return "centerY"
        case .lastBaseline: return "lastBaseline"
        case .firstBaseline: return "firstBaseline"
        case .notAnAttribute: return "notAnAttribute"
#if os(iOS) || os(tvOS)
        case .bottomMargin: return "bottomMargin"
        case .topMargin: return "topMargin"
        case .leftMargin: return "leftMargin"
        case .rightMargin: return "rightMargin"
        case .leadingMargin: return "leadingMargin"
        case .trailingMargin: return "trailingMargin"
        case .centerXWithinMargins: return "centerXWithinMargins"
        case .centerYWithinMargins: return "centerYWithinMargins"
#endif
        @unknown default: return "unexpected"
        }
    }
}

#if os(iOS) || os(tvOS)
typealias View = UIView
typealias LayoutPriority = UILayoutPriority
#elseif os(macOS)
typealias View = NSView
typealias LayoutPriority = NSLayoutConstraint.Priority
#endif
