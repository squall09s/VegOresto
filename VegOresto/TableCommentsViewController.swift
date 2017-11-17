//
//  TableCommentsViewController.swift
//  VegOresto
//
//  Created by Laurent Nicolas (141 - LILLE TOURCOING) on 05/01/2017.
//  Copyright © 2017 Nicolas Laurent. All rights reserved.
//

import UIKit

class TableCommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var varIB_tableView: UITableView?

    var commentsDataKeysSorted = [Comment]()
    var commentsData = [Comment: [Comment]]()

    var currentRestaurant: Restaurant?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshData()

        let button: UIButton = UIButton(type: .custom)
        button.setImage(UIImage(named: "add_post")!, for: .normal)
        button.tintColor = UIColor.white
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.contentMode = .scaleAspectFit

        button.widthAnchor.constraint(equalToConstant: 25.0).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25.0).isActive = true

        let barButton = UIBarButtonItem(customView: button)
        barButton.customView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clic_new_comment)))

        self.navigationItem.rightBarButtonItem = barButton

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.section == self.commentsData.count {

            return 100

        }

        return UITableViewAutomaticDimension

    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.section == self.commentsData.count {

            return 60
        }

        return UITableViewAutomaticDimension

    }

    func numberOfSections(in tableView: UITableView) -> Int {

        return self.commentsDataKeysSorted.count + 1

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == self.commentsData.count {

            return 1
        }

        return (self.commentsData[self.commentsDataKeysSorted[section]]?.count ?? 0 ) + 1
    }

    // swiftlint:disable:next cyclomatic_complexity
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.section == self.commentsDataKeysSorted.count {

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
            currentComment = self.commentsDataKeysSorted[indexPath.section]

        } else {
            currentComment = self.commentsData[self.commentsDataKeysSorted[indexPath.section]]?[indexPath.row - 1 ]
        }

        cell?.varIB_label_comment?.text = currentComment?.content ?? ""

        cell?.setImage(url: currentComment?.imageUrl)

        cell?.varIB_subtitle_label?.text = currentComment?.author ?? ""

        cell?.setRating(ratting: currentComment?.rating?.intValue ?? 0)

        return cell!

    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == self.commentsDataKeysSorted.count {

            self.clic_new_comment()
            return

        }

        if indexPath.row > 0 {
            return
        }

        var currentComment: Comment? = nil

        if indexPath.row == 0 {
            currentComment = self.commentsDataKeysSorted[indexPath.section]
        } else {
            currentComment = self.commentsData[self.commentsDataKeysSorted[indexPath.section]]?[indexPath.row - 1 ]
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

            vc.completionSend = { (comment: Comment) in

                self.refreshData()
                self.varIB_tableView?.reloadData()

            }

        }

    }

    func refreshData() {
        guard let restaurant = self.currentRestaurant else {
            return
        }

        var rootsComment = [Comment]()
        var childsComment = [Comment]()

        for tmpComment in restaurant.commentsArray {
            if (tmpComment.parentId?.intValue ?? 0) <= 0 {
                rootsComment.append(tmpComment)
            } else {
                childsComment.append(tmpComment)
            }
        }

        commentsData.removeAll()

        for tmpRootsComment in rootsComment {

            commentsData[tmpRootsComment] = childsComment.flatMap({ (tmpChildComment) -> Comment? in

                if tmpChildComment.parentId?.intValue == tmpRootsComment.ident?.intValue {
                    return tmpChildComment
                }
                return nil
            })
        }

        commentsDataKeysSorted.removeAll()

        commentsDataKeysSorted = commentsData.flatMap({ (dataRoots) -> Comment? in
            return dataRoots.key
        }).sorted(by: { (comment1, comment2) -> Bool in
            return (comment1.ident?.intValue ?? 0 ) < (comment2.ident?.intValue ?? 0 )
        })

        self.title = "Avis (\(self.commentsDataKeysSorted.count))"

    }

}
