//
//  NavigationAccueilViewController.swift
//  VegOresto
//
//  Created by Laurent Nicolas on 05/04/2016.
//  Copyright © 2016 Nicolas Laurent. All rights reserved.
//

import UIKit
import MBProgressHUD
import PromiseKit

class NavigationAccueilViewController: UIViewController {

    @IBOutlet weak var varIB_scrollView: UIScrollView!

    @IBOutlet weak var varIB_button_tabbar_list: UIButton!
    @IBOutlet weak var varIB_button_tabbar_maps: UIButton!

    @IBOutlet weak var varIB_contrainte_y_chevron_tabbar: NSLayoutConstraint!

    var recherche_viewController: RechercheViewController?
    var maps_viewController: MapsViewController?

    let HAUTEUR_HEADER_BAR = CGFloat(50.0)
    let HAUTEUR_TABBAR = CGFloat(60.0)
    
    // MARK: -
    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = COLOR_ORANGE
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationItem.backBarButtonItem?.title = "Retour"
        self.navigationController?.navigationBar.isTranslucent = true

        self.varIB_button_tabbar_list?.layer.cornerRadius = 6
        self.varIB_button_tabbar_maps?.layer.cornerRadius = 6

        self.varIB_button_tabbar_maps.backgroundColor = UIColor.clear
        self.varIB_button_tabbar_list.backgroundColor = UIColor.white.withAlphaComponent(0.3)

        self.varIB_contrainte_y_chevron_tabbar.constant = Device.WIDTH * 0.25 - 15

        updateDataIfNeeded()
    }

    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(animated)

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
    
    // MARK: Data Loading
    
    private func updateDataIfNeeded() {
        let showProgressIndicator = UserData.shared.getRestaurants().isEmpty
        
        if showProgressIndicator {
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        updateData(forced: false).always {
            if showProgressIndicator {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
        }
    }
    
    public func updateData(forced: Bool = false) -> Promise<Void> {
        return UserData.shared.updateDatabaseIfNeeded(forced: forced).then { () -> Void in
            self.maps_viewController?.updateDataAfterDelay()
            self.recherche_viewController?.updateDataAfterDelay()
            
            let _ = WebRequestManager.shared.loadHoraires()
        }
    }
    
    // MARK: UI Helpers
    
    private func showMapsView() {
        let frame = CGRect(x : Device.WIDTH, y: 0, width: Device.WIDTH, height: Device.HEIGHT - HAUTEUR_HEADER_BAR - HAUTEUR_TABBAR)
        
        // set the enabled categories from the Search view
        self.maps_viewController?.setEnabledCategories(self.recherche_viewController?.enabledCategories ?? Set())
        
        UIView.animate(withDuration: 0.2, animations: {
            self.varIB_scrollView.scrollRectToVisible(frame, animated: false)
            self.varIB_contrainte_y_chevron_tabbar.constant = Device.WIDTH * 0.75 - 15
            self.varIB_button_tabbar_list.backgroundColor = UIColor.clear
            self.varIB_button_tabbar_maps.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            self.view.layoutIfNeeded()
        })
    }
    
    private func showSearchView() {
        let frame = CGRect(x : 0, y: 0, width: Device.WIDTH, height: Device.HEIGHT - HAUTEUR_HEADER_BAR - HAUTEUR_TABBAR)
        
        // set the enabled categories from the Maps view
        self.recherche_viewController?.setEnabledCategories(self.maps_viewController?.enabledCategories ?? Set())
        
        UIView.animate(withDuration: 0.2, animations: {
            self.varIB_scrollView.scrollRectToVisible(frame, animated: false)
            self.varIB_contrainte_y_chevron_tabbar.constant = Device.WIDTH * 0.25 - 15
            self.varIB_button_tabbar_maps.backgroundColor = UIColor.clear
            self.varIB_button_tabbar_list.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            self.view.layoutIfNeeded()
        })
    }

    // MARK: IBActions
    
    @IBAction func touch_bt_tabbar(sender: UIButton) {
        if self.varIB_button_tabbar_maps == sender {
            showMapsView()
        } else if self.varIB_button_tabbar_list == sender {
            showSearchView()
        }
    }

    @IBAction func touch_bt_location(sender: UIButton) {
        maps_viewController?.update_region_for_user_location()
        recherche_viewController?.update_resultats_for_user_location()
    }
    
    // MARK: Segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RechercheViewController {
            self.recherche_viewController = vc
        } else if let vc = segue.destination as? MapsViewController {
            self.maps_viewController = vc
        }
    }
}
