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

        self.navigationController?.navigationBar.barTintColor = COLOR_ORANGE
        self.navigationController?.navigationBar.tintColor = UIColor.white
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

    @IBAction func contactButtonPressed(sender: UIButton) {
        let version = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "Unknown"
        let prefix: String = "Appli VegOresto iPhone [\(version)]"

        guard let subject = prefix.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else {
            return
        }

        let str = "mailto:contact@L214.com?subject=" + subject
        if let url = URL(string: str) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    @IBAction func facebookButtonPressed(sender: Any) {
        let facebookAppUrl = URL(string: "fb://profile/854933141235331")!
        let facebookWebUrl = URL(string: "https://www.facebook.com/vegoresto")!
        if UIApplication.shared.canOpenURL(facebookAppUrl) {
            UIApplication.shared.open(facebookAppUrl, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(facebookWebUrl, options: [:], completionHandler: nil)
        }
    }

    @IBAction func twitterButtonPressed(sender: Any) {
        let twitterAppUrl = URL(string: "twitter://user?screen_name=VegOresto")!
        let twitterWebUrl = URL(string: "https://twitter.com/VegOresto")!
        if UIApplication.shared.canOpenURL(twitterAppUrl) {
            UIApplication.shared.open(twitterAppUrl, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(twitterWebUrl, options: [:], completionHandler: nil)
        }
    }

    @IBAction func instagramButtonPressed(sender: Any) {
        let instagramAppUrl = URL(string: "instagram://user?username=vegoresto")!
        let instagramWebUrl = URL(string: "https://www.instagram.com/vegoresto/")!
        if UIApplication.shared.canOpenURL(instagramAppUrl) {
            UIApplication.shared.open(instagramAppUrl, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(instagramWebUrl, options: [:], completionHandler: nil)
        }
    }

    @IBAction func licenseButtonPressed(sender: UIButton) {
        if let vc: VTAcknowledgementsViewController = VTAcknowledgementsViewController(fileNamed: "Pods-VegOresto-acknowledgements") {
            vc.headerText = "Licences et remerciements"
            vc.title = ""

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
