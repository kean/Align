//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
import Yalta


class MyViewController : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let logo = UILabel()
        let title = UILabel()
        let subtitle = UILabel()

        view.backgroundColor = UIColor.white
        logo.font = UIFont.systemFont(ofSize: 30)
        title.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        subtitle.font = UIFont.systemFont(ofSize: 15)
        subtitle.numberOfLines = 0

        logo.text = "⛵️"
        title.text = "Welcome to Yalta!"
        subtitle.text = "An intuitive and powerful Auto Layout"

        let labels = Stack([title, subtitle], axis: .vertical)
        let stack = Stack(logo, labels) {
            $0.spacing = 10
            $0.alignment = .top
        }

        view.addSubview(stack) {
            $0.center.alignWithSuperview()
            $0.edges(.left, .right).pinToSuperviewMargins(relation: .greaterThanOrEqual)
        }
    }
}

PlaygroundPage.current.liveView = MyViewController()
