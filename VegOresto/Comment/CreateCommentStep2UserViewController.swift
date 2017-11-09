//
//  CreateCommentStep2UserViewController.swift
//  VegOresto
//
//  Created by Nicolas on 24/10/2017.
//  Copyright © 2017 Nicolas Laurent. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

protocol  CreateCommentStep2UserViewControllerProtocol {

    func getCurrentEmail() -> String
    func getCurrentName() -> String

    func get_tfName() -> UITextField?
    func get_tfMail() -> UITextField?
}

class CreateCommentStep2UserViewController: UIViewController, CreateCommentStep2UserViewControllerProtocol, UITextFieldDelegate {

    @IBOutlet weak var tf_name: SkyFloatingLabelTextFieldWithIcon?
    @IBOutlet weak var tf_mail: SkyFloatingLabelTextFieldWithIcon?

    func get_tfName() -> UITextField? {
        return self.tf_name
    }

    func get_tfMail() -> UITextField? {
        return self.tf_mail
    }

    func getCurrentEmail() -> String {

        return self.tf_mail?.text ?? ""

    }

    func getCurrentName() -> String {

        return self.tf_name?.text ?? ""

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let _user_mail = UserDefaults.standard.string(forKey: "USER_SAVE_MAIL") {

            self.tf_mail?.text = _user_mail

        }

        if let _user_name = UserDefaults.standard.string(forKey: "USER_SAVE_NAME") {

            self.tf_name?.text = _user_name

        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField == self.tf_name {

            textField.resignFirstResponder()
            self.tf_mail?.becomeFirstResponder()

        } else if textField == self.tf_mail {

            textField.resignFirstResponder()

            if let parent = self.parent as? AddCommentContainerViewController {
                parent.nextAction(sender: nil)
            }

        }

        return true

    }

}
