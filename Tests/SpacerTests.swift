// The MIT License (MIT)
//
// Copyright (c) 2017 Alexander Grebenyuk (github.com/kean).

import XCTest
@testable import Yalta


private let spacerId = "Yalta.Spacer"

class SpacerTests: XCTestCase {
    func testSpacerWidth() {
        let spacer = Spacer(width: 10)

        let expected = [
            NSLayoutConstraint(item: spacer, attribute: .width, constant: 10, id: spacerId),
            NSLayoutConstraint(item: spacer, attribute: .height, constant: 0, priority: 42, id: spacerId)
        ]
        XCTAssertEqualConstraints(spacer.constraints, expected)
    }

    func testThatOrderDoesntMatter() {
        let spacer = Spacer(width: 10)

        let expected = [
            NSLayoutConstraint(item: spacer, attribute: .height, constant: 0, priority: 42, id: spacerId),
            NSLayoutConstraint(item: spacer, attribute: .width, constant: 10, id: spacerId)
        ]
        XCTAssertEqualConstraints(spacer.constraints, expected)
    }

    func testSpacerMinWidth() {
        let spacer = Spacer(minWidth: 10)

        let expected = [
            NSLayoutConstraint(item: spacer, attribute: .width, relation: .greaterThanOrEqual, constant: 10, id: spacerId),
            NSLayoutConstraint(item: spacer, attribute: .width, constant: 10, priority: 42, id: spacerId),
            NSLayoutConstraint(item: spacer, attribute: .height, constant: 0, priority: 42, id: spacerId)
        ]
        XCTAssertEqualConstraints(spacer.constraints, expected)
    }

    func testSpacerHeight() {
        let spacer = Spacer(height: 10)

        let expected = [
            NSLayoutConstraint(item: spacer, attribute: .height, constant: 10, id: spacerId),
            NSLayoutConstraint(item: spacer, attribute: .width, constant: 0, priority: 42, id: spacerId)
        ]
        XCTAssertEqualConstraints(spacer.constraints, expected)
    }

    func testSpacerMinHeight() {
        let spacer = Spacer(minHeight: 10)

        let expected = [
            NSLayoutConstraint(item: spacer, attribute: .height, relation: .greaterThanOrEqual, constant: 10, id: spacerId),
            NSLayoutConstraint(item: spacer, attribute: .height, constant: 10, priority: 42, id: spacerId),
            NSLayoutConstraint(item: spacer, attribute: .width, constant: 0, priority: 42, id: spacerId)
        ]
        XCTAssertEqualConstraints(spacer.constraints, expected)
    }

    func testSpacerIgnoresBackgroundColor() {
        let spacer = Spacer(width: 10)
        XCTAssertNil(spacer.backgroundColor)
        spacer.backgroundColor = UIColor.white
        XCTAssertNil(spacer.backgroundColor)
    }
}
