//
//  DemoPopUp.swift
//  AAPopUp
//
//  Created by Muhammad Ahsan on 03/01/2017.
//  Copyright © 2017 AA-Creations. All rights reserved.
//

import UIKit
import CoreData
import ReCaptcha
import Result

class AddCommentPopUp: UIViewController {

    let recaptcha = try? ReCaptcha()

    static var completionSend: ((Comment) -> Void)?

    //@IBOutlet weak var captchaWebview: UIWebView!

    //@IBOutlet weak var demoLabel: UILabel!
    @IBOutlet weak var demoTextField: UITextField!
    @IBOutlet weak var demoTextView: UITextView!

    var currentComment: Comment?
    var currentRestaurant: Restaurant?
    var tempRatting: Int = 1

    @IBOutlet var varIB_starRating0: UIButton?
    @IBOutlet var varIB_starRating1: UIButton?
    @IBOutlet var varIB_starRating2: UIButton?
    @IBOutlet var varIB_starRating3: UIButton?
    @IBOutlet var varIB_starRating4: UIButton?

    @IBOutlet var varIB_scrollView: UIScrollView?
    @IBOutlet var varIB_viewSupportCaptcha: UIView?

    @IBOutlet var varIB_activityIndicatorw: UIActivityIndicatorView?
    @IBOutlet var varIB_btResend: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()

        recaptcha?.configureWebView { [weak self] webview in
            webview.frame = CGRect(x: 0, y: 0, width: 320, height: 500)
            webview.backgroundColor = UIColor.white
        }

        // Do any additional setup after loading the view, typically from a nib.

        if let _currentComment = self.currentComment {

            self.demoTextField.text = "Réponse à " + (_currentComment.author ?? "")

        } else {

            self.demoTextField.text = ""
            self.demoTextField.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    @IBAction func resendBtTapped(_ sender: Any) {

        self.varIB_scrollView?.scrollRectToVisible(CGRect(x: 0, y: 0, width: 320, height: 500), animated: true)

    }

    @IBAction func demoButtonAction(_ sender: Any) {

        self.demoTextField.resignFirstResponder()
        self.demoTextView.resignFirstResponder()
        self.varIB_scrollView?.scrollRectToVisible(CGRect(x: 320, y: 0, width: 320, height: 500), animated: true)

        self.varIB_activityIndicatorw?.startAnimating()
        self.varIB_btResend?.isHidden = true

        recaptcha?.validate(on: self.varIB_viewSupportCaptcha!) { result in

            if result.error != nil {

                self.varIB_scrollView?.scrollRectToVisible(CGRect(x: 0, y: 0, width: 320, height: 500), animated: true)

                let alertController = UIAlertController(title: "Erreur", message: "Chargement du Captcha impossible", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)

            } else {

                self.varIB_scrollView?.scrollRectToVisible(CGRect(x: 320 * 2.0, y: 0, width: 320, height: 500), animated: true)

                let entityComment =  NSEntityDescription.entity(forEntityName: "Comment", in: UserData.sharedInstance.managedContext)

                if let new_comment = (NSManagedObject(entity: entityComment!, insertInto: UserData.sharedInstance.managedContext) as? Comment) {

                    new_comment.time = "01/02/1990"
                    new_comment.author = "Moi"
                    new_comment.content = self.demoTextView.text

                    new_comment.childsComments = NSSet()

                    self.currentComment?.addChildComment(newComment: new_comment)

                    if self.currentComment == nil {

                        new_comment.rating = NSNumber(value: self.tempRatting)
                    }

                    if let token = try? result.dematerialize() {

                        WebRequestManager.shared.uploadComment(restaurant: self.currentRestaurant!, comment: new_comment, tokenCaptcha: token, success: {

                            AddCommentPopUp.completionSend?(new_comment)
                            self.closeAction(nil)

                            let alertController = UIAlertController(title: "C'est envoyé", message: "Commentaire envoyé.", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)

                            self.varIB_activityIndicatorw?.stopAnimating()
                            self.varIB_btResend?.isHidden = true

                        }, failure: { (_) in

                            self.varIB_scrollView?.scrollRectToVisible(CGRect(x: 0, y: 0, width: 320, height: 500), animated: true)

                            let alertController = UIAlertController(title: "Erreur", message: "Envoie du commentaire impossible", preferredStyle: .alert)
                            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)

                            self.varIB_activityIndicatorw?.stopAnimating()
                            self.varIB_btResend?.isHidden = true

                        })

                    } else {

                        self.varIB_scrollView?.scrollRectToVisible(CGRect(x: 0, y: 0, width: 320, height: 500), animated: true)

                        let alertController = UIAlertController(title: "Erreur", message: "Captcha non valide", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)

                        self.varIB_activityIndicatorw?.stopAnimating()
                        self.varIB_btResend?.isHidden = false

                    }

                }

            }

        }

    }

    @IBAction func closeAction(_ sender: Any?) {

        // MARK: - Dismiss action

        self.dismiss(animated: true, completion: nil)

    }

    @IBAction func clicRatting(_ sender: UIButton) {

        // MARK: - Dismiss action

        let _ratting = sender.tag + 1

        self.varIB_starRating0?.setImage( UIImage(named: "img_favoris_star_off_white"), for: .normal)
        self.varIB_starRating1?.setImage( UIImage(named: "img_favoris_star_off_white"), for: .normal)
        self.varIB_starRating2?.setImage( UIImage(named: "img_favoris_star_off_white"), for: .normal)
        self.varIB_starRating3?.setImage( UIImage(named: "img_favoris_star_off_white"), for: .normal)
        self.varIB_starRating4?.setImage( UIImage(named: "img_favoris_star_off_white"), for: .normal)

            if _ratting > 0 {
                self.varIB_starRating0?.setImage( UIImage(named: "img_favoris_star_on_white"), for: .normal)
            }
            if _ratting > 1 {
                self.varIB_starRating1?.setImage( UIImage(named: "img_favoris_star_on_white"), for: .normal)
            }
            if _ratting > 2 {
                self.varIB_starRating2?.setImage( UIImage(named: "img_favoris_star_on_white"), for: .normal)
            }
            if _ratting > 3 {
                self.varIB_starRating3?.setImage( UIImage(named: "img_favoris_star_on_white"), for: .normal)
            }
            if _ratting > 4 {
                self.varIB_starRating4?.setImage( UIImage(named: "img_favoris_star_on_white"), for: .normal)
            }

        self.tempRatting = _ratting

    }

}
