package wiki.zex.cloud.example.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import org.apache.commons.collections.CollectionUtils;
import wiki.zex.cloud.example.entity.AppVersion;
import wiki.zex.cloud.example.mapper.AppVersionMapper;
import wiki.zex.cloud.example.service.IAppVersionService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * <p>
 * 服务实现类
 * </p>
 *
 * @author Zex
 * @since 2020-09-11
 */
@Service
public class AppVersionServiceImpl extends ServiceImpl<AppVersionMapper, AppVersion> implements IAppVersionService {

    @Override
    public AppVersion getByVersionCode(Integer versionCode, Integer type, Integer deviceType) {
        List<AppVersion> versions = list(new LambdaQueryWrapper<AppVersion>().eq(AppVersion::getDeviceType,deviceType)
                .eq(AppVersion::getType, type)
                .gt(AppVersion::getVersionCode, versionCode)
                .orderByDesc(AppVersion::getVersionCode));
        AppVersion version;
        if (CollectionUtils.isEmpty(versions)) {
            version = new AppVersion();
            version.setVersionCode(versionCode);
        } else {
            boolean isForce = false;

            for (AppVersion appVersion : versions) {
                if (appVersion.getIsForce()) {
                    isForce = true;
                    break;
                }
            }
            version = versions.get(0);
            version.setIsForce(isForce);
        }

        return version;
    }
}
