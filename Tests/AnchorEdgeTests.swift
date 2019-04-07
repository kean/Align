//
// Copyright (c) 2017-2019 Alexander Grebenyuk (github.com/kean).

import XCTest
import Yalta


class AnchorEdgeTests: XCTestCase {
    let container = UIView()
    let view = UIView()

    override func setUp() {
        super.setUp()

        container.addSubview(view)
    }

    // MARK: Pinning

    func testPinToSuperview() {
        test("pin top to superview") {
            let c = view.al.top.pinToSuperview()
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top))
        }

        test("pin top to superview with inset") {
            let c = view.al.top.pinToSuperview(inset: 10)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top, constant: 10))
        }
        test("pin bottom to superview with inset") {
            let c = view.al.bottom.pinToSuperview(inset: 10)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottom, constant: -10))
        }
        test("pin left to superview with inset") {
            let c = view.al.left.pinToSuperview(inset: 10)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .left, toItem: container, attribute: .left, constant: 10))
        }
        test("pin right to superview with inset") {
            let c = view.al.right.pinToSuperview(inset: 10)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .right, toItem: container, attribute: .right, constant: -10))
        }

        test("pin top to superview with inset and relation") {
            let c = view.al.top.pinToSuperview(inset: 10, relation: .greaterThanOrEqual)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .top, relation: .greaterThanOrEqual, toItem: container, attribute: .top, constant: 10))
        }
        test("pin bottom to superview with inset and relation") {
            let c = view.al.bottom.pinToSuperview(inset: 10, relation: .greaterThanOrEqual)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .bottom, relation: .lessThanOrEqual, toItem: container, attribute: .bottom, constant: -10))
        }
        test("pin left to superview with inset and relation") {
            let c = view.al.left.pinToSuperview(inset: 10, relation: .greaterThanOrEqual)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .left, relation: .greaterThanOrEqual, toItem: container, attribute: .left, constant: 10))
        }
        test("pin right to superview with inset and relation") {
            let c = view.al.right.pinToSuperview(inset: 10, relation: .greaterThanOrEqual)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .right, relation: .lessThanOrEqual, toItem: container, attribute: .right, constant: -10))
        }
    }

    func testPinToSuperviewMargin() {
        test("pin top to superview margin") {
            let c = view.al.top.pinToSuperviewMargin()
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .topMargin))
        }

        test("pin top to superview margin with inset") {
            let c = view.al.top.pinToSuperviewMargin(inset: 10)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .topMargin, constant: 10))
        }
        test("pin bottom to superview margin with inset") {
            let c = view.al.bottom.pinToSuperviewMargin(inset: 10)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottomMargin, constant: -10))
        }
        test("pin left to superview margin with inset") {
            let c = view.al.left.pinToSuperviewMargin(inset: 10)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .left, toItem: container, attribute: .leftMargin, constant: 10))
        }
        test("pin right to superview margin with inset") {
            let c = view.al.right.pinToSuperviewMargin(inset: 10)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .right, toItem: container, attribute: .rightMargin, constant: -10))
        }

        test("pin top to superview margin with inset and relation") {
            let c = view.al.top.pinToSuperviewMargin(inset: 10, relation: .greaterThanOrEqual)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .top, relation: .greaterThanOrEqual, toItem: container, attribute: .topMargin, constant: 10))
        }
        test("pin bottom to superview margin with inset and relation") {
            let c = view.al.bottom.pinToSuperviewMargin(inset: 10, relation: .greaterThanOrEqual)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .bottom, relation: .lessThanOrEqual, toItem: container, attribute: .bottomMargin, constant: -10))
        }
        test("pin left to superview margin with inset and relation") {
            let c = view.al.left.pinToSuperviewMargin(inset: 10, relation: .greaterThanOrEqual)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .left, relation: .greaterThanOrEqual, toItem: container, attribute: .leftMargin, constant: 10))
        }
        test("pin right to superview margin with inset and relation") {
            let c = view.al.right.pinToSuperviewMargin(inset: 10, relation: .greaterThanOrEqual)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .right, relation: .lessThanOrEqual, toItem: container, attribute: .rightMargin, constant: -10))
        }
    }
}
