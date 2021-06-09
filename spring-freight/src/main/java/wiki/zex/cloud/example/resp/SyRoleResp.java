package wiki.zex.cloud.example.resp;

import lombok.Data;
import lombok.EqualsAndHashCode;
import wiki.zex.cloud.example.entity.SyMenu;
import wiki.zex.cloud.example.entity.SyPermission;
import wiki.zex.cloud.example.entity.SyRole;

import java.util.List;

@Data
@EqualsAndHashCode(callSuper = true)
public class SyRoleResp extends SyRole {
    private List<SyPermission> permissions;

    private List<SyMenu> menus;
}
