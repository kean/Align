// The MIT License (MIT)
//
// Copyright (c) 2017-2018 Alexander Grebenyuk (github.com/kean).

import XCTest
import Yalta


class AnchorDimensionTests: XCTestCase {
    let container = UIView()
    let view = UIView()

    override func setUp() {
        super.setUp()

        container.addSubview(view)
    }

    func testSetWidth() {
        XCTAssertEqualConstraints(
            view.al.width.set(10),
            NSLayoutConstraint(item: view, attribute: .width, constant: 10)
        )
        XCTAssertEqualConstraints(
            view.al.width.set(10, relation: .greaterThanOrEqual),
            NSLayoutConstraint(item: view, attribute: .width, relation: .greaterThanOrEqual, constant: 10)
        )
    }

    func testSetHeight() {
        XCTAssertEqualConstraints(
            view.al.height.set(10),
            NSLayoutConstraint(item: view, attribute: .height, constant: 10)
        )
        XCTAssertEqualConstraints(
            view.al.height.set(10, relation: .greaterThanOrEqual),
            NSLayoutConstraint(item: view, attribute: .height, relation: .greaterThanOrEqual, constant: 10)
        )
    }

    func testMatchWidth() {
        XCTAssertEqualConstraints(
            view.al.width.match(container.al.width),
            NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width)
        )
        XCTAssertEqualConstraints(
            view.al.width.match(container.al.height), // can mix and match
            NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .height)
        )
    }
}
