//
//  NavigationAccueilViewController.swift
//  VegoResto
//
//  Created by Laurent Nicolas on 05/04/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//

import UIKit
import MBProgressHUD

class NavigationAccueilViewController: UIViewController {

    @IBOutlet weak var varIB_scrollView: UIScrollView!

    @IBOutlet weak var varIB_button_tabbar_list: UIButton!
    @IBOutlet weak var varIB_button_tabbar_maps: UIButton!

    @IBOutlet weak var varIB_contrainte_y_chevron_tabbar: NSLayoutConstraint!

    var recherche_viewController: RechercheViewController?
    var maps_viewController: MapsViewController?

    let HAUTEUR_HEADER_BAR = CGFloat(70.0)
    let HAUTEUR_TABBAR = CGFloat(60.0)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.recherche_viewController = StoryboardScene.Main.instantiateRechercheViewController()
        self.maps_viewController = StoryboardScene.Main.instantiateMapsViewController()

        self.varIB_button_tabbar_list.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        self.varIB_button_tabbar_maps.backgroundColor = UIColor.clear

        self.varIB_contrainte_y_chevron_tabbar.constant = Device.WIDTH * 0.25 - 15

        MBProgressHUD.showAdded(to: self.view, animated: true)

        WebRequestManager.shared.listRestaurant(success: { (listRestaurant) in

            print("WebRequestManager.shared.listRestaurant success : \(listRestaurant)")
            MBProgressHUD.hide(for: self.view, animated: true)

            self.maps_viewController?.updateDataAfterDelay()
            self.recherche_viewController?.updateDataAfterDelay()

            WebRequestManager.shared.loadHoraires(success: {

            }, failure: { (_) in

            })

        }, failure: { (_) in

            print("WebRequestManager.shared.listRestaurant Error")
            MBProgressHUD.hide(for: self.view, animated: true)

        })

    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

        self.varIB_scrollView.contentSize = CGSize(width : Device.WIDTH * 2.0, height : self.varIB_scrollView.frame.height  )

        if let vc: RechercheViewController = self.recherche_viewController {

            if vc.parent != self {

            self.addChildViewController(vc)

                self.varIB_scrollView.addSubview(vc.view)
            vc.didMove(toParentViewController: self)
            vc.view.frame = CGRect(x : Device.WIDTH, y : 0, width : Device.WIDTH, height : Device.HEIGHT - HAUTEUR_HEADER_BAR - HAUTEUR_TABBAR )

            }

        }

        if let vc: MapsViewController = self.maps_viewController {

            if vc.parent != self {

            self.addChildViewController(vc)
            self.varIB_scrollView.addSubview(vc.view)
            vc.didMove(toParentViewController: self)
            vc.view.frame = CGRect(x : 0, y : 0, width : Device.WIDTH, height : Device.HEIGHT - HAUTEUR_HEADER_BAR - HAUTEUR_TABBAR )

            }
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

    @IBAction func touch_bt_tabbar(sender: UIButton) {

        if self.varIB_button_tabbar_maps == sender {

            let frame = CGRect( x : 0, y : 0, width : Device.WIDTH, height : Device.HEIGHT - HAUTEUR_HEADER_BAR - HAUTEUR_TABBAR )

            self.varIB_scrollView.scrollRectToVisible( frame, animated: true )

            self.varIB_contrainte_y_chevron_tabbar.constant = Device.WIDTH * 0.25 - 15

            UIView.animate(withDuration: 0.2, animations: {

                self.varIB_button_tabbar_list.backgroundColor = UIColor.white.withAlphaComponent(0.3)
                self.varIB_button_tabbar_maps.backgroundColor = UIColor.clear

            })

        } else if self.varIB_button_tabbar_list == sender {

            let frame = CGRect(x : Device.WIDTH, y : 0, width : Device.WIDTH, height :Device.HEIGHT - HAUTEUR_HEADER_BAR - HAUTEUR_TABBAR )

            self.varIB_scrollView.scrollRectToVisible( frame, animated: true )

            self.varIB_contrainte_y_chevron_tabbar.constant = Device.WIDTH * 0.75 - 15

            UIView.animate(withDuration: 0.2, animations: {

                self.varIB_button_tabbar_maps.backgroundColor = UIColor.white.withAlphaComponent(0.3)
                self.varIB_button_tabbar_list.backgroundColor = UIColor.clear

            })

        }

        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func touch_bt_location(sender: UIButton) {

        if let nc_maps = self.maps_viewController {

            nc_maps.update_region_for_user_location()

        }

        if let nc_recherche = self.recherche_viewController {

            nc_recherche.update_resultats_for_user_location()

        }

    }

}
