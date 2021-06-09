/**
 * 这个文件在这是为了解决同时引入element-ui / ant-design  ts 爆粗哦，
 * 解决版本把node_modules 相关文件注释了
 * */

let fs = require('fs')
let path = require('path')

let src1 = '../node_modules/element-ui/types/message.d.ts'
annotation(src1, '$message: ElMessage')
let src2 = '../node_modules/element-ui/types/message-box.d.ts'
annotation(src2, '$confirm: ElMessageBoxShortcutMethod')
let src3 = '../node_modules/element-ui/types/loading.d.ts'
annotation(
  src3,
  '$loading (options: LoadingServiceOptions): ElLoadingComponent'
)
function annotation(src, params) {
  fs.readFile(path.resolve(__dirname, src), 'utf8', function(err, files) {
    if (!err && files !== '') {
      let val = params
      let has = `// ${params}`
      let start = files.indexOf(val)
      let start2 = files.indexOf(has)
      if (start > -1 && start2 === -1) {
        var result = files.replace(val, has)
        fs.writeFile(path.resolve(__dirname, src), result, 'utf8', function(
          err
        ) {
          if (err) {
            console.log(err)
          }
        })
        console.log(params + ' 注释成功！')
      }
    } else {
      console.log(params + ' 没有需要注释对或者已经注释了或者注释文件失败！')
    }
  })
}
