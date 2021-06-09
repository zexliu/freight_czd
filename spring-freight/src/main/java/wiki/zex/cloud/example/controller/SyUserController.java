package wiki.zex.cloud.example.controller;


import com.baomidou.mybatisplus.core.conditions.update.LambdaUpdateWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.hibernate.validator.constraints.Length;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import wiki.zex.cloud.example.entity.SyUser;
import wiki.zex.cloud.example.req.Pageable;
import wiki.zex.cloud.example.req.SyUserReq;
import wiki.zex.cloud.example.resp.SimpleDriverResp;
import wiki.zex.cloud.example.resp.SimpleResp;
import wiki.zex.cloud.example.resp.SyUserResp;
import wiki.zex.cloud.example.security.MyUserDetails;
import wiki.zex.cloud.example.service.ISyUserService;

import javax.validation.Valid;


/**
 * <p>
 * 前端控制器
 * </p>
 *
 * @author Zex
 * @since 2020-05-12
 */
@Validated
@RestController
@RequestMapping("/api/v1/users")
@Api(tags = "用户相关接口")
public class SyUserController {

    @Autowired
    private ISyUserService iSyUserService;


    @GetMapping
    @ApiOperation("分页查询")
    IPage<SyUser> list(Pageable pageable,String keywords, String username, String mobile, String realName, String workNo, Long deptId, Long roleId,Boolean enable, Boolean locked) {
        return iSyUserService.list(pageable.convert(), keywords,username, mobile, realName, workNo, deptId, roleId,enable, locked);
//        return iSyUserService.page(pageable.convert(), new LambdaQueryWrapper<SyUser>()
//                .like(StringUtils.isNotBlank(username), SyUser::getUsername, username)
//                .like(StringUtils.isNotBlank(mobile), SyUser::getMobile, mobile)
//                .eq(StringUtils.isNotBlank(realName), SyUser::getRealName, realName)
//                .like(StringUtils.isNotBlank(workNo), SyUser::getWorkNo, workNo)
//                .eq(enable != null, SyUser::getEnable, enable)
//                .eq(locked != null, SyUser::getLocked, locked)
//                .orderByDesc(SyUser::getCreateAt)
//        );
    }

    @GetMapping("/{id}")
    public SyUserResp getById(@PathVariable Long id) {
        return iSyUserService.getDetailsById(id);
    }

    @PostMapping
    public SyUser create(@Valid @RequestBody SyUserReq req) {
        return iSyUserService.create(req);
    }

    @PutMapping("/{id}")
    public SyUser update(@PathVariable Long id, @Valid @RequestBody SyUserReq req) {
        return iSyUserService.update(id, req);
    }

    @DeleteMapping("/{id}")
    public SimpleResp delete(@PathVariable Long id) {
        iSyUserService.delete(id);
        return SimpleResp.SUCCESS;
    }

    @GetMapping("/self")
    @PreAuthorize("isAuthenticated()")
    public Object authentication(Authentication authentication) {
        return authentication.getPrincipal();
    }


    @PostMapping("/{id}/password")
    public SimpleResp password(@PathVariable Long id, @RequestParam @Length(min = 32, max = 32)
            String password) {
        iSyUserService.password(id, password);
        return SimpleResp.SUCCESS;
    }

    @PostMapping("/mobile")
    @PreAuthorize("isAuthenticated()")
    public SimpleResp updateMobile(@RequestParam String mobile,@RequestParam String captcha,@RequestParam String newCaptcha,Authentication authentication){
        iSyUserService.updateMobile(mobile,captcha,newCaptcha,authentication);
        return SimpleResp.SUCCESS;
    }

    @GetMapping("/count")
    public Long getCount(String roleCode) {
        return iSyUserService.getCount(roleCode);
    }


    @GetMapping("/driver")
    public SimpleDriverResp driver(Pageable pageable, String mobile) {
        return iSyUserService.drivers(pageable.convert(), mobile);
    }


    @PutMapping("/push")
    @PreAuthorize("isAuthenticated()")
    public SimpleResp updatePush(@RequestParam String clientType, String clientId, String pushId, Authentication authentication) {
        MyUserDetails m = (MyUserDetails) authentication.getPrincipal();
        iSyUserService.update(new LambdaUpdateWrapper<SyUser>()
                .set(clientType.equals("master"), SyUser::getMasterClientId, clientId)
                .set(clientType.equals("master"), SyUser::getMasterPushId, pushId)
                .set(clientType.equals("driver"), SyUser::getDriverClientId, clientId)
                .set(clientType.equals("driver"), SyUser::getDriverPushId, pushId)
                .eq(SyUser::getId, m.getId()));
        return SimpleResp.SUCCESS;
    }


    @PutMapping("/avatar")
    @PreAuthorize("isAuthenticated()")
    public SimpleResp updateAvatar(Authentication authentication,@RequestParam String avatar) {
        MyUserDetails m = (MyUserDetails) authentication.getPrincipal();
       iSyUserService.update(new LambdaUpdateWrapper<SyUser>().set(SyUser::getAvatar, avatar).eq(SyUser::getId,m.getId()));
        return SimpleResp.SUCCESS;
    }
}
