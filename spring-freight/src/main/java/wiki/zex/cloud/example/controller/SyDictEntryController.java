package wiki.zex.cloud.example.controller;


import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import wiki.zex.cloud.example.entity.SyDictEntry;
import wiki.zex.cloud.example.req.Pageable;
import wiki.zex.cloud.example.req.SyDictEntryReq;
import wiki.zex.cloud.example.resp.SimpleResp;
import wiki.zex.cloud.example.service.ISyDictEntryService;
import javax.validation.Valid;

/**
 * <p>
 * 字典项 前端控制器
 * </p>
 *
 * @author Zex
 * @since 2020-06-02
 */
@RestController
@RequestMapping("/api/v1/dict/entries")
public class SyDictEntryController {
    @Autowired
    private ISyDictEntryService iSyDictEntryService;

    @GetMapping
    public IPage<SyDictEntry> list(Pageable pageable,String dictCode){
        return iSyDictEntryService.page(pageable.convert(),new LambdaQueryWrapper<SyDictEntry>()
        .eq(StringUtils.isNotBlank(dictCode),SyDictEntry::getDictCode,dictCode));
    }

    @PostMapping
    public SyDictEntry create(@RequestBody @Valid SyDictEntryReq req){
        return iSyDictEntryService.create(req);
    }

    @PutMapping("/{id}")
    public SyDictEntry update(@PathVariable Long id ,@RequestBody @Valid SyDictEntryReq req){
        return iSyDictEntryService.update(id,req);
    }

    @DeleteMapping("/{id}")
    public SimpleResp delete(@PathVariable Long id){
        iSyDictEntryService.delete(id);
        return SimpleResp.SUCCESS;
    }

}
