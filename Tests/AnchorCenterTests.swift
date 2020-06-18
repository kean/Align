// The MIT License (MIT)
//
// Copyright (c) 2017-2020 Alexander Grebenyuk (github.com/kean).

import XCTest
import Align

class AnchorCenterTests: XCTestCase {
    let container = View()
    let view = View()

    override func setUp() {
        super.setUp()

        container.addSubview(view)
    }

    // MARK: Align With Superview

    func testAlignWithSuperview() {
        XCTAssertEqualConstraints(
            view.anchors.centerX.align(),
            NSLayoutConstraint(item: view, attribute: .centerX, toItem: container, attribute: .centerX)
        )
        XCTAssertEqualConstraints(
            view.anchors.centerY.align(),
            NSLayoutConstraint(item: view, attribute: .centerY, toItem: container, attribute: .centerY)
        )
        XCTAssertEqualConstraints(
            view.anchors.centerY.align(offset: -10),
            NSLayoutConstraint(item: view, attribute: .centerY, toItem: container, attribute: .centerY, constant: -10)
        )
    }
}
