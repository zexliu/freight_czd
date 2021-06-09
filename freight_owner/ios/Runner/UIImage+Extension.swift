extension UIImage {
    
    //将图片裁剪成指定比例（多余部分自动删除）
    func crop(ratio: CGFloat , nSize : CGSize?) -> UIImage {
        //计算最终尺寸
        
        var newSize:CGSize!
        
        if(nSize != nil){
            newSize = nSize
        }else{
            if size.width/size.height > ratio {
                newSize = CGSize(width: size.height * ratio, height: size.height)
            }else{
                newSize = CGSize(width: size.width, height: size.width / ratio)
            }
        }
        
        ////图片绘制区域
        var rect = CGRect.zero
        rect.size.width  = size.width
        rect.size.height = size.height
        rect.origin.x    = (newSize.width - size.width ) / 2.0
        rect.origin.y    = (newSize.height - size.height ) / 2.0
        
        //绘制并获取最终图片
        UIGraphicsBeginImageContext(newSize)
        draw(in: rect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}
