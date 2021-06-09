<template>
  <a-card :bordered="false">
    <div class="table-page-search-wrapper">
      <a-form-model v-model="listQuery" layout="inline">
        <a-row :gutter="48">
          <a-col :md="8" :sm="24">
            <a-form-model-item label="模板类型">
              <a-select
                v-model="listQuery.channelType"
                placeholder="请选择公告类型"
              >
                <a-select-option key="">全部</a-select-option>
                <a-select-option
                  v-for="item in announcementTypeOptions"
                  :key="item.dictEntryValue"
                  >{{ item.dictEntryName }}</a-select-option
                >
              </a-select>
            </a-form-model-item>
          </a-col>

          <a-col :md="8" :sm="24">
            <a-form-model-item label="模板标题">
              <a-input
                v-model="listQuery.keywords"
                placeholder="模板标题模糊查询"
              ></a-input>
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
      <span slot="announcementType" slot-scope="announcementType">
        <a-tag>{{ getAnnouncementName(announcementType) }}</a-tag>
      </span>
      <!-- <a-tag v-for="tag in tags" :key="tag" color="blue">{{ tag }}</a-tag> -->
      <span slot="createAt" slot-scope="createAt">
        {{ createAt | timeFormatter }}
      </span>
      <!-- <span
        slot="templateContent"
        slot-scope="templateContent"
        v-html="templateContent"
      >
      </span> -->

      <span slot="action" slot-scope="record">
        <a @click="onPublish(record)">
          <a-icon type="rocket" />
          发布
        </a>
        <a-divider type="vertical" />
        <a @click="onEditClick(record)">
          <a-icon type="edit" />
          编辑
        </a>

        <a-divider type="vertical" />
        <a @click="onDeleteClick(record)">删除</a>
      </span>

      <div slot="expandedRowRender" slot-scope="record" style="margin: 0">
        <h3>模板内容:</h3>
        <span v-html="record.templateContent"></span>
      </div>
    </a-table>
    <details-drawer
      :visible="detailsVisible"
      :type="detailsType"
      :selectedKey="selectedKey"
      @close="onDetailsClosed"
      @on-edit-success="onEditSuccess"
      @on-add-success="onAddSuccess"
      :announcementTypeOptions="announcementTypeOptions"
    >
    </details-drawer>

    <a-modal
      title="发布公告"
      :width="1024"
      :visible="publishVisible"
      :confirm-loading="confirmLoading"
      @ok="handleOk('form')"
      @cancel="
        {
          publishVisible = false
        }
      "
    >
      <a-form-model
        ref="form"
        :model="formData"
        :labelCol="{ span: 4 }"
        :wrapperCol="{ span: 20 }"
        :rules="rules"
      >
        <a-form-model-item label="公告类型" prop="announcementType">
          {{ getAnnouncementName(formData.announcementType) }}
        </a-form-model-item>
        <a-form-model-item label="标题" prop="title">
          {{ formData.title }}
        </a-form-model-item>
        <a-form-model-item label="内容" prop="content">
          <span v-html="formData.content"></span>
        </a-form-model-item>
        <a-form-model-item label="封面图" prop="coverImage">
          <avatar-upload v-model="formData.coverImage" />
        </a-form-model-item>
        <a-form-model-item label="参数" prop="params">
          <a-textarea
            v-model="formData.params"
            :placeholder="'请输入Json格式参数'"
          ></a-textarea>
        </a-form-model-item>
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
    </a-modal>
  </a-card>
</template>

<script lang="ts">
import { Component, Mixins } from 'vue-property-decorator'
import DetailsDrawer from './DetailsDrawer.vue'
import ExcelUpload from '@/components/Upload/ExcelUpload.vue'
import MixinTable from '@/mixins/mixin-table'
import { fetchList, create } from '@/api/common'
import AvatarUpload from '@/components/Upload/AvatarUpload.vue'
import moment from 'moment'
@Component({
  name: 'StoreIndex',
  components: {
    DetailsDrawer,
    ExcelUpload,
    AvatarUpload
  }
})
export default class extends Mixins(MixinTable) {
  subjectTitle = '公告模板'
  subject = 'sbNoticeTemplate'
  url = '/api/v1/announcement/templates'
  publishVisible = false
  confirmLoading = false
  formData: any = {}
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

  announcementTypeOptions: any[] = [
    {
      dictEntryValue: 1,
      dictEntryName: '规则中心'
    },
    {
      dictEntryValue: 2,
      dictEntryName: '公告通知'
    }
  ]
  private created() {
    this.fetch()
    // fetchList('/api/v1/dict/entries', { dictCode: 'ANNOUNCEMENT_TYPE' }).then(
    //   (res: any) => {
    //     this.announcementTypeOptions = res.records
    //   }
    // )
  }

  private columns = [
    {
      dataIndex: 'id',
      title: 'ID',
      width: 220
    },
    //ellipsis: true,
    {
      title: '模板编码',
      dataIndex: 'templateCode',
      width: 120
    },

    {
      title: '模板标题',
      dataIndex: 'templateTitle',
      width: 120
    },

    {
      title: '公告类型',
      dataIndex: 'announcementType',
      width: 90,
      scopedSlots: { customRender: 'announcementType' }
    },
    {
      title: '模板内容',
      dataIndex: 'templateContent',
      ellipsis: true,
      scopedSlots: { customRender: 'templateContent' }
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
      width: 200,
      scopedSlots: { customRender: 'action' }
    }
  ]

  onPublish(value: any) {
    this.formData = {}
    this.publishVisible = true
    this.formData.title = value.templateTitle
    this.formData.content = value.templateContent
    this.formData.announcementType = value.announcementType
    this.formData.params = ''
    this.$set(this.formData, 'validStatus', true)
    this.$set(this.formData, 'validStartAtMoment', null)
    this.$set(this.formData, 'validEndAtMoment', null)
  }

  protected handleOk(formName: string) {
    let el: any = this.$refs[formName]
    el.validate((valid: boolean) => {
      if (valid) {
        console.log(this.formData)
        if (this.formData.validStartAtMoment != null) {
          this.formData.validStartAt = this.formData.validStartAtMoment.format(
            'x'
          )
        }
        if (this.formData.validEndAtMoment != null) {
          console.log('not null?')
          this.formData.validEndAt = this.formData.validEndAtMoment.format('x')
        }
        this.confirmLoading = true
        create('/api/v1/announcements', this.formData)
          .then((res: any) => {
            this.$notification.success({
              message: '成功',
              description: '发布公告成功'
            })
          })
          .catch(() => {
            this.$notification.error({
              message: '失败',
              description: '发布公告失败'
            })
          })
          .finally(() => {
            this.confirmLoading = false
            this.publishVisible = false
          })
      } else {
        console.log('error submit!!')
        return false
      }
    })
  }

  getAnnouncementName(value: number) {
    debugger
    if (value) {
      let find = this.announcementTypeOptions.find((item: any) => {
        return item.dictEntryValue === value.toString()
      })

      return find ? find.dictEntryName : '--'
    }
    return '--'
  }
}
</script>
