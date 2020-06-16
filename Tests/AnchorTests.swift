// The MIT License (MIT)
//
// Copyright (c) 2017-2020 Alexander Grebenyuk (github.com/kean).

import XCTest
import Align

class AnchorTests: XCTestCase {
    let container = View()
    let view = View()

    override func setUp() {
        super.setUp()

        container.addSubview(view)
    }

    func testConstraintsCreatedByAnchorsAreInstalledAutomatically() {
        let constraint = view.anchors.top.align(with: container.anchors.top)
        XCTAssertEqual(constraint.isActive, true)
    }

    func testFirstViewSetToTranslatesAutoresizingMaskIntoConstraints() {
        // make sure that the precndition is always true
        view.translatesAutoresizingMaskIntoConstraints = true
        container.translatesAutoresizingMaskIntoConstraints = true
        XCTAssertTrue(view.translatesAutoresizingMaskIntoConstraints)
        XCTAssertTrue(container.translatesAutoresizingMaskIntoConstraints)

        view.anchors.top.align(with: container.anchors.top)

        XCTAssertFalse(view.translatesAutoresizingMaskIntoConstraints)
        XCTAssertTrue(container.translatesAutoresizingMaskIntoConstraints)

        view.translatesAutoresizingMaskIntoConstraints = true
        container.anchors.top.align(with: view.anchors.top)

        XCTAssertTrue(view.translatesAutoresizingMaskIntoConstraints)
        XCTAssertFalse(container.translatesAutoresizingMaskIntoConstraints)
    }

    // MARK: Offsetting

    func testOffsettingTopAnchor() {
        let anchor = container.anchors.top + 10
        XCTAssertEqualConstraints(
            view.anchors.top.align(with: anchor),
            NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top, constant: 10)
        )
        XCTAssertEqualConstraints(
            view.anchors.top.align(with: anchor + 10),
            NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top, constant: 20)
        )
        XCTAssertEqualConstraints( // test that works both ways
            anchor.align(with: view.anchors.top),
            NSLayoutConstraint(item: container, attribute: .top, toItem: view, attribute: .top, constant: -10)
        )
    }

    func testOffsettingUsingOperators() {
        XCTAssertEqualConstraints(
            view.anchors.top.align(with: container.anchors.top + 10),
            NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top, constant: 10)
        )
        XCTAssertEqualConstraints(
            view.anchors.top.align(with: container.anchors.top - 10),
            NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top, constant: -10)
        )
    }

    func testOffsettingRightAnchor() {
        let anchor = container.anchors.right - 10
        XCTAssertEqualConstraints(
            view.anchors.right.align(with: anchor),
            NSLayoutConstraint(item: view, attribute: .right, toItem: container, attribute: .right, constant: -10)
        )
        XCTAssertEqualConstraints( // test that works both ways
            anchor.align(with: view.anchors.right),
            NSLayoutConstraint(item: container, attribute: .right, toItem: view, attribute: .right, constant: 10)
        )
    }

    func testAligningTwoOffsetAnchors() {
        let containerTop = container.anchors.top + 10
        let viewTop = view.anchors.top + 10
        XCTAssertEqualConstraints(
            viewTop.align(with: containerTop), // nobody's going to do that, but it's nice it's their
            NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top, constant: 0)
        )
    }

    func testOffsettingWidth() {
        XCTAssertEqualConstraints(
            view.anchors.height.match(container.anchors.width + 10),
            NSLayoutConstraint(item: view, attribute: .height, toItem: container, attribute: .width, constant: 10)
        )
        XCTAssertEqualConstraints(
            view.anchors.height.match(container.anchors.width - 10),
            NSLayoutConstraint(item: view, attribute: .height, toItem: container, attribute: .width, constant: -10)
        )
    }

    func testOffsetingMultipleTimes() {
        XCTAssertEqualConstraints(
            view.anchors.height.match((container.anchors.width + 10) + 10),
            NSLayoutConstraint(item: view, attribute: .height, toItem: container, attribute: .width, constant: 20)
        )
    }

    // MARK: Multiplying

    func testMultiplyingWidth() {
        XCTAssertEqualConstraints(
            view.anchors.width.match(container.anchors.width * 0.5),
            NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width, multiplier: 0.5)
        )
        XCTAssertEqualConstraints(
            (view.anchors.width * 2).match(container.anchors.width),
            NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width, multiplier: 0.5)
        )
    }

    func testMultiplyingMultipleTimes() {
        XCTAssertEqualConstraints(
            view.anchors.width.match((container.anchors.width * 0.5) * 0.5),
            NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width, multiplier: 0.25)
        )
        XCTAssertEqualConstraints(
            ((view.anchors.width * 2) * 2).match(container.anchors.width),
            NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width, multiplier: 0.25)
        )
    }

    func testMultiplyingBothAnchors() {
        XCTAssertEqualConstraints(
            (view.anchors.width * 0.5).match(container.anchors.width * 0.5),
            NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width, multiplier: 1)
        )
    }

    // MARK: Mixing Multiplier and Offset

    func testMixingMultiplierAndOffset() {
        XCTAssertEqualConstraints(
            view.anchors.width.match(container.anchors.width * 0.5 + 10),
            NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width, multiplier: 0.5, constant: 10)
        )
        XCTAssertEqualConstraints(
            view.anchors.width.match((container.anchors.width + 10) * 0.5),
            NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width, multiplier: 0.5, constant: 5)
        )
        XCTAssertEqualConstraints(
            view.anchors.width.match((container.anchors.width + 10) * 0.5 + 7),
            NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width, multiplier: 0.5, constant: 12)
        )
        XCTAssertEqualConstraints(
            view.anchors.width.match(((container.anchors.width + 10) * 0.5 + 7) * 2),
            NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width, multiplier: 1, constant: 24)
        )

        XCTAssertEqualConstraints(
            view.anchors.width.match(container.anchors.width + 10 * 0.5),
            NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width, multiplier: 1, constant: 5)
        )
    }
}
