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
            let c = view.anchors.top.align(with: container.anchors.top)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top))
        }

        test("align top with the other edge") {
            let c = view.anchors.top.align(with: container.anchors.bottom)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .bottom))
        }

        test("align top with the center") {
            let c = view.anchors.top.align(with: container.anchors.centerY)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .centerY))
        }

        test("align top with offset, relation, multiplier") {
            let c = view.anchors.top.align(with: container.anchors.top * 2 + 10, relation: .greaterThanOrEqual)
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
            let c = view.anchors.bottom.align(with: container.anchors.bottom)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottom))
        }

        test("align leading") {
            let c = view.anchors.leading.align(with: container.anchors.leading)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .leading, toItem: container, attribute: .leading))
        }

        test("align trailing") {
            let c = view.anchors.trailing.align(with: container.anchors.trailing)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .trailing, toItem: container, attribute: .trailing))
        }

        test("align left with left") {
            let c = view.anchors.left.align(with: container.anchors.left)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .left, toItem: container, attribute: .left))
        }

        test("align right with left") {
            let c = view.anchors.right.align(with: container.anchors.left)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .right, toItem: container, attribute: .left))
        }

        test("align firstBaseline with firstBaseline") {
            XCTAssertEqualConstraints(
                view.anchors.firstBaseline.align(with: container.anchors.firstBaseline),
                NSLayoutConstraint(item: view, attribute: .firstBaseline, toItem: container, attribute: .firstBaseline)
            )
        }

        test("align lastBaseline with top") {
            XCTAssertEqualConstraints(
                view.anchors.lastBaseline.align(with: container.anchors.top),
                NSLayoutConstraint(item: view, attribute: .lastBaseline, toItem: container, attribute: .top)
            )
        }
    }
}
