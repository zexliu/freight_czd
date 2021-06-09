<template>
  <a-card :bordered="false">
    <div class="table-page-search-wrapper">
      <a-form-model v-model="listQuery" layout="inline">
        <a-row :gutter="48">
          <a-col :md="8" :sm="24">
            <a-form-model-item label="字典名称">
              <a-input
                v-model="listQuery.dictName"
                placeholder="请输入字典名称模糊查询"
              />
            </a-form-model-item>
          </a-col>
          <a-col :md="8" :sm="24">
            <a-form-model-item label="字典编码">
              <a-input
                v-model="listQuery.dictCode"
                placeholder="请输入字典编码模糊查询"
              />
            </a-form-model-item>
          </a-col>
          <a-col :md="(!expand && 8) || 24" :sm="24">
            <span
              class="table-page-search-submitButtons"
              :style="(expand && { float: 'right', overflow: 'hidden' }) || {}"
            >
              <a-button type="primary" @click="handleSearch()">查询</a-button>
              <a-button style="margin-left: 8px" @click="handleResetSearch()"
                >重置</a-button
              >
            </span>
          </a-col>
        </a-row>
      </a-form-model>
    </div>
    <div class="table-operator">
      <a-button type="primary" icon="plus" @click="onAddClick">
        添加{{ subjectTitle }}
      </a-button>
      <!-- <excel-upload :name="subject" :on-success="onExcelSuccess"></excel-upload>
      <a-button type="primary" icon="export" @click="exportExcel">
        导出
      </a-button> -->
    </div>

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
        <a @click="onEditDictEntryClick(record)"
          ><a-icon type="setting" /> 字典配置</a
        >
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
      @ok="handleSubmit('dictForm')"
    >
      <a-form-model
        :confirm-loading="loading"
        ref="dictForm"
        :model="formData"
        :rules="rules"
        layout="horizontal"
        :labelCol="{ span: 6 }"
        :wrapperCol="{ span: 14 }"
      >
        <a-form-model-item label="字典名称" prop="dictName">
          <a-input v-model="formData.dictName" />
        </a-form-model-item>
        <a-form-model-item
          v-if="detailsType === 'ADD'"
          label="字典编码"
          prop="dictCode"
        >
          <a-input v-model="formData.dictCode" />
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
    <dict-entry-drawer
      :visible="dictEntryVisible"
      :dictCode="selectedKey"
      @close="onDrawerClose"
    >
    </dict-entry-drawer>
  </a-card>
</template>

<script lang="ts">
import { Component, Mixins } from 'vue-property-decorator'
import MixinTable from '@/mixins/mixin-table'
import { create, update } from '@/api/common'
import DictEntryDrawer from './DictEntryDrawer.vue'

interface DictReq {
  dictName: string
  dictCode: string
  description?: string
}

const defaultForm: DictReq = {
  dictName: '',
  dictCode: '',
  description: ''
}
@Component({
  name: 'DictIndex',
  components: { DictEntryDrawer }
})
export default class extends Mixins(MixinTable) {
  subjectTitle = '字典'
  subject = 'syDict'
  url = '/api/v1/dicts'
  formData: any = Object.assign({}, defaultForm)
  loading = false

  dictEntryVisible = false
  private created() {
    this.fetch()
  }

  private columns = [
    {
      dataIndex: 'id',
      title: 'ID',
      width: 220
    },
    {
      title: '字典名称',
      dataIndex: 'dictName',
      width: 140
    },
    {
      title: '字典编码',
      dataIndex: 'dictCode',
      width: 140
    },

    {
      title: '描述',
      dataIndex: 'description'
    },

    {
      title: '创建时间',
      dataIndex: 'createAt',
      scopedSlots: { customRender: 'createAt' },
      width: 190
    },
    {
      title: '操作',
      key: 'operation',
      fixed: 'right',
      width: 240,
      scopedSlots: { customRender: 'action' }
    }
  ]

  rules = {
    dictName: [
      { required: true, message: '字典名称', trigger: 'blur' },
      { min: 2, max: 30, message: '长度在2-30之间', trigger: 'blur' }
    ],
    dictCode: [
      { required: true, message: '请输入字典编码', trigger: 'blur' },
      { min: 2, max: 30, message: '长度在2-30之间', trigger: 'blur' }
    ]
  }

  protected onEditClick(val: any) {
    this.detailsType = 'EDIT'
    this.detailsVisible = !this.detailsVisible
    this.selectedKey = val.id
    this.formData = Object.assign({}, val)
  }

  handleSubmit(formName: string) {
    let el: any = this.$refs[formName]
    el.validate((valid: boolean) => {
      if (valid) {
        if (this.detailsType === 'ADD') {
          create(this.url, this.formData)
            .then((res: any) => {
              this.$notification.success({
                message: '成功',
                description: '新增' + this.subjectTitle + '成功'
              })
              this.detailsVisible = false
              this.onAddSuccess(res)
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

  onEditDictEntryClick(val: any) {
    this.dictEntryVisible = true
    this.selectedKey = val.dictCode
  }
  onDrawerClose() {
    this.dictEntryVisible = false
  }
}
</script>
