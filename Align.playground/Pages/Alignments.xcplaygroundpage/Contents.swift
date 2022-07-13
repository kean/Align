//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport
import Align

class MyViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let container = UIView()
        container.anchors.size.set(.init(width: 200, height: 200))
        container.layer.borderColor = UIColor.red.cgColor
        container.layer.borderWidth = 2

        let subview = UIView()
        subview.layer.borderColor = UIColor.blue.cgColor
        subview.layer.borderWidth = 2
        Constraints {
            subview.anchors.size.set(.init(width: 80, height: 80)).forEach {
                $0.priority = UILayoutPriority(1)
            }
        }

        container.addSubview(subview)

        subview.anchors.edges.pin(
            insets: EdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
            alignment: Alignment(horizontal: .leading, vertical: .center)
        )

        view.addSubview(container)
        container.anchors.center.alignWithSuperview()
    }
}

PlaygroundPage.current.liveView = MyViewController()
