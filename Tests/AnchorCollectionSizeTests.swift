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
@Suite struct AnchorCollectionSizeTests {
    let container = View()
    let view = View()

    init() {
        container.addSubview(view)
    }

    @Test func setSize() {
        expectEqualConstraints(
            view.anchors.size.equal(CGSize(width: 5, height: 10)),
            [NSLayoutConstraint(item: view, attribute: .width, constant: 5),
             NSLayoutConstraint(item: view, attribute: .height, constant: 10)]
        )
    }

    @Test func matchSize() {
        expectEqualConstraints(
            view.anchors.size.equal(container),
            [NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width),
             NSLayoutConstraint(item: view, attribute: .height, toItem: container, attribute: .height)]
        )
    }

    @Test func matchSizeWithInsets() {
        expectEqualConstraints(
            view.anchors.size.equal(container, insets: CGSize(width: 10, height: 20)),
            [NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width, constant: -10),
             NSLayoutConstraint(item: view, attribute: .height, toItem: container, attribute: .height, constant: -20)]
        )
    }

    @Test func matchSizeMultiplier() {
        expectEqualConstraints(
            view.anchors.size.equal(container, multiplier: 2),
            [NSLayoutConstraint(item: view, attribute: .width, toItem: container, attribute: .width, multiplier: 2),
             NSLayoutConstraint(item: view, attribute: .height, toItem: container, attribute: .height, multiplier: 2)]
        )
    }
}
