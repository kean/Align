// The MIT License (MIT)
//
// Copyright (c) 2017-2026 Alexander Grebenyuk (github.com/kean).

import Testing
#if os(iOS) || os(tvOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
import Align

/// Everything that applies for both edges and center
@MainActor
@Suite struct AnchorAlignmentTests {
    let container = View()
    let view = View()
    let a = View()
    let b = View()

    init() {
        container.addSubview(view)
        container.addSubview(a)
        container.addSubview(b)
    }

    // MARK: Alignments

    @Test func topAlignWith() {
        test("align top with the same edge") {
            let c = view.anchors.top.equal(container.anchors.top)
            expectEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top))
        }

        test("align top with the other edge") {
            let c = view.anchors.top.equal(container.anchors.bottom)
            expectEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .bottom))
        }

        test("align top with the center") {
            let c = view.anchors.top.equal(container.anchors.centerY)
            expectEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .centerY))
        }

        test("align top with offset, relation, multiplier") {
            let c = view.anchors.top.greaterThanOrEqual(container.anchors.top * 2 + 10)
            expectEqualConstraints(c, NSLayoutConstraint(
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

    @Test func alignDifferentAnchors() {
        test("align bottom") {
            let c = view.anchors.bottom.equal(container.anchors.bottom)
            expectEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottom))
        }

        test("align leading") {
            let c = view.anchors.leading.equal(container.anchors.leading)
            expectEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .leading, toItem: container, attribute: .leading))
        }

        test("align trailing") {
            let c = view.anchors.trailing.equal(container.anchors.trailing)
            expectEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .trailing, toItem: container, attribute: .trailing))
        }

        test("align left with left") {
            let c = view.anchors.left.equal(container.anchors.left)
            expectEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .left, toItem: container, attribute: .left))
        }

        test("align right with left") {
            let c = view.anchors.right.equal(container.anchors.left)
            expectEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .right, toItem: container, attribute: .left))
        }

        test("align firstBaseline with firstBaseline") {
            expectEqualConstraints(
                view.anchors.firstBaseline.equal(container.anchors.firstBaseline),
                NSLayoutConstraint(item: view, attribute: .firstBaseline, toItem: container, attribute: .firstBaseline)
            )
        }

        test("align lastBaseline with top") {
            expectEqualConstraints(
                view.anchors.lastBaseline.equal(container.anchors.top),
                NSLayoutConstraint(item: view, attribute: .lastBaseline, toItem: container, attribute: .top)
            )
        }
    }

    @Test func spacing() {
        test("bottom to top") {
            expectEqualConstraints(
                a.anchors.bottom.spacing(10, to: b.anchors.top),
                NSLayoutConstraint(item: a, attribute: .bottom, toItem: b, attribute: .top, constant: -10)
            )
            expectEqualConstraints(
                a.anchors.bottom.spacing(10, to: b.anchors.top, relation: .greaterThanOrEqual),
                NSLayoutConstraint(item: a, attribute: .bottom, relation: .lessThanOrEqual, toItem: b, attribute: .top, constant: -10)
            )
            expectEqualConstraints(
                b.anchors.top.spacing(10, to: a.anchors.bottom),
                NSLayoutConstraint(item: b, attribute: .top, toItem: a, attribute: .bottom, constant: 10)
            )
            expectEqualConstraints(
                b.anchors.top.spacing(10, to: a.anchors.bottom, relation: .greaterThanOrEqual),
                NSLayoutConstraint(item: b, attribute: .top, relation: .greaterThanOrEqual, toItem: a, attribute: .bottom, constant: 10)
            )
        }

        test("top to top") {
            expectEqualConstraints(
                a.anchors.top.spacing(10, to: b.anchors.top),
                NSLayoutConstraint(item: a, attribute: .top, toItem: b, attribute: .top, constant: 10)
            )
            expectEqualConstraints(
                a.anchors.top.spacing(10, to: b.anchors.top, relation: .greaterThanOrEqual),
                NSLayoutConstraint(item: a, attribute: .top, relation: .greaterThanOrEqual, toItem: b, attribute: .top, constant: 10)
            )
            expectEqualConstraints(
                b.anchors.top.spacing(10, to: a.anchors.top),
                NSLayoutConstraint(item: b, attribute: .top, toItem: a, attribute: .top, constant: 10)
            )
            expectEqualConstraints(
                b.anchors.top.spacing(10, to: a.anchors.top, relation: .greaterThanOrEqual),
                NSLayoutConstraint(item: b, attribute: .top, relation: .greaterThanOrEqual, toItem: a, attribute: .top, constant: 10)
            )
        }

        // [a] [b]
        test("right to left") {
            expectEqualConstraints(
                a.anchors.right.spacing(10, to: b.anchors.left),
                NSLayoutConstraint(item: a, attribute: .right, toItem: b, attribute: .left, constant: -10)
            )
            expectEqualConstraints(
                a.anchors.right.spacing(10, to: b.anchors.left, relation: .greaterThanOrEqual),
                NSLayoutConstraint(item: a, attribute: .right, relation: .lessThanOrEqual, toItem: b, attribute: .left, constant: -10)
            )
            expectEqualConstraints(
                a.anchors.right.spacing(10, to: b.anchors.left, relation: .lessThanOrEqual),
                NSLayoutConstraint(item: a, attribute: .right, relation: .greaterThanOrEqual, toItem: b, attribute: .left, constant: -10)
            )
            expectEqualConstraints(
                b.anchors.left.spacing(10, to: a.anchors.right),
                NSLayoutConstraint(item: b, attribute: .left, toItem: a, attribute: .right, constant: 10)
            )
            expectEqualConstraints(
                b.anchors.left.spacing(10, to: a.anchors.right, relation: .greaterThanOrEqual),
                NSLayoutConstraint(item: b, attribute: .left, relation: .greaterThanOrEqual, toItem: a, attribute: .right, constant: 10)
            )
            expectEqualConstraints(
                b.anchors.left.spacing(10, to: a.anchors.right, relation: .lessThanOrEqual),
                NSLayoutConstraint(item: b, attribute: .left, relation: .lessThanOrEqual, toItem: a, attribute: .right, constant: 10)
            )
        }
    }
}
