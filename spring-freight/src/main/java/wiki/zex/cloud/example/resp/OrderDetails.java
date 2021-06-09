package wiki.zex.cloud.example.resp;

import com.baomidou.mybatisplus.annotation.TableField;
import lombok.Data;
import lombok.EqualsAndHashCode;
import wiki.zex.cloud.example.entity.FoOrder;

import java.time.LocalDateTime;

@Data

@EqualsAndHashCode(callSuper = false)
public class OrderDetails extends FoOrder {

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

    private String weight;

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

    private Double expectMoney;

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

    private String driverName;
    private String driverAvatar;
    private String driverMobile;

    private String userName;
    private String userAvatar;
    private String userMobile;
    private String companyName;


}
