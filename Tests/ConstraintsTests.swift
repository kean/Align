// The MIT License (MIT)
//
// Copyright (c) 2017 Alexander Grebenyuk (github.com/kean).

import XCTest
@testable import Yalta


class ConstraintsTests: XCTestCase {
    let container = UIView()
    let view = UIView()

    override func setUp() {
        super.setUp()

        container.addSubview(view)
    }

    func testCanChangePriorityInsideInit() {
        Constraints {
            let c = view.al.top.pinToSuperview()
            XCTAssertEqual(c.priority.rawValue, 1000)
            c.priority = UILayoutPriority(999)
            XCTAssertEqual(c.priority.rawValue, 999)
        }
    }

    // MARK: Nesting

    func testCallsCanBeNested() { // no arguments
        Constraints() {
            XCTAssertEqualConstraints(
                view.al.top.pinToSuperview(),
                NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top)
            )
            Constraints() {
                XCTAssertEqualConstraints(
                    view.al.bottom.pinToSuperview(),
                    NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottom)
                )
            }
        }
    }
}

class ConstraintsArityTests: XCTestCase {
    let container = UIView()
    let a = UIView()
    let b = UIView()
    let c = UIView()
    let d = UIView()

    override func setUp() {
        super.setUp()

        container.addSubview(a)
        container.addSubview(b)
        container.addSubview(c)
        container.addSubview(d)
    }

    // MARK: Test That Behaves Like Standard Init

    func testArity() {
        Constraints(for: a, b) { a, b in
            let constraint = a.top.align(with: b.top)
            XCTAssertEqualConstraints(constraint, NSLayoutConstraint(
                item: self.a,
                attribute: .top,
                relation: .equal,
                toItem: self.b,
                attribute: .top
            ))
        }
    }

    func testCanChangePriorityInsideInit() {
        Constraints(for: a) {
            let cons = $0.top.pinToSuperview()
            XCTAssertEqual(cons.priority.rawValue, 1000)
            cons.priority = UILayoutPriority(999)
            XCTAssertEqual(cons.priority.rawValue, 999)
        }
    }

    func testCallsCanBeNested() {
        Constraints(for: a) {
            XCTAssertEqualConstraints(
                $0.top.pinToSuperview(),
                NSLayoutConstraint(item: a, attribute: .top, toItem: container, attribute: .top)
            )
            Constraints(for: a) {
                XCTAssertEqualConstraints(
                    $0.bottom.pinToSuperview(),
                    NSLayoutConstraint(item: a, attribute: .bottom, toItem: container, attribute: .bottom)
                )
            }
        }
    }

    // MARK: Multiple Arguments

    func testOne() {
        Constraints(for: a) {
            XCTAssertTrue($0.base === a)
            return
        }
    }

    func testTwo() {
        Constraints(for: a, b) {
            XCTAssertTrue($0.base === a)
            XCTAssertTrue($1.base === b)
        }
    }

    func testThree() {
        Constraints(for: a, b, c) {
            XCTAssertTrue($0.base === a)
            XCTAssertTrue($1.base === b)
            XCTAssertTrue($2.base === c)
        }
    }

    func testFour() {
        Constraints(for: a, b, c, d) {
            XCTAssertTrue($0.base === a)
            XCTAssertTrue($1.base === b)
            XCTAssertTrue($2.base === c)
            XCTAssertTrue($3.base === d)
        }
    }
}

class AddingSubviewsTests: XCTestCase {
    let container = UIView()
    let a = UIView()
    let b = UIView()
    let c = UIView()
    let d = UIView()

    func testOne() {
        container.addSubview(a) {
            XCTAssertTrue($0.base.superview === container)
            XCTAssertTrue($0.base === a)
            return
        }
    }

    func testTwo() {
        container.addSubview(a, b) {
            XCTAssertTrue($0.base.superview === container)
            XCTAssertTrue($1.base.superview === container)
            XCTAssertTrue($0.base === a)
            XCTAssertTrue($1.base === b)
        }
    }

    func testThree() {
        container.addSubview(a, b, c) {
            XCTAssertTrue($0.base.superview === container)
            XCTAssertTrue($1.base.superview === container)
            XCTAssertTrue($2.base.superview === container)
            XCTAssertTrue($0.base === a)
            XCTAssertTrue($1.base === b)
            XCTAssertTrue($2.base === c)
        }
    }

    func testFour() {
        container.addSubview(a, b, c, d) {
            XCTAssertTrue($0.base.superview === container)
            XCTAssertTrue($1.base.superview === container)
            XCTAssertTrue($2.base.superview === container)
            XCTAssertTrue($3.base.superview === container)
            XCTAssertTrue($0.base === a)
            XCTAssertTrue($1.base === b)
            XCTAssertTrue($2.base === c)
            XCTAssertTrue($3.base === d)
        }
    }
}
