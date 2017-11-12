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

    func testSetsIdentifier() {
        Constraints(id: "testSetsIdentifier") {
            let c = view.al.top.pinToSuperview()
            XCTAssertEqual(c.identifier, "testSetsIdentifier")
        }
    }

    // MARK: Nesting

    func testCanNestGroups() {
        Constraints(id: "group1") {
            let c = view.al.top.pinToSuperview()
            XCTAssertEqual(c.identifier, "group1")

            Constraints(id: "group2") {
                let c = view.al.bottom.pinToSuperview()
                XCTAssertEqual(c.identifier, "group2")
            }
        }
    }

    func testDoestUseIdFromLevelHigher() {
        Constraints(id: "group1") {
            let c = view.al.top.pinToSuperview()
            XCTAssertEqual(c.identifier, "group1")

            Constraints() {
                let c = view.al.bottom.pinToSuperview()
                XCTAssertEqual(c.identifier, nil)
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
    let e = UIView()

    override func setUp() {
        super.setUp()

        container.addSubview(a)
        container.addSubview(b)
        container.addSubview(c)
        container.addSubview(d)
        container.addSubview(e)
    }

    // MARK: Test That Behaves Like Standard Init

    func testArity() {
        Constraints(with: a, b) { a, b in
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
        Constraints(with: a) {
            let cons = $0.top.pinToSuperview()
            XCTAssertEqual(cons.priority.rawValue, 1000)
            cons.priority = UILayoutPriority(999)
            XCTAssertEqual(cons.priority.rawValue, 999)
        }
    }

    func testSetsIdentifier() {
        Constraints(id: "testSetsIdentifier", with: a) {
            let cons = $0.top.pinToSuperview()
            XCTAssertEqual(cons.identifier, "testSetsIdentifier")
        }
    }

    func testCanNestGroups() {
        Constraints(id: "group1", with: a) {
            let cons = $0.top.pinToSuperview()
            XCTAssertEqual(cons.identifier, "group1")

            Constraints(id: "group2", with: a) {
                let cons = $0.bottom.pinToSuperview()
                XCTAssertEqual(cons.identifier, "group2")
            }
        }
    }

    func testDoestUseIdFromLevelHigher() {
        Constraints(id: "group1", with: a) {
            let cons = $0.top.pinToSuperview()
            XCTAssertEqual(cons.identifier, "group1")

            Constraints(with: a) {
                let cons = $0.bottom.pinToSuperview()
                XCTAssertEqual(cons.identifier, nil)
            }
        }
    }

    // MARK: Multiple Arguments

    func testOne() {
        Constraints(with: a) {
            XCTAssertTrue($0.base === a)
            return
        }
    }

    func testTwo() {
        Constraints(with: a, b) {
            XCTAssertTrue($0.base === a)
            XCTAssertTrue($1.base === b)
        }
    }

    func testThree() {
        Constraints(with: a, b, c) {
            XCTAssertTrue($0.base === a)
            XCTAssertTrue($1.base === b)
            XCTAssertTrue($2.base === c)
        }
    }

    func testFour() {
        Constraints(with: a, b, c, d) {
            XCTAssertTrue($0.base === a)
            XCTAssertTrue($1.base === b)
            XCTAssertTrue($2.base === c)
            XCTAssertTrue($3.base === d)
        }
    }

    func testFive() {
        Constraints(with: a, b, c, d, e) {
            XCTAssertTrue($0.base === a)
            XCTAssertTrue($1.base === b)
            XCTAssertTrue($2.base === c)
            XCTAssertTrue($3.base === d)
            XCTAssertTrue($4.base === e)
        }
    }
}
