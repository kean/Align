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
        view.anchors.left.equal(container.anchors.left)
        view.anchors.left.equal(container.anchors.left + 10)
        view.anchors.left.lessThanOrEqual(container.anchors.left)

        // Edge
        view.anchors.left.pin()
        view.anchors.left.pin(inset: 10)
        view.anchors.left.pin(to: container)

        // Center
        view.anchors.centerX.align()

        // Dimension
        view.anchors.width.equal(10)
        view.anchors.width.greaterThanOrEqual(10)
        view.anchors.width.equal(container.anchors.width)

        // AnchorCollectionEdges
        view.anchors.edges.pin()
        view.anchors.edges.pin(insets: EdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
        view.anchors.edges.pin(to: container)
        view.anchors.edges.pin(axis: .horizontal)

        // AnchorCollectionCenter
        view.anchors.center.align()
        view.anchors.center.align(with: container)

        // AnchorCollectionSize
        view.anchors.size.equal(container)
    }
}
