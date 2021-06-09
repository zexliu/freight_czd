import Flutter
import UIKit

public class SwiftBaiduFacePlugin: NSObject, FlutterPlugin {
    
    private static var CHANNEL = "wiki.zex.baidu_face_plugin"
    
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: registrar.messenger())
        let instance = SwiftBaiduFacePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        //    rootVC.present(T##viewControllerToPresent: UIViewController##UIViewController, animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
        
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let applicationDelegate = UIApplication.shared.delegate as! FlutterAppDelegate
        let rootVC = applicationDelegate.window.rootViewController as! FlutterViewController
        if(call.method == "liveness"){
            let vc = LivenessExpViewController()
            vc.mOkClosure = { (iamge) in
                var dict = Dictionary<String ,String>.init()
                dict["image"] = iamge
                dict["success"] = "true"
                result(dict)
            }
            let nav = UINavigationController.init(rootViewController: vc)
            nav.isNavigationBarHidden =  true
//            nav.modalPresentationStyle = .fullScreen
            let model = LivingConfigModel.sharedInstance()!;
            vc.livenesswithList(model.liveActionArray as? [Any], order: model.isByOrder, numberOfLiveness: model.numOfLiveness)
            //        LivingConfigModel* model = [LivingConfigModel sharedInstance];
            //           [lvc livenesswithList:model.liveActionArray order:model.isByOrder numberOfLiveness:model.numOfLiveness];
            rootVC.present(nav, animated: true, completion: nil)
            //        result("success")
        }else if(call.method == "detect"){
            let vc = FaceDetectExpViewController()
            vc.mOkClosure = { (iamge) in
                var dict = Dictionary<String ,String>.init()
                dict["image"] = iamge
                dict["success"] = "true"
                result(dict)
            }
            let nav = UINavigationController.init(rootViewController: vc)
            nav.isNavigationBarHidden =  true
//            nav.modalPresentationStyle = .fullScreen
            rootVC.present(nav, animated: true, completion: nil)
            //        result("success")
        }else if (call.method == "identityCard"){
            
            let vc = AipCaptureCardVC.viewController(with: .idCardFont) { (image) in
                
                AipOcrService.shard()?.detectIdCardFront(from: image!, withOptions: nil, successHandler: { (any) in
                    self.successHandler(result: any, image: imageToBase64String(image: image ?? UIImage())!, flutterResult: result)
                }, failHandler:{(any) in
                    self.failHandler(result: any, flutterResult: result)
                })
                
            }
//            vc!.modalPresentationStyle = .fullScreen
            rootVC.present(vc!, animated: true, completion: nil)
        }else if (call.method == "localIdentityCard"){
                    
                    let vc = AipCaptureCardVC.viewController(with: .localIdCardFont) { (image) in
                        
                        AipOcrService.shard()?.detectIdCardFront(from: image!, withOptions: nil, successHandler: { (any) in
                            self.successHandler(result: any, image: imageToBase64String(image: image ?? UIImage())!, flutterResult: result)
                        }, failHandler:{(any) in
                            self.failHandler(result: any, flutterResult: result)
                        })
                        
                    }
        //            vc!.modalPresentationStyle = .fullScreen
                    rootVC.present(vc!, animated: true, completion: nil)
                }else{
            result(FlutterMethodNotImplemented)
        }
    }
    
   
    func successHandler(result : Any?, image:String , flutterResult:  FlutterResult) -> Void {
        var dict = Dictionary<String ,String>.init()
        dict["image"] = image
        dict["success"] = "true"
        
        ((result as! NSDictionary)["words_result"] as! NSDictionary).enumerateKeysAndObjects { (key, obj, stop) in
            if(key as! String == "姓名"){
                dict["name"] = (obj as! NSDictionary)["words"] as? String
            }
            if(key as! String == "出生"){
                dict["birthDay"] = (obj as! NSDictionary)["words"] as? String
            }
            if(key as! String == "公民身份号码"){
                dict["identityCardNo"] = (obj as! NSDictionary)["words"] as? String
            }
            if(key as! String == "性别"){
                dict["gender"] = (obj as! NSDictionary)["words"] as? String
            }
            
            if(key as! String == "住址"){
                dict["address"] = (obj as! NSDictionary)["words"] as? String
            }
            if(key as! String == "民族"){
                dict["national"] = (obj as! NSDictionary)["words"] as? String
            }
        }
        
        OperationQueue.main.addOperation {
               let applicationDelegate = UIApplication.shared.delegate as! FlutterAppDelegate
                 let rootVC = applicationDelegate.window.rootViewController as! FlutterViewController
                 rootVC.dismiss(animated: true, completion: nil)
        }
        
        flutterResult(dict)

    }
    
    
    func failHandler(result : Any? , flutterResult:FlutterResult ) -> Void {
        var dict = Dictionary<String ,String>.init()
                       dict["success"] = "false"
        print("failHandler")
        flutterResult(dict)

    }
    
    
}



///传入图片image回传对应的base64字符串,默认不带有data标识,
   func imageToBase64String(image:UIImage)->String?{
       
       ///根据图片得到对应的二进制编码

       let dataTmp = image.jpegData(compressionQuality: 1)
       if let data = dataTmp {
           let imageStrTT = data.base64EncodedString(options: .lineLength64Characters)
           return imageStrTT
       }
       return nil
       
   }
   
   
