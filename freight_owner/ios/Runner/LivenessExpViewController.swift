//
//  LivenessExpViewController.swift
//  Runner
//
//  Created by Zex Liu on 2020/6/27.
//

import UIKit

class LivenessExpViewController: LivenessViewController {
    
    typealias OkClosure = (_ image: String) -> Void//声明
    
    var mOkClosure :OkClosure?
    
    
    override func onSuccess(_ image: String!) {
//        let data = Data.init(base64Encoded: image, options: .ignoreUnknownCharacters)
//        let bestImage = UIImage.init(data: data!)
//        let cropImage =  bestImage!.crop(ratio: 1, nSize: CGSize.init(width: bestImage!.size.width / 2 , height: bestImage!.size.width / 2 ))
//        let base64 =  imageToBase64String(image: cropImage)
        self.mOkClosure?(image!)
    }
    
}
