// The MIT License (MIT)
//
// Copyright (c) 2017-2018 Alexander Grebenyuk (github.com/kean).

import XCTest
import Yalta


class AnchorCollectionSizeTests: XCTestCase {
    let container = UIView()
    let view = UIView()

    override func setUp() {
        super.setUp()

        container.addSubview(view)
    }

    func testSetSize() {
        XCTAssertEqualConstraints(
            view.al.size.set(CGSize(width: 5, height: 10)),
            [NSLayoutConstraint(item: view, attribute: .width, constant: 5),
             NSLayoutConstraint(item: view, attribute: .height, constant: 10)]
        )
    }

    func testMatchSize() {
        XCTAssertEqualConstraints(
            view.al.size.match(container.al.size),
            [NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width),
             NSLayoutConstraint(item: view, attribute: .height, toItem: container, attribute: .height)]
        )
    }

    func testMatchSizeWithInsets() {
        XCTAssertEqualConstraints(
            view.al.size.match(container.al.size, insets: CGSize(width: 10, height: 20)),
            [NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width, constant: -10),
             NSLayoutConstraint(item: view, attribute: .height, toItem: container, attribute: .height, constant: -20)]
        )
    }

    func testMatchSizeMultiplier() {
        XCTAssertEqualConstraints(
            view.al.size.match(container.al.size, multiplier: 2),
            [NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width, multiplier: 2),
             NSLayoutConstraint(item: view, attribute: .height, toItem: container, attribute: .height, multiplier: 2)]
        )
    }
}
