pro experiment3_1

  t1 = systime(1)
;********************读取数据****************
  
  fn = dialog_pickfile(title = 'choose rs', path = 'D:\汪梓鑫\实验报告\遥感综合实验\第三次实验\c\c')
  envi_open_file, fn, r_fid = fid
  envi_file_query, fid, ns = ns, nl = nl, nb = nb, dims = dims, $
    data_type = data_type, interleave = interleave, offset = offset
  data = make_array(ns, nl, nb, type = data_type)
  for i = 0, nb - 1 do data[*, *, i] = envi_get_data(fid = fid, dims = dims, pos = i)
  
  fn = dialog_pickfile(path = 'D:\汪梓鑫\实验报告\遥感综合实验\第三次实验\c\c')
  wv = fltarr(128)
  openr, lun, fn, /get_lun
  readf, lun, wv
  free_lun, lun
  
  ;***************通过ENVI上寻找我们想要的点******
  withoutsun_white = fltarr(128)
  withoutsun_leaf = fltarr(128)
  sun_white1 = fltarr(128)
  sun_leaf1 = fltarr(128)
  sun_white2 = fltarr(128)
  sun_leaf2 = fltarr(128)
  sun_white3 = fltarr(128)
  sun_leaf3 = fltarr(128)
  
  withoutsun_white = get_reference(29, 259, 44, 270, data)
  withoutsun_leaf = get_reference(23, 283, 38, 288, data) 
  sun_white1 = get_reference(244, 276, 264, 292, data)
  sun_leaf1 = get_reference(266, 263, 268, 271, data)
  sun_white2 = get_reference(104, 406, 115, 423, data)
  sun_leaf2 = get_reference(100, 388, 111, 398, data)
  sun_white3 = get_reference(172, 475, 186, 482, data)
  sun_leaf3 = get_reference(167, 466, 169, 469)
  
  ref_ws_leaf = withoutsun_leaf / withoutsun_white
  ref_s_leaf1 = sun_leaf1 / sun_white1
  ref_s_leaf2 = sun_leaf2 / sun_white2
  ref_s_leaf3 = sun_leaf3 / sun_white3
  
  ;****************滤波************** 
  ref_ws_leaf_smoothed = get_smoothed(ref_ws_leaf)
  ref_s_leaf1_smoothed = get_smoothed(ref_s_leaf1)
  ref_s_leaf2_smoothed = get_smoothed(ref_s_leaf2)
  ref_s_leaf3_smoothed = get_smoothed(ref_s_leaf3)
  
  ;***************输出图像*************
  plot, wv, sun_white1, xtitle = 'Wavelenth(nm)', ytitle = 'Reflectance()', $
    xrange = [min(wv[*]), max(wv[*])], yrange = [0, max(sun_white1[*])], xstyle = 1, ystyle = 16, $
    color = '000000'xl, background = 'FFFFFF'xl, /nodata
  oplot, wv, withoutsun_white, color = '0000FF'xl, thick = 2
  oplot, wv, withoutsun_leaf, color = '0000FF'xl, thick = 2
  oplot, wv, sun_white1, color = '00FF00'xl, thick = 2
  oplot, wv, sun_leaf1, color = '00FF00'xl, thick = 2
  oplot, wv, sun_white2, color = 'FF0000'xl, thick = 2
  oplot, wv, sun_leaf2, color = 'FF0000'xl, thick = 2
  oplot, wv, sun_white3, color = 'FFFF00'xl, thick =2
  oplot, wv, sun_leaf3, color = 'FFFF00'xl, thick = 2

  cor_x = [0.65, 0.70, 0.75, 0.80, 0.85, 0.90, 0.95, 1.00]
  cor_y = [0.86, 0.81, 0.76, 0.71, 0.66, 0.61, 0.56, 0.51]
  cor_data = convert_coord(cor_x, cor_y[0], /normal, /to_data)
  oplot, [cor_data[0, 0], cor_data[0, 1]], $
    [cor_data[1, 0], cor_data[1, 1]], color = '0000FF'xl
  cor_data = convert_coord(cor_x, cor_y[1], /normal, /to_data)
  oplot, [cor_data[0, 0], cor_data[0, 1]], $
    [cor_data[1, 0], cor_data[1, 1]], color = '0000FF'xl
  cor_data = convert_coord(cor_x, cor_y[2], /normal, /to_data)
  oplot, [cor_data[0, 0], cor_data[0, 1]], $
    [cor_data[1, 0], cor_data[1, 1]], color = '00FF00'xl
  cor_data = convert_coord(cor_x, cor_y[3], /normal, /to_data)
  oplot, [cor_data[0, 0], cor_data[0, 1]], $
    [cor_data[1, 0], cor_data[1, 1]], color = '00FF00'xl
  cor_data = convert_coord(cor_x, cor_y[4], /normal, /to_data)
  oplot, [cor_data[0, 0], cor_data[0, 1]], $
    [cor_data[1, 0], cor_data[1, 1]], color = 'FF0000'xl
  cor_data = convert_coord(cor_x, cor_y[5], /normal, /to_data)
  oplot, [cor_data[0, 0], cor_data[0, 1]], $
    [cor_data[1, 0], cor_data[1, 1]], color = 'FF0000'xl
  cor_data = convert_coord(cor_x, cor_y[6], /normal, /to_data)
  oplot, [cor_data[0, 0], cor_data[0, 1]], $
    [cor_data[1, 0], cor_data[1, 1]], color = 'FFFF00'xl
  cor_data = convert_coord(cor_x, cor_y[7], /normal, /to_data)
  oplot, [cor_data[0, 0], cor_data[0, 1]], $
    [cor_data[1, 0], cor_data[1, 1]], color = 'FFFF00'xl

  xyouts, 0.72, 0.85, 'withoutsun_white', /normal, color = '0000FF'xl
  xyouts, 0.72, 0.80, 'withoutsun_leaf', /normal, color = '0000FF'xl
  xyouts, 0.72, 0.75, 'sun_white1', /normal, color = '00FF00'xl
  xyouts, 0.72, 0.70, 'sun_leaf1', /normal, color = '00FF00'xl
  xyouts, 0.72, 0.65, 'sun_white2', /normal, color = 'FF0000'xl
  xyouts, 0.72, 0.60, 'sun_leaf2', /normal, color = 'FF0000'xl
  xyouts, 0.72, 0.55, 'sun_white3', /normal, color = 'FFFF00'xl
  xyouts, 0.72, 0.50, 'sun_leaf3', /normal, color = 'FFFF00'xl
;
;  plot, wv, ref_s_leaf1, xtitle = 'Wavelenth(nm)', ytitle = 'Reflectance(%)', $
;    xrange = [min(wv[*]), max(wv[*])], yrange = [0, max(ref_s_leaf1[*])], xstyle = 1, ystyle = 16, $
;    color = '000000'xl, background = 'FFFFFF'xl, /nodata
;  oplot, wv, ref_ws_leaf_smoothed, color = '0000FF'xl, thick = 2
;  oplot, wv, ref_s_leaf1_smoothed, color = '00FF00'xl, thick = 2
;  oplot, wv, ref_s_leaf2_smoothed, color = 'FF0000'xl, thick = 2
;  oplot, wv, ref_s_leaf3_smoothed, color = 'FFFF00'xl, thick = 2
;  
;  cor_x = [0.15, 0.20, 0.25, 0.30]
;  cor_y = [0.86, 0.81, 0.76, 0.71]
;  cor_data = convert_coord(cor_x, cor_y[0], /normal, /to_data)
;  oplot, [cor_data[0, 0], cor_data[0, 1]], $
;    [cor_data[1, 0], cor_data[1, 1]], color = '0000FF'xl
;  
;  cor_data = convert_coord(cor_x, cor_y[1], /normal, /to_data)
;  oplot, [cor_data[0, 0], cor_data[0, 1]], $
;    [cor_data[1, 0], cor_data[1, 1]], color = '00FF00'xl
;  
;  cor_data = convert_coord(cor_x, cor_y[2], /normal, /to_data)
;  oplot, [cor_data[0, 0], cor_data[0, 1]], $
;    [cor_data[1, 0], cor_data[1, 1]], color = 'FF0000'xl
;  
;  cor_data = convert_coord(cor_x, cor_y[3], /normal, /to_data)
;  oplot, [cor_data[0, 0], cor_data[0, 1]], $
;    [cor_data[1, 0], cor_data[1, 1]], color = 'FFFF00'xl
;  
;  
;  xyouts, 0.22, 0.85, 'withoutsun leaf ', /normal, color = '0000FF'xl
;  xyouts, 0.22, 0.80, 'sun leaf1', /normal, color = '00FF00'xl
;  xyouts, 0.22, 0.75, 'sun leaf2', /normal, color = 'FF0000'xl
;  xyouts, 0.22, 0.70, 'sun leaf3', /normal, color = 'FFFF00'xl

  reflect = fltarr(5, 128)
  reflect[0, *] = wv
  reflect[1, *] = ref_ws_leaf
  reflect[2, *] = ref_s_leaf1
  reflect[3, *] = ref_s_leaf2
  reflect[4, *] = ref_s_leaf3
  
  openw , lun, 'D:\ref.txt', /get_lun
  printf, lun, reflect
  free_lun, lun
end

function get_reference, x1, y1, x2, y2, data
  ref = dblarr(128)
  for i = 0, 127 do begin
    for x = x1, x2 do begin
      for y = y1, y2 do begin
        ref[i] = ref[i] + data[x, y, i]
      endfor
    endfor
  endfor
  l = (x2 - x1) * (y2 - y1)
  ref = ref / l
  return, ref[*]
end

function get_smoothed, leaf
  leaf_smooth = dblarr(128)
  nb = 128

  width = 5
  for i = width/2, nb-1-width/2 do begin
    leaf_smooth[i] = total(leaf[i-width/2:i+width/2])/width
  endfor

  return, leaf_smooth[*]
end

