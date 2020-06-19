// The MIT License (MIT)
//
// Copyright (c) 2017-2020 Alexander Grebenyuk (github.com/kean).

import XCTest
import Align


class ConstraintsTests: XCTestCase {
    let container = View()
    let view = View()

    override func setUp() {
        super.setUp()

        container.addSubview(view)
    }

    func testCanChangePriorityInsideInit() {
        Constraints {
            let c = view.anchors.top.pin()
            XCTAssertEqual(c.priority.rawValue, 1000)
            c.priority = LayoutPriority(999)
            XCTAssertEqual(c.priority.rawValue, 999)
        }
    }

    // MARK: Nesting

    func testCallsCanBeNested() { // no arguments
        Constraints() {
            XCTAssertEqualConstraints(
                view.anchors.top.pin(),
                NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top)
            )
            Constraints() {
                XCTAssertEqualConstraints(
                    view.anchors.bottom.pin(),
                    NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottom)
                )
            }
        }
    }
}

class ConstraintsArityTests: XCTestCase {
    let container = View()
    let a = View()
    let b = View()
    let c = View()
    let d = View()

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
            let constraint = a.top.equal(b.top)
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
            let cons = $0.top.pin()
            XCTAssertEqual(cons.priority.rawValue, 1000)
            cons.priority = LayoutPriority(999)
            XCTAssertEqual(cons.priority.rawValue, 999)
        }
    }

    func testCallsCanBeNested() {
        Constraints(for: a) {
            XCTAssertEqualConstraints(
                $0.top.pin(),
                NSLayoutConstraint(item: a, attribute: .top, toItem: container, attribute: .top)
            )
            Constraints(for: a) {
                XCTAssertEqualConstraints(
                    $0.bottom.pin(),
                    NSLayoutConstraint(item: a, attribute: .bottom, toItem: container, attribute: .bottom)
                )
            }
        }
    }

    func testCollection() {
        let constraints = Constraints {
            a.anchors.top.pin()
            a.anchors.bottom.pin()
        }

        XCTAssertEqualConstraints(Array(constraints), [
            NSLayoutConstraint(item: a, attribute: .top, toItem: container, attribute: .top),
            NSLayoutConstraint(item: a, attribute: .bottom, toItem: container, attribute: .bottom)
        ])

        XCTAssertEqualConstraints(
            constraints[0],
            NSLayoutConstraint(item: a, attribute: .top, toItem: container, attribute: .top)
        )

        XCTAssertEqualConstraints(
            constraints[1],
            NSLayoutConstraint(item: a, attribute: .bottom, toItem: container, attribute: .bottom)
        )
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

#if os(iOS) || os(tvOS)
class AddingSubviewsTests: XCTestCase {
    let container = View()
    let a = View()
    let b = View()
    let c = View()
    let d = View()

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
#endif
