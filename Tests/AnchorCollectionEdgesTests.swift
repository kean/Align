// The MIT License (MIT)
//
// Copyright (c) 2017-2020 Alexander Grebenyuk (github.com/kean).

import XCTest
import Align

class AnchorCollectionEdgesTests: XCTestCase {
    let container = View()
    let view = View()

    override func setUp() {
        super.setUp()

        container.addSubview(view)
    }

    func testPinToSuperview() {
        XCTAssertEqualConstraints(
            view.anchors.edges.pin(),
            [NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top),
             NSLayoutConstraint(item: view, attribute: .leading, toItem: container, attribute: .leading),
             NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottom),
             NSLayoutConstraint(item: view, attribute: .trailing, toItem: container, attribute: .trailing)]
        )
    }

    func testPinToSuperviewAbsolute() {
        XCTAssertEqualConstraints(
            view.anchors.edges.absolute().pin(),
            [NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top),
             NSLayoutConstraint(item: view, attribute: .left, toItem: container, attribute: .left),
             NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottom),
             NSLayoutConstraint(item: view, attribute: .right, toItem: container, attribute: .right)]
        )
    }

    func testPinToSuperviewWithInsets() {
        let insets = EdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
        XCTAssertEqualConstraints(
            view.anchors.edges.pin(insets: insets),
            [NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top, constant: 1),
             NSLayoutConstraint(item: view, attribute: .leading, toItem: container, attribute: .leading, constant: 2),
             NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottom, constant: -3),
             NSLayoutConstraint(item: view, attribute: .trailing, toItem: container, attribute: .trailing, constant: -4)]
        )
    }

    func testPinToSuperviewLessThanOrEqualAlignmentCenter() {
        XCTAssertEqualConstraints(
            view.anchors.edges.pin(alignment: .center),
            [NSLayoutConstraint(item: view, attribute: .top, relation: .greaterThanOrEqual, toItem: container, attribute: .top),
             NSLayoutConstraint(item: view, attribute: .leading, relation: .greaterThanOrEqual,toItem: container, attribute: .leading),
             NSLayoutConstraint(item: view, attribute: .bottom, relation: .lessThanOrEqual, toItem: container, attribute: .bottom),
             NSLayoutConstraint(item: view, attribute: .trailing, relation: .lessThanOrEqual, toItem: container, attribute: .trailing),
             NSLayoutConstraint(item: view, attribute: .centerX, relation: .equal, toItem: container, attribute: .centerX),
             NSLayoutConstraint(item: view, attribute: .centerY, relation: .equal, toItem: container, attribute: .centerY)]
        )
    }

    func testPinToSuperviewLessThanOrEqual() {
        XCTAssertEqualConstraints(
            view.anchors.edges.lessThanOrEqual(container.anchors.edges),
            [NSLayoutConstraint(item: view, attribute: .top, relation: .greaterThanOrEqual, toItem: container, attribute: .top),
             NSLayoutConstraint(item: view, attribute: .leading, relation: .greaterThanOrEqual,toItem: container, attribute: .leading),
             NSLayoutConstraint(item: view, attribute: .bottom, relation: .lessThanOrEqual, toItem: container, attribute: .bottom),
             NSLayoutConstraint(item: view, attribute: .trailing, relation: .lessThanOrEqual, toItem: container, attribute: .trailing)]
        )
    }

    func testPinToSuperviewAlongAxis() {
         XCTAssertEqualConstraints(
            view.anchors.edges.pin(axis: .vertical),
             [NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top),
              NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottom)]
         )
         XCTAssertEqualConstraints(
             view.anchors.edges.pin(axis: .horizontal),
             [NSLayoutConstraint(item: view, attribute: .leading, toItem: container, attribute: .leading),
              NSLayoutConstraint(item: view, attribute: .trailing, toItem: container, attribute: .trailing)]
         )
     }
}

