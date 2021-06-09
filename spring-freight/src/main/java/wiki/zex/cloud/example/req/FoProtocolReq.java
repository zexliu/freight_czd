package wiki.zex.cloud.example.req;

import lombok.Data;

import java.time.LocalDateTime;

@Data
public class FoProtocolReq {


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
    private String supplement;


}
