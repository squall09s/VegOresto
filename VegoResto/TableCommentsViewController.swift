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

        return 1

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.comments.count
    }

    // swiftlint:disable:next cyclomatic_complexity
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

                let reuseIdentifier: String = "CommentCell"

                var cell: CommentTableViewCell? = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? CommentTableViewCell

                if cell == nil {
                    cell = CommentTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: reuseIdentifier)

                }

                let currentComment = self.comments[indexPath.row]

                cell?.varIB_label_comment?.text = currentComment.content

                cell?.varIB_subtitle_label?.text = currentComment.author

                return cell!

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
}
