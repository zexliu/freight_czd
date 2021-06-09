<template>
  <a-card :bordered="false">
    <div class="table-page-search-wrapper">
      <a-form-model v-model="listQuery" layout="inline">
        <a-row :gutter="48">
          <a-col :md="8" :sm="24">
            <a-form-model-item label="所属货主">
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
                  >{{ item.realName }}</a-select-option
                >
              </a-select>
            </a-form-model-item>
          </a-col>
          <a-col :md="8" :sm="24">
            <a-form-model-item label="所属司机">
              <a-select
                show-search
                v-model="listQuery.driverId"
                placeholder="姓名/手机号"
                style="width: 100%"
                :filter-option="false"
                :not-found-content="fetching ? undefined : null"
                @search="fetchDriver"
              >
                <a-spin v-if="fetching" slot="notFoundContent" size="small" />
                <a-select-option
                  v-for="item in drivers"
                  :key="item.id"
                  :value="item.id"
                  >{{ item.realName }}</a-select-option
                >
              </a-select>
            </a-form-model-item>
          </a-col>

          <template v-if="expand">
            <a-col :md="8" :sm="24">
              <a-form-model-item label="确认状态">
                <a-select
                  v-model="listQuery.confirmStatus"
                  placeholder="是否确认"
                  style="width: 100%"
                >
                  <a-select-option
                    v-for="item in stateOptions"
                    :key="item.value"
                    :value="item.value"
                    >{{ item.label }}</a-select-option
                  >
                </a-select>
              </a-form-model-item>
            </a-col>

            <a-col :md="8" :sm="24">
              <a-form-model-item label="货主支付">
                <a-select
                  v-model="listQuery.payStatus"
                  placeholder="是否支付"
                  style="width: 100%"
                >
                  <a-select-option
                    v-for="item in stateOptions"
                    :key="item.value"
                    :value="item.value"
                    >{{ item.label }}</a-select-option
                  >
                </a-select>
              </a-form-model-item>
            </a-col>

            <a-col :md="8" :sm="24">
              <a-form-model-item label="司机支付">
                <a-select
                  v-model="listQuery.driverPayStatus"
                  placeholder="是否支付"
                  style="width: 100%"
                >
                  <a-select-option
                    v-for="item in stateOptions"
                    :key="item.value"
                    :value="item.value"
                    >{{ item.label }}</a-select-option
                  >
                </a-select>
              </a-form-model-item>
            </a-col>
            <a-col :md="8" :sm="24">
              <a-form-model-item label="取消状态">
                <a-select
                  v-model="listQuery.cancelStatus"
                  placeholder="是否取消"
                  style="width: 100%"
                >
                  <a-select-option
                    v-for="item in stateOptions"
                    :key="item.value"
                    :value="item.value"
                    >{{ item.label }}</a-select-option
                  >
                </a-select>
              </a-form-model-item>
            </a-col>
            <a-col :md="8" :sm="24">
              <a-form-model-item label="货主评价">
                <a-select
                  v-model="listQuery.evaluateStatus"
                  placeholder="是否评价"
                  style="width: 100%"
                >
                  <a-select-option
                    v-for="item in stateOptions"
                    :key="item.value"
                    :value="item.value"
                    >{{ item.label }}</a-select-option
                  >
                </a-select>
              </a-form-model-item>
            </a-col>
            <a-col :md="8" :sm="24">
              <a-form-model-item label="司机评价">
                <a-select
                  v-model="listQuery.driverEvaluateStatus"
                  placeholder="是否评价"
                  style="width: 100%"
                >
                  <a-select-option
                    v-for="item in stateOptions"
                    :key="item.value"
                    :value="item.value"
                    >{{ item.label }}</a-select-option
                  >
                </a-select>
              </a-form-model-item>
            </a-col>

            <a-col :md="8" :sm="24">
              <a-form-model-item label="协议状态">
                <a-select
                  v-model="listQuery.protocolStatus"
                  placeholder="是否签署协议"
                  style="width: 100%"
                >
                  <a-select-option
                    v-for="item in stateOptions"
                    :key="item.value"
                    :value="item.value"
                    >{{ item.label }}</a-select-option
                  >
                </a-select>
              </a-form-model-item>
            </a-col>
            <a-col :md="8" :sm="24">
              <a-form-model-item label="退款状态">
                <a-select
                  v-model="listQuery.refundStatus"
                  placeholder="是否签署协议"
                  style="width: 100%"
                >
                  <a-select-option
                    v-for="item in stateOptions"
                    :key="item.value"
                    :value="item.value"
                    >{{ item.label }}</a-select-option
                  >
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
    >
      <span slot="userAvatar" slot-scope="userAvatar">
        <a-avatar :src="userAvatar" size="large" />
      </span>

      <div slot="expandedRowRender" slot-scope="record" style="margin: 0">
        <a-descriptions title="订单详情">
          <a-descriptions-item label="装货地">
            {{
              getAddress(
                record.loadProvinceCode,
                record.loadCityCode,
                record.loadDistrictCode
              )
            }}
          </a-descriptions-item>
          <a-descriptions-item label="卸货地">
            {{
              getAddress(
                record.unloadProvinceCode,
                record.unloadCityCode,
                record.unloadDistrictCode
              )
            }}
          </a-descriptions-item>
          <a-descriptions-item label="货物类型">
            {{ record.categoryName }}
          </a-descriptions-item>

          <a-descriptions-item label="装货日期">
            {{ record.loadStartAt | dateFormatter }}
          </a-descriptions-item>
          <a-descriptions-item label="卸货日期">
            {{ record.loadEndAt | dateFormatter }}
          </a-descriptions-item>
          <a-descriptions-item label="创建时间">
            {{ record.createAt | timeFormatter }}
          </a-descriptions-item>
          <a-descriptions-item label="是否确认">
            <a-tag v-if="record.confirmStatus" color="blue">
              是
            </a-tag>
            <a-tag v-else>
              否
            </a-tag>
          </a-descriptions-item>

          <a-descriptions-item label="货主支付">
            <a-tag v-if="record.payStatus" color="blue">
              是
            </a-tag>
            <a-tag v-else>
              否
            </a-tag>
          </a-descriptions-item>
          <a-descriptions-item label="司机支付">
            <a-tag v-if="record.driverPayStatus" color="blue">
              是
            </a-tag>
            <a-tag v-else>
              否
            </a-tag>
          </a-descriptions-item>
          <a-descriptions-item label="货主评价">
            <a-tag v-if="record.evaluateStatus" color="blue">
              是
            </a-tag>
            <a-tag v-else>
              否
            </a-tag>
          </a-descriptions-item>
          <a-descriptions-item label="司机评价">
            <a-tag v-if="record.driverEvaluateStatus" color="blue">
              是
            </a-tag>
            <a-tag v-else>
              否
            </a-tag>
          </a-descriptions-item>

          <a-descriptions-item label="是否取消">
            <a-tag v-if="record.cancelStatus" color="blue">
              是
            </a-tag>
            <a-tag v-else>
              否
            </a-tag>
          </a-descriptions-item>

          <a-descriptions-item label="是否退款">
            <a-tag v-if="record.refundStatus" color="blue">
              是
            </a-tag>
            <a-tag v-else>
              否
            </a-tag>
          </a-descriptions-item>
          <a-descriptions-item label="协议状态">
            <a-tag v-if="record.protocolStatus === 1" color="blue">
              已签署
            </a-tag>
            <a-tag v-else>
              未签署
            </a-tag>
          </a-descriptions-item>
        </a-descriptions>
      </div>
    </a-table>
  </a-card>
</template>

<script lang="ts">
import { Component, Mixins } from 'vue-property-decorator'
import ExcelUpload from '@/components/Upload/ExcelUpload.vue'
import MixinTable from '@/mixins/mixin-table'
import { fetchList, create } from '@/api/common'
import RichEditor from '@/components/RichEditor/Index.vue'
import moment from 'moment'
@Component({
  name: 'DeliveryIndex',
  components: {
    ExcelUpload,
    RichEditor
  }
})
export default class extends Mixins(MixinTable) {
  subjectTitle = '订单列表'
  subject = 'iFoOrder'
  url = '/api/v1/orders'

  private created() {
    // fetchList('/api/v1/dict/entries', { dictCode: 'ANNOUNCEMENT_TYPE' }).then(
    //   (res: any) => {
    //     this.announcementTypeOptions = res.records
    //   }
    // )
    this.fetch()
    fetchList('/api/v1/areas', {}).then((res: any) => {
      this.areas = res
      console.log('result => ', this.areas)
    })
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
      dataIndex: 'orderId',
      title: '订单编号',
      width: 220
    },
    //ellipsis: true,
    {
      title: '发货人',
      dataIndex: 'userNickname',
      width: 100
    },
    {
      title: '发货人电话',
      dataIndex: 'userMobile',
      width: 120
    },
    {
      title: '司机',
      dataIndex: 'driverNickname',
      width: 100
    },
    {
      title: '司机电话',
      dataIndex: 'driverMobile',
      width: 120
    },
    {
      title: '定金(元)',
      dataIndex: 'freightAmount',
      width: 120
    },
    {
      title: '运费(元)',
      dataIndex: 'amount',
      width: 120
    },
    {
      title: '车牌号',
      dataIndex: 'carNo',
      width: 120
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
      keywords: value,
      roleId: '1278600509777190913'
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

  fetchDriver(value: any) {
    console.log('fetching driver', value)
    this.fetching = true
    fetchList('/api/v1/users', {
      keywords: value,
      roleId: '1278600509777190914'
    })
      .then((res: any) => {
        this.drivers = res.records
      })
      .finally(() => {
        this.fetching = false
      })
  }
  getAddress(provinceCode: string, cityCode: string, districtCode: string) {
    let province = this.areas.find(item => {
      return item.value === provinceCode
    })
    let city = province.children.find((item: any) => {
      return item.value === cityCode
    })
    let district = city.children.find((item: any) => {
      return item.value === districtCode
    })
    return province.label + '/' + city.label + '/' + district.label
  }
}
</script>
