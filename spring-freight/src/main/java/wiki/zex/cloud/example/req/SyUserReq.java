package wiki.zex.cloud.example.req;

import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import org.hibernate.validator.constraints.Length;
import wiki.zex.cloud.example.enums.GenderType;
import javax.validation.constraints.NotBlank;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Data
public class SyUserReq {

    @NotBlank
    @Length(min = 5, max = 30)
    private String username;

    @NotBlank
    @Length(min = 2, max = 10)
    private String realName;
    @NotBlank
    @Length(min = 2, max = 20)
    private String nickname;

    private String avatar;

    @Length(min = 32, max = 32)
    private String password;

    @NotBlank
    @Length(min = 11, max = 11)
    private String mobile;

    @Length(max = 30)
    private String workNo;

    @Length(min = 8, max = 30)
    private String email;

    private GenderType gender;

    private LocalDate birthDay;

    private Boolean enable;

    private LocalDateTime expireAt;

    private Boolean locked;

    private List<Long> roleIds;

    private List<Long> deptIds;

    private String national;

    private String identityCard;

    private String identityCardNo;

    private String authenticationAvatar;
}
