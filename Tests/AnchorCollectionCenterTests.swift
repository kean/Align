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
@Suite struct AnchorCollectionCenterTests {
    let container = View()
    let view = View()

    init() {
        container.addSubview(view)
    }

    @Test func core() {
        expectEqualConstraints(
            view.anchors.center.equal(container),
            [NSLayoutConstraint(item: view, attribute: .centerX, toItem: container, attribute: .centerX),
            NSLayoutConstraint(item: view, attribute: .centerY, toItem: container, attribute: .centerY)]
        )

        expectEqualConstraints(
            view.anchors.center.equal(container, offset: CGPoint(x: 10, y: 20)),
            [NSLayoutConstraint(item: view, attribute: .centerX, toItem: container, attribute: .centerX, constant: 10),
            NSLayoutConstraint(item: view, attribute: .centerY, toItem: container, attribute: .centerY, constant: 20)]
        )

        expectEqualConstraints(
            view.anchors.center.greaterThanOrEqual(container),
            [NSLayoutConstraint(item: view, attribute: .centerX, relation: .greaterThanOrEqual, toItem: container, attribute: .centerX),
            NSLayoutConstraint(item: view, attribute: .centerY, relation: .greaterThanOrEqual, toItem: container, attribute: .centerY)]
        )

        expectEqualConstraints(
            view.anchors.center.lessThanOrEqual(container),
            [NSLayoutConstraint(item: view, attribute: .centerX, relation: .lessThanOrEqual, toItem: container, attribute: .centerX),
            NSLayoutConstraint(item: view, attribute: .centerY, relation: .lessThanOrEqual, toItem: container, attribute: .centerY)]
        )
    }

    @Test func align() {
        expectEqualConstraints(
            view.anchors.center.align(with: container),
            [NSLayoutConstraint(item: view, attribute: .centerX, toItem: container, attribute: .centerX),
             NSLayoutConstraint(item: view, attribute: .centerY, toItem: container, attribute: .centerY)]
        )
    }

    @Test func alignWithSuperview() {
        expectEqualConstraints(
            view.anchors.center.align(),
            [NSLayoutConstraint(item: view, attribute: .centerX, toItem: container, attribute: .centerX),
             NSLayoutConstraint(item: view, attribute: .centerY, toItem: container, attribute: .centerY)]
        )
    }
}
