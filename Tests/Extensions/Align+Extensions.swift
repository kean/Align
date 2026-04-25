// The MIT License (MIT)
//
// Copyright (c) 2017-2026 Alexander Grebenyuk (github.com/kean).

#if os(iOS) || os(tvOS)

import Align
import UIKit

// MARK: - UIView + Constraints

public extension UIView {
    @discardableResult @nonobjc func addSubview<each Item: UIView>(
        _ item: repeat each Item,
        constraints: (repeat LayoutAnchors<each Item>) -> Void
    ) -> Constraints {
        _ = (repeat addSubview(each item))
        return Constraints(for: repeat each item, closure: constraints)
    }
}

#endif
