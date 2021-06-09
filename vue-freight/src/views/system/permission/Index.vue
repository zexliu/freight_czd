<template>
  <a-card :bordered="false">
    <div class="table-operator">
      <a-button type="primary" icon="plus" @click="onAddClick">
        添加{{ subjectTitle }}
      </a-button>
    </div>
    <!-- @change="handleTableChange" -->
    <a-table
      :pagination="false"
      :columns="columns"
      :data-source="tableData"
      :bordered="true"
      :loading="loading"
      :row-key="record => record.id"
      :scroll="{ x: 1600 }"
    >
      <span slot="methodType" slot-scope="methodType">
        <a-tag :color="getColor(methodType)">
          {{ methodType }}
        </a-tag>
      </span>

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
            <a-menu-item key="3" :disabled="record.children ? true : false">
              <a
                :disabled="record.children ? true : false"
                href="javascript:;"
                @click="onDeleteClick(record)"
                >删除</a
              >
            </a-menu-item>
          </a-menu>
        </a-dropdown>
      </span>
    </a-table>

    <details-drawer
      :visible="detailsVisible"
      :type="detailsType"
      :selectedKey="selectedKey"
      :permissionOptions="permissionOptions"
      @close="onDetailsClosed"
      @on-edit-success="onEditSuccess"
      @on-add-success="onAddSuccess"
    >
    </details-drawer>
  </a-card>
</template>
<script lang="ts">
import MixinTable from '@/mixins/mixin-table'
import { Component, Mixins, Watch } from 'vue-property-decorator'
import { fetchList } from '@/api/common'
import DetailsDrawer from './DetailsDrawer.vue'

@Component({
  name: 'PermissionIndex',
  components: { DetailsDrawer }
})
export default class extends Mixins(MixinTable) {
  subjectTitle = '权限'
  subject = 'syPermission'
  url = '/api/v1/permissions'
  permissionOptions: any[] = []
  private columns = [
    {
      title: '权限名称',
      dataIndex: 'permissionName',
      width: 300
    },

    {
      title: '权限编码',
      dataIndex: 'permissionCode',
      width: 180
    },
    {
      title: '权限路径',
      dataIndex: 'permissionPath',
      width: 200
    },

    {
      title: '排序',
      dataIndex: 'seq',
      width: 70
    },
    {
      title: '方法类型',
      dataIndex: 'methodType',
      scopedSlots: { customRender: 'methodType' },
      width: 90
    },
    {
      title: '描述',
      dataIndex: 'description'
    },
    {
      dataIndex: 'id',
      title: 'ID',
      width: 220
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

  created() {
    console.log('created')
    this.fetch()
  }

  protected fetch() {
    this.loading = true
    fetchList(this.url + '/tree', {})
      .then((response: any) => {
        this.tableData = response
        this.permissionOptions = response.slice()
        this.permissionOptions.unshift({
          id: null,
          permissionName: '根权限'
        })
      })
      .finally(() => {
        this.loading = false
      })
  }

  getColor(methodType: string) {
    switch (methodType) {
      case 'ALL':
        return 'blue'
      case 'GET':
        return 'green'
      case 'POST':
        return 'purple'
      case 'PUT':
        return 'orange'
      case 'DELETE':
        return 'red'
    }
  }

  protected onEditSuccess(val: any) {
    this.fetch()
  }
}
</script>
