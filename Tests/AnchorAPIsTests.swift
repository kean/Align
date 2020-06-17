// The MIT License (MIT)
//
// Copyright (c) 2017-2020 Alexander Grebenyuk (github.com/kean).

import Foundation
import XCTest
import Align

class AnchorAPITests: XCTestCase {
    let view = View()
    let container = View()

    override func setUp() {
        super.setUp()

        container.addSubview(view)
    }

    func testAPIs() {
        // Alignment
        view.anchors.left.align(with: container.anchors.left)
        view.anchors.left.align(with: container.anchors.left + 10)
        view.anchors.left.align(with: container.anchors.left, relation: .lessThanOrEqual)

        // Edge
        view.anchors.left.pinToSuperview()
        view.anchors.left.pin(to: container)
        view.anchors.left.pinToSuperview(inset: 10)
        view.anchors.left.pinToSuperview(inset: 10, relation: .greaterThanOrEqual)

        // Dimension
        view.anchors.width.set(10)
        view.anchors.width.match(container.anchors.width)

        // AnchorCollectionEdges
        view.anchors.edges.pinToSuperview()
        view.anchors.edges.pinToSuperview(insets: EdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
        view.anchors.edges.pin(to: container)
        view.anchors.edges(.left, .right).pin(to: container)

        // AnchorCollectionCenter
        view.anchors.center.alignWithSuperview()
        view.anchors.center.align(with: container.anchors.center)

        // AnchorCollectionSize
        view.anchors.size.match(container.anchors.size)
    }
}
