// The MIT License (MIT)
//
// Copyright (c) 2017 Alexander Grebenyuk (github.com/kean).

import XCTest
import Yalta


class FillingTests: XCTestCase {
    let container = UIView()
    let view = UIView()

    override func setUp() {
        super.setUp()

        container.addSubview(view)
    }

    func testFillSuperview() {
        XCTAssertEqualConstraints(
            view.al.fillSuperview(),
            [NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top),
             NSLayoutConstraint(item: view, attribute: .left, toItem: container, attribute: .left),
             NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottom),
             NSLayoutConstraint(item: view, attribute: .right, toItem: container, attribute: .right)]
        )
    }

    func testFillSuperviewWithInsets() {
        XCTAssertEqualConstraints(
            view.al.fillSuperview(insets: 10),
            [NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top, constant: 10),
             NSLayoutConstraint(item: view, attribute: .left, toItem: container, attribute: .left, constant: 10),
             NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottom, constant: -10),
             NSLayoutConstraint(item: view, attribute: .right, toItem: container, attribute: .right, constant: -10)]
        )
    }

    func testFillSuperviewWithEdgeInsets() {
        let insets = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
        XCTAssertEqualConstraints(
            view.al.fillSuperview(insets: insets),
            [NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top, constant: 1),
             NSLayoutConstraint(item: view, attribute: .left, toItem: container, attribute: .left, constant: 2),
             NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottom, constant: -3),
             NSLayoutConstraint(item: view, attribute: .right, toItem: container, attribute: .right, constant: -4)]
        )
    }

    func testFillSuperviewLessThanOrEqual() {
        XCTAssertEqualConstraints(
            view.al.fillSuperview(relation: .lessThanOrEqual),
            [NSLayoutConstraint(item: view, attribute: .top, relation: .greaterThanOrEqual, toItem: container, attribute: .top),
             NSLayoutConstraint(item: view, attribute: .left, relation: .greaterThanOrEqual,toItem: container, attribute: .left),
             NSLayoutConstraint(item: view, attribute: .bottom, relation: .lessThanOrEqual, toItem: container, attribute: .bottom),
             NSLayoutConstraint(item: view, attribute: .right, relation: .lessThanOrEqual, toItem: container, attribute: .right)]
        )
    }

    func testFillSuperviewGreaterThanOrEqual() { // doens't make sense in practice really
        XCTAssertEqualConstraints(
            view.al.fillSuperview(relation: .greaterThanOrEqual),
            [NSLayoutConstraint(item: view, attribute: .top, relation: .lessThanOrEqual, toItem: container, attribute: .top),
             NSLayoutConstraint(item: view, attribute: .left, relation: .lessThanOrEqual,toItem: container, attribute: .left),
             NSLayoutConstraint(item: view, attribute: .bottom, relation: .greaterThanOrEqual, toItem: container, attribute: .bottom),
             NSLayoutConstraint(item: view, attribute: .right, relation: .greaterThanOrEqual, toItem: container, attribute: .right)]
        )
    }

    func testFillSuperviewMargins() {
        XCTAssertEqualConstraints(
            view.al.fillSuperviewMargins(),
            [NSLayoutConstraint(item: view, attribute: .top, toItem: container.layoutMarginsGuide, attribute: .top),
             NSLayoutConstraint(item: view, attribute: .left, toItem: container.layoutMarginsGuide, attribute: .left),
             NSLayoutConstraint(item: view, attribute: .bottom, toItem: container.layoutMarginsGuide, attribute: .bottom),
             NSLayoutConstraint(item: view, attribute: .right, toItem: container.layoutMarginsGuide, attribute: .right)]
        )
    }

    func testFillSuperviewAlongAxis() {
        XCTAssertEqualConstraints(
            view.al.fillSuperview(alongAxis: .vertical),
            [NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top),
             NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottom)]
        )
        XCTAssertEqualConstraints(
            view.al.fillSuperview(alongAxis: .horizontal),
            [NSLayoutConstraint(item: view, attribute: .left, toItem: container, attribute: .left),
             NSLayoutConstraint(item: view, attribute: .right, toItem: container, attribute: .right)]
        )
    }

    func testFillLayoutGuide() {
        XCTAssertEqualConstraints(
            view.al.fill(container.layoutMarginsGuide),
            [NSLayoutConstraint(item: view, attribute: .top, toItem: container.layoutMarginsGuide, attribute: .top),
             NSLayoutConstraint(item: view, attribute: .left, toItem: container.layoutMarginsGuide, attribute: .left),
             NSLayoutConstraint(item: view, attribute: .bottom, toItem: container.layoutMarginsGuide, attribute: .bottom),
             NSLayoutConstraint(item: view, attribute: .right, toItem: container.layoutMarginsGuide, attribute: .right)]
        )
    }
}

