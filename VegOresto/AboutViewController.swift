//
//  ParametresViewController.swift
//  SkylieRecettes
//
//  Created by Laurent Nicolas (141 - LILLE TOURCOING) on 09/08/2016.
//  Copyright © 2016 LaurentNicolas. All rights reserved.
//

import UIKit
import VTAcknowledgementsViewController

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.barTintColor = COLOR_ORANGE
        self.navigationItem.backBarButtonItem?.title = "Retour"
        self.navigationController?.navigationBar.isTranslucent = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @IBAction func contactButtonPressed(_ sender: Any) {
        let version = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "Unknown"
        let subject = "Appli VegOresto iPhone [\(version)]"
        Deeplinking.openSendEmail(to: "vegoresto@l214.com", subject: subject)
    }

    @IBAction func suggestRestaurant(_ sender: Any) {
        Deeplinking.openWebsite(url: "https://vegoresto.fr/signalement-restaurant-eligible-vegoresto/")
    }

    @IBAction func facebookButtonPressed(_ sender: Any) {
        Deeplinking.openFacebookProfile()
    }

    @IBAction func twitterButtonPressed(_ sender: Any) {
        Deeplinking.openTwitterProfile()
    }

    @IBAction func instagramButtonPressed(_ sender: Any) {
        Deeplinking.openInstagramProfile()
    }

    @IBAction func licenseButtonPressed(_ sender: Any) {
        if let vc: VTAcknowledgementsViewController = VTAcknowledgementsViewController(fileNamed: "Pods-VegOresto-acknowledgements") {
            vc.title = "Licenses Open Source"

            let customLicense0: VTAcknowledgement = VTAcknowledgement(title: "", text: "", license : nil)
            customLicense0.title = "SwiftLint"
            // swiftlint:disable:next line_length
            customLicense0.text  = "The MIT License (MIT)\n\nCopyright (c) 2015 Realm Inc.\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."

            let customLicense0b: VTAcknowledgement = VTAcknowledgement(title: "", text: "", license : nil)
            customLicense0b.title = "LGSideMenuController"
            // swiftlint:disable:next line_length
            customLicense0b.text  = "The MIT License (MIT)\n\nCopyright (c) 2015 Grigory Lutkov <Friend.LGA@gmail.com>\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."

            vc.acknowledgements?.append( contentsOf: [customLicense0, customLicense0b] )

            self.navigationController?.pushViewController(vc, animated: true)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }
}
