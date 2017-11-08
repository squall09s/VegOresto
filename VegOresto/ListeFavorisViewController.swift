//
//  ListeFavorisViewController.swift
//  VegOresto
//
//  Created by Laurent Nicolas (141 - LILLE TOURCOING) on 20/06/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//

import UIKit

class ListeFavorisViewController: UIViewController {

    var recherche_viewController: RechercheViewController?

    var HAUTEUR_HEADER_BAR: CGFloat = 70.0

    override func viewDidLoad() {
        super.viewDidLoad()

        if UIDevice.current.userInterfaceIdiom == .phone && UIScreen.main.bounds.height == 812.0 {
            HAUTEUR_HEADER_BAR += 40
        }

        self.recherche_viewController = StoryboardScene.Main.rechercheViewController.instantiate()
        self.recherche_viewController?.afficherUniquementFavoris = true

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        self.navigationController?.navigationBar.barTintColor = COLOR_ORANGE
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.backBarButtonItem?.title = "Retour"
        self.navigationController?.navigationBar.isTranslucent = true

        if let vc: RechercheViewController = self.recherche_viewController {

            if vc.parent != self {

            self.addChildViewController(vc)
            self.view.addSubview(vc.view)
            vc.didMove(toParentViewController: self)
            vc.view.frame = CGRect(x : 0, y : HAUTEUR_HEADER_BAR, width : Device.WIDTH, height : Device.HEIGHT - HAUTEUR_HEADER_BAR )

            } else {

                vc.updateData()

            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillDisappear(_ animated: Bool) {

        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
