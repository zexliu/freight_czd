package wiki.zex.cloud.example.service;


import wiki.zex.cloud.example.enums.AuditStatus;
import wiki.zex.cloud.example.resp.AuditAuthenticationPush;

public interface AuditProcessor {


    AuditAuthenticationPush auditProcess(Long id , AuditStatus auditStatus) ;


}
