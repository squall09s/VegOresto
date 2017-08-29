//
//  DemoPopUp.swift
//  AAPopUp
//
//  Created by Muhammad Ahsan on 03/01/2017.
//  Copyright © 2017 AA-Creations. All rights reserved.
//

import UIKit
import CoreData

class AddCommentPopUp: UIViewController {

    static var completionSend: ((Comment) -> Void)?

    @IBOutlet weak var demoLabel: UILabel!
    @IBOutlet weak var demoTextField: UITextField!
    @IBOutlet weak var demoTextView: UITextView!

    var currentComment: Comment?
    var tempRatting: Int = 0

    @IBOutlet var varIB_starRating0: UIButton?
    @IBOutlet var varIB_starRating1: UIButton?
    @IBOutlet var varIB_starRating2: UIButton?
    @IBOutlet var varIB_starRating3: UIButton?
    @IBOutlet var varIB_starRating4: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
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

    @IBAction func demoButtonAction(_ sender: Any) {

        let entityComment =  NSEntityDescription.entity(forEntityName: "Comment", in: UserData.sharedInstance.managedContext)

        if let new_comment = (NSManagedObject(entity: entityComment!, insertInto: UserData.sharedInstance.managedContext) as? Comment) {

            new_comment.time = "01/02/1990"
            new_comment.author = "Moi"
            new_comment.content = self.demoTextView.text

            new_comment.childsComments = NSSet()

            self.currentComment?.addChildComment(newComment: new_comment)

            if self.currentComment == nil {
                new_comment.rating = NSNumber(value: tempRatting)
            }

            AddCommentPopUp.completionSend?(new_comment)
        }

        self.closeAction(nil)

    }

    @IBAction func closeAction(_ sender: Any?) {

        // MARK: - Dismiss action

        self.dismiss(animated: true, completion: nil)

    }

    @IBAction func clicRatting(_ sender: UIButton) {

        // MARK: - Dismiss action

        let _ratting = sender.tag + 1

        self.varIB_starRating0?.setImage( UIImage(named: "img_favoris_star_off"), for: .normal)
        self.varIB_starRating1?.setImage( UIImage(named: "img_favoris_star_off"), for: .normal)
        self.varIB_starRating2?.setImage( UIImage(named: "img_favoris_star_off"), for: .normal)
        self.varIB_starRating3?.setImage( UIImage(named: "img_favoris_star_off"), for: .normal)
        self.varIB_starRating4?.setImage( UIImage(named: "img_favoris_star_off"), for: .normal)

            if _ratting > 0 {
                self.varIB_starRating0?.setImage( UIImage(named: "img_favoris_star_on"), for: .normal)
            }
            if _ratting > 1 {
                self.varIB_starRating1?.setImage( UIImage(named: "img_favoris_star_on"), for: .normal)
            }
            if _ratting > 2 {
                self.varIB_starRating2?.setImage( UIImage(named: "img_favoris_star_on"), for: .normal)
            }
            if _ratting > 3 {
                self.varIB_starRating3?.setImage( UIImage(named: "img_favoris_star_on"), for: .normal)
            }
            if _ratting > 4 {
                self.varIB_starRating4?.setImage( UIImage(named: "img_favoris_star_on"), for: .normal)
            }

        self.tempRatting = _ratting

    }

}
