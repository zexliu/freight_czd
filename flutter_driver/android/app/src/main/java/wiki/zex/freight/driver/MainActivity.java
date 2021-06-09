package wiki.zex.freight.driver;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.baidu.idl.face.platform.FaceConfig;
import com.baidu.idl.face.platform.FaceEnvironment;
import com.baidu.idl.face.platform.FaceSDKManager;
import com.baidu.ocr.sdk.OCR;
import com.baidu.ocr.sdk.OnResultListener;
import com.baidu.ocr.sdk.exception.OCRError;
import com.baidu.ocr.sdk.model.AccessToken;
import com.baidu.ocr.sdk.model.IDCardParams;
import com.baidu.ocr.sdk.model.IDCardResult;
import com.baidu.ocr.ui.camera.CameraActivity;
import com.baidu.ocr.ui.camera.CameraNativeHelper;
import com.baidu.ocr.ui.camera.CameraView;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import android.os.Build;
import android.view.ViewTreeObserver;
import android.view.WindowManager;
public class MainActivity extends FlutterActivity implements MethodChannel.MethodCallHandler {


    private static final String CHANNEL = "wiki.zex.baidu_face_plugin";

    private static final int LIVENESS_REQUEST_CODE = 10110;

    private static final int DETECT_REQUEST_CODE = 10111;

    private LivenessCallback livenessCallback;

    private DetectCallback detectCallback;
    private IdentityCallback identityCallback;

    private static final int REQUEST_CODE_CAMERA = 102;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    boolean flutter_native_splash = true;
    int originalStatusBarColor = 0;
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
        originalStatusBarColor = getWindow().getStatusBarColor();
        getWindow().setStatusBarColor(0xffeaeaea);
    }
    int originalStatusBarColorFinal = originalStatusBarColor;

        FaceSDKManager.getInstance().initialize(this, "freight-driver-face-android", "idl-license.face-android");
        OCR.getInstance(this).initAccessTokenWithAkSk(new OnResultListener<AccessToken>() {
            @Override
            public void onResult(AccessToken result) {
                String token = result.getAccessToken();
                initCameraNativeHelper();
            }

            @Override
            public void onError(OCRError error) {
                error.printStackTrace();
            }
        }, getApplicationContext(), "ahBwp3RUsettCFZXz5f0d87u", "mqxeC61743HRaBofV2NY2pXyKU9W7IeZ");
        setFaceConfig();
    }


    private void initCameraNativeHelper() {
        //  初始化本地质量控制模型,释放代码在onDestory中
        //  调用身份证扫描必须加上 intent.putExtra(CameraActivity.KEY_NATIVE_MANUAL, true); 关闭自动初始化和释放本地模型
        CameraNativeHelper.init(this, OCR.getInstance(this).getLicense(),
                (errorCode, e) -> {
                    String msg;
                    switch (errorCode) {
                        case CameraView.NATIVE_SOLOAD_FAIL:
                            msg = "加载so失败，请确保apk中存在ui部分的so";
                            break;
                        case CameraView.NATIVE_AUTH_FAIL:
                            msg = "授权本地质量控制token获取失败";
                            break;
                        case CameraView.NATIVE_INIT_FAIL:
                            msg = "本地质量控制";
                            break;
                        default:
                            msg = String.valueOf(errorCode);
                    }

                    if (!TextUtils.isEmpty(msg)) {
                        Log.e("initCameraNativeHelper",msg);
                    }
                });
    }
    private void setFaceConfig() {
        FaceConfig config = FaceSDKManager.getInstance().getFaceConfig();
        // SDK初始化已经设置完默认参数（推荐参数），您也根据实际需求进行数值调整
        config.setLivenessTypeList(FaceConstants.livenessList);
        config.setLivenessRandom(FaceConstants.isLivenessRandom);
        config.setBlurnessValue(FaceEnvironment.VALUE_BLURNESS);
        config.setBrightnessValue(FaceEnvironment.VALUE_BRIGHTNESS);
        config.setCropFaceValue(FaceEnvironment.VALUE_CROP_FACE_SIZE);
        config.setHeadPitchValue(FaceEnvironment.VALUE_HEAD_PITCH);
        config.setHeadRollValue(FaceEnvironment.VALUE_HEAD_ROLL);
        config.setHeadYawValue(FaceEnvironment.VALUE_HEAD_YAW);
        config.setMinFaceSize(FaceEnvironment.VALUE_MIN_FACE_SIZE);
        config.setNotFaceValue(FaceEnvironment.VALUE_NOT_FACE_THRESHOLD);
        config.setOcclusionValue(FaceEnvironment.VALUE_OCCLUSION);
        config.setCheckFaceQuality(true);
        config.setFaceDecodeNumberOfThreads(2);
        FaceSDKManager.getInstance().setFaceConfig(config);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if ("liveness".equals(call.method)) {
            livenessCallback = new LivenessCallback(result);
            liveness(call.hasArgument("language") ? call.<String>argument("language") : null);
        } else if ("detect".equals(call.method)) {
            detectCallback = new DetectCallback(result);
            detect(call.hasArgument("language") ? call.<String>argument("language") : null);
        } else if ("identityCard".equals(call.method)) {
            identityCard();
        } else if ("localIdentityCard".equals(call.method)) {
            localIdentityCard();
        } else {
            result.notImplemented();
        }


//
    }


    private void identityCard() {
        Intent intent = new Intent(this, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH,
                FileUtil.getSaveFile(getApplication()).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_ID_CARD_FRONT);
        startActivityForResult(intent, REQUEST_CODE_CAMERA);
    }

    private void localIdentityCard() {
        Intent intent = new Intent(this, CameraActivity.class);
        intent.putExtra(CameraActivity.KEY_OUTPUT_FILE_PATH,
                FileUtil.getSaveFile(getApplication()).getAbsolutePath());
        intent.putExtra(CameraActivity.KEY_NATIVE_ENABLE,
                true);
        // KEY_NATIVE_MANUAL设置了之后CameraActivity中不再自动初始化和释放模型
        // 请手动使用CameraNativeHelper初始化和释放模型
        // 推荐这样做，可以避免一些activity切换导致的不必要的异常
        intent.putExtra(CameraActivity.KEY_NATIVE_MANUAL,
                true);
        intent.putExtra(CameraActivity.KEY_CONTENT_TYPE, CameraActivity.CONTENT_TYPE_ID_CARD_FRONT);
        startActivityForResult(intent, REQUEST_CODE_CAMERA);
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        final MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);
        channel.setMethodCallHandler(this);

    }

    private void detect(String language) {
        Intent intent = new Intent(this, FaceDetectExpActivity.class);
        Bundle mBundle = new Bundle();
        mBundle.putString("language", (language == null || "".equals(language)) ? "zh" : language);
        intent.putExtras(mBundle);
        startActivityForResult(intent, DETECT_REQUEST_CODE);
    }

    private void liveness(String language) {
        Intent intent = new Intent(this, FaceLivenessExpActivity.class);
        Bundle mBundle = new Bundle();
        mBundle.putString("language", (language == null || "".equals(language)) ? "zh" : language);
        intent.putExtras(mBundle);
        startActivityForResult(intent, LIVENESS_REQUEST_CODE);
    }


    @Override
    public void onPointerCaptureChanged(boolean hasCapture) {

    }



    static class LivenessCallback {

        private MethodChannel.Result result;

        public LivenessCallback(MethodChannel.Result result) {
            this.result = result;
        }

        public void success(String image) {
            Map<String, String> map = new HashMap<>();
            map.put("success", "true");
            map.put("image", image);
            result.success(map);
        }

        public void failed() {
            Map<String, String> map = new HashMap<>();
            map.put("success", "false");
            result.success(map);
        }

    }

    static class DetectCallback {

        private MethodChannel.Result result;

        public DetectCallback(MethodChannel.Result result) {
            this.result = result;
        }

        public void success(String image) {
            Map<String, String> map = new HashMap<>();
            map.put("success", "true");
            map.put("image", image);
            result.success(map);
        }

        public void failed() {
            Map<String, String> map = new HashMap<>();
            map.put("success", "false");
            result.success(map);
        }

    }

    static class IdentityCallback {

        private MethodChannel.Result result;

        public IdentityCallback(MethodChannel.Result result) {
            this.result = result;
        }

        public void success(String image, String name, String birthDay, String identityCardNo, String gender, String address, String national) {
            Map<String, String> map = new HashMap<>();
            map.put("success", "true");
            map.put("image", image);
            map.put("name", name);
            map.put("birthDay", birthDay);
            map.put("identityCardNo", identityCardNo);
            map.put("gender", gender);
            map.put("address", address);
            map.put("national", national);
            result.success(map);
        }

        public void failed() {
            Map<String, String> map = new HashMap<>();
            map.put("success", "false");
            result.success(map);
        }

    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode != Activity.RESULT_OK){
            return;
        }
        switch (requestCode) {
            case LIVENESS_REQUEST_CODE: {
                if (livenessCallback != null && data != null) {
                    if (data.getBooleanExtra("success", false)) {
                        livenessCallback.success(data.getStringExtra("image"));
                    } else {
                        livenessCallback.failed();
                    }
                }
                break;
            }
            case DETECT_REQUEST_CODE: {
                if (detectCallback != null && data != null) {
                    if (data.getBooleanExtra("success", false)) {
                        detectCallback.success(data.getStringExtra("image"));
                    } else {
                        detectCallback.failed();
                    }
                }
                break;
            }
            case REQUEST_CODE_CAMERA: {

                if ( identityCallback != null &&  data != null) {
                    String contentType = data.getStringExtra(CameraActivity.KEY_CONTENT_TYPE);
                    String filePath = FileUtil.getSaveFile(getApplicationContext()).getAbsolutePath();
                    if (!TextUtils.isEmpty(contentType)) {
                        if (CameraActivity.CONTENT_TYPE_ID_CARD_FRONT.equals(contentType)) {
                            recIDCard(IDCardParams.ID_CARD_SIDE_FRONT, filePath);
                        }
                    }
                }
            }
            default:
        }
    }


    private void recIDCard(String idCardSide, String filePath) {
        IDCardParams param = new IDCardParams();
        param.setImageFile(new File(filePath));
        // 设置身份证正反面
        param.setIdCardSide(idCardSide);
        // 设置方向检测
        param.setDetectDirection(true);
        // 设置图像参数压缩质量0-100, 越大图像质量越好但是请求时间越长。 不设置则默认值为20
        param.setImageQuality(20);

        OCR.getInstance(this).recognizeIDCard(param, new OnResultListener<IDCardResult>() {
            @Override
            public void onResult(IDCardResult result) {
                if (result != null) {
                    identityCallback.success(FileUtil.fileToBase64(param.getImageFile()), result.getName().getWords(), result.getBirthday().getWords(), result.getIdNumber().getWords(), result.getGender().getWords(), result.getAddress().getWords(), result.getEthnic().getWords());
                }
            }

            @Override
            public void onError(OCRError error) {
                identityCallback.failed();
                Toast.makeText(MainActivity.this, error.getMessage(), Toast.LENGTH_SHORT).show();
            }
        });
    }


    @Override
    protected void onDestroy() {
        // 释放本地质量控制模型
//        CameraNativeHelper.release();
        super.onDestroy();
    }
}