import UIKit

class ViewController: UIViewController {
   
    var gamesVc: GamesVc? = GamesVc()

    override func viewDidLoad() {
        super.viewDidLoad()

        if let gamesVc = gamesVc {
            addChild(gamesVc)
            gamesVc.view.frame = view.bounds  // Adjust the frame of the child view controller
            view.addSubview(gamesVc.view)
            gamesVc.didMove(toParent: self)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        gamesVc?.view.center = view.center
    }
}
