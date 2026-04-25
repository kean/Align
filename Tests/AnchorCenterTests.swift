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
@Suite struct AnchorCenterTests {
    let container = View()
    let view = View()

    init() {
        container.addSubview(view)
    }

    // MARK: Align With Superview

    @Test func alignWithSuperview() {
        expectEqualConstraints(
            view.anchors.centerX.align(),
            NSLayoutConstraint(item: view, attribute: .centerX, toItem: container, attribute: .centerX)
        )
        expectEqualConstraints(
            view.anchors.centerY.align(),
            NSLayoutConstraint(item: view, attribute: .centerY, toItem: container, attribute: .centerY)
        )
        expectEqualConstraints(
            view.anchors.centerY.align(offset: -10),
            NSLayoutConstraint(item: view, attribute: .centerY, toItem: container, attribute: .centerY, constant: -10)
        )
    }
}
