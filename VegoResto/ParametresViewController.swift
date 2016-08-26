//
//  ParametresViewController.swift
//  SkylieRecettes
//
//  Created by Laurent Nicolas (141 - LILLE TOURCOING) on 09/08/2016.
//  Copyright © 2016 LaurentNicolas. All rights reserved.
//

import UIKit
import VTAcknowledgementsViewController



class ParametresViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func viewWillAppear(animated: Bool) {

        super.viewWillAppear(animated)

        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }






    @IBAction func clic_nous_contacter(sender: UIButton) {




                if let suject = "CONTACT - VégOresto iOS ".stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet() ) {

                    var sujet2 = "" + suject

                    if let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {

                        sujet2 = sujet2 + "[" + version + "]"

                    }

                    let str = "mailto:squall.leonhart@me.com,contact@L214.com?subject=" + sujet2

                    let url = NSURL(string: str)
                    UIApplication.sharedApplication().openURL(url!)

                }


    }

    @IBAction func clic_licences(sender: UIButton) {

        if let vc: VTAcknowledgementsViewController = VTAcknowledgementsViewController(fileNamed: "Pods-VegoResto-acknowledgements") {

            vc.headerText = "Remerciements et Licences"
            vc.title = ""

            let customLicense0: VTAcknowledgement = VTAcknowledgement(title: "", text: "")
            customLicense0.title = "SwiftLint"
            // swiftlint:disable:next line_length
            customLicense0.text  = "The MIT License (MIT)\n\nCopyright (c) 2015 Realm Inc.\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."


            let customLicense0b: VTAcknowledgement = VTAcknowledgement(title: "", text: "")
            customLicense0b.title = "LGSideMenuController"
            // swiftlint:disable:next line_length
            customLicense0b.text  = "The MIT License (MIT)\n\nCopyright (c) 2015 Grigory Lutkov <Friend.LGA@gmail.com>\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\n\nTHE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."


            let customLicense1: VTAcknowledgement = VTAcknowledgement(title: "", text: "")
            customLicense1.title = "UIImage+ImageEffects"
            customLicense1.text  = "Used UIImage+ImageEffects (Extentions) of Created by Aaron Pang, achiving Bluring effect to headerView"


            let customLicense2: VTAcknowledgement = VTAcknowledgement(title: "", text: "")
            customLicense2.title = "Freepik"
            customLicense2.text  = "Icons [Gastronomy-Collection] : designed by Freepik and distributed by Flaticon"

            vc.acknowledgements?.appendContentsOf( [customLicense0, customLicense0b, customLicense1, customLicense2] )


            self.navigationController?.pushViewController(vc, animated: true)

            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
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
