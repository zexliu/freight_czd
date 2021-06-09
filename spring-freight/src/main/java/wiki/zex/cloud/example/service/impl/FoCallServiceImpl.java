package wiki.zex.cloud.example.service.impl;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.beans.BeanUtils;
import org.springframework.security.core.Authentication;
import wiki.zex.cloud.example.entity.FoCall;
import wiki.zex.cloud.example.mapper.FoCallMapper;
import wiki.zex.cloud.example.req.FoCallReq;
import wiki.zex.cloud.example.resp.FoCallResp;
import wiki.zex.cloud.example.security.MyUserDetails;
import wiki.zex.cloud.example.service.IFoCallService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author Zex
 * @since 2020-07-14
 */
@Service
public class FoCallServiceImpl extends ServiceImpl<FoCallMapper, FoCall> implements IFoCallService {

    @Override
    public FoCall create(FoCallReq req, Authentication authentication) {
        MyUserDetails myUserDetails = (MyUserDetails) authentication.getPrincipal();
        FoCall foCall = new FoCall();
        foCall.setFromUserId(myUserDetails.getId());
        BeanUtils.copyProperties(req,foCall);
        save(foCall);
        return foCall;
    }



    @Override
    public IPage<FoCallResp> list(Page<FoCallResp> page, Authentication authentication) {

        MyUserDetails myUserDetails = (MyUserDetails) authentication.getPrincipal();
        return baseMapper.list(page,myUserDetails.getId());
    }

}
