//
//  UIViewControllerExtension.swift
//  SkylieRecettes
//
//  Created by Laurent Nicolas (141 - LILLE TOURCOING) on 01/06/2016.
//  Copyright © 2016 LaurentNicolas. All rights reserved.
//

import UIKit

extension UIViewController {
    // new functionality to add to SomeType goes here

    @IBAction func tap_menu_lateral(sender: UIButton) {

        MainViewController.sharedInstance?.showLeftViewAnimated(true, completionHandler: nil)

        MainViewController.sharedInstance?.controllerMenuLateral.varIB_tableView.reloadData()

    }

}
