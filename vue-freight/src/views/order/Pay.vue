<template>
  <a-card :bordered="false">
    <div class="table-page-search-wrapper">
      <a-form-model v-model="listQuery" layout="inline">
        <a-row :gutter="48">
          <a-col :md="8" :sm="24">
            <a-form-model-item label="订单编号">
              <a-input
                v-model="listQuery.orderId"
                placeholder="订单编号模糊查询"
              ></a-input>
            </a-form-model-item>
          </a-col>
          <a-col :md="8" :sm="24">
            <a-form-model-item label="所属用户">
              <a-select
                show-search
                v-model="listQuery.userId"
                placeholder="姓名/手机号"
                style="width: 100%"
                :filter-option="false"
                :not-found-content="fetching ? undefined : null"
                @search="fetchUser"
              >
                <a-spin v-if="fetching" slot="notFoundContent" size="small" />
                <a-select-option
                  v-for="item in users"
                  :key="item.id"
                  :value="item.id"
                >
                  {{ item.realName }}
                </a-select-option>
              </a-select>
            </a-form-model-item>
          </a-col>

          <template v-if="expand">
            <a-col :md="8" :sm="24">
              <a-form-model-item label="支付方式">
                <a-select
                  v-model="listQuery.channelType"
                  placeholder="请选择支付方式"
                  style="width: 100%"
                >
                  <a-select-option value="">全部</a-select-option>
                  <a-select-option value="WXPAY_APP">微信</a-select-option>
                </a-select>
              </a-form-model-item>
            </a-col>

            <a-col :md="8" :sm="24">
              <a-form-model-item label="三方订单号">
                <a-input
                  v-model="listQuery.thirdPartyId"
                  placeholder="三方订单号模糊查询"
                ></a-input>
              </a-form-model-item>
            </a-col>

            <a-col :md="8" :sm="24">
              <a-form-model-item label="订单类型">
                <a-select
                  v-model="listQuery.orderType"
                  placeholder="请选择订单类型"
                  style="width: 100%"
                >
                  <a-select-option value="">全部</a-select-option>
                  <a-select-option value="DRIVER_GOODS_DEPOSIT"
                    >司机货源支付定金</a-select-option
                  >
                  <a-select-option value="DRIVER_DEPOSIT"
                    >司机支付定金</a-select-option
                  >
                  <a-select-option value="MASTER_FREIGHT"
                    >用户支付运费</a-select-option
                  >
                </a-select>
              </a-form-model-item>
            </a-col>
            <a-col :md="8" :sm="24">
              <a-form-model-item label="支付状态">
                <a-select
                  v-model="listQuery.status"
                  placeholder="请选择支付状态"
                  style="width: 100%"
                >
                  <a-select-option value="">全部</a-select-option>
                  <a-select-option value="1">已支付</a-select-option>
                  <a-select-option value="0">未支付</a-select-option>
                </a-select>
              </a-form-model-item>
            </a-col>

            <a-col :md="8" :sm="24">
              <a-form-model-item label="开始日期">
                <a-date-picker @change="onStartAtChange" />
              </a-form-model-item>
            </a-col>
            <a-col :md="8" :sm="24">
              <a-form-model-item label="结束日期">
                <a-date-picker @change="onEndAtChange" />
              </a-form-model-item>
            </a-col>
          </template>
          <a-col :md="(!expand && 8) || 24" :sm="24">
            <span
              class="table-page-search-submitButtons"
              :style="(expand && { float: 'right', overflow: 'hidden' }) || {}"
            >
              <a-button type="primary" @click="handleSearch()">查询</a-button>
              <a-button style="margin-left: 8px" @click="handleResetSearch()"
                >重置</a-button
              >
              <a @click="expandToggle" style="margin-left: 8px">
                {{ expand ? '收起' : '展开' }}
                <a-icon :type="expand ? 'up' : 'down'" />
              </a>
            </span>
          </a-col>
        </a-row>
      </a-form-model>
    </div>
    <div class="table-operator">
      <!-- <a-button type="primary" icon="plus" @click="onAddClick">
        发布公告
      </a-button> -->
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
      :row-key="record => record.orderId"
      @change="handleTableChange"
      :scroll="{ x: 1840 }"
    >
      <span slot="createAt" slot-scope="createAt">
        {{ createAt | timeFormatter }}
      </span>
      <span slot="payAt" slot-scope="payAt">
        {{ payAt | timeFormatter }}
      </span>
      <span slot="orderType" slot-scope="orderType">
        <span v-if="orderType === 'DRIVER_GOODS_DEPOSIT'">
          司机货源支付定金
        </span>
        <span v-if="orderType === 'DRIVER_DEPOSIT'">
          司机支付定金
        </span>
        <span v-if="orderType === 'MASTER_FREIGHT'">
          用户支付运费
        </span>
      </span>
      <span slot="status" slot-scope="status">
        <a-tag v-if="status === 1" color="blue">
          已支付
        </a-tag>
        <a-tag v-else>
          未支付
        </a-tag>
      </span>
      <span slot="channelType" slot-scope="channelType">
        <a-tag v-if="channelType === 'WXPAY_APP'" color="green">
          微信
        </a-tag>
        <a-tag v-else>
          未知
        </a-tag>
      </span>
      <!-- <div slot="expandedRowRender" slot-scope="record" style="margin: 0">
        
      </div> -->
    </a-table>
  </a-card>
</template>

<script lang="ts">
import { Component, Mixins } from 'vue-property-decorator'
import ExcelUpload from '@/components/Upload/ExcelUpload.vue'
import MixinTable from '@/mixins/mixin-table'
import { fetchList, create } from '@/api/common'
import RichEditor from '@/components/RichEditor/Index.vue'

@Component({
  name: 'DeliveryIndex',
  components: {
    ExcelUpload,
    RichEditor
  }
})
export default class extends Mixins(MixinTable) {
  subjectTitle = '支付对账单'
  subject = 'payOrder'
  url = '/api/v1/order/pay'

  private created() {
    // fetchList('/api/v1/dict/entries', { dictCode: 'ANNOUNCEMENT_TYPE' }).then(
    //   (res: any) => {
    //     this.announcementTypeOptions = res.records
    //   }
    // )
    this.fetch()
  }

  fetching = false

  areas: any[] = []

  users: any[] = []
  drivers: any[] = []
  stateOptions = [
    {
      label: '全部',
      value: ''
    },
    {
      label: '是',
      value: true
    },
    {
      label: '否',
      value: false
    }
  ]

  private columns = [
    {
      dataIndex: 'id',
      title: '支付单编号',
      width: 220
    },
    //ellipsis: true,
    {
      title: '订单编号',
      dataIndex: 'foOrderId',
      width: 220
    },
    {
      title: '用户编号',
      dataIndex: 'userId',
      width: 220
    },
    {
      title: '支付方式',
      dataIndex: 'channelType',
      width: 120,
      scopedSlots: { customRender: 'channelType' }
    },
    {
      title: '三方订单号',
      dataIndex: 'thirdPartyId',
      width: 220
    },
    {
      title: '订单类型',
      dataIndex: 'orderType',
      width: 120,
      scopedSlots: { customRender: 'orderType' }
    },
    {
      title: '金额(元)',
      dataIndex: 'amount',
      width: 100
    },
    {
      title: '描述',
      dataIndex: 'subject',
      width: 120
    },

    {
      title: '支付状态',
      dataIndex: 'status',
      width: 120,
      scopedSlots: { customRender: 'status' }
    },

    {
      title: '创建时间',
      dataIndex: 'createAt',
      width: 190,
      scopedSlots: { customRender: 'createAt' }
    },
    {
      title: '支付时间',
      dataIndex: 'payAt',
      width: 190,
      scopedSlots: { customRender: 'payAt' }
    }
    // {
    //   title: '操作',
    //   width: 120,
    //   key: 'operation',
    //   scopedSlots: { customRender: 'action' }
    // }
  ]

  fetchUser(value: any) {
    console.log('fetching user', value)
    this.fetching = true
    fetchList('/api/v1/users', {
      keywords: value
    })
      .then((res: any) => {
        this.users = res.records
      })
      .finally(() => {
        this.fetching = false
      })
  }

  onEndAtChange(value: any) {
    if (value == null) {
      this.listQuery.endAt = null
    } else {
      this.listQuery.endAt = value
        .clone()
        .add(1, 'd')
        .hours(0)
        .minutes(0)
        .seconds(0)
        .format('x')
    }
  }

  onStartAtChange(value: any) {
    if (value == null) {
      this.listQuery.startAt = null
    } else {
      this.listQuery.startAt = value
        .hours(0)
        .minutes(0)
        .seconds(0)
        .format('x')
    }
  }
}
</script>
