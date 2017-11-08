//
//  VGAbstractFilterViewController.swift
//  VegOresto
//
//  Created by Nicolas on 07/11/2017.
//  Copyright © 2017 Nicolas Laurent. All rights reserved.
//

import UIKit
import BEMCheckBox

class VGAbstractFilterViewController: UIViewController {

    let colorUnselected = UIColor.lightGray

    @IBOutlet weak var varIB_check_categorie_1: BEMCheckBox?
    @IBOutlet weak var varIB_check_categorie_2: BEMCheckBox?
    @IBOutlet weak var varIB_check_categorie_3: BEMCheckBox?

    @IBOutlet weak var varIB_bt_filtre_categorie_1: UIButton!
    @IBOutlet weak var varIB_bt_filtre_categorie_2: UIButton!
    @IBOutlet weak var varIB_bt_filtre_categorie_3: UIButton!

    @IBOutlet weak var varIB_separator_categorie_1: UIView!
    @IBOutlet weak var varIB_separator_categorie_2: UIView!
    @IBOutlet weak var varIB_separator_categorie_3: UIView!

    @IBOutlet weak var varIB_label_categorie_1: UILabel!
    @IBOutlet weak var varIB_label_categorie_2: UILabel!
    @IBOutlet weak var varIB_label_categorie_3: UILabel!

    var filtre_categorie_Vegetarien_active = true
    var filtre_categorie_Vegan_active = true
    var filtre_categorie_VeganFriendly_active = true

    @IBAction func touch_bt_categorie(sender: UIButton) {

        if sender == self.varIB_bt_filtre_categorie_1 {

            if self.filtre_categorie_Vegetarien_active == false || ( self.filtre_categorie_Vegan_active || self.filtre_categorie_VeganFriendly_active ) {
                self.filtre_categorie_Vegetarien_active = !(self.filtre_categorie_Vegetarien_active)
            }
        } else if sender == self.varIB_bt_filtre_categorie_2 {

            if self.filtre_categorie_Vegan_active == false || ( self.filtre_categorie_Vegetarien_active || self.filtre_categorie_VeganFriendly_active ) {
                self.filtre_categorie_Vegan_active = !(self.filtre_categorie_Vegan_active)
            }
        } else if sender == self.varIB_bt_filtre_categorie_3 {

            if self.filtre_categorie_VeganFriendly_active == false || ( self.filtre_categorie_Vegan_active || self.filtre_categorie_Vegetarien_active ) {
                self.filtre_categorie_VeganFriendly_active = !(self.filtre_categorie_VeganFriendly_active)
            }
        }

        let MidWidthSeparator = ((Device.WIDTH - 40.0 ) / 3.0 ) / 2.0

        if self.filtre_categorie_Vegetarien_active {
            if self.varIB_check_categorie_1!.on == false {
                self.varIB_check_categorie_1?.setOn(true, animated: true)
                UIView.animate(withDuration: 0.5, animations: {
                    self.varIB_label_categorie_1?.textColor = COLOR_VIOLET
                })
            }
        } else {
            if self.varIB_check_categorie_1!.on == true {
                self.varIB_check_categorie_1?.setOn(false, animated: true)
                UIView.animate(withDuration: 0.5, animations: {
                    self.varIB_label_categorie_1?.textColor = self.colorUnselected
                })
            }
        }

        self.varIB_separator_categorie_1?.mdInflateAnimatedFromPoint(point: CGPoint(x: MidWidthSeparator, y: 0), backgroundColor: self.filtre_categorie_Vegetarien_active ? COLOR_VIOLET : UIColor.lightGray.withAlphaComponent(0.4), duration: 0.5, completion: {

        })

        if self.filtre_categorie_Vegan_active {
            if self.varIB_check_categorie_2!.on == false {
                self.varIB_check_categorie_2?.setOn(true, animated: true)
                UIView.animate(withDuration: 0.5, animations: {
                    self.varIB_label_categorie_2?.textColor = COLOR_VERT
                })
            }
        } else {
            if self.varIB_check_categorie_2!.on == true {
                self.varIB_check_categorie_2?.setOn(false, animated: true)
                UIView.animate(withDuration: 0.5, animations: {
                    self.varIB_label_categorie_2?.textColor = self.colorUnselected
                })
            }
        }

        self.varIB_separator_categorie_2?.mdInflateAnimatedFromPoint(point: CGPoint(x: MidWidthSeparator, y: 0), backgroundColor: self.filtre_categorie_Vegan_active ? COLOR_VERT : UIColor.lightGray.withAlphaComponent(0.4), duration: 0.5, completion: {

        })

        if self.filtre_categorie_VeganFriendly_active {
            if self.varIB_check_categorie_3!.on == false {
                self.varIB_check_categorie_3?.setOn(true, animated: true)
                UIView.animate(withDuration: 0.5, animations: {
                    self.varIB_label_categorie_3?.textColor = COLOR_BLEU
                })
            }
        } else {
            if self.varIB_check_categorie_3!.on == true {
                self.varIB_check_categorie_3?.setOn(false, animated: true)
                UIView.animate(withDuration: 0.5, animations: {
                    self.varIB_label_categorie_3?.textColor = self.colorUnselected
                })
            }
        }

        self.varIB_separator_categorie_3?.mdInflateAnimatedFromPoint(point: CGPoint(x: MidWidthSeparator, y: 0), backgroundColor: self.filtre_categorie_VeganFriendly_active ? COLOR_BLEU : UIColor.lightGray.withAlphaComponent(0.4), duration: 0.5, completion: {

        })

        self.updateData()

    }

    func updateData() {

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.varIB_bt_filtre_categorie_1?.layer.cornerRadius = 15.0
        self.varIB_bt_filtre_categorie_2?.layer.cornerRadius = 15.0
        self.varIB_bt_filtre_categorie_3?.layer.cornerRadius = 15.0

        self.varIB_check_categorie_1?.boxType = .square
        self.varIB_check_categorie_2?.boxType = .square
        self.varIB_check_categorie_3?.boxType = .square

        self.varIB_check_categorie_1?.onAnimationType = .bounce
        self.varIB_check_categorie_1?.offAnimationType = .bounce

        self.varIB_check_categorie_2?.onAnimationType = .bounce
        self.varIB_check_categorie_2?.offAnimationType = .bounce

        self.varIB_check_categorie_3?.onAnimationType = .bounce
        self.varIB_check_categorie_3?.offAnimationType = .bounce

        self.varIB_check_categorie_1?.onFillColor = COLOR_VIOLET
        self.varIB_check_categorie_2?.onFillColor = COLOR_VERT
        self.varIB_check_categorie_3?.onFillColor = COLOR_BLEU

        self.varIB_check_categorie_1?.onTintColor = UIColor.white
        self.varIB_check_categorie_2?.onTintColor = UIColor.white
        self.varIB_check_categorie_3?.onTintColor = UIColor.white

        self.varIB_check_categorie_1?.tintColor = colorUnselected
        self.varIB_check_categorie_2?.tintColor = colorUnselected
        self.varIB_check_categorie_3?.tintColor = colorUnselected

        self.varIB_check_categorie_1?.onCheckColor = UIColor.white
        self.varIB_check_categorie_2?.onCheckColor = UIColor.white
        self.varIB_check_categorie_3?.onCheckColor = UIColor.white

        self.varIB_check_categorie_1?.setOn(true, animated: false)
        self.varIB_label_categorie_1?.textColor = COLOR_VIOLET

        self.varIB_check_categorie_2?.setOn(true, animated: false)
        self.varIB_label_categorie_2?.textColor = COLOR_VERT

        self.varIB_check_categorie_3?.setOn(true, animated: false)
        self.varIB_label_categorie_3?.textColor = COLOR_BLEU

        self.varIB_separator_categorie_1?.backgroundColor = COLOR_VIOLET
        self.varIB_separator_categorie_2?.backgroundColor = COLOR_VERT
        self.varIB_separator_categorie_3?.backgroundColor = COLOR_BLEU

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

}
