package wiki.zex.cloud.example.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.google.common.base.Function;
import org.checkerframework.checker.nullness.qual.Nullable;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.transaction.annotation.Transactional;
import wiki.zex.cloud.example.entity.SyDept;
import wiki.zex.cloud.example.mapper.SyDeptMapper;
import wiki.zex.cloud.example.req.SyDeptReq;
import wiki.zex.cloud.example.resp.SyDeptDetails;
import wiki.zex.cloud.example.resp.SyDeptTree;
import wiki.zex.cloud.example.service.ISyDeptRoleRelService;
import wiki.zex.cloud.example.service.ISyDeptService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;
import wiki.zex.cloud.example.service.ISyUserDeptRelService;
import wiki.zex.cloud.example.utils.TreeUtils;

import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * <p>
 * 部门表 服务实现类
 * </p>
 *
 * @author Zex
 * @since 2020-05-29
 */
@Service
public class SyDeptServiceImpl extends ServiceImpl<SyDeptMapper, SyDept> implements ISyDeptService {

    @Autowired
    private ISyDeptRoleRelService iSyDeptRoleRelService;

    @Autowired
    private ISyUserDeptRelService iSyUserDeptRelService;
    @Override
    @Transactional
    public SyDept create(SyDeptReq req) {
        SyDept syDept = new SyDept();
        BeanUtils.copyProperties(req,syDept);
        save(syDept);
        iSyDeptRoleRelService.updateByDeptId(syDept.getId(),req.getRoleIds());
        return syDept;
    }

    @Override
    @Transactional
    public SyDept update(Long id, SyDeptReq req) {
        SyDept syDept = new SyDept();
        syDept.setId(id);
        BeanUtils.copyProperties(req,syDept);
        updateById(syDept);
        iSyDeptRoleRelService.updateByDeptId(syDept.getId(),req.getRoleIds());
        return syDept;
    }

    @Override
    public List<SyDeptTree> tree() {
        List<SyDept> depts = list(new LambdaQueryWrapper<SyDept>().orderByDesc(SyDept::getSeq));
        List<SyDeptTree> list = depts.stream().flatMap((Function<SyDept, Stream<SyDeptTree>>) input -> {
            SyDeptTree tree = new SyDeptTree();
            BeanUtils.copyProperties(input, tree);
            return Stream.of(tree);
        }).collect(Collectors.toList());
        return TreeUtils.listToTree(list);
    }

    @Override
    public SyDeptDetails detailsById(Long id) {
        SyDeptDetails details = new SyDeptDetails();
        SyDept dept = getById(id);
        BeanUtils.copyProperties(dept,details);
        List<Long> roleIds = iSyDeptRoleRelService.getIdsByDeptId(id);
        details.setRoleIds(roleIds);
        return details;
    }

    @Override
    @Transactional
    public void delete(Long id) {
        iSyUserDeptRelService.removeByDeptId(id);
        iSyDeptRoleRelService.removeByDeptId(id);
        removeById(id);
    }
}
