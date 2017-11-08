//
//  CreateCommentStep4ResumeViewController.swift
//  VegOresto
//
//  Created by Nicolas on 24/10/2017.
//  Copyright © 2017 Nicolas Laurent. All rights reserved.
//

import UIKit

protocol  CreateCommentStep4ResumeViewControllerProtocol {

    func starLoading()
    func stopLoading()

}

class CreateCommentStep4ResumeViewController: UIViewController, CreateCommentStep4ResumeViewControllerProtocol {

    @IBOutlet var varIB_activityIndicatorw: UIActivityIndicatorView?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.stopLoading()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func starLoading() {

        self.varIB_activityIndicatorw?.alpha = 0
        self.varIB_activityIndicatorw?.isHidden = false
        self.varIB_activityIndicatorw?.startAnimating()

        UIView.animate(withDuration: 0.5, animations: {

            self.varIB_activityIndicatorw?.alpha = 1

        }) { (_) in

        }

    }

    func stopLoading() {

        UIView.animate(withDuration: 0.5, animations: {

            self.varIB_activityIndicatorw?.alpha = 0

        }) { (_) in

            self.varIB_activityIndicatorw?.stopAnimating()
            self.varIB_activityIndicatorw?.isHidden = true
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
