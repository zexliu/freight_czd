<template>
  <a-card :bordered="false">
    <div class="table-page-search-wrapper">
      <a-form-model v-model="listQuery" layout="inline">
        <a-row :gutter="48">
          <a-col :md="8" :sm="24">
            <a-form-model-item label="公告类型">
              <a-select
                v-model="listQuery.announcementType"
                placeholder="请选择公告类型"
              >
                <a-select-option
                  v-for="item in announcementTypeOptions"
                  :key="parseInt(item.dictEntryValue)"
                  >{{ item.dictEntryName }}</a-select-option
                >
              </a-select>
            </a-form-model-item>
          </a-col>

          <a-col :md="8" :sm="24">
            <a-form-model-item label="公告标题">
              <a-input
                v-model="listQuery.keywords"
                placeholder="公告标题模糊查询"
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
        发布公告
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
        {{ getAnnouncementName(announcementType) }}
      </span>

      <span slot="validStartAt" slot-scope="validStartAt">
        {{ validStartAt | timeFormatter }}
      </span>
      <span slot="validEndAt" slot-scope="validEndAt">
        {{ validEndAt | timeFormatter }}
      </span>
      <span slot="createAt" slot-scope="createAt">
        {{ createAt | timeFormatter }}
      </span>
      <span slot="validStatus" slot-scope="validStatus">
        <a-tag v-if="validStatus" color="blue">
          是
        </a-tag>
        <a-tag v-else color="orange">
          否
        </a-tag>
      </span>
      <!-- <span
        slot="templateContent"
        slot-scope="templateContent"
        v-html="templateContent"
      >
      </span> -->

      <span slot="action" slot-scope="record">
        <!-- <a @click="onDetailsClick(record)">
          详情
        </a>
        <a-divider type="vertical" /> -->
        <a @click="onEditClick(record)">
          编辑
        </a>
        <a-divider type="vertical" />
        <a @click="onDeleteClick(record)">删除</a>
      </span>

      <div slot="expandedRowRender" slot-scope="record" style="margin: 0">
        <h3>标题:</h3>
        <span>{{ record.title }}</span>
        <a-divider style=" margin-top: 10px; margin-bottom: 10px; "></a-divider>
        <h3>内容:</h3>
        <span v-html="record.content"></span>
        <!-- <h3>参数:</h3>
        <span>{{ record.params }}</span> -->
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
  </a-card>
</template>

<script lang="ts">
import { Component, Mixins } from 'vue-property-decorator'
import DetailsDrawer from './DetailsDrawer.vue'
import ExcelUpload from '@/components/Upload/ExcelUpload.vue'
import MixinTable from '@/mixins/mixin-table'
import { fetchList, create } from '@/api/common'
import RichEditor from '@/components/RichEditor/Index.vue'

@Component({
  name: 'StoreIndex',
  components: {
    DetailsDrawer,
    ExcelUpload,
    RichEditor
  }
})
export default class extends Mixins(MixinTable) {
  subjectTitle = '通知记录'
  subject = 'iSnAnnouncement'
  url = '/api/v1/announcements'

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
    // fetchList('/api/v1/dict/entries', { dictCode: 'ANNOUNCEMENT_TYPE' }).then(
    //   (res: any) => {
    //     this.announcementTypeOptions = res.records
    //   }
    // )
    this.fetch()
  }

  private columns = [
    {
      dataIndex: 'id',
      title: 'ID',
      width: 220
    },
    //ellipsis: true,
    {
      title: '标题',
      dataIndex: 'title',
      width: 200
    },
    {
      title: '公告类型',
      dataIndex: 'announcementType',
      scopedSlots: { customRender: 'announcementType' },
      width: 120
    },

    // {
    //   title: '参数',
    //   dataIndex: 'params',
    //   width: 200,
    //   ellipsis: true
    // },
    {
      title: '是否有效',
      dataIndex: 'validStatus',
      width: 90,
      scopedSlots: { customRender: 'validStatus' }
    },
    {
      title: '有效开始时间',
      dataIndex: 'validStartAt',
      width: 190,
      scopedSlots: { customRender: 'validStartAt' }
    },
    {
      title: '有效结束时间',
      dataIndex: 'validEndAt',
      width: 190,
      scopedSlots: { customRender: 'validEndAt' }
    },
    // {
    //   title: '内容',
    //   dataIndex: 'content',
    //   width: 400,
    //   ellipsis: true,
    //   scopedSlots: { customRender: 'templateContent' }
    // },
    {
      title: '创建时间',
      dataIndex: 'createAt',
      scopedSlots: { customRender: 'createAt' },
      width: 190
    },
    {
      title: '操作',
      width: 120,
      key: 'operation',
      scopedSlots: { customRender: 'action' }
    }
  ]

  getAnnouncementName(value: number) {
    if (value) {
      let find = this.announcementTypeOptions.find((item: any) => {
        return item.dictEntryValue === value
      })

      return find ? find.dictEntryName : '--'
    }
    return '--'
  }
}
</script>
