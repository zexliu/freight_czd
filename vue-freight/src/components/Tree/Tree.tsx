import { Component, Prop, Vue } from 'vue-property-decorator'
import { Menu, Icon, Input } from 'ant-design-vue'

const { Item, ItemGroup, SubMenu } = Menu
const { Search } = Input

@Component({
  name: 'Tree',
  components: {}
})
export default class TreeComponent extends Vue {
  @Prop({ type: Array, required: true })
  private treeData!: []

  @Prop({ type: Array, default: () => [] })
  private openKeys!: []

  @Prop({ type: Boolean, default: false })
  private search!: boolean

  @Prop({ type: Boolean, default: false })
  private showAdd!: boolean

  @Prop({
    type: Object,
    default: { children: 'children', title: 'title', key: 'key' }
  })
  private replaceFields!: any

  private localOpenKeys: any[]

  constructor() {
    super()
    this.localOpenKeys = []
  }

  // Lifecycle
  created() {
    this.localOpenKeys = this.openKeys.slice(0)
  }

  // methods
  private handlePlus(item: any) {
    this.$emit('add', item)
  }

  private renderSearch() {
    return (
      <Search
        placeholder="input search text"
        style="width: 100%; margin-bottom: 1rem"
      />
    )
  }

  private renderIcon(icon: any) {
    return (icon && <Icon type={icon} />) || null
  }

  private renderMenuItem(item: any, key = undefined) {
    return (
      <Item key={item[this.replaceFields.key]}>
        {this.renderIcon(item.icon)}
        {item[this.replaceFields.title]}
        <a
          class="btn"
          style="width: 20px;z-index:1300"
          {...{ on: { click: () => this.handlePlus(item) } }}>
          <a-icon type="plus" />
        </a>
      </Item>
    )
  }

  private renderItem(item: any, key = undefined) {
    return item[this.replaceFields.children]
      ? this.renderSubItem(item, item[this.replaceFields.key])
      : this.renderMenuItem(item, item[this.replaceFields.key])
  }

  private renderItemGroup(item: any) {
    const childrenItems = item[this.replaceFields.children].map((o: any) => {
      return this.renderItem(o, o[this.replaceFields.key])
    })

    return (
      <ItemGroup key={item[this.replaceFields.key]}>
        <template slot="title">
          <span>{item[this.replaceFields.title]}</span>
          <a-dropdown>
            <a class="btn">
              <a-icon type="ellipsis" />
            </a>
            <a-menu slot="overlay">
              <a-menu-item key="1">新增</a-menu-item>
              <a-menu-item key="2">合并</a-menu-item>
              <a-menu-item key="3">移除</a-menu-item>
            </a-menu>
          </a-dropdown>
        </template>
        {childrenItems}
      </ItemGroup>
    )
  }

  private renderSubItem(item: any, key: any) {
    const childrenItems =
      item[this.replaceFields.children] &&
      item[this.replaceFields.children].map((o: any) => {
        return this.renderItem(o, o[this.replaceFields.key])
      })

    const title = (
      <span slot="title">
        {this.renderIcon(item.icon)}
        <span>{item[this.replaceFields.title]}</span>
      </span>
    )

    if (item.group) {
      return this.renderItemGroup(item)
    }
    // titleClick={this.handleTitleClick(item)}
    return (
      <SubMenu key={key}>
        {title}
        {childrenItems}
      </SubMenu>
    )
  }

  render() {
    const { treeData, search } = this.$props

    // this.localOpenKeys = openKeys.slice(0)
    const list = treeData.map((item: any) => {
      return this.renderItem(item)
    })

    return (
      <div class="tree-wrapper">
        {search ? this.renderSearch() : null}
        <Menu
          mode="inline"
          class="custom-tree"
          {...{
            on: {
              click: (item: any) => this.$emit('click', item),
              'update:openKeys': (val: []) => {
                this.localOpenKeys = val
              }
            }
          }}
          openKeys={this.localOpenKeys}>
          {list}
        </Menu>
      </div>
    )
  }
}
