//
//  FaceDetectExpViewController.swift
//  Runner
//
//  Created by Zex Liu on 2020/6/27.
//

import UIKit

class FaceDetectExpViewController: DetectionViewController {

    typealias OkClosure = (_ image: String) -> Void//声明
    
    var mOkClosure :OkClosure?
    
    
    override func onSuccess(_ image: String!) {
        self.mOkClosure?(image)
    }

    
}
