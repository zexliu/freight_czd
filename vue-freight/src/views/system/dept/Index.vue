<template>
  <a-row :gutter="16">
    <a-col :span="10">
      <a-card :bordered="false">
        <div class="table-operator">
          <a-button
            type="primary"
            icon="plus"
            @click="onAddClick"
            :disabled="isAdd"
          >
            添加部门
          </a-button>
          <a-button
            :disabled="!selectedKey || hasChildren"
            type="primary"
            icon="delete"
            @click="onDeleteClick"
          >
            删除部门
          </a-button>
        </div>

        <a-tree
          :show-line="true"
          @select="onSelect"
          @expand="onExpand"
          :default-expand-all="true"
          :tree-data="treeData"
          :expanded-keys="expandedKeys"
          :selected-keys="selectedKeys"
          :replaceFields="{
            children: 'children',
            title: 'deptName',
            key: 'id'
          }"
        >
        </a-tree>
        <a-divider />
        <a-dropdown placement="topCenter">
          <a-menu slot="overlay">
            <a-menu-item key="1" @click="expandAll(treeData)">
              <a-icon type="folder-open" />展开所有
            </a-menu-item>
            <a-menu-item key="2" @click="closedAll">
              <a-icon type="folder" />合并所有
            </a-menu-item>
          </a-menu>
          <a-button style="margin-left: 8px">
            树操作 <a-icon type="up" />
          </a-button>
        </a-dropdown>
      </a-card>
    </a-col>
    <a-col :span="14">
      <a-card>
        <a-skeleton active :loading="skeletonLoading">
          <a-empty v-show="!isAdd && selectedKey == null">
            <span slot="description">
              请选择一个部门
            </span>
          </a-empty>

          <a-form-model
            v-show="isAdd || selectedKey !== null"
            ref="form"
            :model="formData"
            :labelCol="{ span: 8 }"
            :wrapperCol="{ span: 14 }"
            :rules="rules"
          >
            <h3>{{ isAdd ? '添加部门' : '修改部门' }}</h3>
            <a-divider></a-divider>
            <a-row :gutter="16">
              <a-col :span="12">
                <a-form-model-item label="部门名称" prop="deptName">
                  <a-input
                    v-model="formData.deptName"
                    placeholder="请输入部门名称"
                  />
                </a-form-model-item>
                <a-form-model-item label="部门编码" prop="deptCode">
                  <a-input
                    v-model="formData.deptCode"
                    placeholder="请输入部门编码"
                  />
                </a-form-model-item>
                <!-- v-model="formData.parentId" -->

                <a-form-model-item label="所属部门" prop="parentIds">
                  <a-cascader
                    change-on-select
                    :field-names="{
                      label: 'deptName',
                      value: 'id',
                      children: 'children'
                    }"
                    v-model="formData.parentIds"
                    :options="deptOptions"
                    :display-render="displayRender"
                    placeholder="请选择所属部门"
                  />
                </a-form-model-item>
              </a-col>
              <a-col :span="12">
                <a-form-model-item label="传真" prop="fax">
                  <a-input v-model="formData.fax" placeholder="请输入传真" />
                </a-form-model-item>
                <a-form-model-item label="电话" prop="phone">
                  <a-input v-model="formData.phone" placeholder="请输入电话" />
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
              </a-col>
            </a-row>
            <a-form-model-item
              label="关联角色"
              prop="roleIds"
              :labelCol="{ span: 4 }"
              :wrapperCol="{ span: 19 }"
            >
              <a-select
                v-model="formData.roleIds"
                mode="multiple"
                placeholder="请选择关联角色"
                style="width: 100%"
              >
                <a-select-option v-for="role in roles" :key="role.id">
                  {{ role.roleName }}
                </a-select-option>
              </a-select>
            </a-form-model-item>
            <a-form-model-item
              label="地址"
              prop="address"
              :labelCol="{ span: 4 }"
              :wrapperCol="{ span: 19 }"
            >
              <a-input v-model="formData.address" placeholder="请输入地址" />
            </a-form-model-item>
            <a-form-model-item
              label="描述"
              :labelCol="{ span: 4 }"
              :wrapperCol="{ span: 19 }"
            >
              <a-textarea
                allow-clear
                v-model="formData.description"
                placeholder="请输入描述"
                :maxLength="200"
                :auto-size="{ minRows: 3, maxRows: 8 }"
              ></a-textarea>
            </a-form-model-item>

            <a-row>
              <a-col :span="12">
                <a-form-model-item :wrapper-col="{ span: 14, offset: 8 }">
                  <a-button
                    type="primary"
                    @click="onSubmit"
                    :loading="submitLoading"
                  >
                    确定
                  </a-button>
                </a-form-model-item>
              </a-col>
              <a-col :span="12">
                <a-form-model-item :wrapper-col="{ span: 14, offset: 8 }">
                  <a-button style="margin-left: 10px;" @click="onCancelClick">
                    {{ isAdd ? '重置' : '取消' }}
                  </a-button>
                </a-form-model-item>
              </a-col>
            </a-row>
          </a-form-model>
        </a-skeleton>
      </a-card>
    </a-col>
  </a-row>
</template>

<script lang="ts">
import { Component, Vue, Watch } from 'vue-property-decorator'
import Tree from '@/components/Tree/Tree'
import { fetchList, create, update, remove, details } from '@/api/common'
interface DeptReq {
  deptName: string
  deptCode: string
  parentId: string
  parentIds: any[]
  address: string
  fax: string
  phone: string
  description: string
  seq: number
}

const defaultFormData = {
  deptName: '',
  deptCode: '',
  parentId: '',
  parentIds: [null],
  roleIds: [],
  address: '',
  fax: '',
  phone: '',
  description: '',
  seq: 0
}
@Component({
  name: 'DeptIndex'
})
export default class extends Vue {
  private isAdd = false
  private isEdit = false
  private skeletonLoading = false
  private selectedKey: string | null = null
  private selectedKeys: any[] = []
  private hasChildren = false
  private url = 'api/v1/depts'
  private formData: DeptReq | any = Object.assign({}, defaultFormData)
  private treeData: any[] = []
  private deptOptions: any[] = []
  private expandedKeys: any[] = []
  private roles: any[] = []
  private submitLoading = false
  private rules = {
    deptName: [
      { required: true, message: '请输入部门名称', trigger: 'blur' },
      { min: 2, max: 32, message: '长度在2-32之间', trigger: 'blur' }
    ],
    deptCode: [
      { required: true, message: '请输入部门编码', trigger: 'blur' },
      { min: 2, max: 32, message: '长度在2-32之间', trigger: 'blur' }
    ],
    parentIds: [{ required: true, message: '请选择所属部门', trigger: 'blur' }],
    address: [{ max: 200, message: '长度在200之内', trigger: 'blur' }],
    fax: [{ max: 32, message: '长度在32之内', trigger: 'blur' }],
    phone: [{ max: 32, message: '长度在32之内', trigger: 'blur' }],
    description: [{ max: 32, message: '长度在32之内', trigger: 'blur' }]
  }

  created() {
    this.fetch()
    this.fetchRoles()
  }

  onAddClick() {
    this.isAdd = true
    this.resetFormData()
    if (this.selectedKey !== null) {
      this.selectedKey = null
      this.selectedKeys = []
    }
  }
  onDeleteClick() {
    let that = this
    this.$confirm({
      title: '确定要删除该部门吗?',
      onOk() {
        return remove(that.url, that.selectedKey!).then(() => {
          that.$notification.success({
            message: '成功',
            description: '删除部门成功'
          })
          that.fetch()
        })
      }
    })
  }

  onSelect(selectedKeys: any[], info: any) {
    this.selectedKeys = selectedKeys
    if (info.event === 'select') {
      this.selectedKey = selectedKeys[0]
      this.isAdd = false
      this.hasChildren = info.selectedNodes[0].data.props.dataRef.children
        ? true
        : false
    }
  }
  onExpand(expandedKeys: any) {
    this.expandedKeys = expandedKeys
  }

  onSubmit() {
    this.formData.parentId = this.formData.parentIds[
      this.formData.parentIds.length - 1
    ]
    let el: any = this.$refs.form
    el.validate((valid: boolean) => {
      if (valid) {
        this.submitLoading = true
        if (this.isAdd) {
          create(this.url, this.formData)
            .then((res: any) => {
              this.$notification.success({
                message: '成功',
                description: '新增部门成功'
              })
              this.fetch()
              this.resetFormData()
            })
            .finally(() => {
              this.submitLoading = false
            })
        } else {
          update(this.url, this.selectedKey!, this.formData)
            .then((res: any) => {
              this.$notification.success({
                message: '成功',
                description: '修改部门成功'
              })
              this.fetch()
            })
            .finally(() => {
              this.submitLoading = false
            })
        }
      } else {
        console.log('error submit!!')
        return false
      }
    })
  }

  resetFormData() {
    this.formData = Object.assign({}, defaultFormData)
  }
  onCancelClick() {
    if (this.isAdd) {
      this.resetFormData()
    } else {
      this.selectedKeys = []
      this.selectedKey = null
    }
  }
  fetch() {
    fetchList(this.url + '/tree', {}).then((res: any) => {
      this.treeData = res
      this.deptOptions = res.slice()
      this.deptOptions.unshift({
        id: null,
        deptName: '根部门'
      })
      this.expandedKeys = []
      this.expandAll(this.treeData)
    })
  }

  fetchRoles() {
    fetchList('/api/v1/roles', {
      current: 1,
      size: 10000
    }).then((res: any) => {
      this.roles = res.records
    })
  }

  expandAll(list: any) {
    list.forEach((item: any) => {
      this.expandedKeys.push(item.id)
      if (item.children) {
        this.expandAll(item.children)
      }
    })
  }
  closedAll() {
    this.expandedKeys = []
  }

  @Watch('selectedKey')
  onSelectedKeyChanged(newVal: string, oldVal: string) {
    if (newVal) {
      this.skeletonLoading = true
      details(this.url, this.selectedKey!)
        .then((res: any) => {
          this.formData = res
          this.resetParentIds(newVal)
          if (this.formData.parentIds.length == 0) {
            this.formData.parentIds.push(null)
          }
        })
        .finally(() => (this.skeletonLoading = false))
    } else {
      this.resetParentIds(oldVal)
      this.formData.parentIds.push(oldVal)
    }
  }

  resetParentIds(val: string) {
    this.recursiveDisabled(this.deptOptions)
    this.$set(this.formData, 'parentIds', [])
    this.recursiveParentIds(val, this.deptOptions)
  }
  recursiveDisabled(list: any[]) {
    if (list) {
      list.forEach((item: any) => {
        if (this.selectedKey !== null && item.id === this.selectedKey) {
          item.disabled = true
        } else {
          item.disabled = false
        }
        if (item.children) {
          this.recursiveDisabled(item.children)
        }
      })
    }
  }
  displayRender(val: any) {
    return val.labels[val.labels.length - 1]
  }

  recursiveParentIds(currentKey: string, list: any[]) {
    list.forEach((item: any) => {
      if (item.id === currentKey) {
        if (item.parentId) {
          this.formData.parentIds.unshift(item.parentId)
          return this.recursiveParentIds(item.parentId, this.deptOptions)
        } else {
          return
        }
      }
      if (item.children) {
        this.recursiveParentIds(currentKey, item.children)
      }
    })
  }
}
</script>
