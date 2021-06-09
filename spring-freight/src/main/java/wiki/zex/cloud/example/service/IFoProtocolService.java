package wiki.zex.cloud.example.service;

import org.springframework.security.core.Authentication;
import wiki.zex.cloud.example.entity.FoProtocol;
import com.baomidou.mybatisplus.extension.service.IService;
import wiki.zex.cloud.example.req.FoProtocolReq;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author Zex
 * @since 2020-07-30
 */
public interface IFoProtocolService extends IService<FoProtocol> {

    FoProtocol create(FoProtocolReq req, Authentication authentication);

    void agree(Long id, Authentication authentication);

}
