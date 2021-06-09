package wiki.zex.cloud.example.controller;


import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import io.swagger.annotations.Api;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import wiki.zex.cloud.example.entity.SyMenu;
import wiki.zex.cloud.example.entity.SyPermission;
import wiki.zex.cloud.example.req.Pageable;
import wiki.zex.cloud.example.req.SyMenuReq;
import wiki.zex.cloud.example.req.SyPermissionReq;
import wiki.zex.cloud.example.resp.SimpleResp;
import wiki.zex.cloud.example.resp.SyMenuTree;
import wiki.zex.cloud.example.resp.SyPermissionTree;
import wiki.zex.cloud.example.service.ISyMenuService;
import wiki.zex.cloud.example.service.ISyPermissionService;

import javax.validation.Valid;
import java.util.List;

/**
 * <p>
 * 菜单管理 前端控制器
 * </p>
 *
 * @author Zex
 * @since 2020-05-31
 */
@RestController
@RequestMapping("/api/v1/menus")
@Api(tags = "菜单相关接口")
public class SyMenuController {

    @Autowired
    private ISyMenuService iSyMenuService;

    @GetMapping
    public IPage<SyMenu> list(Pageable pageable) {
        return iSyMenuService.page(pageable.convert(), new LambdaQueryWrapper<SyMenu>().orderByDesc(SyMenu::getSeq));
    }

    @GetMapping("/tree")
    public List<SyMenuTree> tree() {
        return iSyMenuService.tree();
    }

    @PostMapping
    public SyMenu create(@RequestBody @Valid SyMenuReq req){
        return iSyMenuService.create(req);
    }

    @GetMapping("/{id}")
    public SyMenu update(@PathVariable Long id){
        return iSyMenuService.getById(id);
    }


    @PutMapping("/{id}")
    public SyMenu update(@PathVariable Long id,@RequestBody @Valid SyMenuReq req){
        return iSyMenuService.update(id,req);
    }

    @DeleteMapping("/{id}")
    public SimpleResp delete(@PathVariable Long id){
        iSyMenuService.delete(id);
        return SimpleResp.SUCCESS;
    }


    @GetMapping("/tree/self")
    @PreAuthorize("isAuthenticated()")
    public List<SyMenuTree> tree(Authentication authentication) {
        return iSyMenuService.tree(authentication);
    }
}
