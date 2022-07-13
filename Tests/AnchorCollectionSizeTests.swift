// The MIT License (MIT)
//
// Copyright (c) 2017-2022 Alexander Grebenyuk (github.com/kean).

import XCTest
import Align

class AnchorCollectionSizeTests: XCTestCase {
    let container = View()
    let view = View()

    override func setUp() {
        super.setUp()

        container.addSubview(view)
    }

    func testSetSize() {
        XCTAssertEqualConstraints(
            view.anchors.size.equal(CGSize(width: 5, height: 10)),
            [NSLayoutConstraint(item: view, attribute: .width, constant: 5),
             NSLayoutConstraint(item: view, attribute: .height, constant: 10)]
        )
    }

    func testMatchSize() {
        XCTAssertEqualConstraints(
            view.anchors.size.equal(container),
            [NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width),
             NSLayoutConstraint(item: view, attribute: .height, toItem: container, attribute: .height)]
        )
    }

    func testMatchSizeWithInsets() {
        XCTAssertEqualConstraints(
            view.anchors.size.equal(container, insets: CGSize(width: 10, height: 20)),
            [NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width, constant: -10),
             NSLayoutConstraint(item: view, attribute: .height, toItem: container, attribute: .height, constant: -20)]
        )
    }

    func testMatchSizeMultiplier() {
        XCTAssertEqualConstraints(
            view.anchors.size.equal(container, multiplier: 2),
            [NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width, multiplier: 2),
             NSLayoutConstraint(item: view, attribute: .height, toItem: container, attribute: .height, multiplier: 2)]
        )
    }
}
