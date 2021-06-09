<template>
  <a-card :bordered="false">
    <div class="table-page-search-wrapper">
      <a-form-model v-model="listQuery" layout="inline">
        <a-row :gutter="48">
          <a-col :md="8" :sm="24">
            <a-form-model-item label="角色名称">
              <a-input
                v-model="listQuery.roleName"
                placeholder="请输入角色名称模糊查询"
              />
            </a-form-model-item>
          </a-col>
          <a-col :md="8" :sm="24">
            <a-form-model-item label="角色编码">
              <a-input
                v-model="listQuery.roleCode"
                placeholder="请输入角色编码模糊查询"
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

      <span slot="action" slot-scope="record">
        <a-dropdown>
          <a class="ant-dropdown-link" @click="e => e.preventDefault()">
            更多 <a-icon type="down" />
          </a>
          <a-menu slot="overlay">
            <a-menu-item>
              <a href="javascript:;" @click="onDetailsClick(record)">详情</a>
            </a-menu-item>
            <a-menu-item>
              <a href="javascript:;" @click="onEditClick(record)">编辑</a>
            </a-menu-item>
            <a-menu-item>
              <a href="javascript:;" @click="onDeleteClick(record)">删除</a>
            </a-menu-item>
          </a-menu>
        </a-dropdown>
      </span>
    </a-table>
    <details-drawer
      :visible="detailsVisible"
      :type="detailsType"
      :selectedKey="selectedKey"
      @close="onDetailsClosed"
      @on-edit-success="onEditSuccess"
      @on-add-success="onAddSuccess"
    >
    </details-drawer>
  </a-card>
</template>

<script lang="ts">
import { Component, Mixins } from 'vue-property-decorator'
import DetailsDrawer from './DetailsDrawer.vue'
import ExcelUpload from '@/components/Upload/ExcelUpload.vue'
import MixinTable from '@/mixins/mixin-table'

@Component({
  name: 'RoleIndex',
  components: {
    DetailsDrawer,
    ExcelUpload
  }
})
export default class extends Mixins(MixinTable) {
  subjectTitle = '角色'
  subject = 'syRole'
  url = '/api/v1/roles'

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
      title: '角色名称',
      dataIndex: 'roleName',
      width: 140
    },
    {
      title: '角色编码',
      dataIndex: 'roleCode',
      width: 140
    },
    {
      title: '排序',
      dataIndex: 'seq',
      width: 120
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
      width: 100,
      scopedSlots: { customRender: 'action' }
    }
  ]
}
</script>
