<template>
  <div>
    <a-drawer
      :title="
        type === 'ADD'
          ? '新增' + subjectTitle
          : type === 'EDIT'
          ? '编辑' + subjectTitle
          : subjectTitle + '详情'
      "
      width="70%"
      :visible="visible"
      :body-style="{ paddingBottom: '80px' }"
      @close="onClose"
    >
      <a-skeleton :loading="showSkeleton">
        <a-form-model
          ref="form"
          :model="formData"
          :labelCol="{ span: 6 }"
          :wrapperCol="{ span: 14 }"
          :rules="rules"
        >
          <a-form-model-item label="模板编码" prop="templateCode">
            <a-input v-model="formData.templateCode"></a-input>
          </a-form-model-item>

          <a-form-model-item label="模板标题" prop="templateTitle">
            <a-input v-model="formData.templateTitle"></a-input>
          </a-form-model-item>

          <a-form-model-item label="公告类型" prop="announcementType">
            <a-select
              v-model="formData.announcementType"
              placeholder="请选择发布渠道"
            >
              <a-select-option
                :key="parseInt(item.dictEntryValue)"
                v-for="item in announcementTypeOptions"
              >
                {{ item.dictEntryName }}
              </a-select-option>
            </a-select>
          </a-form-model-item>

          <a-form-model-item label="模板内容" prop="templateContent">
            <rich-editor
              v-model="formData.templateContent"
              placeholder="请输入模板内容"
            >
            </rich-editor>
          </a-form-model-item>
        </a-form-model>
        <div
          v-if="type !== 'INFO'"
          :style="{
            position: 'absolute',
            right: 0,
            bottom: 0,
            width: '100%',
            borderTop: '1px solid #e9e9e9',
            padding: '10px 16px',
            background: '#fff',
            textAlign: 'right',
            zIndex: 1
          }"
        >
          <a-button :style="{ marginRight: '8px' }" @click="onClose">
            取消
          </a-button>
          <a-button
            type="primary"
            :loading="loading"
            @click="submitForm('form')"
          >
            确认
          </a-button>
        </div>
      </a-skeleton>
    </a-drawer>
  </div>
</template>
<script lang="ts">
import { Mixins, Component, Prop } from 'vue-property-decorator'
import MixinDetails from '@/mixins/mixin-details'
import { fetchList } from '@/api/common'
import RichEditor from '@/components/RichEditor/Index.vue'

interface QuestionReq {
  templateCode: string
  templateTitle: string
  templateContent: string
  announcementType: string
}

const defaultForm: QuestionReq = {
  templateCode: '',
  templateTitle: '',
  templateContent: '',
  announcementType: ''
}

@Component({
  name: 'DetailsDrawer',
  components: { RichEditor }
})
export default class DetailsDrawer extends Mixins(MixinDetails) {
  protected url = '/api/v1/announcement/templates'
  protected subjectTitle = '公告模板'
  protected formData = Object.assign({}, defaultForm)

  @Prop({
    type: Array,
    default: []
  })
  private announcementTypeOptions!: []

  private rules = {
    templateCode: [
      { required: true, message: '请输入模板编码', trigger: 'blur' }
    ],
    templateTitle: [
      { required: true, message: '请输入模板标题', trigger: 'blur' }
    ],
    templateContent: [
      { required: true, message: '请输入模板内容', trigger: 'blur' }
    ],
    announcementType: [
      { required: true, message: '请选择公告类型', trigger: 'blur' }
    ]
  }

  protected resetFormData() {
    this.formData = Object.assign({}, defaultForm)
  }
}
</script>

<style scoped lang="less">
.dynamic-delete-button {
  cursor: pointer;
  position: relative;
  top: 4px;
  font-size: 24px;
  color: #999;
  transition: all 0.3s;
}
.dynamic-delete-button:hover {
  color: #777;
}
</style>
