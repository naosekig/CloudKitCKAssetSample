# CloudKitCKAssetSample
Sample code for CloudKit when saving images to CKAsset.

## INSERT
```
    private func insertData(code:String,name:String,costRate:Double,salesPrice:Int,image:UIImage!){
        let ckDatabase = CKContainer.default().privateCloudDatabase
        
        let ckRecord = CKRecord(recordType: "GoodsMaster2")
        ckRecord["code"] = code
        ckRecord["name"] = name
        ckRecord["costRate"] = costRate
        ckRecord["salesPrice"] = salesPrice
        
        if image != nil {
            let url = saveImageFile(fileName: code + ".png", image: image)
            if url == nil {
                return
            }
            let ckAsset = CKAsset(fileURL: url!)
            ckRecord["image"] = ckAsset
        }
        
        ckDatabase.save(ckRecord, completionHandler: { (ckRecords, error) in
            if error != nil {
                print("\(String(describing: error?.localizedDescription))")
            }
        })
    }
    
    private func saveImageFile(fileName:String,image:UIImage) -> URL!{
        let directoryName:String = NSHomeDirectory() + "/Library"
        let documentsURL = URL(fileURLWithPath: directoryName)
        let fileURL = documentsURL.appendingPathComponent(fileName)
        let pngImageData = image.pngData()
        let fileManager = FileManager.default
        
        do {
            if (!fileManager.fileExists(atPath: directoryName)){
                try fileManager.createDirectory(atPath: directoryName, withIntermediateDirectories: true, attributes: nil)
            }
            
            try pngImageData!.write(to: fileURL)
            
            return fileURL
        } catch let error{
            print("\(String(describing: error.localizedDescription))")
            return nil
        }
    }
```

## SELECT
```
    private var goodsMasters:[GoodsMaster] = [GoodsMaster]()

    struct GoodsMaster {
        var code:String
        var name:String
        var costPrice:Double
        var salesPrice:Int
        var image:UIImage!
    }

    private func searchData(minSalesPrice:Int,maxSalesPrice:Int){
        let ckDatabase = CKContainer.default().privateCloudDatabase
        let ckQuery = CKQuery(recordType: "GoodsMaster2", predicate: NSPredicate(format: "salesPrice >= %d and salesPrice <= %d", argumentArray: [minSalesPrice,maxSalesPrice]))
        
        ckQuery.sortDescriptors = [NSSortDescriptor(key: "salesPrice", ascending: false),NSSortDescriptor(key: "costRate", ascending: true)]
        
        ckDatabase.perform(ckQuery, inZoneWith: nil, completionHandler: { (ckRecords, error) in
            if error != nil {
                print("\(String(describing: error?.localizedDescription))")
            }else{
                self.goodsMasters.removeAll()
                for ckRecord in ckRecords!{
                    var image:UIImage! = nil
                    
                    if (ckRecord["image"] != nil){
                        guard let ckAsset = ckRecord["image"] as? CKAsset else{
                            return
                        }
                        guard let imageData = NSData(contentsOf: ckAsset.fileURL) else {
                            return
                        }
                        image = UIImage(data: imageData as Data)
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
```

## UPDATE
```
    private func updateData(whereCode:String,updateName:String,updateCostRate:Double,updateSalesPrice:Int,updateImage:UIImage!){
        let ckDatabase = CKContainer.default().privateCloudDatabase
        
        //1.更新対象のレコードを検索する
        let ckQuery = CKQuery(recordType: "GoodsMaster2", predicate: NSPredicate(format: "code == %@", argumentArray: [whereCode]))
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
                        let url = self.saveImageFile(fileName: ckRecord["code"]! + ".png", image: updateImage)
                        if url == nil {
                            return
                        }
                        let ckAsset = CKAsset(fileURL: url!)
                        ckRecord["image"] = ckAsset
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
```

## DELETE
```
    private func deleteData(whereCode:String){
        let ckDatabase = CKContainer.default().privateCloudDatabase
        
        //1.削除対象のレコードを検索する
        let ckQuery = CKQuery(recordType: "GoodsMaster2", predicate: NSPredicate(format: "code == %@", argumentArray: [whereCode]))
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
```
