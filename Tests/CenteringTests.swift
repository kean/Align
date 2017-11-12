// The MIT License (MIT)
//
// Copyright (c) 2017 Alexander Grebenyuk (github.com/kean).

import XCTest
import Yalta


class CenteringTests: XCTestCase {
    let container = UIView()
    let view = UIView()

    override func setUp() {
        super.setUp()

        container.addSubview(view)
    }

    func testCenteringInSuperview() {
        XCTAssertEqualConstraints(
            view.al.centerInSuperview(),
            [NSLayoutConstraint(item: view, attribute: .centerX, toItem: container, attribute: .centerX),
             NSLayoutConstraint(item: view, attribute: .centerY, toItem: container, attribute: .centerY)]
        )
        XCTAssertEqualConstraints(
            view.al.centerInSuperview(alongAxis: .horizontal),
            NSLayoutConstraint(item: view, attribute: .centerX, toItem: container, attribute: .centerX)
        )
        XCTAssertEqualConstraints(
            view.al.centerInSuperview(alongAxis: .vertical),
            NSLayoutConstraint(item: view, attribute: .centerY, toItem: container, attribute: .centerY)
        )
    }
}

