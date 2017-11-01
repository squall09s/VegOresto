//
//  AddCommentContainerViewController.swift
//  VegoResto
//
//  Created by Nicolas on 24/10/2017.
//  Copyright © 2017 Nicolas Laurent. All rights reserved.
//

import UIKit
import CoreData

class AddCommentContainerViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var varIB_scrollContainer: UIScrollView?
    @IBOutlet var varIB_pageControl: UIPageControl?
    @IBOutlet var varIB_title: UILabel?
    @IBOutlet var varIB_bt_cancel: UIButton?

    @IBOutlet var varIB_bt_next: UIButton?
    @IBOutlet var varIB_bt_back: UIButton?

    var completionSend : ( (Comment?) -> Void )?

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

    func sendComment() {

        //self.varIB_activityIndicatorw?.startAnimating()

        let entityComment =  NSEntityDescription.entity(forEntityName: "Comment", in: UserData.sharedInstance.managedContext)

        if let new_comment = (NSManagedObject(entity: entityComment!, insertInto: UserData.sharedInstance.managedContext) as? Comment) {

            new_comment.time = "01/02/1990"
            new_comment.author = "Moi"
            new_comment.content = self.childViewControllerStep1?.getContent()
            new_comment.childsComments = NSSet()

            self.parentComment?.addChildComment(newComment: new_comment)

            if self.parentComment == nil {
                new_comment.rating = NSNumber(value: self.childViewControllerStep1?.getVote() ?? 1 )
            }

            WebRequestManager.shared.uploadComment(restaurant: self.currentRestaurant!, comment: new_comment, success: {

                self.closeAction(nil)

                let alertController = UIAlertController(title: "C'est envoyé", message: "Commentaire envoyé.", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)

                //self.completionSend(nex)

            }, failure: { (_) in

                let alertController = UIAlertController(title: "Erreur", message: "Envoie du commentaire impossible", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

                UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)

            })

        }

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

}
