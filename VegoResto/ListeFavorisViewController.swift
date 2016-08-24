//
//  ListeFavorisViewController.swift
//  VegoResto
//
//  Created by Laurent Nicolas (141 - LILLE TOURCOING) on 20/06/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//

import UIKit

class ListeFavorisViewController: UIViewController {

    var recherche_viewController: RechercheViewController?

    let HAUTEUR_HEADER_BAR: CGFloat = 70.0

    override func viewDidLoad() {
        super.viewDidLoad()


        self.recherche_viewController = StoryboardScene.Main.instantiateRechercheViewController()
        self.recherche_viewController?.afficherUniquementFavoris = true


        // Do any additional setup after loading the view.
    }



    override func viewDidAppear(animated: Bool) {

        super.viewDidAppear(animated)

        if let vc: RechercheViewController = self.recherche_viewController {

            self.addChildViewController(vc)
            self.view.addSubview(vc.view)
            vc.didMoveToParentViewController(self)
            vc.view.frame = CGRect(x : 0, y : HAUTEUR_HEADER_BAR, width : Device.LARGEUR, height : Device.HAUTEUR - HAUTEUR_HEADER_BAR )
        }


    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
