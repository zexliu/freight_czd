package wiki.zex.cloud.example.req;

import io.swagger.annotations.ApiModel;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;

/**
 * <p>
 * 
 * </p>
 *
 * @author Zex
 * @since 2020-03-01
 */
@Data
@EqualsAndHashCode(callSuper = false)
@ApiModel(value="SmFeedback对象", description="")
public class SmFeedbackParam implements Serializable {

    private String content;

    private String images;

    private String type;

}
