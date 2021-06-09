package wiki.zex.cloud.example.entity;

import com.baomidou.mybatisplus.annotation.IdType;

import java.time.LocalDateTime;

import com.baomidou.mybatisplus.annotation.TableId;

import java.io.Serializable;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;
import wiki.zex.cloud.example.config.serializers.JsonLongSerializer;

/**
 * <p>
 *
 * </p>
 *
 * @author Zex
 * @since 2020-07-30
 */
@Data
@EqualsAndHashCode(callSuper = false)
@Accessors(chain = true)
@ApiModel(value = "FoProtocol对象", description = "")
public class FoProtocol implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.ASSIGN_ID)
    @JsonSerialize(using = JsonLongSerializer.class)

    private Long id;
    @JsonSerialize(using = JsonLongSerializer.class)

    private Long orderId;

    private Double amount;

    private Double freightAmount;

    private Integer payDays;

    private LocalDateTime loadStartAt;
    private LocalDateTime loadEndAt;

    private LocalDateTime unloadStartAt;
    private LocalDateTime unloadEndAt;

    private String loadProvinceCode;

    private String loadCityCode;

    private String loadDistrictCode;

    private String unloadProvinceCode;

    private String unloadCityCode;

    private String unloadDistrictCode;

    private String loadAddress;

    private String unloadAddress;

    private String categoryName;

    private String carType;

    private String carLongs;

    private String carModels;
    //傻逼需求修改
    private String weight;
    //傻逼需求修改
    private String volume;

    private String plateNumber;

    private Boolean driverAgree;

    private Boolean userAgree;

    private LocalDateTime createAt;

    private String supplement;


}
