// The MIT License (MIT)
//
// Copyright (c) 2017-2026 Alexander Grebenyuk (github.com/kean).

import XCTest
import Align

// WARNING: Don't forget to compile for Release mode!
@available(iOS 16, tvOS 16, macOS 13, watchOS 9, *)
@MainActor
final class AnchorPerformanceTests: XCTestCase {
    func testPin() {
        let view = View()
        let container = View()
        container.addSubview(view)

        let clock = ContinuousClock()
        let elapsed = clock.measure {
            for _ in 0...10_000 {
                view.anchors.edges.pin(alignment: .center)
            }
        }
        print("testPin: \(format(elapsed))")
    }

    func testPinUsingConstraints() {
        let view = View()
        let container = View()
        container.addSubview(view)

        let clock = ContinuousClock()
        let elapsed = clock.measure {
            Constraints {
                for _ in 0...10_000 {
                    view.anchors.edges.pin(alignment: .center)
                }
            }
        }
        print("testPinUsingConstraints: \(format(elapsed))")
    }

    func testConstraintsPin() {
        let view = View()
        let container = View()
        container.addSubview(view)

        Constraints(for: view, container) { view, container in
            view.top.equal(container.top)
        }

        let clock = ContinuousClock()
        let elapsed = clock.measure {
            Constraints {
                for _ in 0...10_000 {
                    view.anchors.width.equal(view.anchors.height)
                }
            }
        }
        print("testConstraintsPin: \(format(elapsed))")
    }

    private func format(_ duration: Duration) -> String {
        let ms = Double(duration.components.seconds) * 1_000 + Double(duration.components.attoseconds) / 1e15
        return String(format: "%.3f ms", ms)
    }
}
