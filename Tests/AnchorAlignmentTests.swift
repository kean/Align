// The MIT License (MIT)
//
// Copyright (c) 2017-2020 Alexander Grebenyuk (github.com/kean).

import XCTest
import Align

/// Everything that applies for both edges and center
class AnchorAlignmentTests: XCTestCase {
    let container = View()
    let view = View()

    override func setUp() {
        super.setUp()

        container.addSubview(view)
    }

    // MARK: Alignments

    func testTopAlignWith() {
        test("align top with the same edge") {
            let c = view.al.top.align(with: container.al.top)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top))
        }

        test("align top with the other edge") {
            let c = view.al.top.align(with: container.al.bottom)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .bottom))
        }

        test("align top with the center") {
            let c = view.al.top.align(with: container.al.centerY)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .centerY))
        }

        test("align top with offset, relation, multiplier") {
            let c = view.al.top.align(with: container.al.top * 2 + 10, relation: .greaterThanOrEqual)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(
                item: view,
                attribute: .top,
                relatedBy: .greaterThanOrEqual,
                toItem: container,
                attribute: .top,
                multiplier: 2,
                constant: 10
            ))
        }
    }

    func testAlignDifferentAnchors() {
        test("align bottom") {
            let c = view.al.bottom.align(with: container.al.bottom)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottom))
        }

        test("align leading") {
            let c = view.al.leading.align(with: container.al.leading)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .leading, toItem: container, attribute: .leading))
        }

        test("align trailing") {
            let c = view.al.trailing.align(with: container.al.trailing)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .trailing, toItem: container, attribute: .trailing))
        }

        test("align left with left") {
            let c = view.al.left.align(with: container.al.left)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .left, toItem: container, attribute: .left))
        }

        test("align right with left") {
            let c = view.al.right.align(with: container.al.left)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .right, toItem: container, attribute: .left))
        }

        test("align firstBaseline with firstBaseline") {
            XCTAssertEqualConstraints(
                view.al.firstBaseline.align(with: container.al.firstBaseline),
                NSLayoutConstraint(item: view, attribute: .firstBaseline, toItem: container, attribute: .firstBaseline)
            )
        }

        test("align lastBaseline with top") {
            XCTAssertEqualConstraints(
                view.al.lastBaseline.align(with: container.al.top),
                NSLayoutConstraint(item: view, attribute: .lastBaseline, toItem: container, attribute: .top)
            )
        }
    }
}
