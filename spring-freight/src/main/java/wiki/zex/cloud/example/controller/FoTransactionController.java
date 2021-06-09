package wiki.zex.cloud.example.controller;


import com.baomidou.mybatisplus.core.metadata.IPage;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import org.springframework.web.bind.annotation.RestController;
import wiki.zex.cloud.example.entity.FoTransaction;
import wiki.zex.cloud.example.req.Pageable;
import wiki.zex.cloud.example.service.IFoTransactionService;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author Zex
 * @since 2020-08-17
 */
@RestController
@RequestMapping("/api/v1/transactions")
public class FoTransactionController {



    @Autowired
    private IFoTransactionService iFoTransactionService;

    @GetMapping
    @ApiOperation("获取交易记录分页")
    public IPage<FoTransaction> page(Pageable pageable, LocalDateTime startAt, LocalDateTime endAt, Boolean incrStatus, Integer type, Long userId) {
        return iFoTransactionService.page(pageable.convert(),startAt,endAt,incrStatus,type,userId);
    }

    @GetMapping("/balance")
    @ApiOperation("获取当前用户钱包余额")
    public BigDecimal currentBalance(LocalDateTime startAt, LocalDateTime endAt, Boolean incrStatus, Integer type,Long userId){
        return iFoTransactionService.balance(startAt,endAt,incrStatus,type,userId);
    }

}
