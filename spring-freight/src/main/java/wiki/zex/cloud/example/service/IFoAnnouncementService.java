package wiki.zex.cloud.example.service;

import wiki.zex.cloud.example.entity.FoAnnouncement;
import com.baomidou.mybatisplus.extension.service.IService;
import wiki.zex.cloud.example.req.FoAnnouncementReq;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author Zex
 * @since 2020-08-21
 */
public interface IFoAnnouncementService extends IService<FoAnnouncement> {
    FoAnnouncement create(FoAnnouncementReq req);

    FoAnnouncement update(Long id, FoAnnouncementReq req);

    void delete(Long id);
}
