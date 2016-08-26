//
//  LeftViewController.swift
//  SkylieRecettes
//
//  Created by Laurent Nicolas (141 - LILLE TOURCOING) on 01/06/2016.
//  Copyright © 2016 LaurentNicolas. All rights reserved.
//

import UIKit

private let TAG_CELL_TITRE = 509
private let TAG_CELL_IMAGE = 510
private let array_titres: [String] = [ "LES RESTAURANTS", "MES FAVORIS", "PARAMÈTRES", "A PROPOS" ]

class MenuLateral: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var varIB_tableView: UITableView!




    override func viewDidLoad() {

        super.viewDidLoad()

        self.varIB_tableView.contentInset = UIEdgeInsetsMake(44.0, 0.0, 44.0, 0.0)
        self.varIB_tableView?.reloadData()

    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {


        return array_titres.count

    }

    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {


        var reuseIdentifier: String = "cell"


        let mainController: MainViewController? = UIApplication.sharedApplication().delegate?.window??.rootViewController as? MainViewController

        let kNavigationController: UITabBarController? = mainController?.rootViewController as? UITabBarController


        if (indexPath as NSIndexPath).row == kNavigationController?.selectedIndex {

            reuseIdentifier = "cell_selected"

        }

        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)


        let label_titre: UILabel? = cell.viewWithTag(TAG_CELL_TITRE) as? UILabel
        label_titre?.text = array_titres[(indexPath as NSIndexPath).row]

        let image_view: UIImageView? = cell.viewWithTag(TAG_CELL_IMAGE) as? UIImageView


        switch (indexPath as NSIndexPath).row {
        case 0:
            image_view?.image = UIImage(asset: .Img_menu_0)
        case 1:
            image_view?.image = UIImage(asset: .Img_menu_1)
        case 2:
            image_view?.image = UIImage(asset: .Img_menu_2)
        case 3:
            image_view?.image = UIImage(asset: .Img_menu_3)

        default:
            break
        }



        cell.tintColor = UIColor.blackColor()

        return cell

    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return 44

    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {



        let mainController: MainViewController? = UIApplication.sharedApplication().delegate?.window??.rootViewController as? MainViewController

        let kNavigationController: UITabBarController? = mainController?.rootViewController as? UITabBarController

        kNavigationController?.selectedIndex = (indexPath as NSIndexPath).row

        mainController?.hideLeftViewAnimated(true, completionHandler: nil)

        if (indexPath as NSIndexPath).row == 0 {

            let accueilNVC: UINavigationController? = (kNavigationController?.viewControllers?[(indexPath as NSIndexPath).row]) as? UINavigationController

            let accueilVC: NavigationAccueilViewController? = accueilNVC?.viewControllers[0] as? NavigationAccueilViewController

            accueilVC?.recherche_viewController?.updateData()

        } else if (indexPath as NSIndexPath).row == 1 {

            let listeControllersFavorisNC: UINavigationController? = (kNavigationController?.viewControllers?[(indexPath as NSIndexPath).row]) as? UINavigationController

            let listeControllersFavoris: ListeFavorisViewController? = listeControllersFavorisNC?.viewControllers[0] as? ListeFavorisViewController

            listeControllersFavoris?.recherche_viewController?.updateData()

        }

        self.runAfterDelay(0.3) {

            self.varIB_tableView.reloadData()

        }

    }


    func updateDataOnCV() {

            let mainController: MainViewController? = UIApplication.sharedApplication().delegate?.window??.rootViewController as? MainViewController

            let kNavigationController: UITabBarController? = mainController?.rootViewController as? UITabBarController



            let accueilNVC: UINavigationController? = (kNavigationController?.viewControllers?[0]) as? UINavigationController

            let accueilVC: NavigationAccueilViewController? = accueilNVC?.viewControllers[0] as? NavigationAccueilViewController

            accueilVC?.recherche_viewController?.updateData()



            let listeControllersFavorisNC: UINavigationController? = (kNavigationController?.viewControllers?[1]) as? UINavigationController

            let listeControllersFavoris: ListeFavorisViewController? = listeControllersFavorisNC?.viewControllers[0] as? ListeFavorisViewController

            listeControllersFavoris?.recherche_viewController?.updateData()



    }


    func runAfterDelay(delay: NSTimeInterval, block: dispatch_block_t) {
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue(), block)
    }

}
