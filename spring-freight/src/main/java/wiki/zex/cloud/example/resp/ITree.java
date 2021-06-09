package wiki.zex.cloud.example.resp;

import java.util.List;

public interface ITree<T> {

    Long getId();

    Long getParentId();

    void setChildren(List<T> list);

}
