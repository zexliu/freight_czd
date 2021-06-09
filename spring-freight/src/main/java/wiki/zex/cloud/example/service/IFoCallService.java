package wiki.zex.cloud.example.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.security.core.Authentication;
import wiki.zex.cloud.example.entity.FoCall;
import com.baomidou.mybatisplus.extension.service.IService;
import wiki.zex.cloud.example.req.FoCallReq;
import wiki.zex.cloud.example.resp.FoCallResp;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author Zex
 * @since 2020-07-14
 */
public interface IFoCallService extends IService<FoCall> {

    FoCall create(FoCallReq req, Authentication authentication);


    IPage<FoCallResp> list(Page<FoCallResp> page, Authentication authentication);

}
