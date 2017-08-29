//
//  TableCommentsViewController.swift
//  VegoResto
//
//  Created by Laurent Nicolas (141 - LILLE TOURCOING) on 05/01/2017.
//  Copyright © 2017 Nicolas Laurent. All rights reserved.
//

import UIKit

class TableCommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var varIB_title_label: UILabel!
    @IBOutlet var varIB_tableView: UITableView?

    var comments: [Comment] = [Comment]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.varIB_title_label.text = "Avis (\(self.comments.count))"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableViewAutomaticDimension

    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableViewAutomaticDimension

    }

    func numberOfSections(in tableView: UITableView) -> Int {

        return self.comments.count

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return (self.comments[section].getChildsCommentsAsArray()?.count ?? 0 ) + 1
    }

    // swiftlint:disable:next cyclomatic_complexity
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let reuseIdentifier: String

        if indexPath.row == 0 {
            reuseIdentifier = "CommentCell"
        } else {
            reuseIdentifier = "ChildCommentCell"
        }

        var cell: CommentTableViewCell? = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? CommentTableViewCell

        if cell == nil {
            cell = CommentTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: reuseIdentifier)
        }

        var currentComment: Comment? = nil

        if indexPath.row == 0 {
            currentComment = self.comments[indexPath.section]
        } else {
            currentComment = self.comments[indexPath.section].getChildsCommentsAsArray()?[indexPath.row - 1 ]
        }

        cell?.varIB_label_comment?.text = currentComment?.content ?? ""

        cell?.varIB_subtitle_label?.text = currentComment?.author ?? ""

        cell?.setRating(ratting: currentComment?.rating?.intValue ?? 0)

        return cell!

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row > 0 {
            return
        }

        let options = AAPopUp.globalOptions
        options.storyboardName = "Main"
        options.dismissTag = 9
        options.cornerRadius = 4.0
        options.animationDuration = 0.3
        options.backgroundColor = UIColor.black.withAlphaComponent(0.7)

        var currentComment: Comment? = nil

        if indexPath.row == 0 {
            currentComment = self.comments[indexPath.section]
        } else {
            currentComment = self.comments[indexPath.section].getChildsCommentsAsArray()?[indexPath.row - 1 ]
        }

        let popUps = AAPopUps<String?, String, Comment?>("Main", identifier: "AddCommentPopUp", currentComment: currentComment)

        let popup: AAPopUp = AAPopUp(popup: popUps )

        AddCommentPopUp.completionSend = { newComment in

            self.varIB_tableView?.reloadData()
        }

        popup.present { _ in
            // MARK: - View Did Appear Here

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

    @IBAction func clic_back(_ sender: Any) {

        _ = self.navigationController?.popViewController( animated: true)

    }

    @IBAction func clic_new_comment(_ sender : Any ) {

        let options = AAPopUp.globalOptions
        options.storyboardName = "Main"
        options.dismissTag = 9
        options.cornerRadius = 4.0
        options.animationDuration = 0.3
        options.backgroundColor = UIColor.black.withAlphaComponent(0.7)

        let popUps = AAPopUps<String?, String, Comment?>("Main", identifier: "AddCommentPopUp", currentComment: nil)

        let popup: AAPopUp = AAPopUp(popup: popUps )

        AddCommentPopUp.completionSend = { newComment in

            self.comments.append(newComment)
            self.varIB_tableView?.reloadData()
        }

        popup.present { _ in
            // MARK: - View Did Appear Here

        }

    }
}
