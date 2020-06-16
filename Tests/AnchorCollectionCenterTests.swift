// The MIT License (MIT)
//
// Copyright (c) 2017-2019 Alexander Grebenyuk (github.com/kean).

import XCTest
import Align


class AnchorCollectionCenterTests: XCTestCase {
    let container = View()
    let view = View()

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

    func testAlignWithSuperview() {
        XCTAssertEqualConstraints(
            view.al.center.alignWithSuperview(),
            [NSLayoutConstraint(item: view, attribute: .centerX, toItem: container, attribute: .centerX),
             NSLayoutConstraint(item: view, attribute: .centerY, toItem: container, attribute: .centerY)]
        )
    }
}
