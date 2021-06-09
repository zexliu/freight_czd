import { Component, Vue } from 'vue-property-decorator'
import { downloadExcel } from '@/api/excel'
import { fetchList, remove } from '@/api/common'

@Component({
  components: {}
})
export default class MixinTable extends Vue {
  //data

  //查询条件
  protected listQuery: any = {}

  protected subjectTitle = ''
  protected subject = ''
  protected url = ''
  //查询表单的样式
  protected labelCol = { span: 6 }
  protected wrapperCol = { span: 14 }
  //表单展开
  protected expand = false
  //table加载框
  protected loading = false
  //table数据
  protected tableData = []

  protected deleteDescription = '删除后将删除其所有关联信息,且数据不可恢复'
  //Table分页配置
  protected pagination = {
    showSizeChanger: true,
    pageSizeOptions: ['10', '20', '50', '100'],
    showQuickJumper: true,
    showLessItems: true,
    total: 0,
    current: 1,
    pageSize: 10
  }

  //详情显示状态
  protected detailsVisible = false

  //详情显示类型
  protected detailsType = 'ADD'

  //详情选择的Key
  protected selectedKey: string | null = null

  //methods
  //查询 查询
  protected handleSearch() {
    this.pagination.current = 1
    this.beforeSearch()
    this.fetch()
  }

  //查询重置
  protected handleResetSearch() {
    this.listQuery = {}
  }

  //查询展开
  protected expandToggle() {
    this.expand = !this.expand
  }

  //table 改变重新加载数据
  protected handleTableChange(pagination: any) {
    this.pagination = pagination
    this.fetch()
  }

  //详情点击
  protected onDetailsClick(val: any) {
    this.detailsType = 'INFO'
    this.detailsVisible = !this.detailsVisible
    this.selectedKey = val.id
  }

  //新增点击
  protected onAddClick() {
    this.detailsType = 'ADD'
    this.selectedKey = null
    this.detailsVisible = true
  }

  //编辑点击
  protected onEditClick(val: any) {
    this.detailsType = 'EDIT'
    this.detailsVisible = !this.detailsVisible
    this.selectedKey = val.id
  }

  //新增成功回调
  protected onAddSuccess(val: any) {
    this.pagination.current = 1
    this.fetch()
  }

  //编辑成功回调
  protected onEditSuccess(val: any) {
    const newData = [...this.tableData]
    const target = newData.find((item: any) => {
      return item.id === this.selectedKey
    })
    if (target) {
      Object.assign(target, val)
      this.tableData = newData
    }
  }

  //详情关闭回调
  protected onDetailsClosed(val: boolean) {
    this.detailsVisible = val
  }

  protected onExcelSuccess() {
    this.fetch()
  }
  protected exportExcel() {
    downloadExcel({ name: this.subject }).then((res: any) => {
      console.log(res)
      let blob = new Blob([res], { type: 'application/vnd.ms-excel' })
      let url = window.URL.createObjectURL(blob)
      const link = document.createElement('a') // 创建a标签
      link.href = url
      link.download = this.subjectTitle + '信息.xlsx' // 重命名文件
      link.click()
      URL.revokeObjectURL(url)
    })
  }
  protected onDeleteClick(val: any) {
    let that = this
    this.$confirm({
      title: '确定要删除该' + that.subjectTitle + '吗?',
      content: this.deleteDescription,
      onOk() {
        return remove(that.url, val.id).then(() => {
          that.$notification.success({
            message: '成功',
            description: '删除' + that.subjectTitle + '成功'
          })
          that.fetch()
        })
      }
    })
  }
  protected fetch() {
    this.listQuery.current = this.pagination.current
    this.listQuery.size = this.pagination.pageSize
    this.loading = true
    fetchList(this.url, this.listQuery)
      .then((response: any) => {
        this.tableData = response.records
        this.pagination.total = response.total
      })
      .finally(() => {
        this.loading = false
      })
  }
  protected beforeSearch() {}
}
