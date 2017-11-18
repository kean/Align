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

    // MARK: Offsetting

    func testOffsettingTopAnchor() {
        let anchor = container.al.top.offsetting(by: 10)
        XCTAssertEqualConstraints(
            view.al.top.align(with: anchor),
            NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top, constant: 10)
        )
        XCTAssertEqualConstraints(
            view.al.top.align(with: anchor, offset: 10),
            NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top, constant: 20)
        )
        XCTAssertEqualConstraints( // test that works both ways
            anchor.align(with: view.al.top),
            NSLayoutConstraint(item: container, attribute: .top, toItem: view, attribute: .top, constant: -10)
        )
    }

    func testOffsettingUsingOperators() {
        XCTAssertEqualConstraints(
            view.al.top.align(with: container.al.top + 10),
            NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top, constant: 10)
        )
        XCTAssertEqualConstraints(
            view.al.top.align(with: container.al.top - 10),
            NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top, constant: -10)
        )
    }

    func testOffsettingRightAnchor() {
        let anchor = container.al.right.offsetting(by: -10)
        XCTAssertEqualConstraints(
            view.al.right.align(with: anchor),
            NSLayoutConstraint(item: view, attribute: .right, toItem: container, attribute: .right, constant: -10)
        )
        XCTAssertEqualConstraints( // test that works both ways
            anchor.align(with: view.al.right),
            NSLayoutConstraint(item: container, attribute: .right, toItem: view, attribute: .right, constant: 10)
        )
    }

    func testAligningTwoOffsetAnchors() {
        let containerTop = container.al.top.offsetting(by: 10)
        let viewTop = view.al.top.offsetting(by: 10)
        XCTAssertEqualConstraints(
            viewTop.align(with: containerTop), // nobody's going to do that, but it's nice it's their
            NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top, constant: 0)
        )
    }

    func testOffsettingWidth() {
        XCTAssertEqualConstraints(
            view.al.height.match(container.al.width + 10),
            NSLayoutConstraint(item: view, attribute: .height, toItem: container, attribute: .width, constant: 10)
        )
        XCTAssertEqualConstraints(
            view.al.height.match(container.al.width - 10),
            NSLayoutConstraint(item: view, attribute: .height, toItem: container, attribute: .width, constant: -10)
        )
    }

    func testOffsetingMultipleTimes() {
        XCTAssertEqualConstraints(
            view.al.height.match((container.al.width + 10) + 10),
            NSLayoutConstraint(item: view, attribute: .height, toItem: container, attribute: .width, constant: 20)
        )
    }
}
