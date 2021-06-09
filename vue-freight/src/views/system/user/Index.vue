<template>
  <a-card :bordered="false">
    <div class="table-page-search-wrapper">
      <a-form-model v-model="listQuery" layout="inline">
        <a-row :gutter="48">
          <a-col :md="8" :sm="24">
            <a-form-model-item label="账号">
              <a-input
                v-model="listQuery.username"
                placeholder="请输入账号模糊查询"
              />
            </a-form-model-item>
          </a-col>
          <a-col :md="8" :sm="24">
            <a-form-model-item label="手机号码">
              <a-input
                v-model="listQuery.mobile"
                placeholder="请输入手机号模糊查询"
              />
            </a-form-model-item>
          </a-col>
          <template v-if="expand">
            <a-col :md="8" :sm="24">
              <a-form-model-item label="所属部门">
                <a-cascader
                  placeholder="请选择所属部门"
                  :options="depts"
                  change-on-select
                  :fieldNames="{
                    label: 'deptName',
                    value: 'id',
                    children: 'children'
                  }"
                  v-model="deptIds"
                />
              </a-form-model-item>
            </a-col>
            <a-col :md="8" :sm="24">
              <a-form-model-item label="工号">
                <a-input
                  v-model="listQuery.workNo"
                  placeholder="请输入工号模糊查询"
                />
              </a-form-model-item>
            </a-col>
            <a-col :md="8" :sm="24">
              <a-form-model-item label="可用状态">
                <a-select
                  default-value=""
                  v-model="listQuery.enable"
                  style="width: 100%"
                  placeholder="请选择可用状态"
                >
                  <a-select-option
                    v-for="item in enableOptions"
                    :key="item.value"
                  >
                    {{ item.name }}</a-select-option
                  >
                </a-select>
              </a-form-model-item>
            </a-col>

            <a-col :md="8" :sm="24">
              <a-form-model-item label="锁定状态">
                <a-select
                  default-value=""
                  v-model="listQuery.locked"
                  style="width: 100%"
                  placeholder="请选择锁定状态"
                >
                  <a-select-option
                    v-for="item in lockOptions"
                    :key="item.value"
                  >
                    {{ item.name }}</a-select-option
                  >
                </a-select>
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
      :scroll="{ x: 1800 }"
    >
      <span slot="avatar" slot-scope="avatar">
        <a-avatar :src="avatar" size="large" />
      </span>
      <span slot="enable" slot-scope="enable">
        <a-tag v-if="enable" color="blue">
          可用
        </a-tag>
        <a-tag v-else color="orange">
          不可用
        </a-tag>
      </span>

      <span slot="locked" slot-scope="locked">
        <a-tag v-if="locked" color="orange">
          已锁定
        </a-tag>
        <a-tag v-else color="blue">
          未锁定
        </a-tag>
      </span>

      <span slot="gender" slot-scope="gender">
        <a-tag v-if="gender === 'UNKNOWN'" color="orange">
          未知
        </a-tag>
        <a-tag v-else-if="gender === 'MALE'" color="blue">
          男
        </a-tag>
        <a-tag v-else-if="gender === 'FEMALE'" color="pink">
          女
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
            <a-menu-item>
              <a href="javascript:;" @click="onPasswordClick(record)">密码</a>
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
    <a-modal
      title="修改密码"
      :visible="passwordVisible"
      :confirm-loading="passwordLoading"
      @ok="handlePasswordOk"
      @cancel="handlePasswordCancel"
    >
      <a-form-model
        ref="passwordForm"
        :model="passwordForm"
        :rules="passwordRules"
        :labelCol="labelCol"
        :wrapperCol="wrapperCol"
      >
        <a-form-model-item label="密码" prop="password">
          <a-input-password
            v-model="passwordForm.password"
            placeholder="请输入密码"
            autocomplete="off"
          />
        </a-form-model-item>
        <a-form-model-item label="确认密码" prop="rPassword">
          <a-input-password
            v-model="passwordForm.rPassword"
            placeholder="请再次输入密码"
            autocomplete="off"
          />
        </a-form-model-item>
      </a-form-model>
    </a-modal>
  </a-card>
</template>

<script lang="ts">
import { Component, Mixins } from 'vue-property-decorator'
import { password } from '@/api/user'
import DetailsDrawer from './DetailsDrawer.vue'
import md5 from 'md5'
import ExcelUpload from '@/components/Upload/ExcelUpload.vue'
import MixinTable from '@/mixins/mixin-table'
import { fetchList } from '@/api/common'
const defaultPasswordForm = {
  password: '',
  rPassword: ''
}
@Component({
  name: 'UserIndex',
  components: {
    DetailsDrawer,
    ExcelUpload
  }
})
export default class extends Mixins(MixinTable) {
  private passwordForm = Object.assign({}, defaultPasswordForm)

  subjectTitle = '用户'
  subject = 'syUser'
  url = '/api/v1/users'
  private deptIds: any[] | null = []
  private depts: any[] = []

  private enableOptions = [
    { name: '全部', value: '' },
    { name: '可用', value: 'true' },
    { name: '不可用', value: 'false' }
  ]

  private lockOptions = [
    { name: '全部', value: '' },
    { name: '已锁定', value: 'true' },
    { name: '未锁定', value: 'false' }
  ]

  private passwordRules = {
    password: [
      { required: true, message: '请输入密码', trigger: 'blur' },
      { min: 6, max: 20, message: '长度在6-20之间', trigger: 'blur' }
    ],
    rPassword: [
      { required: true, message: '请再次输入密码', trigger: 'blur' },
      {
        validator: this.validPass,
        trigger: 'blur'
      }
    ]
  }

  private columns = [
    {
      dataIndex: 'id',
      title: 'ID',
      width: 220
    },
    {
      title: '账号',
      dataIndex: 'username',
      width: 140
    },
    {
      title: '真实姓名',
      dataIndex: 'realName',
      width: 120
    },
    {
      title: '昵称',
      dataIndex: 'nickname',
      width: 120
    },
    {
      title: '头像',
      dataIndex: 'avatar',
      scopedSlots: { customRender: 'avatar' },
      width: 70
    },
    {
      title: '手机号',
      dataIndex: 'mobile',
      width: 140
    },
    {
      title: '工号',
      dataIndex: 'workNo',
      width: 120
    },
    {
      title: '邮箱',
      dataIndex: 'email'
    },

    {
      title: '性别',
      dataIndex: 'gender',
      scopedSlots: { customRender: 'gender' },
      width: 70
    },

    {
      title: '可用状态',
      dataIndex: 'enable',
      scopedSlots: { customRender: 'enable' },
      width: 90
    },
    {
      title: '锁定状态',
      dataIndex: 'locked',
      scopedSlots: { customRender: 'locked' },
      width: 90
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

  private passwordVisible = false
  private passwordLoading = false

  private onPasswordClick(val: any) {
    this.passwordVisible = true
    this.selectedKey = val.id
  }

  private created() {
    this.fetch()
    fetchList('/api/v1/depts/tree', {}).then((res: any) => {
      this.depts = res
    })
  }

  private validPass(rule: any, value: any, callback: any) {
    if (value !== this.passwordForm.password) {
      callback(new Error('两次输入的密码不一致'))
    } else {
      callback()
    }
  }

  private handlePasswordOk(e: any) {
    this.passwordLoading = true
    let el: any = this.$refs.passwordForm
    el.validate((valid: boolean) => {
      if (valid) {
        let pass = md5(this.passwordForm.password!)
        password(this.selectedKey as string, { password: pass })
          .then(() => {
            this.$notification.success({
              message: '成功',
              description: '修改密码成功'
            })
            this.passwordVisible = false
          })
          .finally(() => {
            this.passwordLoading = false
          })
      } else {
        console.log('error submit!!')
        return false
      }
    })
  }

  handlePasswordCancel(e: any) {
    if (!this.passwordLoading) {
      this.passwordForm = Object.assign({}, defaultPasswordForm)
      this.passwordVisible = false
    }
  }
  protected beforeSearch() {
    if (this.deptIds && this.deptIds.length > 0) {
      this.listQuery.deptId = this.deptIds[this.deptIds.length - 1]
    }
  }
}
</script>
