// The MIT License (MIT)
//
// Copyright (c) 2017-2019 Alexander Grebenyuk (github.com/kean).

import XCTest
import Align

class AnchorCenterTests: XCTestCase {
    let container = UIView()
    let view = UIView()

    override func setUp() {
        super.setUp()

        container.addSubview(view)
    }

    // MARK: Align With Superview

    func testAlignWithSuperview() {
        XCTAssertEqualConstraints(
            view.al.centerX.alignWithSuperview(),
            NSLayoutConstraint(item: view, attribute: .centerX, toItem: container, attribute: .centerX)
        )
        XCTAssertEqualConstraints(
            view.al.centerY.alignWithSuperview(),
            NSLayoutConstraint(item: view, attribute: .centerY, toItem: container, attribute: .centerY)
        )
        XCTAssertEqualConstraints(
            view.al.centerY.alignWithSuperview(offset: -10),
            NSLayoutConstraint(item: view, attribute: .centerY, toItem: container, attribute: .centerY, constant: -10)
        )
    }
}
