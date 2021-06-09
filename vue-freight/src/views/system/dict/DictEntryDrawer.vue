<template>
  <a-drawer
    title="字典项列表"
    :width="720"
    :visible="visible"
    :body-style="{ paddingBottom: '80px' }"
    @close="onClose"
  >
    <a-button type="primary" icon="plus" @click="onAddClick">
      添加{{ subjectTitle }}
    </a-button>
    <a-table
      :pagination="pagination"
      :columns="columns"
      :data-source="tableData"
      :bordered="true"
      :loading="loading"
      :row-key="record => record.id"
      @change="handleTableChange"
    >
      <span slot="createAt" slot-scope="createAt">
        {{ createAt | timeFormatter }}
      </span>

      <span slot="action" slot-scope="text, record">
        <a @click="onEditClick(record)">
          <a-icon type="edit" />
          编辑
        </a>
        <a-divider type="vertical" />
        <a @click="onDeleteClick(record)">删除</a>
      </span>
    </a-table>
    <a-modal
      :visible="detailsVisible"
      title="创建字典"
      okText="确定"
      @cancel="
        () => {
          detailsVisible = false
        }
      "
      @ok="handleSubmit('dictEntryForm')"
    >
      <a-form-model
        :confirm-loading="loading"
        ref="dictEntryForm"
        :model="formData"
        :rules="rules"
        layout="horizontal"
        :labelCol="{ span: 6 }"
        :wrapperCol="{ span: 14 }"
      >
        <a-form-model-item label="字典项名称" prop="dictEntryName">
          <a-input v-model="formData.dictEntryName" />
        </a-form-model-item>
        <a-form-model-item
          v-if="detailsType === 'ADD'"
          label="字典项值"
          prop="dictEntryValue"
        >
          <a-input v-model="formData.dictEntryValue" />
        </a-form-model-item>
        <a-form-model-item label="可用状态" prop="enable">
          <a-switch v-model="formData.enable"></a-switch>
        </a-form-model-item>
        <a-form-model-item label="排序">
          <a-input-number
            style="width: 100%"
            v-model="formData.seq"
            placeholder="请输入排序"
            :precision="0"
            :max="999999999"
            :min="0"
          ></a-input-number>
        </a-form-model-item>
        <a-form-model-item label="描述">
          <a-textarea
            v-model="formData.description"
            placeholder="请输入描述"
            :maxLength="200"
            :auto-size="{ minRows: 2, maxRows: 8 }"
          ></a-textarea>
        </a-form-model-item>
      </a-form-model>
    </a-modal>
  </a-drawer>
</template>

<script lang="ts">
import { Component, Mixins, Prop, Emit, Watch } from 'vue-property-decorator'
import MixinTable from '@/mixins/mixin-table'
import { create, update } from '@/api/common'

interface DictEntryReq {
  dictCode: string
  dictEntryName: string
  dictEntryValue: string
  seq: number
  description?: string
  enable: boolean
}

const defaultForm: DictEntryReq = {
  dictCode: '',
  dictEntryName: '',
  dictEntryValue: '',
  seq: 0,
  description: '',
  enable: true
}
@Component({
  name: 'DictEntryDrawer',
  components: {}
})
export default class extends Mixins(MixinTable) {
  url = '/api/v1/dict/entries'
  @Prop({
    type: Boolean,
    default: false
  })
  protected visible!: boolean

  @Prop({
    type: String
  })
  protected dictCode!: string

  formData = Object.assign({}, defaultForm)

  // watch
  @Watch('dictCode')
  tagListChange(val: any[]) {
    this.handleSearch()
  }

  rules = {
    dictEntryName: [
      { required: true, message: '字典项名称', trigger: 'blur' },
      { min: 1, max: 30, message: '长度在1-30之间', trigger: 'blur' }
    ],
    dictEntryValue: [
      { required: true, message: '请输入字典项值', trigger: 'blur' },
      { min: 1, max: 30, message: '长度在1-30之间', trigger: 'blur' }
    ]
  }
  subjectTitle = '字典项'
  private columns = [
    {
      title: '字典项名称',
      dataIndex: 'dictEntryName',
      width: 140
    },
    {
      title: '字典项值',
      dataIndex: 'dictEntryValue',
      width: 140
    },

    {
      title: '描述',
      dataIndex: 'description'
    },

    {
      title: '操作',
      key: 'operation',
      fixed: 'right',
      width: 140,
      scopedSlots: { customRender: 'action' }
    }
  ]

  onClose() {
    if (!this.loading) {
      this.close(false)
    }
  }

  beforeSearch() {
    console.log('before search ')
    this.listQuery.dictCode = this.dictCode
  }
  @Emit()
  protected close(val: boolean) {}

  handleSubmit(formName: string) {
    let el: any = this.$refs[formName]
    el.validate((valid: boolean) => {
      if (valid) {
        if (this.detailsType === 'ADD') {
          this.formData.dictCode = this.dictCode
          create(this.url, this.formData)
            .then((res: any) => {
              this.$notification.success({
                message: '成功',
                description: '新增' + this.subjectTitle + '成功'
              })
              this.onAddSuccess(res)
              this.detailsVisible = false
              this.formData = Object.assign({}, defaultForm)
            })
            .finally(() => {
              this.loading = false
            })
        } else {
          update(this.url, this.selectedKey!, this.formData)
            .then((res: any) => {
              this.$notification.success({
                message: '成功',
                description: '修改' + this.subjectTitle + '成功'
              })
              this.detailsVisible = false
              this.onEditSuccess(res)
            })
            .finally(() => {
              this.loading = false
            })
        }
      } else {
        console.log('error submit!!')
        return false
      }
    })
  }

  protected onEditClick(val: any) {
    this.detailsType = 'EDIT'
    this.detailsVisible = !this.detailsVisible
    this.selectedKey = val.id
    this.formData = Object.assign({}, val)
  }
}
</script>

<style></style>
