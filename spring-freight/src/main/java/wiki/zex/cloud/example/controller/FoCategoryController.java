package wiki.zex.cloud.example.controller;


import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import io.swagger.annotations.Api;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import wiki.zex.cloud.example.entity.FoCategory;
import wiki.zex.cloud.example.resp.FoCategoryDetails;
import wiki.zex.cloud.example.req.Pageable;
import wiki.zex.cloud.example.req.FoCategoryReq;
import wiki.zex.cloud.example.resp.SimpleResp;
import wiki.zex.cloud.example.resp.FoCategoryTree;
import wiki.zex.cloud.example.service.IFoCategoryService;

import javax.validation.Valid;
import java.util.List;

/**
 * <p>
 *  前端控制器
 * </p>
 *
 * @author Zex
 * @since 2020-07-04
 */
@RestController
@RequestMapping("/api/v1/categories")
@Api(tags = "分类相关接口")
public class FoCategoryController {

    @Autowired
    private IFoCategoryService iFoCategoryService;


    @GetMapping
    public IPage<FoCategory> list( Pageable pageable, String categoryName, String categoryCode, Boolean isHot,Boolean isParent){
        return iFoCategoryService.page(pageable.convert(),new LambdaQueryWrapper<FoCategory>()
                .like(StringUtils.isNotBlank(categoryName),FoCategory::getCategoryName,categoryName)
                .eq(StringUtils.isNotBlank(categoryCode),FoCategory::getCategoryCode,categoryCode)
                .eq(isHot != null,FoCategory::getIsHot , isHot)
                .isNull(isParent != null , FoCategory::getParentId)
                .orderByDesc(FoCategory::getSeq));
    }

    @GetMapping("/tree")
    public List<FoCategoryTree> tree(String categoryCode){
        return iFoCategoryService.tree(categoryCode);
    }
    @GetMapping("/{id}")
    public FoCategoryDetails getById(@PathVariable Long id ){
        return iFoCategoryService.getDetailsById(id);
    }

    @GetMapping("/name")
    public FoCategoryDetails getByName(@RequestParam String categoryName){
        return iFoCategoryService.getByName(categoryName);
    }

    @PostMapping
    public FoCategory create(@RequestBody @Valid FoCategoryReq req){
        return iFoCategoryService.create(req);
    }

    @PutMapping("/{id}")
    public FoCategory update(@PathVariable Long id ,@RequestBody @Valid  FoCategoryReq req){
        return iFoCategoryService.update(id,req);
    }

    @DeleteMapping("/{id}")
    public SimpleResp resp(@PathVariable Long id){
        iFoCategoryService.delete(id);
        return SimpleResp.SUCCESS;
    }
}
