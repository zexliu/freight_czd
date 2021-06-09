package wiki.zex.cloud.example.service.impl;

import org.springframework.beans.BeanUtils;
import wiki.zex.cloud.example.entity.FoAnnouncement;
import wiki.zex.cloud.example.mapper.FoAnnouncementMapper;
import wiki.zex.cloud.example.req.FoAnnouncementReq;
import wiki.zex.cloud.example.service.IFoAnnouncementService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author Zex
 * @since 2020-08-21
 */
@Service
public class FoAnnouncementServiceImpl extends ServiceImpl<FoAnnouncementMapper, FoAnnouncement> implements IFoAnnouncementService {



    @Override
    public FoAnnouncement create(FoAnnouncementReq req) {
        FoAnnouncement snAnnouncement = new FoAnnouncement();
        BeanUtils.copyProperties(req,snAnnouncement);
        save(snAnnouncement);
        return snAnnouncement;
    }

    @Override
    public FoAnnouncement update(Long id, FoAnnouncementReq req) {
        FoAnnouncement snAnnouncement = new FoAnnouncement();
        BeanUtils.copyProperties(req,snAnnouncement);
        snAnnouncement.setId(id);
        updateById(snAnnouncement);
        return snAnnouncement;
    }

    @Override
    public void delete(Long id) {
        removeById(id);
    }
}
