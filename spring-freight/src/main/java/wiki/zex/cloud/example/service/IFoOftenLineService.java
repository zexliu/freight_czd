package wiki.zex.cloud.example.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.security.core.Authentication;
import wiki.zex.cloud.example.entity.FoOftenLine;
import com.baomidou.mybatisplus.extension.service.IService;
import wiki.zex.cloud.example.req.FoOftenLineReq;

import java.util.List;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author Zex
 * @since 2020-07-12
 */
public interface IFoOftenLineService extends IService<FoOftenLine> {

    IPage<FoOftenLine> page(Page<FoOftenLine> page , Authentication authentication);

    FoOftenLine create(FoOftenLineReq req, Authentication authentication);

    FoOftenLine update(Long id, FoOftenLineReq req, Authentication authentication);

    void updateStatus(Long clientId, boolean b);

    List<FoOftenLine> findByStatus(boolean b);
}
