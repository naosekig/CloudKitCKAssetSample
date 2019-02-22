//
//  ViewController.swift
//  CloudKitSample
//
//  Created by NAOAKI SEKIGUCHI on 2019/02/22.
//  Copyright © 2019 NAOAKI SEKIGUCHI. All rights reserved.
//

import UIKit
import CloudKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    private let labelSearch:UILabel = UILabel()
    private let labelMinSalesPrice:UILabel = UILabel()
    private let textMinSalesPrice:UITextView = UITextView()
    private let labelMaxSalesPrice:UILabel = UILabel()
    private let textMaxSalesPrice:UITextView = UITextView()
    private let buttonSearch:UIButton = UIButton()
    private let labelCode:UILabel = UILabel()
    private let textCode:UITextView = UITextView()
    private let labelName:UILabel = UILabel()
    private let textName:UITextView = UITextView()
    private let labelCostRate:UILabel = UILabel()
    private let textCostRate:UITextView = UITextView()
    private let labelSalesPrice:UILabel = UILabel()
    private let textSalesPrice:UITextView = UITextView()
    private let labelImage:UILabel = UILabel()
    private let imageView:UIImageView = UIImageView()
    private let buttonImage:UIButton = UIButton()
    private let buttonInsert:UIButton = UIButton()
    private let buttonUpdate:UIButton = UIButton()
    private let buttonDelete:UIButton = UIButton()
    private let tableView:UITableView = UITableView()
    private var goodsMasters:[GoodsMaster] = [GoodsMaster]()

    struct GoodsMaster {
        var code:String
        var name:String
        var costPrice:Double
        var salesPrice:Int
        var image:UIImage!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelSearch.text = "検索条件[SalesPrice]"
        self.view.addSubview(labelSearch)
        
        labelMinSalesPrice.text = "最小値"
        self.view.addSubview(labelMinSalesPrice)
        
        designTextView(textView: textMinSalesPrice,keyboardType: .numberPad)
        self.view.addSubview(textMinSalesPrice)
        
        labelMaxSalesPrice.text = "最大値"
        self.view.addSubview(labelMaxSalesPrice)
        
        designTextView(textView: textMaxSalesPrice,keyboardType: .numberPad)
        self.view.addSubview(textMaxSalesPrice)
        buttonSearch.setTitle("検索", for: .normal)
        buttonSearch.addTarget(self, action: #selector(self.touchUpButtonSearch), for: .touchUpInside)
        designButton(button: buttonSearch)
        self.view.addSubview(buttonSearch)
        
        labelCode.text = "Code(コード)"
        self.view.addSubview(labelCode)
        designTextView(textView: textCode,keyboardType: .numberPad)
        self.view.addSubview(textCode)
        labelName.text = "Name(名称)"
        self.view.addSubview(labelName)
        designTextView(textView: textName,keyboardType: .default)
        self.view.addSubview(textName)
        labelCostRate.text = "CostRate(原価率)"
        self.view.addSubview(labelCostRate)
        designTextView(textView: textCostRate,keyboardType: .decimalPad)
        self.view.addSubview(textCostRate)
        labelSalesPrice.text = "SalesPrice(売単価)"
        self.view.addSubview(labelSalesPrice)
        designTextView(textView: textSalesPrice,keyboardType: .numberPad)
        self.view.addSubview(textSalesPrice)
        
        labelImage.text = "Image(画像)"
        self.view.addSubview(labelImage)
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        buttonImage.setTitle("Pictureから取得", for: .normal)
        buttonImage.addTarget(self, action: #selector(self.touchUpButtonPicture), for: .touchUpInside)
        designButton(button: buttonImage)
        self.view.addSubview(buttonImage)
        
        buttonInsert.setTitle("INSERT", for: .normal)
        buttonInsert.addTarget(self, action: #selector(self.touchUpButtonInsert), for: .touchUpInside)
        designButton(button: buttonInsert)
        self.view.addSubview(buttonInsert)
        
        buttonUpdate.setTitle("UPDATE", for: .normal)
        buttonUpdate.addTarget(self, action: #selector(self.touchUpButtonUpdate), for: .touchUpInside)
        designButton(button: buttonUpdate)
        self.view.addSubview(buttonUpdate)
        
        buttonDelete.setTitle("DELETE", for: .normal)
        buttonDelete.addTarget(self, action: #selector(self.touchUpButtonDelete), for: .touchUpInside)
        designButton(button: buttonDelete)
        self.view.addSubview(buttonDelete)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        changeScreen()
    }
    
    private func designTextView(textView:UITextView,keyboardType:UIKeyboardType){
        textView.layer.cornerRadius = 10
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.5
        textView.keyboardType = keyboardType
        textView.delegate = self
    }
    
    private func designButton(button:UIButton){
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.setTitleColor(UIColor.blue, for: .normal)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(
            alongsideTransition: nil,
            completion: {(UIViewControllerTransitionCoordinatorContext) in
                self.changeScreen()
        }
        )
    }
    
    private func changeScreen(){
        let screenSize: CGRect = UIScreen.main.bounds
        let widthValue = screenSize.width
        let heightValue = screenSize.height
        
        labelSearch.frame = CGRect(x: 5, y: 50, width: widthValue-120, height: 40)
        buttonSearch.frame = CGRect(x: widthValue-110, y: 50, width: 100, height: 40)
        labelMinSalesPrice.frame = CGRect(x: 5, y: 100, width: 50, height: 40)
        textMinSalesPrice.frame = CGRect(x: 60, y: 100, width: widthValue/2-65, height: 40)
        labelMaxSalesPrice.frame = CGRect(x: widthValue/2 + 5, y: 100, width: 50, height: 40)
        textMaxSalesPrice.frame = CGRect(x: widthValue/2 + 60, y: 100, width: widthValue/2-65, height: 40)
        
        labelCode.frame = CGRect(x: 5, y: 150, width: 150, height: 40)
        textCode.frame = CGRect(x: 160, y: 150, width: widthValue-165, height: 40)
        labelName.frame = CGRect(x: 5, y: 195, width: 150, height: 40)
        textName.frame = CGRect(x: 160, y: 195, width: widthValue-165, height: 40)
        labelCostRate.frame = CGRect(x: 5, y: 240, width: 150, height: 40)
        textCostRate.frame = CGRect(x: 160, y: 240, width: widthValue-165, height: 40)
        labelSalesPrice.frame = CGRect(x: 5, y: 285, width: 150, height: 40)
        textSalesPrice.frame = CGRect(x: 160, y: 285, width: widthValue-165, height: 40)
        labelImage.frame = CGRect(x: 5, y: 330, width: 150, height: 80)
        imageView.frame = CGRect(x: 160, y: 330, width: widthValue-320, height: 80)
        buttonImage.frame = CGRect(x: widthValue-155, y: 330, width: 150, height: 80)
        
        buttonInsert.frame = CGRect(x: 5, y: 415, width: widthValue/3-10, height: 40)
        buttonUpdate.frame = CGRect(x: widthValue/3+5, y: 415, width: widthValue/3-10, height: 40)
        buttonDelete.frame = CGRect(x: widthValue/3*2+5, y: 415, width: widthValue/3-10, height: 40)
        
        tableView.frame = CGRect(x: 5, y: 455, width: widthValue-10, height: heightValue-455)
    }
    
    /**
     Cloud KitにデータをINSERTする
     @param INSERTするデータ code:コード name:名称 costRate:原価率 salesPrice:売単価 image:画像
     */
    private func insertData(code:String,name:String,costRate:Double,salesPrice:Int,image:UIImage!){
        let ckDatabase = CKContainer.default().privateCloudDatabase
        
        //INSERTするデータを設定
        let ckRecord = CKRecord(recordType: "GoodsMaster")
        ckRecord["code"] = code
        ckRecord["name"] = name
        ckRecord["costRate"] = costRate
        ckRecord["salesPrice"] = salesPrice
        
        if (image != nil){
            //UIImageをNSDataに変換
            let imageData = image.jpegData(compressionQuality: 1.0)
        
            //UIImageの方向を確認
            var imageOrientation:Int = 0
            if (image.imageOrientation == UIImage.Orientation.down){
                imageOrientation = 2
            }else{
                imageOrientation = 1
            }
            
            ckRecord["image"] = imageData
            ckRecord["imageOrientation"] = imageOrientation
        }
        
        //データのINSERTを実行
        ckDatabase.save(ckRecord, completionHandler: { (ckRecords, error) in
            if error != nil {
                //INSERTがエラーになった場合
                print("\(String(describing: error?.localizedDescription))")
            }
        })
    }
    
    /**
     Cloud Kitからデータを検索する
     @param 検索条件 minSalesPrice:検索条件のsalesPriceの最小値 maxSalesPrice:検索条件のsalesPriceの最大値
     */
    private func searchData(minSalesPrice:Int,maxSalesPrice:Int){
        let ckDatabase = CKContainer.default().privateCloudDatabase
        //検索条件指定
        let ckQuery = CKQuery(recordType: "GoodsMaster", predicate: NSPredicate(format: "salesPrice >= %d and salesPrice <= %d", argumentArray: [minSalesPrice,maxSalesPrice]))
        
        //ソート条件指定
        ckQuery.sortDescriptors = [NSSortDescriptor(key: "salesPrice", ascending: false),NSSortDescriptor(key: "costRate", ascending: true)]
        
        //検索実行
        ckDatabase.perform(ckQuery, inZoneWith: nil, completionHandler: { (ckRecords, error) in
            if error != nil {
                //検索エラー
                print("\(String(describing: error?.localizedDescription))")
            }else{
                //検索成功
                self.goodsMasters.removeAll()
                for ckRecord in ckRecords!{
                    var image:UIImage! = nil
                    let imageData = ckRecord["image"]
                    if (imageData != nil){
                        image = UIImage(data: ckRecord["image"]!)
                        let imageOrientation:Int = ckRecord["imageOrientation"]!
                        if (imageOrientation == 2) {
                            image = UIImage(cgImage: image!.cgImage!, scale: image!.scale, orientation: UIImage.Orientation.down)
                        }
                    }
                    let goodsMaster = GoodsMaster(code: ckRecord["code"]!, name: ckRecord["name"]!, costPrice: ckRecord["costRate"]!, salesPrice: ckRecord["salesPrice"]!,image:image)
                    self.goodsMasters.append(goodsMaster)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    /**
     指定した条件でCloud KitのデータをUPDATEする
     @param whereCode:更新対象のコード updateName:名称の更新値 updateCostRate:原価率の更新値 updateSalesPrice:売単価の更新値 updateImage:画像の更新値
     */
    private func updateData(whereCode:String,updateName:String,updateCostRate:Double,updateSalesPrice:Int,updateImage:UIImage!){
        let ckDatabase = CKContainer.default().privateCloudDatabase
        
        //1.更新対象のレコードを検索する
        let ckQuery = CKQuery(recordType: "GoodsMaster", predicate: NSPredicate(format: "code == %@", argumentArray: [whereCode]))
        ckDatabase.perform(ckQuery, inZoneWith: nil, completionHandler: { (ckRecords, error) in
            if error != nil {
                print("\(String(describing: error?.localizedDescription))")
            }else{
                //2.検索したレコードの値をUPDATEする
                for ckRecord in ckRecords!{
                    ckRecord["name"] = updateName
                    ckRecord["costRate"] = updateCostRate
                    ckRecord["salesPrice"] = updateSalesPrice
                    if (updateImage != nil){
                        //UIImageをNSDataに変換
                        let imageData = updateImage.jpegData(compressionQuality: 1.0)
                        
                        //UIImageの方向を確認
                        var imageOrientation:Int = 0
                        if (updateImage.imageOrientation == UIImage.Orientation.down){
                            imageOrientation = 2
                        }else{
                            imageOrientation = 1
                        }
                        
                        ckRecord["image"] = imageData
                        ckRecord["imageOrientation"] = imageOrientation
                    }
                    
                    ckDatabase.save(ckRecord, completionHandler: { (ckRecord, error) in
                        if error != nil {
                            print("\(String(describing: error?.localizedDescription))")
                        }
                    })
                }
            }
        })
    }
    
    /**
     指定した条件でCloud KitのデータをDELETEする
     @param whereCode:削除対象のCode
     */
    private func deleteData(whereCode:String){
        let ckDatabase = CKContainer.default().privateCloudDatabase
        
        //1.削除対象のレコードを検索する
        let ckQuery = CKQuery(recordType: "GoodsMaster", predicate: NSPredicate(format: "code == %@", argumentArray: [whereCode]))
        ckDatabase.perform(ckQuery, inZoneWith: nil, completionHandler: { (ckRecords, error) in
            if error != nil {
                print("\(String(describing: error?.localizedDescription))")
            }else{
                //2.検索したレコードを削除する
                for ckRecord in ckRecords!{
                    ckDatabase.delete(withRecordID: ckRecord.recordID, completionHandler: { (recordId, error) in
                        if error != nil {
                            print("\(String(describing: error?.localizedDescription))")
                        }
                    })
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goodsMasters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index:Int = indexPath.row
        var cell:UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel!.text = goodsMasters[index].code + " " + goodsMasters[index].name
        cell.textLabel!.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel!.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index:Int = indexPath.row
        textCode.text = goodsMasters[index].code
        textName.text = goodsMasters[index].name
        textCostRate.text = goodsMasters[index].costPrice.description
        textSalesPrice.text = goodsMasters[index].salesPrice.description
        imageView.image = goodsMasters[index].image
    }
    
    @objc func touchUpButtonSearch(){
        self.view.endEditing(true)
        
        var minSalesPriceString = textMinSalesPrice.text!
        if (minSalesPriceString.count == 0){
            minSalesPriceString = "0"
        }
        var maxSalesPriceString = textMaxSalesPrice.text!
        if (maxSalesPriceString.count == 0){
            maxSalesPriceString = "999999999999"
        }
        
        searchData(minSalesPrice: Int(minSalesPriceString)!, maxSalesPrice: Int(maxSalesPriceString)!)
    }
    
    @objc func touchUpButtonInsert(){
        self.view.endEditing(true)
        
        let codeString = textCode.text!
        let nameString = textName.text!
        let costRateString = textCostRate.text!
        let salesPriceString = textSalesPrice.text!
        
        insertData(code: codeString, name: nameString, costRate: Double(costRateString)!, salesPrice: Int(salesPriceString)!,image:imageView.image)
    }
    
    @objc func touchUpButtonUpdate(){
        self.view.endEditing(true)
        
        let codeString = textCode.text!
        let nameString = textName.text!
        let costRateString = textCostRate.text!
        let salesPriceString = textSalesPrice.text!
        
        updateData(whereCode: codeString, updateName: nameString, updateCostRate: Double(costRateString)!, updateSalesPrice: Int(salesPriceString)!,updateImage: imageView.image)
    }
    
    @objc func touchUpButtonDelete(){
        self.view.endEditing(true)
        
        let codeString = textCode.text!
        
        deleteData(whereCode: codeString)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n"){
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @objc func touchUpButtonPicture(){
        openPicker()
    }
    
    @objc func openPicker(){
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            return
        }
        
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.delegate = self
        
        self.present(picker,animated:false,completion:nil)
    }
    
    func imagePickerController(_ picker:UIImagePickerController,didFinishPickingMediaWithInfo info:[UIImagePickerController.InfoKey:Any]){
        
        picker.presentingViewController?.dismiss(animated: false, completion: nil)
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        let widthValue:CGFloat = image!.size.width
        let heightValue:CGFloat = image!.size.height
        let scaleValue:CGFloat = 860/widthValue
        
        let size = CGSize(width: widthValue*scaleValue, height: heightValue*scaleValue)
        UIGraphicsBeginImageContext(size)
        image!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizeImage:UIImage! = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        imageView.image = resizeImage
    }
}

