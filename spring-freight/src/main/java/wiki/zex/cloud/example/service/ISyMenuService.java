package wiki.zex.cloud.example.service;

import org.springframework.security.core.Authentication;
import wiki.zex.cloud.example.entity.SyMenu;
import com.baomidou.mybatisplus.extension.service.IService;
import wiki.zex.cloud.example.req.SyMenuReq;
import wiki.zex.cloud.example.resp.SyMenuTree;

import java.util.List;

/**
 * <p>
 * 菜单管理 服务类
 * </p>
 *
 * @author Zex
 * @since 2020-05-31
 */
public interface ISyMenuService extends IService<SyMenu> {

    List<SyMenuTree> tree();

    SyMenu create(SyMenuReq req);

    SyMenu update(Long id, SyMenuReq req);

    void delete(Long id);

    List<SyMenuTree> tree(Authentication userId);

    List<SyMenu> getByRoleId(Long id);
}
