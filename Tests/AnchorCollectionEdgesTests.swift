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
             NSLayoutConstraint(item: view, attribute: .left, toItem: container, attribute: .left),
             NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottom),
             NSLayoutConstraint(item: view, attribute: .right, toItem: container, attribute: .right)]
        )
    }

    @available(*, deprecated)
    func testPinToSuperviewDeprecated() {
        XCTAssertEqualConstraints(
            view.anchors.edges.pinToSuperview(),
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
             NSLayoutConstraint(item: view, attribute: .left, toItem: container, attribute: .left, constant: 2),
             NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottom, constant: -3),
             NSLayoutConstraint(item: view, attribute: .right, toItem: container, attribute: .right, constant: -4)]
        )
    }

    @available(*, deprecated)
    func testPinToSuperviewWithInsetsDeprecated() {
        let insets = EdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
        XCTAssertEqualConstraints(
            view.anchors.edges.pinToSuperview(insets: insets),
            [NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top, constant: 1),
             NSLayoutConstraint(item: view, attribute: .left, toItem: container, attribute: .left, constant: 2),
             NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottom, constant: -3),
             NSLayoutConstraint(item: view, attribute: .right, toItem: container, attribute: .right, constant: -4)]
        )
    }

    func testPinToSuperviewLessThanOrEqual() {
        XCTAssertEqualConstraints(
            view.anchors.edges.pin(alignment: .center),
            [NSLayoutConstraint(item: view, attribute: .top, relation: .greaterThanOrEqual, toItem: container, attribute: .top),
             NSLayoutConstraint(item: view, attribute: .left, relation: .greaterThanOrEqual,toItem: container, attribute: .left),
             NSLayoutConstraint(item: view, attribute: .bottom, relation: .lessThanOrEqual, toItem: container, attribute: .bottom),
             NSLayoutConstraint(item: view, attribute: .right, relation: .lessThanOrEqual, toItem: container, attribute: .right),
             NSLayoutConstraint(item: view, attribute: .centerX, relation: .equal, toItem: container, attribute: .centerX),
             NSLayoutConstraint(item: view, attribute: .centerY, relation: .equal, toItem: container, attribute: .centerY)]
        )
    }

    @available(*, deprecated)
    func testPinToSuperviewLessThanOrEqualDeprecated() {
        XCTAssertEqualConstraints(
            view.anchors.edges.pinToSuperview(relation: .greaterThanOrEqual),
            [NSLayoutConstraint(item: view, attribute: .top, relation: .greaterThanOrEqual, toItem: container, attribute: .top),
             NSLayoutConstraint(item: view, attribute: .left, relation: .greaterThanOrEqual,toItem: container, attribute: .left),
             NSLayoutConstraint(item: view, attribute: .bottom, relation: .lessThanOrEqual, toItem: container, attribute: .bottom),
             NSLayoutConstraint(item: view, attribute: .right, relation: .lessThanOrEqual, toItem: container, attribute: .right)]
        )
    }

    @available(*, deprecated)
    func testPinToSuperviewGreaterThanOrEqual() { // doens't make sense in practice really
        XCTAssertEqualConstraints(
            view.anchors.edges.pinToSuperview(relation: .lessThanOrEqual),
            [NSLayoutConstraint(item: view, attribute: .top, relation: .lessThanOrEqual, toItem: container, attribute: .top),
             NSLayoutConstraint(item: view, attribute: .left, relation: .lessThanOrEqual,toItem: container, attribute: .left),
             NSLayoutConstraint(item: view, attribute: .bottom, relation: .greaterThanOrEqual, toItem: container, attribute: .bottom),
             NSLayoutConstraint(item: view, attribute: .right, relation: .greaterThanOrEqual, toItem: container, attribute: .right)]
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
             [NSLayoutConstraint(item: view, attribute: .left, toItem: container, attribute: .left),
              NSLayoutConstraint(item: view, attribute: .right, toItem: container, attribute: .right)]
         )
     }

    @available(*, deprecated)
    func testPinToSuperviewAlongAxisDeprecated() {
        XCTAssertEqualConstraints(
            view.anchors.edges(.top, .bottom).pinToSuperview(),
            [NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top),
             NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottom)]
        )
        XCTAssertEqualConstraints(
            view.anchors.edges(.left, .right).pinToSuperview(),
            [NSLayoutConstraint(item: view, attribute: .left, toItem: container, attribute: .left),
             NSLayoutConstraint(item: view, attribute: .right, toItem: container, attribute: .right)]
        )
    }

#if os(iOS) || os(tvOS)
    func testPinToSuperviewLayoutGuide() {
        XCTAssertEqualConstraints(
            view.anchors.edges.pin(to: container.layoutMarginsGuide),
            [NSLayoutConstraint(item: view, attribute: .top, toItem: container.layoutMarginsGuide, attribute: .top),
             NSLayoutConstraint(item: view, attribute: .left, toItem: container.layoutMarginsGuide, attribute: .left),
             NSLayoutConstraint(item: view, attribute: .bottom, toItem: container.layoutMarginsGuide, attribute: .bottom),
             NSLayoutConstraint(item: view, attribute: .right, toItem: container.layoutMarginsGuide, attribute: .right)]
        )
    }

    @available(*, deprecated)
    func testPinToSuperviewMargins() {
        XCTAssertEqualConstraints(
            view.anchors.edges.pinToSuperviewMargins(),
            [NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .topMargin),
             NSLayoutConstraint(item: view, attribute: .left, toItem: container, attribute: .leftMargin),
             NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottomMargin),
             NSLayoutConstraint(item: view, attribute: .right, toItem: container, attribute: .rightMargin)]
        )
    }
#endif
}

