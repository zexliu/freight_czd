package wiki.zex.cloud.example.service;

import org.springframework.security.core.Authentication;
import wiki.zex.cloud.example.resp.MeStatisticalResp;

public interface IStatisticalService {
    Object meStatisticalResp(Authentication authentication);


}
