package wiki.zex.cloud.example.entity;

import com.baomidou.mybatisplus.annotation.IdType;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableField;

import java.io.Serializable;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import io.swagger.annotations.ApiModel;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.experimental.Accessors;
import wiki.zex.cloud.example.config.serializers.JsonLongSerializer;

/**
 * <p>
 * 发货信息
 * </p>
 *
 * @author Zex
 * @since 2020-07-08
 */
@Data
@EqualsAndHashCode(callSuper = false)
@ApiModel(value = "FoDeliverGoods对象", description = "发货信息")
public class FoDeliverGoods implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(value = "id", type = IdType.ASSIGN_ID)
    @JsonSerialize(using = JsonLongSerializer.class)
    private Long id;
    @JsonSerialize(using = JsonLongSerializer.class)

    private Long userId;

    private String loadProvinceCode;

    private String loadCityCode;

    private String loadDistrictCode;

    private String loadAddress;

    private String loadWayProvinceCode;

    private String loadWayCityCode;

    private String loadWayDistrictCode;

    private String loadWayAddress;

    private String unloadProvinceCode;

    private String unloadCityCode;

    private String unloadDistrictCode;

    private String unloadAddress;

    private String unloadWayProvinceCode;

    private String unloadWayCityCode;

    private String unloadWayDistrictCode;

    private String unloadWayAddress;

    private String categoryName;

    //傻逼需求修改
    private String weight;
    //傻逼需求修改
    private String volume;

    private String carType;

    private String carLongs;

    private Double carPlaceLong;

    private String carModels;

    private String loadUnload;

    private LocalDateTime loadStartAt;

    private LocalDateTime loadEndAt;


    private String remark;

    @TableField("require_List")
    private String requireList;

    private BigDecimal expectMoney;

    private String expectUnit;

    private LocalDateTime createAt;

    private Integer status;
    private Integer deleteStatus;
    private Integer markStatus;
    private Double loadLat;
    private Double loadLon;
    private Double loadWayLat;
    private Double loadWayLon;
    private Double unloadLat;
    private Double unloadLon;
    private Double unloadWayLat;
    private Double unloadWayLon;
    private String packageMode;

}
