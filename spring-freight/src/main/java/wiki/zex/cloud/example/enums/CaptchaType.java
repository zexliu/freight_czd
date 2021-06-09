package wiki.zex.cloud.example.enums;

public enum CaptchaType {

    LOGIN("SMS_204615024"), CHANGE_MOBILE("SMS_204756931"),;

    String templateCode;

    CaptchaType(String templateCode) {
        this.templateCode = templateCode;
    }

    public String getTemplateCode() {
        return templateCode;
    }
}
