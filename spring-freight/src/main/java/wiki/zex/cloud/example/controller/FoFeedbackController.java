package wiki.zex.cloud.example.controller;


import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import io.swagger.annotations.ApiOperation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import wiki.zex.cloud.example.entity.FoFeedback;
import wiki.zex.cloud.example.enums.FeedbackStatus;
import wiki.zex.cloud.example.req.Pageable;
import wiki.zex.cloud.example.req.SmFeedbackParam;
import wiki.zex.cloud.example.resp.SimpleResp;
import wiki.zex.cloud.example.security.MyUserDetails;
import wiki.zex.cloud.example.service.IFoFeedbackService;
import wiki.zex.cloud.example.utils.NetWorkUtil;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author Zex
 * @since 2020-08-19
 */
@RestController
@RequestMapping("/api/v1/feedbacks")
public class FoFeedbackController {


    @Autowired
    private IFoFeedbackService iFoFeedbackService;

    @GetMapping
    @ApiOperation("查询列表")
    public IPage<FoFeedback> list(Pageable pageable, FeedbackStatus status , Long userId){
        return iFoFeedbackService.page(pageable.convert(),new LambdaQueryWrapper<FoFeedback>()
                .eq(status != null,FoFeedback::getStatus, status)
                .eq(userId != null,FoFeedback::getUserId,userId));
    }

    @PostMapping
    @ApiOperation("新增")
    public FoFeedback create(@Valid @RequestBody SmFeedbackParam param, Authentication authentication){
        MyUserDetails myUserDetails = (MyUserDetails) authentication.getPrincipal();
        return  iFoFeedbackService.save(param, myUserDetails.getId());

    }

    @PutMapping("/status/{id}")
    @ApiOperation("处理")
    public SimpleResp updateStatus(@PathVariable  Long id , FeedbackStatus status, Authentication authentication){
        MyUserDetails myUserDetails = (MyUserDetails) authentication.getPrincipal();
        iFoFeedbackService.updateStatus(id,status,myUserDetails.getId());
        return SimpleResp.SUCCESS;

    }

}
