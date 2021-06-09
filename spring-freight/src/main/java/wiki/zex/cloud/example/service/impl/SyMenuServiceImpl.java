package wiki.zex.cloud.example.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import wiki.zex.cloud.example.entity.SyMenu;
import wiki.zex.cloud.example.mapper.SyMenuMapper;
import wiki.zex.cloud.example.req.SyMenuReq;
import wiki.zex.cloud.example.resp.SyMenuTree;
import wiki.zex.cloud.example.security.MyUserDetails;
import wiki.zex.cloud.example.service.ISyMenuService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;
import wiki.zex.cloud.example.service.ISyRoleMenuRelService;
import wiki.zex.cloud.example.utils.TreeUtils;

import java.util.List;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

/**
 * <p>
 * 菜单管理 服务实现类
 * </p>
 *
 * @author Zex
 * @since 2020-05-31
 */
@Service
public class SyMenuServiceImpl extends ServiceImpl<SyMenuMapper, SyMenu> implements ISyMenuService {


    @Autowired
    private ISyRoleMenuRelService iSyRoleMenuRelService;
    @Override
    public List<SyMenuTree> tree() {
        List<SyMenu> list = list(new LambdaQueryWrapper<SyMenu>().orderByDesc(SyMenu::getSeq));
       return listToTree(list);
    }

    private List<SyMenuTree> listToTree(List<SyMenu> list) {
        List<SyMenuTree> collect = list.stream().flatMap((Function<SyMenu, Stream<SyMenuTree>>) syMenu -> {
            SyMenuTree tree = new SyMenuTree();
            BeanUtils.copyProperties(syMenu, tree);
            return Stream.of(tree);
        }).collect(Collectors.toList());
        return TreeUtils.listToTree(collect);
    }

    @Override
    public SyMenu create(SyMenuReq req) {
        SyMenu syMenu = new SyMenu();
        BeanUtils.copyProperties(req,syMenu);
        save(syMenu);
        return syMenu;
    }

    @Override
    public SyMenu update(Long id, SyMenuReq req) {
        SyMenu syMenu = new SyMenu();
        BeanUtils.copyProperties(req,syMenu);
        syMenu.setId(id);
        updateById(syMenu);
        return syMenu;
    }

    @Override
    public void delete(Long id) {
        iSyRoleMenuRelService.removeByMenuId(id);
        removeById(id);
    }

    @Override
    public List<SyMenuTree> tree(Authentication authentication) {
        MyUserDetails userDetails = (MyUserDetails) authentication.getPrincipal();
        List<SyMenu> list = baseMapper.getListByUserId(userDetails.getId());
        return listToTree(list);
    }

    @Override
    public List<SyMenu> getByRoleId(Long id) {
        return baseMapper.getByRoleId(id);
    }
}
