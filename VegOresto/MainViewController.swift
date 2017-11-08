//
//  MainViewController.swift
//  SkylieRecettes
//
//  Created by Laurent Nicolas (141 - LILLE TOURCOING) on 31/05/2016.
//  Copyright © 2016 LaurentNicolas. All rights reserved.
//

import UIKit

class MainViewController: LGSideMenuController {

    static var sharedInstance: MainViewController?
    var isAlreadySet = false

    var controllerMenuLateral: MenuLateral = StoryboardScene.Main.menuLateral.instantiate()

    override func viewDidLoad() {

        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {

        self.setup()

    }

    func setup() {

        if isAlreadySet {
            return
        }

        Debug.log(object: "[ Setup MainViewController ]")

        MainViewController.sharedInstance = self

        let navigationController: UITabBarController = StoryboardScene.Main.navigationController.instantiate()

        self.rootViewController = navigationController

        navigationController.tabBar.isHidden = true

        self.setLeftViewEnabledWithWidth(250.0, presentationStyle: .slideAbove, alwaysVisibleOptions: [] )

        self.leftViewStatusBarStyle = .default
        self.leftViewStatusBarVisibleOptions = .onAll

        self.leftView().addSubview( self.controllerMenuLateral.view )

        isAlreadySet = true

    }

    override func leftViewWillLayoutSubviews(with size: CGSize) {

        super.leftViewWillLayoutSubviews(with: size)

        self.controllerMenuLateral.varIB_tableView.frame = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)

    }

}
