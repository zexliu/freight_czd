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
            添加分类
          </a-button>
          <a-button
            :disabled="!selectedKey || hasChildren"
            type="primary"
            icon="delete"
            @click="onDeleteClick"
          >
            删除分类
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
            title: 'categoryName',
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
              请选择一个分类
            </span>
          </a-empty>

          <a-form-model
            v-show="isAdd || selectedKey !== null"
            ref="form"
            :model="formData"
            :labelCol="{ span: 4 }"
            :wrapperCol="{ span: 20 }"
            :rules="rules"
          >
            <h3>{{ isAdd ? '添加分类' : '修改分类' }}</h3>
            <a-divider></a-divider>
            <a-form-model-item label="分类名称" prop="categoryName">
              <a-input
                v-model="formData.categoryName"
                placeholder="请输入分类名称"
              />
            </a-form-model-item>
            <a-form-model-item label="所属分类" prop="parentId">
              <a-select
                v-model="formData.parentId"
                :disabled="formData.children && formData.children.length > 0"
              >
                <a-select-option value="">
                  根分类
                </a-select-option>
                <a-select-option v-for="item in treeData" :key="item.id">
                  {{ item.categoryName }}</a-select-option
                >
              </a-select>
            </a-form-model-item>
            <a-form-model-item
              v-if="formData.parentId !== ''"
              label="包装方式"
              prop="dictEntryValues"
            >
              <a-select mode="multiple" v-model="formData.dictEntryValues">
                <a-select-option
                  v-for="item in dictEntries"
                  :key="item.dictEntryValue"
                >
                  {{ item.dictEntryName }}</a-select-option
                >
              </a-select>
            </a-form-model-item>
            <a-form-model-item label="是否热门" v-if="formData.parentId !== ''">
              <a-switch v-model="formData.isHot"> </a-switch>
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

            <a-form-model-item label="描述">
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
  categoryName: string
  categoryCode: string
  parentId: string | null
  description: string
  seq: number
  dictEntryValues: []
  isHot: boolean
}

const defaultFormData: DeptReq = {
  categoryName: '',
  categoryCode: 'delivery',
  parentId: '',
  description: '',
  seq: 0,
  dictEntryValues: [],
  isHot: false
}
@Component({
  name: 'CategoryIndex'
})
export default class extends Vue {
  private isAdd = false
  private isEdit = false
  private skeletonLoading = false
  private selectedKey: string | null = null
  private selectedKeys: any[] = []
  private hasChildren = false
  private url = 'api/v1/categories'
  private formData: DeptReq | any = Object.assign({}, defaultFormData)
  private treeData: any[] = []
  private expandedKeys: any[] = []
  private submitLoading = false
  private dictEntries = []
  private rules = {
    categoryName: [
      { required: true, message: '请输入分类名称', trigger: 'blur' },
      { min: 2, max: 32, message: '长度在2-32之间', trigger: 'blur' }
    ],
    description: [{ max: 32, message: '长度在32之内', trigger: 'blur' }]
  }

  created() {
    this.fetch()
    fetchList('/api/v1/dict/entries', {
      current: 1,
      size: 9999,
      dictCode: 'package_mode'
    }).then((res: any) => {
      this.dictEntries = res.records
    })
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
      title: '确定要删除该分类吗?',
      onOk() {
        return remove(that.url, that.selectedKey!).then(() => {
          that.$notification.success({
            message: '成功',
            description: '删除分类成功'
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
    let el: any = this.$refs.form
    el.validate((valid: boolean) => {
      if (valid) {
        if (this.formData.parentId == '') {
          this.formData.isHot = false
        }
        this.submitLoading = true
        if (this.isAdd) {
          create(this.url, this.formData)
            .then((res: any) => {
              this.$notification.success({
                message: '成功',
                description: '新增分类成功'
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
                description: '修改分类成功'
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
    fetchList(this.url + '/tree', { categoryCode: 'delivery' }).then(
      (res: any) => {
        this.treeData = res
        this.expandedKeys = []
        this.expandAll(this.treeData)
      }
    )
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
          if (!this.formData.parentId) {
            this.$set(this.formData, 'parentId', '')
          }
          let values = []
          if (this.formData.dictEntries) {
            for (let i = 0; i < this.formData.dictEntries.length; i++) {
              const element = this.formData.dictEntries[i]
              values.push(element.dictEntryValue)
            }
          }
          console.log('values', values)
          this.$set(this.formData, 'dictEntryValues', values)
          console.log(this.formData)
        })
        .finally(() => (this.skeletonLoading = false))
    }
  }

  displayRender(val: any) {
    return val.labels[val.labels.length - 1]
  }
}
</script>
