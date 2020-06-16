// The MIT License (MIT)
//
// Copyright (c) 2017-2020 Alexander Grebenyuk (github.com/kean).

import XCTest
import Align

class AnchorDimensionTests: XCTestCase {
    let container = View()
    let view = View()

    override func setUp() {
        super.setUp()

        container.addSubview(view)
    }

    func testSetWidth() {
        XCTAssertEqualConstraints(
            view.anchors.width.set(10),
            NSLayoutConstraint(item: view, attribute: .width, constant: 10)
        )
        XCTAssertEqualConstraints(
            view.anchors.width.set(10, relation: .greaterThanOrEqual),
            NSLayoutConstraint(item: view, attribute: .width, relation: .greaterThanOrEqual, constant: 10)
        )
    }

    func testSetHeight() {
        XCTAssertEqualConstraints(
            view.anchors.height.set(10),
            NSLayoutConstraint(item: view, attribute: .height, constant: 10)
        )
        XCTAssertEqualConstraints(
            view.anchors.height.set(10, relation: .greaterThanOrEqual),
            NSLayoutConstraint(item: view, attribute: .height, relation: .greaterThanOrEqual, constant: 10)
        )
    }

    func testMatchWidth() {
        XCTAssertEqualConstraints(
            view.anchors.width.match(container.anchors.width),
            NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width)
        )
        XCTAssertEqualConstraints(
            view.anchors.width.match(container.anchors.height), // can mix and match
            NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .height)
        )
    }
}
