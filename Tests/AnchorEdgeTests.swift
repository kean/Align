//
// Copyright (c) 2017-2020 Alexander Grebenyuk (github.com/kean).

import XCTest
import Align

class AnchorEdgeTests: XCTestCase {
    let container = View()
    let view = View()

    override func setUp() {
        super.setUp()

        container.addSubview(view)
    }

    // MARK: Pinning

    func testPinToSuperview() {
        test("pin top to superview") {
            let c = view.anchors.top.pinToSuperview()
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top))
        }

        test("pin top to superview with inset") {
            let c = view.anchors.top.pinToSuperview(inset: 10)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top, constant: 10))
        }
        test("pin bottom to superview with inset") {
            let c = view.anchors.bottom.pinToSuperview(inset: 10)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottom, constant: -10))
        }
        test("pin left to superview with inset") {
            let c = view.anchors.left.pinToSuperview(inset: 10)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .left, toItem: container, attribute: .left, constant: 10))
        }
        test("pin right to superview with inset") {
            let c = view.anchors.right.pinToSuperview(inset: 10)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .right, toItem: container, attribute: .right, constant: -10))
        }
    }

#if os(iOS) || os(tvOS)
    func testPinToSuperviewMargin() {
        test("pin top to superview margin") {
            let c = view.anchors.top.pinToSuperviewMargin()
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .topMargin))
        }

        test("pin top to superview margin with inset") {
            let c = view.anchors.top.pinToSuperviewMargin(inset: 10)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .topMargin, constant: 10))
        }
        test("pin bottom to superview margin with inset") {
            let c = view.anchors.bottom.pinToSuperviewMargin(inset: 10)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottomMargin, constant: -10))
        }
        test("pin left to superview margin with inset") {
            let c = view.anchors.left.pinToSuperviewMargin(inset: 10)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .left, toItem: container, attribute: .leftMargin, constant: 10))
        }
        test("pin right to superview margin with inset") {
            let c = view.anchors.right.pinToSuperviewMargin(inset: 10)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .right, toItem: container, attribute: .rightMargin, constant: -10))
        }
    }
#endif
}
