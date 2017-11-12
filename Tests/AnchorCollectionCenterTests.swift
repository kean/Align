// The MIT License (MIT)
//
// Copyright (c) 2017 Alexander Grebenyuk (github.com/kean).

import XCTest
import Yalta


class AnchorCollectionCenterTests: XCTestCase {
    let container = UIView()
    let view = UIView()

    override func setUp() {
        super.setUp()

        container.addSubview(view)
    }

    func testAlign() {
        XCTAssertEqualConstraints(
            view.al.center.align(with: container.al.center),
            [NSLayoutConstraint(item: view, attribute: .centerX, toItem: container, attribute: .centerX),
             NSLayoutConstraint(item: view, attribute: .centerY, toItem: container, attribute: .centerY)]
        )
    }
}
