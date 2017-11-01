//
//  CreateCommentStep1ViewController.swift
//  VegoResto
//
//  Created by Nicolas on 24/10/2017.
//  Copyright © 2017 Nicolas Laurent. All rights reserved.
//

import UIKit

protocol CreateCommentStep1ViewControllerProtocol {

    func getContent() -> String
    func getVote() -> Int

}

class CreateCommentStep1ViewController: UIViewController, CreateCommentStep1ViewControllerProtocol {

    var tempRatting = 1

    @IBOutlet var varIB_label_placeholder: UILabel?

    @IBOutlet var varIB_starRating0: UIButton?
    @IBOutlet var varIB_starRating1: UIButton?
    @IBOutlet var varIB_starRating2: UIButton?
    @IBOutlet var varIB_starRating3: UIButton?
    @IBOutlet var varIB_starRating4: UIButton?

    @IBOutlet var varIB_textView: UITextView?

    override func viewDidLoad() {
        super.viewDidLoad()

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

    func getContent() -> String {

        return self.varIB_textView?.text ?? ""

    }

    func getVote() -> Int {

        return tempRatting

    }

}

extension CreateCommentStep1ViewController : UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {

        self.varIB_label_placeholder?.isHidden = textView.text.characters.count != 0

    }

}
