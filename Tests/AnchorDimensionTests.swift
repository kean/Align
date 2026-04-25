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
@Suite struct AnchorDimensionTests {
    let container = View()
    let view = View()

    init() {
        container.addSubview(view)
    }

    @Test func setWidth() {
        expectEqualConstraints(
            view.anchors.width.equal(10),
            NSLayoutConstraint(item: view, attribute: .width, constant: 10)
        )
        expectEqualConstraints(
            view.anchors.width.greaterThanOrEqual(10),
            NSLayoutConstraint(item: view, attribute: .width, relation: .greaterThanOrEqual, constant: 10)
        )
    }

    @Test func setHeight() {
        expectEqualConstraints(
            view.anchors.height.equal(10),
            NSLayoutConstraint(item: view, attribute: .height, constant: 10)
        )
        expectEqualConstraints(
            view.anchors.height.greaterThanOrEqual(10),
            NSLayoutConstraint(item: view, attribute: .height, relation: .greaterThanOrEqual, constant: 10)
        )
    }

    @Test func matchWidth() {
        expectEqualConstraints(
            view.anchors.width.equal(container.anchors.width),
            NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width)
        )
        expectEqualConstraints(
            view.anchors.width.equal(container.anchors.height), // can mix and match
            NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .height)
        )
    }

    @Test func clamp() {
        expectEqualConstraints(
            view.anchors.height.clamp(to: 10...20),
            [NSLayoutConstraint(item: view, attribute: .height, relation: .greaterThanOrEqual, constant: 10),
             NSLayoutConstraint(item: view, attribute: .height, relation: .lessThanOrEqual, constant: 20)]
        )
    }
}
