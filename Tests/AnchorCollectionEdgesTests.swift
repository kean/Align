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
            view.anchors.edges.pinToSuperview(insets: insets),
            [NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top, constant: 1),
             NSLayoutConstraint(item: view, attribute: .left, toItem: container, attribute: .left, constant: 2),
             NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottom, constant: -3),
             NSLayoutConstraint(item: view, attribute: .right, toItem: container, attribute: .right, constant: -4)]
        )
    }

    func testPinToSuperviewWithInsetsFloat() {
        XCTAssertEqualConstraints(
            view.anchors.edges.pinToSuperview(insets: 4),
            [NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top, constant: 4),
             NSLayoutConstraint(item: view, attribute: .left, toItem: container, attribute: .left, constant: 4),
             NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottom, constant: -4),
             NSLayoutConstraint(item: view, attribute: .right, toItem: container, attribute: .right, constant: -4)]
        )
    }

    func testPinToSuperviewAlongAxis() {
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

