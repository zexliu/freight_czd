package wiki.zex.cloud.example.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.google.common.base.Function;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import wiki.zex.cloud.example.entity.FoCategory;
import wiki.zex.cloud.example.entity.SyDictEntry;
import wiki.zex.cloud.example.mapper.FoCategoryMapper;
import wiki.zex.cloud.example.req.FoCategoryReq;
import wiki.zex.cloud.example.resp.FoCategoryDetails;
import wiki.zex.cloud.example.resp.FoCategoryTree;
import wiki.zex.cloud.example.service.IFoCategoryService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;
import wiki.zex.cloud.example.service.IFoDictRelationService;
import wiki.zex.cloud.example.utils.TreeUtils;

import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static wiki.zex.cloud.example.constants.SysConstants.PACKAGE_MODEL;

/**
 * <p>
 * 服务实现类
 * </p>
 *
 * @author Zex
 * @since 2020-07-04
 */
@Service
public class FoCategoryServiceImpl extends ServiceImpl<FoCategoryMapper, FoCategory> implements IFoCategoryService {

    @Autowired
    private IFoDictRelationService iFoDictRelationService;

    @Override
    public void delete(Long id) {
        iFoDictRelationService.removeByRelationId(id, PACKAGE_MODEL);
        removeById(id);
    }

    @Override
    @Transactional
    public FoCategory update(Long id, FoCategoryReq req) {
        FoCategory category = new FoCategory();
        BeanUtils.copyProperties(req, category);
        category.setId(id);
        updateById(category);
        iFoDictRelationService.updateRelation(category.getId(), PACKAGE_MODEL, req.getDictEntryValues());
        return category;
    }

    @Override
    @Transactional
    public FoCategory create(FoCategoryReq req) {
        FoCategory category = new FoCategory();
        BeanUtils.copyProperties(req, category);
        save(category);
        iFoDictRelationService.updateRelation(category.getId(), PACKAGE_MODEL, req.getDictEntryValues());
        return category;
    }

    @Override
    public List<FoCategoryTree> tree(String categoryCode) {
        List<FoCategory> categories = list(new LambdaQueryWrapper<FoCategory>()
                .eq(FoCategory::getCategoryCode, categoryCode)
                .orderByDesc(FoCategory::getSeq));
        List<FoCategoryTree> list = categories.stream()
                .flatMap((Function<FoCategory, Stream<FoCategoryTree>>) input -> {
            FoCategoryTree tree = new FoCategoryTree();
            BeanUtils.copyProperties(input, tree);
            return Stream.of(tree);
        }).collect(Collectors.toList());
        return TreeUtils.listToTree(list);
    }

    @Override
    public FoCategoryDetails getDetailsById(Long id) {
        FoCategoryDetails details = new FoCategoryDetails();
        FoCategory category = getById(id);
        BeanUtils.copyProperties(category, details);
        List<FoCategory> categories = list(new LambdaQueryWrapper<FoCategory>()
                .eq(FoCategory::getParentId, id)
                .orderByDesc(FoCategory::getSeq));
        details.setChildren(categories);
        List<SyDictEntry> dictEntries = iFoDictRelationService.dictEntries(id, PACKAGE_MODEL);
        details.setDictEntries(dictEntries);
        return details;
    }

    @Override
    public FoCategoryDetails getByName(String categoryName) {
        FoCategoryDetails details = new FoCategoryDetails();
        FoCategory category = getOne(new LambdaQueryWrapper<FoCategory>().eq(FoCategory::getCategoryName, categoryName),false);
        if (category == null){
            return null;
        }
        BeanUtils.copyProperties(category, details);
        List<FoCategory> categories = list(new LambdaQueryWrapper<FoCategory>()
                .eq(FoCategory::getParentId, category.getId())
                .orderByDesc(FoCategory::getSeq));
        details.setChildren(categories);
        List<SyDictEntry> dictEntries = iFoDictRelationService.dictEntries(category.getId(), PACKAGE_MODEL);
        details.setDictEntries(dictEntries);
        return details;
    }
}
