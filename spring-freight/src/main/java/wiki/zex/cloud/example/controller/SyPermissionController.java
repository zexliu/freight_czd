package wiki.zex.cloud.example.controller;


import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import io.swagger.annotations.Api;
import org.apache.ibatis.annotations.Delete;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import wiki.zex.cloud.example.entity.SyPermission;
import wiki.zex.cloud.example.req.Pageable;
import wiki.zex.cloud.example.req.SyPermissionReq;
import wiki.zex.cloud.example.resp.SimpleResp;
import wiki.zex.cloud.example.resp.SyPermissionTree;
import wiki.zex.cloud.example.service.ISyPermissionService;

import javax.validation.Valid;
import java.util.List;

/**
 * <p>
 * 权限管理 前端控制器
 * </p>
 *
 * @author Zex
 * @since 2020-05-31
 */
@RestController
@RequestMapping("/api/v1/permissions")
@Api(tags = "权限相关接口")
public class SyPermissionController {

    @Autowired
    private ISyPermissionService iSyPermissionService;

    @GetMapping
    public IPage<SyPermission> list(Pageable pageable) {
        return iSyPermissionService.page(pageable.convert(), new LambdaQueryWrapper<SyPermission>().orderByDesc(SyPermission::getSeq));
    }


    @GetMapping("/tree")
    public List<SyPermissionTree>tree() {
        return iSyPermissionService.tree();
    }


    @PostMapping
    public SyPermission create(@RequestBody @Valid SyPermissionReq req){
        return iSyPermissionService.create(req);
    }

    @GetMapping("/{id}")
    public SyPermission update(@PathVariable Long id){
        return iSyPermissionService.getById(id);
    }


    @PutMapping("/{id}")
    public SyPermission update(@PathVariable Long id,@RequestBody @Valid SyPermissionReq req){
        return iSyPermissionService.update(id,req);
    }

    @DeleteMapping("/{id}")
    public SimpleResp delete(@PathVariable Long id){
         iSyPermissionService.delete(id);
        return SimpleResp.SUCCESS;
    }
}
