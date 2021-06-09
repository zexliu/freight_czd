package wiki.zex.cloud.example.utils;

import org.apache.commons.collections4.CollectionUtils;

import java.util.*;

public class ListUtils {

    public static <T> List<List<T>> rowToCol(List<List<T>> list) {

        if (CollectionUtils.isEmpty(list)) {
            return list;
        }

        List<List<T>> toList = new ArrayList<>();

        Map<Integer, List<T>> map = new HashMap<>();

        for (int i = 0; i < list.size(); i++) {
            List<T> row = list.get(i);

            for (int j = 0; j < row.size(); j++) {
                T cell = row.get(j);

                List<T> col = map.get(j);
                if (col == null) {
                    col = new ArrayList<T>();
                }
                col.add(cell);
                map.put(j, col);
            }
        }

        List<Integer> sort = new ArrayList<>(map.keySet());

        Collections.sort(sort);

        for (Integer key : sort) {
            toList.add(map.get(key));
        }

        return toList;
    }
}
