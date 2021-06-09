package wiki.zex.cloud.example.controller;


import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import io.swagger.annotations.Api;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import wiki.zex.cloud.example.entity.SyDept;
import wiki.zex.cloud.example.req.Pageable;
import wiki.zex.cloud.example.req.SyDeptReq;
import wiki.zex.cloud.example.resp.SimpleResp;
import wiki.zex.cloud.example.resp.SyDeptDetails;
import wiki.zex.cloud.example.resp.SyDeptTree;
import wiki.zex.cloud.example.service.ISyDeptService;
import wiki.zex.cloud.example.utils.TreeUtils;

import javax.validation.Valid;
import java.util.List;

/**
 * <p>
 * 部门表 前端控制器
 * </p>
 *
 * @author Zex
 * @since 2020-05-29
 */
@RestController
@RequestMapping("/api/v1/depts")
@Api(tags = "部门相关接口")
public class SyDeptController {

    @Autowired
    private ISyDeptService iSyDeptService;


    @GetMapping
    public IPage<SyDept> list(@RequestBody @Valid Pageable pageable,String deptName,String deptCode){
        return iSyDeptService.page(pageable.convert(),new LambdaQueryWrapper<SyDept>()
                .like(StringUtils.isNotBlank(deptName),SyDept::getDeptName,deptName)
                .like(StringUtils.isNotBlank(deptCode),SyDept::getDeptCode,deptCode)
        .orderByDesc(SyDept::getSeq));
    }

    @GetMapping("/tree")
    public List<SyDeptTree> tree(){
        return iSyDeptService.tree();
    }
    @GetMapping("/{id}")
    public SyDeptDetails getById(@PathVariable Long id ){
        return iSyDeptService.detailsById(id);
    }


    @PostMapping
    public SyDept create(@RequestBody @Valid  SyDeptReq req){
        return iSyDeptService.create(req);
    }

    @PutMapping("/{id}")
    public SyDept update(@PathVariable Long id ,@RequestBody @Valid  SyDeptReq req){
        return iSyDeptService.update(id,req);
    }

    @DeleteMapping("/{id}")
    public SimpleResp resp(@PathVariable Long id){
         iSyDeptService.delete(id);
        return SimpleResp.SUCCESS;
    }

}
