// The MIT License (MIT)
//
// Copyright (c) 2017 Alexander Grebenyuk (github.com/kean).

import XCTest
import Yalta


class AnchorTests: XCTestCase {
    let container = UIView()
    let view = UIView()

    override func setUp() {
        super.setUp()

        container.addSubview(view)
    }

    func testConstraintsCreatedByAnchorsAreInstalledAutomatically() {
        let constraint = view.al.top.align(with: container.al.top)
        XCTAssertEqual(constraint.isActive, true)
    }

    func testFirstViewSetToTranslatesAutoresizingMaskIntoConstraints() {
        // make sure that the precndition is always true
        view.translatesAutoresizingMaskIntoConstraints = true
        container.translatesAutoresizingMaskIntoConstraints = true
        XCTAssertTrue(view.translatesAutoresizingMaskIntoConstraints)
        XCTAssertTrue(container.translatesAutoresizingMaskIntoConstraints)

        view.al.top.align(with: container.al.top)

        XCTAssertFalse(view.translatesAutoresizingMaskIntoConstraints)
        XCTAssertTrue(container.translatesAutoresizingMaskIntoConstraints)

        view.translatesAutoresizingMaskIntoConstraints = true
        container.al.top.align(with: view.al.top)

        XCTAssertTrue(view.translatesAutoresizingMaskIntoConstraints)
        XCTAssertFalse(container.translatesAutoresizingMaskIntoConstraints)
    }
}
