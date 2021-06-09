package wiki.zex.cloud.example.entity;

import com.alibaba.excel.annotation.ExcelIgnore;
import com.alibaba.excel.annotation.ExcelProperty;
import com.baomidou.mybatisplus.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;
import wiki.zex.cloud.example.config.excel.GenderConverter;
import wiki.zex.cloud.example.config.serializers.JsonLongSerializer;
import wiki.zex.cloud.example.enums.GenderType;

/**
 * <p>
 * 
 * </p>
 *
 * @author Zex
 * @since 2020-05-12
 */
@Data
@EqualsAndHashCode(callSuper = false)
@ApiModel(value="SyUser对象", description="")
public class SyUser implements Serializable {

    private static final long serialVersionUID = 1L;


    @TableId(value = "id", type = IdType.ASSIGN_ID)
    @JsonSerialize(using = JsonLongSerializer.class)
    @ExcelProperty("id")
    private Long id;

    @ApiModelProperty(value = "账号")
    @ExcelProperty("账号")
    private String username;

    @ApiModelProperty(value = "密码")
    @JsonIgnore
    @ExcelIgnore
    private String password;

    @ApiModelProperty(value = "手机号码")
    @ExcelProperty("手机号码")
    private String mobile;

    @ApiModelProperty(value = "邮箱")
    @ExcelProperty("邮箱")
    private String email;

    @ApiModelProperty(value = "昵称")
    @ExcelProperty("昵称")
    private String nickname;

    @ApiModelProperty(value = "真实姓名")
    @ExcelProperty("真实姓名")
    private String realName;

    @ApiModelProperty(value = "头像")
    @ExcelProperty("头像")
    private String avatar;

    @ApiModelProperty(value = "工号")
    @ExcelProperty("工号")
    private String workNo;

    @ApiModelProperty(value = "性别")
    @ExcelProperty(value = "性别",converter = GenderConverter.class)
    private GenderType gender;

    @ApiModelProperty(value = "生日")
    @ExcelIgnore
    private LocalDate birthDay;

    @ApiModelProperty(value = "创建时间")
    @ExcelIgnore
    private LocalDateTime createAt;

    @ApiModelProperty(value = "最后登录时间")
    @ExcelIgnore
    private LocalDateTime loginAt;

    @ApiModelProperty(value = "最后登录IP")
    @ExcelIgnore
    private String loginIp;

    @ExcelIgnore
    @ApiModelProperty(value = "过期时间")
    @TableField(updateStrategy= FieldStrategy.IGNORED)
    private LocalDateTime expireAt;

    @ApiModelProperty(value = "可用状态")
    @ExcelIgnore
    private Boolean enable;

    @ApiModelProperty(value = "锁定状态")
    @ExcelIgnore
    private Boolean locked;

    @ApiModelProperty(value = "民族")
    private String national;

    @ApiModelProperty(value = "身份证图片")
    private String identityCard;

    @ApiModelProperty(value = "身份证图片反面")
    private String identityCardBackend;

    @ApiModelProperty(value = "手持身份证照片")
    private String identityCardTake;

    @ApiModelProperty(value = "身份证号码")
    private String identityCardNo;



    private String masterClientId;
    private String masterPushId;
    private String driverPushId;
    private String driverClientId;
    private String authenticationAvatar;




}
