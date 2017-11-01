//
//  TableCommentsViewController.swift
//  VegoResto
//
//  Created by Laurent Nicolas (141 - LILLE TOURCOING) on 05/01/2017.
//  Copyright © 2017 Nicolas Laurent. All rights reserved.
//

import UIKit

class TableCommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var varIB_tableView: UITableView?

    var comments: [Comment] = [Comment]()
    var currentRestaurant: Restaurant?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Avis (\(self.comments.count))"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.section == self.comments.count {

            return 100

        }

        return UITableViewAutomaticDimension

    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.section == self.comments.count {

            return 60
        }

        return UITableViewAutomaticDimension

    }

    func numberOfSections(in tableView: UITableView) -> Int {

        return self.comments.count + 1

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == self.comments.count {

            return 1
        }

        return (self.comments[section].getChildsCommentsAsArray()?.count ?? 0 ) + 1
    }

    // swiftlint:disable:next cyclomatic_complexity
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == self.comments.count {

            return tableView.dequeueReusableCell(withIdentifier: "AddCommentCell", for: indexPath)

        }

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

        if indexPath.section == self.comments.count {

            self.clic_new_comment()
            return

        }

        if indexPath.row > 0 {
            return
        }

        var currentComment: Comment? = nil

        if indexPath.row == 0 {
            currentComment = self.comments[indexPath.section]
        } else {
            currentComment = self.comments[indexPath.section].getChildsCommentsAsArray()?[indexPath.row - 1 ]
        }

        self.perform(segue: StoryboardSegue.Main.segueToAddComment, sender: currentComment)

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

    func clic_new_comment() {

        self.perform(segue: StoryboardSegue.Main.segueToAddComment)

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let vc = segue.destination as? AddCommentContainerViewController {

            vc.currentRestaurant = self.currentRestaurant

            if let parentComment = sender as? Comment {
                vc.parentComment = parentComment
            }

        }

    }

}
