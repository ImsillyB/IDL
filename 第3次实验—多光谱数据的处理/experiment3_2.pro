pro experiment3_2

  t1 = systime(1)
  ;********************读取数据****************
  fn = dialog_pickfile(title = 'choose rs', path = 'D:\汪梓鑫\实验报告\遥感综合实验\第三次实验\c\c')
  ;cd, work_dir
  envi_open_file, fn, r_fid = fid
  envi_file_query, fid, ns = ns, nl = nl, nb = nb, dims = dims, $
    data_type = data_type, interleave = interleave, offset = offset
  data = make_array(ns, nl, nb, type = data_type)
  for i = 0, nb - 1 do data[*, *, i] = envi_get_data(fid = fid, dims = dims, pos = i)


  fn = dialog_pickfile(path = 'D:\汪梓鑫\实验报告\遥感综合实验\第三次实验\c\c')
  wv = dblarr(128)
  openr, lun, fn, /get_lun
  readf, lun, wv
  free_lun, lun

  ;***************通过ENVI上寻找我们想要的点******
  leaf1 = dblarr(128)
  leaf2 = dblarr(128)
  leaf3 = dblarr(128)
  leaf4 = dblarr(128)
  
  leaf1 = get_reference(99, 329, 108, 352, data)
  leaf2 = get_reference(116, 328, 128, 349, data)
  white = get_reference(104, 406, 115, 423, data)
  
  leaf1 = leaf1 / white
  leaf2 = leaf2 / white
  
  leaf1_smoothed = get_smoothed(leaf1)
  leaf2_smoothed = get_smoothed(leaf2)

  ;***************输出图像*************
  plot, wv, leaf1_smoothed, xtitle = 'Wavelenth(nm)', ytitle = 'Reflectance(%)', $
    xrange = [min(wv[*]), max(wv[*])], yrange = [0, max(leaf2_smoothed[*])], xstyle = 1, ystyle = 16, $
    color = '000000'xl, background = 'FFFFFF'xl, /nodata
  oplot, wv, leaf1, color = '0000FF'xl, thick = 2
  oplot, wv, leaf2, color = '00FF00'xl, thick = 2
;  oplot, wv, leaf3_smoothed, color = 'FF0000'xl, thick = 2
;  oplot, wv, leaf4_smoothed, color = 'FFFF00'xl, thick = 2
  
  cor_x = [0.65, 0.70, 0.75, 0.80]
  cor_y = [0.86, 0.81, 0.76, 0.71]
  cor_data = convert_coord(cor_x, cor_y[0], /normal, /to_data)
  oplot, [cor_data[0, 0], cor_data[0, 1]], $
    [cor_data[1, 0], cor_data[1, 1]], color = '0000FF'xl
  cor_data = convert_coord(cor_x, cor_y[1], /normal, /to_data)
  oplot, [cor_data[0, 0], cor_data[0, 1]], $
    [cor_data[1, 0], cor_data[1, 1]], color = '00FF00'xl

;  cor_data = convert_coord(cor_x, cor_y[2], /normal, /to_data)
;  oplot, [cor_data[0, 0], cor_data[0, 1]], $
;    [cor_data[1, 0], cor_data[1, 1]], color = 'FF0000'xl
;
;  cor_data = convert_coord(cor_x, cor_y[3], /normal, /to_data)
;  oplot, [cor_data[0, 0], cor_data[0, 1]], $
;    [cor_data[1, 0], cor_data[1, 1]], color = 'FFFF00'xl

  xyouts, 0.72, 0.85, 'leaf1', /normal, color = '0000FF'xl
  xyouts, 0.72, 0.80, 'leaf2', /normal, color = '00FF00'xl
;  xyouts, 0.72, 0.75, 'leaf3', /normal, color = 'FF0000'xl
;  xyouts, 0.72, 0.70, 'leaf4', /normal, color = 'FFFF00'xl
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

