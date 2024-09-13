//
// Copyright (c) 2017-2024 Alexander Grebenyuk (github.com/kean).

import XCTest
import Align

@MainActor
class AnchorEdgeTests: XCTestCase {
    let container = View()
    let view = View()

    @MainActor
    override func setUp() async throws {
        container.addSubview(view)
    }

    // MARK: Pinning

    @MainActor
    func testPinToSuperview() {
        test("pin top to superview") {
            let c = view.anchors.top.pin()
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top))
        }

        test("pin top to superview with inset") {
            let c = view.anchors.top.pin(inset: 10)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top, constant: 10))
        }
        test("pin bottom to superview with inset") {
            let c = view.anchors.bottom.pin(inset: 10)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottom, constant: -10))
        }
        test("pin left to superview with inset") {
            let c = view.anchors.left.pin(inset: 10)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .left, toItem: container, attribute: .left, constant: 10))
        }
        test("pin right to superview with inset") {
            let c = view.anchors.right.pin(inset: 10)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .right, toItem: container, attribute: .right, constant: -10))
        }
    }

#if os(iOS) || os(tvOS)
    @MainActor
    func testPinToSuperviewMargin() {
        test("pin top to superview margin") {
            let c = view.anchors.top.pin(to: container.layoutMarginsGuide)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .top, toItem: container.layoutMarginsGuide, attribute: .top))
        }

        test("pin top to superview margin with inset") {
            let c = view.anchors.top.pin(to: container.layoutMarginsGuide, inset: 10)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .top, toItem: container.layoutMarginsGuide, attribute: .top, constant: 10))
        }
    }
#endif
}
