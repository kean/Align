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

@MainActor
@Suite struct AnchorTests {
    let container = View()
    let view = View()

    init() {
        container.addSubview(view)
    }

    @Test func constraintsCreatedByAnchorsAreInstalledAutomatically() {
        let constraint = view.anchors.top.equal(container.anchors.top)
        #expect(constraint.isActive == true)
    }

    @Test func firstViewSetToTranslatesAutoresizingMaskIntoConstraints() {
        // make sure that the precondition is always true
        view.translatesAutoresizingMaskIntoConstraints = true
        container.translatesAutoresizingMaskIntoConstraints = true
        #expect(view.translatesAutoresizingMaskIntoConstraints)
        #expect(container.translatesAutoresizingMaskIntoConstraints)

        view.anchors.top.equal(container.anchors.top)

        #expect(!view.translatesAutoresizingMaskIntoConstraints)
        #expect(container.translatesAutoresizingMaskIntoConstraints)

        view.translatesAutoresizingMaskIntoConstraints = true
        container.anchors.top.equal(view.anchors.top)

        #expect(view.translatesAutoresizingMaskIntoConstraints)
        #expect(!container.translatesAutoresizingMaskIntoConstraints)
    }

    // MARK: Offsetting

    @Test func offsettingTopAnchor() {
        let anchor = container.anchors.top + 10
        expectEqualConstraints(
            view.anchors.top.equal(anchor),
            NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top, constant: 10)
        )
        expectEqualConstraints(
            view.anchors.top.equal(anchor + 10),
            NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top, constant: 20)
        )
        expectEqualConstraints( // test that works both ways
            anchor.equal(view.anchors.top),
            NSLayoutConstraint(item: container, attribute: .top, toItem: view, attribute: .top, constant: -10)
        )
    }

    @Test func offsettingUsingOperators() {
        expectEqualConstraints(
            view.anchors.top.equal(container.anchors.top + 10),
            NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top, constant: 10)
        )
        expectEqualConstraints(
            view.anchors.top.equal(container.anchors.top - 10),
            NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top, constant: -10)
        )
    }

    @Test func offsettingRightAnchor() {
        let anchor = container.anchors.right - 10
        expectEqualConstraints(
            view.anchors.right.equal(anchor),
            NSLayoutConstraint(item: view, attribute: .right, toItem: container, attribute: .right, constant: -10)
        )
        expectEqualConstraints( // test that works both ways
            anchor.equal(view.anchors.right),
            NSLayoutConstraint(item: container, attribute: .right, toItem: view, attribute: .right, constant: 10)
        )
    }

    @Test func aligningTwoOffsetAnchors() {
        let containerTop = container.anchors.top + 10
        let viewTop = view.anchors.top + 10
        expectEqualConstraints(
            viewTop.equal(containerTop), // nobody's going to do that, but it's nice it's their
            NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top, constant: 0)
        )
    }

    @Test func offsettingWidth() {
        expectEqualConstraints(
            view.anchors.height.equal(container.anchors.width + 10),
            NSLayoutConstraint(item: view, attribute: .height, toItem: container, attribute: .width, constant: 10)
        )
        expectEqualConstraints(
            view.anchors.height.equal(container.anchors.width - 10),
            NSLayoutConstraint(item: view, attribute: .height, toItem: container, attribute: .width, constant: -10)
        )
    }

    @Test func offsetingMultipleTimes() {
        expectEqualConstraints(
            view.anchors.height.equal((container.anchors.width + 10) + 10),
            NSLayoutConstraint(item: view, attribute: .height, toItem: container, attribute: .width, constant: 20)
        )
    }

    // MARK: Multiplying

    @Test func multiplyingWidth() {
        expectEqualConstraints(
            view.anchors.width.equal(container.anchors.width * 0.5),
            NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width, multiplier: 0.5)
        )
        expectEqualConstraints(
            (view.anchors.width * 2).equal(container.anchors.width),
            NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width, multiplier: 0.5)
        )
    }

    @Test func multiplyingMultipleTimes() {
        expectEqualConstraints(
            view.anchors.width.equal((container.anchors.width * 0.5) * 0.5),
            NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width, multiplier: 0.25)
        )
        expectEqualConstraints(
            ((view.anchors.width * 2) * 2).equal(container.anchors.width),
            NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width, multiplier: 0.25)
        )
    }

    @Test func multiplyingBothAnchors() {
        expectEqualConstraints(
            (view.anchors.width * 0.5).equal(container.anchors.width * 0.5),
            NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width, multiplier: 1)
        )
    }

    // MARK: Dividing

    @Test func dividingWidth() {
        expectEqualConstraints(
            view.anchors.width.equal(container.anchors.width / 2),
            NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width, multiplier: 0.5)
        )
        expectEqualConstraints(
            (view.anchors.width / 2).equal(container.anchors.width),
            NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width, multiplier: 2)
        )
    }

    @Test func dividingMatchesMultiplyingByReciprocal() {
        expectEqualConstraints(
            view.anchors.width.equal(container.anchors.width / 4),
            NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width, multiplier: 0.25)
        )
    }

    // MARK: Mixing Multiplier and Offset

    @Test func mixingMultiplierAndOffset() {
        expectEqualConstraints(
            view.anchors.width.equal(container.anchors.width * 0.5 + 10),
            NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width, multiplier: 0.5, constant: 10)
        )
        expectEqualConstraints(
            view.anchors.width.equal((container.anchors.width + 10) * 0.5),
            NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width, multiplier: 0.5, constant: 5)
        )
        expectEqualConstraints(
            view.anchors.width.equal((container.anchors.width + 10) * 0.5 + 7),
            NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width, multiplier: 0.5, constant: 12)
        )
        expectEqualConstraints(
            view.anchors.width.equal(((container.anchors.width + 10) * 0.5 + 7) * 2),
            NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width, multiplier: 1, constant: 24)
        )

        expectEqualConstraints(
            view.anchors.width.equal(container.anchors.width + 10 * 0.5),
            NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width, multiplier: 1, constant: 5)
        )
    }
}
