package wiki.zex.freight.master;

import android.os.Bundle;

import com.baidu.idl.face.platform.FaceStatusEnum;
import com.baidu.idl.face.platform.ui.FaceDetectActivity;

import java.util.HashMap;

public class FaceDetectExpActivity extends FaceDetectActivity {


    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public void onDetectCompletion(FaceStatusEnum status, String message, HashMap<String, String> base64ImageMap) {
        super.onDetectCompletion(status, message, base64ImageMap);
        if (status == FaceStatusEnum.OK && mIsCompletion) {
            this.getIntent().putExtra("success", true);
            // map中包含所有动作照片，另外会记录一张bestImage0
            this.getIntent().putExtra("image", base64ImageMap.get("bestImage0"));
            this.setResult(RESULT_OK, this.getIntent());
            finish();
//            showMessageDialog("人脸图像采集", "采集成功");
        } else if (status == FaceStatusEnum.Error_DetectTimeout ||
                status == FaceStatusEnum.Error_LivenessTimeout ||
                status == FaceStatusEnum.Error_Timeout) {
            this.getIntent().putExtra("success", false);
            this.setResult(RESULT_OK, this.getIntent());
            finish();
//            showMessageDialog("人脸图像采集", "采集超时");
        }
    }


    @Override
    public void finish() {
        super.finish();
    }

}
