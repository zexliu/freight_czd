package wiki.zex.cloud.example.req;

import lombok.Data;
import wiki.zex.cloud.example.enums.GenderType;

import java.time.LocalDate;

@Data
public class AuthenticateOwnerReq {


    private String authenticationAvatar;

    private String national;
    private String identityCardNo;
    private String identityCard;

    private LocalDate birthDay;

    private GenderType genderType;

    private String address;

    private String realName;

    private String nature;
}
