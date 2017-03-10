//
//  GoodsEvaluateViewController.swift
//  FameShopping
//
//  Created by YunTu on 2017/3/10.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

class GoodsEvaluateViewController: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    var goodsInfo:NSDictionary?
    var collectionView: UICollectionView?
    var textView: UITextView?
    var placeHolder: UILabel?
    var anonymityBtn: UIButton?
    
    var mainScore:TQStarRatingView?
    var shScore:TQStarRatingView?
    var bzScore:TQStarRatingView?
    var psyScore:TQStarRatingView?
    
    var imgArr = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "提交", style: .plain, target: self, action: #selector(rightBarItemDidClick(_:)))
        self.navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.9144125581, green: 0.3713477254, blue: 0.5323973894, alpha: 1)
        self.title = "评价"
        print(goodsInfo!)
    }
    
    public class func getInstance() -> GoodsEvaluateViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "goodsEvaluate")
        return vc as! GoodsEvaluateViewController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView(frame: .zero)
        v.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        return v
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentify = ""
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cellIdentify = "scoreCell"
            }else if indexPath.row == 1 {
                cellIdentify = "contentCell"
            }else{
                cellIdentify = "imgCell"
            }
        }else{
            cellIdentify = "totalCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (goodsInfo?["graphic"] as! String))!)
                mainScore = cell.viewWithTag(2) as? TQStarRatingView
            }else if indexPath.row == 1 {
                textView = cell.viewWithTag(1) as? UITextView
                textView?.delegate = self
                placeHolder = cell.viewWithTag(2) as? UILabel
            }else{
                collectionView = cell.viewWithTag(1) as? UICollectionView
                collectionView?.delegate = self
                collectionView?.dataSource = self
                anonymityBtn = (cell.viewWithTag(2) as! UIButton)
                anonymityBtn?.addTarget(self, action: #selector(anonymityBtnDidClick(_:)), for: .touchUpInside)
            }
        }else{
            shScore = cell.viewWithTag(1) as? TQStarRatingView
            bzScore = cell.viewWithTag(2) as? TQStarRatingView
            psyScore = cell.viewWithTag(3) as? TQStarRatingView
        }
        
        
        return cell
    }
    
    // MARK: - UICollectionView delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + imgArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        if indexPath.row == imgArr.count {
            (cell.viewWithTag(1) as! UIImageView).image = #imageLiteral(resourceName: "order-camera")
        }else {
            (cell.viewWithTag(1) as! UIImageView).image = imgArr[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        sheet.addAction(UIAlertAction(title: "相机", style: .default, handler: { (action) in
            imgPicker.sourceType = .camera
            imgPicker.allowsEditing = true
            self.present(imgPicker, animated: true, completion: nil)
        }))
        sheet.addAction(UIAlertAction(title: "相册", style: .default, handler: { (action) in
            imgPicker.sourceType = .savedPhotosAlbum
            imgPicker.allowsEditing = true
            self.present(imgPicker, animated: true, completion: nil)
        }))
        sheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            
        }))
        self.present(sheet, animated: true, completion: nil)
    }

    // MARK: - UIImagePickerView delegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imgArr.append(info[UIImagePickerControllerEditedImage] as! UIImage)
        self.dismiss(animated: true, completion: nil)
        self.collectionView?.reloadData()
        let width = Helpers.screanSize().width - 24
        let column:Int = Int(width) / 85
        let last = (imgArr.count + 1) % column
        var count = (imgArr.count + 1) / column
        if last > 0 {
            count = count + 1
        }
        count = max(count, 1)
        if count > 1 {
            self.tableView.beginUpdates()
            for constrain in (self.collectionView?.constraints)! {
                if constrain.identifier == "collectionHeight" {
                    constrain.constant = CGFloat(count * 75) + CGFloat(10 * (count - 1))
                    break
                }
            }
            self.tableView.endUpdates()
        }
    }
    
    // MARK: - UITextView delegate
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.characters.count > 0 {
            placeHolder?.isHidden = true
        }else{
            placeHolder?.isHidden = false
        }
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func anonymityBtnDidClick(_ sender: UIButton) -> Void {
        sender.isSelected = !sender.isSelected
    }
    
    func rightBarItemDidClick(_ sender: UIBarButtonItem) -> Void {
        self.requestAddEvaluate()
    }

    func requestAddEvaluate() -> Void {
        SVProgressHUD.show()
        let param = ["og_id":self.goodsInfo?["og_id"] as? String,"user_id":UserModel.share.userId,"score":String(mainScore!.numberOfStar),"message":textView?.text!,"sh_score":String(shScore!.numberOfStar),"bz_score":String(bzScore!.numberOfStar),"psy_score":String(psyScore!.numberOfStar)]
        print(param)
        if imgArr.count > 0 {
            UploadNetwork.request(param as! [String : String], datas: imgArr, paramName: "ping_img[]", url: "/Order/ping_add", complete: { (dic) in
                if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                    SVProgressHUD.dismiss()
                    _ = self.navigationController?.popViewController(animated: true)
                }else{
                    SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
                }
            })
        }else{
            NetworkModel.request(param as NSDictionary, url: "/Order/ping_add", complete: { (dic) in
                if Int((dic as! NSDictionary)["code"] as! String) == 200 {
                    SVProgressHUD.dismiss()
                    _ = self.navigationController?.popViewController(animated: true)
                }else{
                    SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as! String)
                }
            })
        }
    }
    
}
