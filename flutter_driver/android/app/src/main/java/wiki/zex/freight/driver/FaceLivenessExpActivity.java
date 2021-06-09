package wiki.zex.freight.driver;

import android.os.Bundle;

import com.baidu.idl.face.platform.FaceStatusEnum;
import com.baidu.idl.face.platform.ui.FaceLivenessActivity;

import java.util.HashMap;

public class FaceLivenessExpActivity extends FaceLivenessActivity {


    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public void onLivenessCompletion(FaceStatusEnum status, String message, HashMap<String, String> base64ImageMap) {
        super.onLivenessCompletion(status, message, base64ImageMap);
        if (status == FaceStatusEnum.OK && mIsCompletion) {
            this.getIntent().putExtra("success", true);
            // map中包含所有动作照片，另外会记录一张bestImage0
            this.getIntent().putExtra("image", base64ImageMap.get("bestImage0"));
            this.setResult(RESULT_OK, this.getIntent());
            finish();
//            showMessageDialog("活体检测", "检测成功");
        } else if (status == FaceStatusEnum.Error_DetectTimeout ||
                status == FaceStatusEnum.Error_LivenessTimeout ||
                status == FaceStatusEnum.Error_Timeout) {
            this.getIntent().putExtra("success", false);
            this.setResult(RESULT_OK, this.getIntent());
            finish();
//            showMessageDialog("活体检测", "采集超时");
        }
    }


    @Override
    public void finish() {
        super.finish();
    }

}
