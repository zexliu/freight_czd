package wiki.zex.cloud.example.resp;

import lombok.Data;
import lombok.EqualsAndHashCode;
import wiki.zex.cloud.example.entity.SyPermission;

import java.util.List;

@EqualsAndHashCode(callSuper = true)
@Data
public class SyPermissionTree extends SyPermission implements ITree<SyPermissionTree>{
    List<SyPermissionTree> children;
}
