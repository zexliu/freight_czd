<template>
  <a-card :bordered="false">
    <div class="table-page-search-wrapper">
      <a-form-model v-model="listQuery" layout="inline">
        <a-row :gutter="48">
          <a-col :md="8" :sm="24">
            <a-form-model-item label="审核状态">
              <a-select
                v-model="listQuery.auditStatus"
                placeholder="请选择审核状态"
              >
                <a-select-option
                  v-for="item in auditStatuOptions"
                  :key="item.value"
                  >{{ item.label }}</a-select-option
                >
              </a-select>
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
      :row-key="record => record.id"
      @change="handleTableChange"
    >
      <span slot="avatar" slot-scope="avatar">
        <a-avatar :src="avatar" size="large" />
      </span>

      <span slot="auditStatus" slot-scope="auditStatus">
        <a-tag v-if="auditStatus === 'PENDING'" color="orange">
          待审核
        </a-tag>
        <a-tag v-else-if="auditStatus === 'PASSED'" color="blue">
          已通过
        </a-tag>
        <a-tag v-else color="red">
          已驳回
        </a-tag>
      </span>
      <span slot="createAt" slot-scope="createAt">
        {{ createAt | dateFormatter }}
      </span>

      <span slot="action" slot-scope="record">
        <a
          :disabled="record.auditStatus !== 'PENDING'"
          @click="onAuditClick(record.id, 'PASSED')"
          >通过</a
        >
        <a-divider type="vertical" />
        <a
          :disabled="record.auditStatus !== 'PENDING'"
          @click="onAuditClick(record.id, 'REJECTED')"
          >驳回</a
        >
      </span>

      <div slot="expandedRowRender" slot-scope="record" style="margin: 0">
        <a-descriptions title="认证信息">
          <a-descriptions-item label="身份证正面">
            <el-image
              style="width: 220px; height: 140px"
              :src="record.identityCard"
              :fit="fit"
              :preview-src-list="[
                record.identityCard,
                record.identityCardBackend,
                record.identityCardTake,
                record.vehicleLicense,
                record.vehicleLicenseBackend,
                record.carGroupPhoto,
                record.driverLicense,
                record.driverLicenseBackend
              ]"
            ></el-image>
          </a-descriptions-item>
          <a-descriptions-item label="身份证反面">
            <el-image
              style="width: 220px; height: 140px"
              :src="record.identityCardBackend"
              :fit="fit"
              :preview-src-list="[
                record.identityCardBackend,
                record.identityCardTake,
                record.vehicleLicense,
                record.vehicleLicenseBackend,
                record.carGroupPhoto,
                record.driverLicense,
                record.identityCard,
                record.driverLicenseBackend
              ]"
            ></el-image>
          </a-descriptions-item>
          <a-descriptions-item label="手持身份证照片">
            <el-image
              style="width: 220px; height: 140px"
              :src="record.identityCardTake"
              :fit="fit"
              :preview-src-list="[
                record.identityCardTake,
                record.vehicleLicense,
                record.vehicleLicenseBackend,
                record.carGroupPhoto,
                record.driverLicense,
                record.identityCard,
                record.driverLicenseBackend,
                record.identityCardBackend
              ]"
            ></el-image>
          </a-descriptions-item>
          <a-descriptions-item label="行驶证正面">
            <el-image
              style="width: 220px; height: 140px"
              :src="record.vehicleLicense"
              :fit="fit"
              :preview-src-list="[
                record.vehicleLicense,
                record.vehicleLicenseBackend,
                record.carGroupPhoto,
                record.driverLicense,
                record.identityCard,
                record.driverLicenseBackend,
                record.identityCardBackend,
                record.identityCardTake
              ]"
            ></el-image>
          </a-descriptions-item>
          <a-descriptions-item label="行驶证反面">
            <el-image
              style="width: 220px; height: 140px"
              :src="record.vehicleLicenseBackend"
              :fit="fit"
              :preview-src-list="[
                record.vehicleLicenseBackend,
                record.carGroupPhoto,
                record.driverLicense,
                record.identityCard,
                record.driverLicenseBackend,
                record.identityCardBackend,
                record.identityCardTake,
                record.vehicleLicense
              ]"
            ></el-image>
          </a-descriptions-item>
          <a-descriptions-item label="人车合影扎拗片">
            <el-image
              style="width: 220px; height: 140px"
              :src="record.carGroupPhoto"
              :fit="fit"
              :preview-src-list="[
                record.carGroupPhoto,
                record.driverLicense,
                record.driverLicenseBackend,
                record.identityCard,
                record.identityCardBackend,
                record.identityCardTake,
                record.vehicleLicense,
                record.vehicleLicenseBackend
              ]"
            ></el-image>
          </a-descriptions-item>
          <a-descriptions-item label="驾驶证正面">
            <el-image
              style="width: 220px; height: 140px"
              :src="record.driverLicense"
              :fit="fit"
              :preview-src-list="[
                record.driverLicense,
                record.driverLicenseBackend,
                record.identityCard,
                record.identityCardBackend,
                record.identityCardTake,
                record.vehicleLicense,
                record.vehicleLicenseBackend,
                record.carGroupPhoto
              ]"
            ></el-image>
          </a-descriptions-item>
          <a-descriptions-item label="驾驶证方面">
            <el-image
              style="width: 220px; height: 140px"
              :src="record.driverLicenseBackend"
              :fit="fit"
              :preview-src-list="[
                record.driverLicenseBackend,
                record.identityCard,
                record.identityCardBackend,
                record.identityCardTake,
                record.vehicleLicense,
                record.vehicleLicenseBackend,
                record.carGroupPhoto,
                record.driverLicense
              ]"
            ></el-image>
          </a-descriptions-item>
        </a-descriptions>
        <span>{{ record.params }}</span>
      </div>
    </a-table>
    <a-modal
      :title="dialogTitle"
      :visible="dialogVisible"
      :confirm-loading="dialogLoading"
      @ok="confirm"
      @cancel="cancel"
    >
      <a-textarea
        v-model="formData.message"
        placeholder="请输入审核意见"
        :auto-size="{ minRows: 3, maxRows: 5 }"
        :maxLength="200"
      />
    </a-modal>
  </a-card>
</template>

<script lang="ts">
import { Component, Mixins } from 'vue-property-decorator'
import ExcelUpload from '@/components/Upload/ExcelUpload.vue'
import MixinTable from '@/mixins/mixin-table'
import { fetchList, create } from '@/api/common'
import RichEditor from '@/components/RichEditor/Index.vue'

@Component({
  name: 'MasterIndex',
  components: {
    ExcelUpload,
    RichEditor
  }
})
export default class extends Mixins(MixinTable) {
  subjectTitle = '司机认证'
  subject = 'iFoDriverExtension'
  url = '/api/v1/driver/extension'

  auditStatuOptions: any[] = [
    {
      label: '待审核',
      value: 'PENDING'
    },
    {
      label: '已通过',
      value: 'PASSED'
    },
    {
      label: '已拒绝',
      value: 'REJECTED'
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
  dialogVisible = false
  dialogLoading = false
  dialogTitle = ''
  formData: any = {}

  private columns = [
    {
      dataIndex: 'id',
      title: 'ID',
      width: 210
    },
    //ellipsis: true,
    {
      title: '姓名',
      dataIndex: 'realName',
      width: 80
    },
    {
      title: '头像',
      dataIndex: 'avatar',
      scopedSlots: { customRender: 'avatar' },
      width: 80
    },
    {
      title: '手机号码',
      dataIndex: 'mobile',
      width: 120
    },

    // {
    //   title: '参数',
    //   dataIndex: 'params',
    //   width: 200,
    //   ellipsis: true
    // },
    {
      title: '车长',
      dataIndex: 'carLong',
      width: 80
    },
    {
      title: '车型',
      dataIndex: 'carModel',
      width: 80
    },
    {
      title: '车号',
      dataIndex: 'carNo',
      width: 100
    },
    {
      title: '营运性质',
      dataIndex: 'nature',
      width: 80
    },

    {
      title: '审核状态',
      dataIndex: 'auditStatus',
      width: 90,
      scopedSlots: { customRender: 'auditStatus' }
    },
    {
      title: '创建时间',
      dataIndex: 'createAt',
      scopedSlots: { customRender: 'createAt' },
      width: 110
    },
    {
      title: '操作',
      width: 120,
      key: 'operation',
      scopedSlots: { customRender: 'action' }
    }
  ]

  onAuditClick(id: string, auditStatus: String) {
    this.dialogVisible = true
    this.formData.targetId = id
    this.formData.targetType = 'DRIVER_AUTHENTICATION'
    this.formData.auditStatus = auditStatus
    this.dialogTitle =
      auditStatus === 'PASSED'
        ? '确定要通过该条申请吗?'
        : '确定要驳回该条申请吗?'
  }

  confirm() {
    this.dialogLoading = true
    create('/api/v1/audits', this.formData)
      .then((res: any) => {
        this.$notification.success({
          message: '成功',
          description: '审核成功'
        })
        this.fetch()
      })
      .finally(() => {
        this.dialogLoading = false
        this.dialogVisible = false
      })
  }
  cancel() {
    this.dialogVisible = false
    this.formData.message = ''
  }
}
</script>
