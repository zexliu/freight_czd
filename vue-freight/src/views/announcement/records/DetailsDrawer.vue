<template>
  <div>
    <a-drawer
      :title="type === 'ADD' ? '发布公告' : '公告详情'"
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
          <a-form-model-item label="标题" prop="title">
            <a-input
              v-model="formData.title"
              :disabled="type == 'INFO'"
            ></a-input>
          </a-form-model-item>
          <a-form-model-item label="公告类型" prop="announcementType">
            <a-select
              :disabled="type == 'INFO'"
              v-model="formData.announcementType"
              placeholder="请选择发布渠道"
            >
              <a-select-option
                v-for="item in announcementTypeOptions"
                :key="parseInt(item.dictEntryValue)"
              >
                {{ item.dictEntryName }}
              </a-select-option>
            </a-select>
          </a-form-model-item>
          <a-form-model-item label="封面图" prop="coverImage">
            <avatar-upload v-model="formData.coverImage" />
          </a-form-model-item>
          <a-form-model-item label="内容" prop="content">
            <rich-editor v-model="formData.content" placeholder="请输入内容">
            </rich-editor>
          </a-form-model-item>
          <!-- <a-form-model-item label="参数" prop="params">
            <a-textarea
              :disabled="type == 'INFO'"
              v-model="formData.params"
              :placeholder="'请输入Json格式参数'"
            ></a-textarea>
          </a-form-model-item> -->
          <a-form-model-item label="有效开始时间">
            <a-date-picker
              show-time
              v-model="formData.validStartAtMoment"
              format="YYYY-MM-DD HH:mm:ss"
            />
          </a-form-model-item>
          <a-form-model-item label="有效结束时间">
            <a-date-picker
              show-time
              v-model="formData.validEndAtMoment"
              format="YYYY-MM-DD HH:mm:ss"
            />
          </a-form-model-item>

          <a-form-model-item label="有效状态" prop="validStatus">
            <a-switch
              checked-children="有效"
              un-checked-children="无效"
              v-model="formData.validStatus"
            />
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
import moment from 'moment'
import AvatarUpload from '@/components/Upload/AvatarUpload.vue'

interface QuestionReq {
  params: string
  announcementType: string | null
  title: string
  content: string
  validStartAt: string | null
  validEndAt: string | null
  validStartAtMoment: any | null
  validEndAtMoment: any | null
  validStatus: boolean
  coverImage: string | null
}

const defaultForm: QuestionReq = {
  params: '',
  announcementType: null,
  title: '',
  content: '',
  validStartAt: null,
  validEndAt: null,
  validStartAtMoment: null,
  validEndAtMoment: null,
  validStatus: true,
  coverImage: null
}

@Component({
  name: 'DetailsDrawer',
  components: { RichEditor, AvatarUpload }
})
export default class DetailsDrawer extends Mixins(MixinDetails) {
  protected url = '/api/v1/announcements'
  protected subjectTitle = '公告'
  protected formData = Object.assign({}, defaultForm)

  @Prop({
    type: Array,
    default: []
  })
  private announcementTypeOptions!: any[]
  private rules = {
    title: [{ required: true, message: '请输入标题', trigger: 'blur' }],
    content: [{ required: true, message: '请输入内容', trigger: 'blur' }],
    announcementType: [
      { required: true, message: '请选择公告类型', trigger: 'blur' }
    ],
    validStatus: [
      { required: true, message: '请选择有效状态', trigger: 'blur' }
    ]
  }

  protected resetFormData() {
    this.formData = Object.assign({}, defaultForm)
  }

  beforeEditData() {
    this.beforeAddData()
  }

  beforeAddData() {
    if (this.formData.validStartAtMoment != null) {
      this.formData.validStartAt = this.formData.validStartAtMoment.format('x')
      this.formData.validEndAt = this.formData.validEndAtMoment.format('x')
    } else {
      this.formData.validStartAt = null
      this.formData.validEndAt = null
    }
  }

  onLoadDataSuccess() {
    this.$set(
      this.formData,
      'validStartAtMoment',
      this.formData.validStartAt
        ? moment(this.formData.validStartAt, 'x')
        : null
    )
    this.$set(
      this.formData,
      'validEndAtMoment',
      this.formData.validEndAt ? moment(this.formData.validEndAt, 'x') : null
    )
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
