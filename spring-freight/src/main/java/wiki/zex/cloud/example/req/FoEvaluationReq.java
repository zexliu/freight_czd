package wiki.zex.cloud.example.req;


import lombok.Data;

@Data
public class FoEvaluationReq {

    private String tags;

    private String description;

    private Boolean anonymous;

    private Integer level;



}
