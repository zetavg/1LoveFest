# This requires jquery_lazyload and activate :automatic_image_sizes
#
# Usage:
# ll_img "path/to/image" [,"alt"] # for asset
# ll_img "path/to/image", "width+px", "height+px" [,"alt"] # for things outside
#

module SvgImg
  def svg_img(src)
    return '<img src="' + src + '.svg" onerror="this.src=' + src + '.png">'
  end
end
