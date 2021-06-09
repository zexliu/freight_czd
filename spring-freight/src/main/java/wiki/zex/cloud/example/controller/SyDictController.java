package wiki.zex.cloud.example.controller;


import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import wiki.zex.cloud.example.entity.SyDict;
import wiki.zex.cloud.example.req.Pageable;
import wiki.zex.cloud.example.req.SyDictReq;
import wiki.zex.cloud.example.resp.SimpleResp;
import wiki.zex.cloud.example.service.ISyDictService;
import javax.validation.Valid;

/**
 * <p>
 * 数据字典 前端控制器
 * </p>
 *
 * @author Zex
 * @since 2020-06-02
 */
@RestController
@RequestMapping("/api/v1/dicts")
public class SyDictController {

    @Autowired
    private ISyDictService iSyDictService;

    @GetMapping
    public IPage<SyDict> list(Pageable pageable,String dictName,String dictCode){
        return iSyDictService.page(pageable.convert(),new LambdaQueryWrapper<SyDict>()
        .like(StringUtils.isNotBlank(dictName),SyDict::getDictName,dictName)
        .like(StringUtils.isNotBlank(dictCode),SyDict::getDictCode,dictCode));
    }

    @PostMapping
    public SyDict create(@RequestBody @Valid SyDictReq req){
        return iSyDictService.create(req);
    }

    @PutMapping("/{id}")
    public SyDict update(@PathVariable Long id ,@RequestBody @Valid SyDictReq req){
        return iSyDictService.update(id,req);
    }

    @DeleteMapping("/{id}")
    public SimpleResp delete(@PathVariable Long id){
         iSyDictService.delete(id);
        return SimpleResp.SUCCESS;
    }

}
