//
//  AddCommentContainerViewController.swift
//  VegOresto
//
//  Created by Nicolas on 24/10/2017.
//  Copyright © 2017 Nicolas Laurent. All rights reserved.
//

import UIKit
import CoreData
import PromiseKit

class AddCommentContainerViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var varIB_scrollContainer: UIScrollView?
    @IBOutlet var varIB_pageControl: UIPageControl?
    @IBOutlet var varIB_title: UILabel?
    @IBOutlet var varIB_bt_cancel: UIButton?

    @IBOutlet var varIB_bt_next: UIButton?
    @IBOutlet var varIB_bt_back: UIButton?

    var completionSend : ( (Comment) -> Void )?

    var childViewControllerStep1: CreateCommentStep1ViewControllerProtocol?
    var childViewControllerStep2: CreateCommentStep2UserViewControllerProtocol?
    var childViewControllerStep3: CreateCommentStep3ImagesViewControllerProtocol?
    var childViewControllerStep4: CreateCommentStep4ResumeViewControllerProtocol?

    var parentComment: Comment?
    var currentRestaurant: Restaurant?

    var currentPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

        if let parentComment = self.parentComment {
            self.varIB_title?.text = "Répondre à \(parentComment.author ?? "")"
            self.childViewControllerStep1?.hideSectionRatting(hidden: true)
        } else {
            self.varIB_title?.text = "Nouveau Commentaire"
            self.childViewControllerStep1?.hideSectionRatting(hidden: false)
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

    @IBAction func backAction(sender: UIButton?) {

        // MARK: - Dismiss action

        if currentPage == 1 {

            self.childViewControllerStep2?.get_tfMail()?.resignFirstResponder()
            self.childViewControllerStep2?.get_tfName()?.resignFirstResponder()

        }

        if currentPage > 0 {

            if currentPage == 1 {
                UIView.animate(withDuration: 0.2, animations: {
                    sender?.alpha = 0.0
                })
            }

            self.currentPage -= 1
            self.updateScrollViewWithAnimation()

            UIView.animate(withDuration: 0.2, animations: {
                self.varIB_bt_next?.alpha = 1.0
            })

        }

    }

    @IBAction func nextAction(sender: UIButton?) {

        if currentPage == 0 {

            if (self.childViewControllerStep1?.getContent().count ?? 0) <= 5 {

                let alertController = UIAlertController(title: "Oups", message: "Tu dois entrer un commentaire avant tout !", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)

                return
            }

            self.childViewControllerStep1?.get_textView()?.resignFirstResponder()

        }

        if currentPage == 1 {

            if (self.childViewControllerStep2?.getCurrentName().count ?? 0) <= 4 {

                let alertController = UIAlertController(title: "Oups", message: "Tu dois entrer un nom d'utilisateur (minimum 5 caractères) pour poster ton commentaire !", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)

                return
            }

            if (self.childViewControllerStep2?.getCurrentEmail().count ?? 0) <= 5 || !self.isValidEmail(testStr: self.childViewControllerStep2?.getCurrentEmail() ?? "") {

                let alertController = UIAlertController(title: "Oups", message: "Tu dois entrer un email valide !", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)

                return
            }

            self.childViewControllerStep2?.get_tfMail()?.resignFirstResponder()
            self.childViewControllerStep2?.get_tfName()?.resignFirstResponder()

        }

        if currentPage == 2 {

           UIView.animate(withDuration: 0.2, animations: {
                sender?.alpha = 0.0
            })

            self.childViewControllerStep4?.starLoading()

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {

                self.sendComment()
            }

            self.currentPage += 1
            self.updateScrollViewWithAnimation()

        } else {

            UIView.animate(withDuration: 0.2, animations: {
                self.varIB_bt_back?.alpha = 1.0
            })

            self.currentPage += 1
            self.updateScrollViewWithAnimation()
        }
    }

    @IBAction func closeAction(_ sender: Any?) {

        // MARK: - Dismiss action
        self.navigationController?.popViewController(animated: true)

    }

    private func sendComment(restaurant: Restaurant, comment: Comment, image: UIImage? = nil) -> Promise<Comment> {
        // first, send image if needed
        var imageSendPromise: Promise<Void>!
        if let _image = image {
            imageSendPromise = WebRequestManager.shared.postImageMedia(image: _image).then(execute: { (imageId: String) -> Void in
                comment.temporaryImageIdentSend = imageId
            })
        }
        else {
            imageSendPromise = Promise(value: ())
        }

        // then, send comment
        return imageSendPromise.then { () -> Promise<Comment> in
            return WebRequestManager.shared.postComment(comment: comment)
        }
    }
    
    private func sendComment() {
        guard let restaurant = self.currentRestaurant else {
            return
        }

        assert(Thread.isMainThread)

        // create comment object
        let context = UserData.shared.viewContext
        let comment = Comment(context: context)
        comment.identifier = (-1) // draft comment
        comment.time = "01/02/1990"
        comment.author = self.childViewControllerStep2?.getCurrentName()
        comment.email = self.childViewControllerStep2?.getCurrentEmail()
        comment.content = self.childViewControllerStep1?.getContent()
        comment.parentId = self.parentComment?.identifier
        comment.restaurant = restaurant
        if self.parentComment == nil {
            comment.rating = NSNumber(value: self.childViewControllerStep1?.getVote() ?? 1 )
        }

        // get image
        let image = self.childViewControllerStep3?.getImage()
        
        // send image and comment
        let _ = sendComment(restaurant: restaurant, comment: comment, image: image).then(execute: { (newComment: Comment) -> Void in
            self.sendCommentDone(newComment: newComment)
        }).catch(execute: { (error: Error) in
            let alertController = UIAlertController(title: "Echec de l'envoi", message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        })
    }

    private func sendCommentDone(newComment: Comment) {
        UserDefaults.standard.set(self.childViewControllerStep2?.getCurrentEmail(), forKey: "USER_SAVE_MAIL")
        UserDefaults.standard.set(self.childViewControllerStep2?.getCurrentName(), forKey: "USER_SAVE_NAME")

        self.closeAction(nil)

        let alertController = UIAlertController(title: "C'est envoyé", message: "Commentaire envoyé.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)

        self.completionSend?(newComment)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == StoryboardSegue.Main.segueToCreateCommentStep1ViewController.rawValue {
            self.childViewControllerStep1 = segue.destination as? CreateCommentStep1ViewControllerProtocol
        } else if segue.identifier == StoryboardSegue.Main.segueToCreateCommentStep2UserViewController.rawValue {
            self.childViewControllerStep2 = segue.destination as? CreateCommentStep2UserViewControllerProtocol
        } else if segue.identifier == StoryboardSegue.Main.segueToCreateCommentStep3ImagesViewController.rawValue {
            self.childViewControllerStep3 = segue.destination as? CreateCommentStep3ImagesViewControllerProtocol
        } else if segue.identifier == StoryboardSegue.Main.segueToCreateCommentStep4ResumeViewController.rawValue {
            self.childViewControllerStep4 = segue.destination as? CreateCommentStep4ResumeViewControllerProtocol
        }

    }

    func updateScrollViewWithAnimation() {

        self.varIB_pageControl?.currentPage = self.currentPage
        self.varIB_scrollContainer?.scrollRectToVisible(CGRect(x: Device.WIDTH * CGFloat(self.currentPage), y: 0, width: Device.WIDTH, height: (self.varIB_scrollContainer?.contentSize.height)!), animated: true)

    }

    func isValidEmail(testStr: String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

}
