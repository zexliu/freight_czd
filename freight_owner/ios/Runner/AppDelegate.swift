import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let licensePath = Bundle.main.path(forResource: FaceParameterConfig.FACE_LICENSE_NAME, ofType: FaceParameterConfig.FACE_LICENSE_SUFFIX)
    assert(FileManager.default.fileExists(atPath: licensePath!),"license文件路径不对，请仔细查看文档")
    FaceSDKManager.sharedInstance()?.setLicenseID(FaceParameterConfig.FACE_LICENSE_ID, andLocalLicenceFile: licensePath!)
//      let licensePath1 = Bundle.main.path(forResource: FaceParameterConfig.OCR_LICENSE_NAME, ofType: FaceParameterConfig.OCR_LICENSE_SUFFIX)
//    assert(FileManager.default.fileExists(atPath: licensePath1!),"license文件路径不对，请仔细查看文档")
//
//    let licenseFileData = NSData.init(contentsOfFile: licensePath1!)
    
    AipOcrService.shard()?.auth(withAK: FaceParameterConfig.FACE_API_KEY, andSK: FaceParameterConfig.FACE_SECRET_KEY)
//    AipOcrService.shard()?.auth(withLicenseFileData:  Data(referencing: licenseFileData!))
    
    var flutter_native_splash = 1
    UIApplication.shared.isStatusBarHidden = false

    GeneratedPluginRegistrant.register(with: self)
    SwiftBaiduFacePlugin.register(with: self.registrar(forPlugin: "SwiftBaiduFacePlugin")!)
    
    
    
//    [FlutterNativePlugin registerWithRegistrar: [self registrarForPlugin:@"FlutterNativePlugin"]];

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}