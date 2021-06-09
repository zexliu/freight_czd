package wiki.zex.cloud.example.controller;


import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import io.swagger.annotations.Api;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import wiki.zex.cloud.example.entity.SyRole;
import wiki.zex.cloud.example.req.Pageable;
import wiki.zex.cloud.example.req.SyRoleReq;
import wiki.zex.cloud.example.resp.SimpleResp;
import wiki.zex.cloud.example.resp.SyRoleResp;
import wiki.zex.cloud.example.service.ISyRoleService;

import javax.validation.Valid;

/**
 * <p>
 * 角色表 前端控制器
 * </p>
 *
 * @author Zex
 * @since 2020-05-28
 */
@RestController
@RequestMapping("/api/v1/roles")
@Api(tags = "角色相关接口")
public class SyRoleController {

    @Autowired
    private ISyRoleService iSyRoleService;

    @GetMapping
    public IPage<SyRole> list(Pageable pageable){
        return iSyRoleService.page(pageable.convert(),
                new LambdaQueryWrapper<SyRole>().orderByDesc(SyRole::getSeq));
    }

    @GetMapping("/{id}")
    public SyRoleResp detailsById(@PathVariable Long id){
        return iSyRoleService.detailsById(id);
    }
    @PostMapping
    public SyRole create(@RequestBody @Valid SyRoleReq req){
        return iSyRoleService.create(req);
    }

    @PutMapping("/{id}")
    public SyRole update(@PathVariable Long id ,@RequestBody @Valid SyRoleReq req){
        return iSyRoleService.update(id,req);
    }

    @DeleteMapping("/{id}")
    public SimpleResp delete(@PathVariable Long id ){
         iSyRoleService.delete(id);
        return SimpleResp.SUCCESS;
    }

}
