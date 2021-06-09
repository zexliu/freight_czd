package wiki.zex.cloud.example.req;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import io.swagger.annotations.ApiModel;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

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
public class FoDeliverGoodsReq implements Serializable {

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

    private String volume;

    private String carType;

    private List<String> carLongs;

    private Double carPlaceLong;

    private List<String> carModels;

    private String loadUnload;

    private LocalDateTime loadStartAt;

    private LocalDateTime loadEndAt;

    private String remark;

    private List<String> requireList;

    private BigDecimal expectMoney;

    private String expectUnit;

    private LocalDateTime createAt;

    private Integer status;

    private Double loadLat;
    private Double loadLon;
    private Double loadWayLat;
    private Double loadWayLon;
    private Double unloadLat;
    private Double unloadLon;
    private Double unloadWayLat;
    private Double unloadWayLon;
    private String packageMode;

    private Long driverId;
    private BigDecimal amount;
    private BigDecimal freightAmount;

}
