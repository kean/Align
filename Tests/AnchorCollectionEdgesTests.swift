// The MIT License (MIT)
//
// Copyright (c) 2017 Alexander Grebenyuk (github.com/kean).

import XCTest
import Yalta


class AnchorCollectionEdgesTests: XCTestCase {
    let container = UIView()
    let view = UIView()

    override func setUp() {
        super.setUp()

        container.addSubview(view)
    }

    func testPinToSuperview() {
        XCTAssertEqualConstraints(
            view.al.edges.pinToSuperview(),
            [NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top),
             NSLayoutConstraint(item: view, attribute: .left, toItem: container, attribute: .left),
             NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottom),
             NSLayoutConstraint(item: view, attribute: .right, toItem: container, attribute: .right)]
        )
    }

    func testPinToSuperviewWithInsets() {
        let insets = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
        XCTAssertEqualConstraints(
            view.al.edges.pinToSuperview(insets: insets),
            [NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top, constant: 1),
             NSLayoutConstraint(item: view, attribute: .left, toItem: container, attribute: .left, constant: 2),
             NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottom, constant: -3),
             NSLayoutConstraint(item: view, attribute: .right, toItem: container, attribute: .right, constant: -4)]
        )
    }

    func testPinToSuperviewLessThanOrEqual() {
        XCTAssertEqualConstraints(
            view.al.edges.pinToSuperview(relation: .greaterThanOrEqual),
            [NSLayoutConstraint(item: view, attribute: .top, relation: .greaterThanOrEqual, toItem: container, attribute: .top),
             NSLayoutConstraint(item: view, attribute: .left, relation: .greaterThanOrEqual,toItem: container, attribute: .left),
             NSLayoutConstraint(item: view, attribute: .bottom, relation: .lessThanOrEqual, toItem: container, attribute: .bottom),
             NSLayoutConstraint(item: view, attribute: .right, relation: .lessThanOrEqual, toItem: container, attribute: .right)]
        )
    }

    func testPinToSuperviewGreaterThanOrEqual() { // doens't make sense in practice really
        XCTAssertEqualConstraints(
            view.al.edges.pinToSuperview(relation: .lessThanOrEqual),
            [NSLayoutConstraint(item: view, attribute: .top, relation: .lessThanOrEqual, toItem: container, attribute: .top),
             NSLayoutConstraint(item: view, attribute: .left, relation: .lessThanOrEqual,toItem: container, attribute: .left),
             NSLayoutConstraint(item: view, attribute: .bottom, relation: .greaterThanOrEqual, toItem: container, attribute: .bottom),
             NSLayoutConstraint(item: view, attribute: .right, relation: .greaterThanOrEqual, toItem: container, attribute: .right)]
        )
    }

    func testPinToSuperviewMargins() {
        XCTAssertEqualConstraints(
            view.al.edges.pinToSuperviewMargins(),
            [NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .topMargin),
             NSLayoutConstraint(item: view, attribute: .left, toItem: container, attribute: .leftMargin),
             NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottomMargin),
             NSLayoutConstraint(item: view, attribute: .right, toItem: container, attribute: .rightMargin)]
        )
    }

    func testPinToSuperviewAlongAxis() {
        XCTAssertEqualConstraints(
            view.al.edges(.top, .bottom).pinToSuperview(),
            [NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top),
             NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottom)]
        )
        XCTAssertEqualConstraints(
            view.al.edges(.left, .right).pinToSuperview(),
            [NSLayoutConstraint(item: view, attribute: .left, toItem: container, attribute: .left),
             NSLayoutConstraint(item: view, attribute: .right, toItem: container, attribute: .right)]
        )
    }

    func testPinToSuperviewLayoutGuide() {
        XCTAssertEqualConstraints(
            view.al.edges.pin(to: container.layoutMarginsGuide),
            [NSLayoutConstraint(item: view, attribute: .top, toItem: container.layoutMarginsGuide, attribute: .top),
             NSLayoutConstraint(item: view, attribute: .left, toItem: container.layoutMarginsGuide, attribute: .left),
             NSLayoutConstraint(item: view, attribute: .bottom, toItem: container.layoutMarginsGuide, attribute: .bottom),
             NSLayoutConstraint(item: view, attribute: .right, toItem: container.layoutMarginsGuide, attribute: .right)]
        )
    }
}

