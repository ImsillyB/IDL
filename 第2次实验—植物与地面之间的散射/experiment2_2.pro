pro experiment2_2
  fn = dialog_pickfile(path='D:\汪梓鑫\第三次实验\2017_Mar_14\2017_Mar_14')
  nb = file_lines(fn)
  data_plant1 = fltarr(2, nb)
  openr, lun, fn, /get_lun
  readf, lun, data_plant1
  free_lun, lun

  wv = transpose(data_plant1[0, *])   ;波长
  ref_plant1 = transpose(data_plant1[1, *])  ;反射率

  fn = dialog_pickfile(path='D:\汪梓鑫\第三次实验\2017_Mar_14\2017_Mar_14')
  nb = file_lines(fn)
  data_plant2 = fltarr(2, nb)
  openr, lun, fn, /get_lun
  readf, lun, data_plant2
  free_lun, lun

  ref_plant2 = transpose(data_plant2[1, *])
  
  ref_plant = (ref_plant1 + ref_plant2)/2

  fn = dialog_pickfile(path='D:\汪梓鑫\第三次实验\2017_Mar_14\2017_Mar_14')
  nb = file_lines(fn)
  data_white1 = fltarr(2, nb)
  openr, lun, fn, /get_lun
  readf, lun, data_white1
  free_lun, lun

  ref_white1 = transpose(data_white1[1, *])
  
  fn = dialog_pickfile(path='D:\汪梓鑫\第三次实验\2017_Mar_14\2017_Mar_14')
  nb = file_lines(fn)
  data_white2 = fltarr(2, nb)
  openr, lun, fn, /get_lun
  readf, lun, data_white2
  free_lun, lun

  ref_white2 = transpose(data_white2[1, *])
  
  fn = dialog_pickfile(path='D:\汪梓鑫\第三次实验\2017_Mar_14\2017_Mar_14')
  nb = file_lines(fn)
  data_white3 = fltarr(2, nb)
  openr, lun, fn, /get_lun
  readf, lun, data_white3
  free_lun, lun

  ref_white3 = transpose(data_white3[1, *])
  ref_white = (ref_white1 + ref_white2 + ref_white3)/3

  fn = dialog_pickfile(path='D:\汪梓鑫\第三次实验\2017_Mar_14\2017_Mar_14')
  nb = file_lines(fn)
  data_all1 = fltarr(2, nb)
  openr, lun, fn, /get_lun
  readf, lun, data_all1
  free_lun, lun

  ref_all1 = transpose(data_all1[1, *])
  
  fn = dialog_pickfile(path='D:\汪梓鑫\第三次实验\2017_Mar_14\2017_Mar_14')
  nb = file_lines(fn)
  data_all2 = fltarr(2, nb)
  openr, lun, fn, /get_lun
  readf, lun, data_all2
  free_lun, lun

  ref_all2 = transpose(data_all2[1, *])
  
  fn = dialog_pickfile(path='D:\汪梓鑫\第三次实验\2017_Mar_14\2017_Mar_14')
  nb = file_lines(fn)
  data_all3 = fltarr(2, nb)
  openr, lun, fn, /get_lun
  readf, lun, data_all3
  free_lun, lun

  ref_all3 = transpose(data_all3[1, *])
  ref_all = (ref_all1 + ref_all2 + ref_all3)/3
 
  fn = dialog_pickfile(path='D:\汪梓鑫\第三次实验\2017_Mar_14\2017_Mar_14')
  nb = file_lines(fn)
  data_black1 = fltarr(2, nb)
  openr, lun, fn, /get_lun
  readf, lun, data_black1
  free_lun, lun

  ref_black1 = transpose(data_black1[1, *])
  
  fn = dialog_pickfile(path='D:\汪梓鑫\第三次实验\2017_Mar_14\2017_Mar_14')
  nb = file_lines(fn)
  data_black2 = fltarr(2, nb)
  openr, lun, fn, /get_lun
  readf, lun, data_black2
  free_lun, lun

  ref_black2 = transpose(data_black2[1, *])
  ref_black = ref_black1 + ref_black2
  
  ref_PAWWB = ref_plant + ref_white - ref_black
  
  width = 5
  
  ref_all_smoothed = ref_all
  for i = width/2, nb-1-width/2 do begin
    ref_all_smoothed[i] = total(ref_all[i-width/2:i+width/2])/width
  endfor
  
  ref_PAWWB_smoothed = ref_PAWWB
  width = 5
  for i = width/2, nb-1-width/2 do begin
    ref_PAWWB_smoothed[i] = total(ref_PAWWB[i-width/2:i+width/2])/width
  endfor
  
  plot, wv, ref_all_smoothed, xtitle = 'Wavelenth(nm)', ytitle = 'Reflectance(%)', $
    xrange = [200, 1200], yrange = [0, max(ref_all_smoothed[*])], xstyle = 1, ystyle = 16, $
    color = '000000'xl, background = 'FFFFFF'xl, /nodata
 ; oplot, wv, ref_plant_smoothed, color = '0000FF'xl,  thick = 2
 ; oplot, wv, ref_white_smoothed, color = 'FF0000'xl, thick = 2
  oplot, wv, ref_all_smoothed, color = '00FF00'xl, thick = 2
  oplot, wv, ref_PAWWB_smoothed, color = '0000FF'xl, thick = 2

  cor_x = [0.15, 0.2]
  cor_y = [0.86, 0.81]
  cor_data = convert_coord(cor_x, cor_y[0], /normal, /to_data)
  oplot, [cor_data[0, 0], cor_data[0, 1]], $
    [cor_data[1, 0], cor_data[1, 1]], color = '00FF00'xl

  cor_data = convert_coord(cor_x, cor_y[1], /normal, /to_data)
  oplot, [cor_data[0, 0], cor_data[0, 1]], $
    [cor_data[1, 0], cor_data[1, 1]], color = '0000FF'xl

;  cor_data = convert_coord(cor_x, cor_y[2], /normal, /to_data)
;  oplot, [cor_data[0, 0], cor_data[0, 1]], $
;    [cor_data[1, 0], cor_data[1, 1]], color = '00FF00'xl
;    
;  cor_data = convert_coord(cor_x, cor_y[3], /normal, /to_data)
;  oplot, [cor_data[0, 0], cor_data[0, 1]], $
;    [cor_data[1, 0], cor_data[1, 1]], color = '00FFFF'xl

;  xyouts, 0.22, 0.85, 'plant', /normal, color = '0000FF'xl
;  xyouts, 0.22, 0.80, 'white plastic', /normal, color = 'FF0000'xl
  xyouts, 0.22, 0.85, 'all', /normal, color = '00FF00'xl
  xyouts, 0.22, 0.80, 'plant and white without black plastic', /normal, color = '0000FF'xl

  ref_sanshe = ref_all - ref_PAWWB
  arr = fltarr(2,nb)
  arr[0, *] = wv
  arr[1, *] = ref_sanshe
  openw , lun, 'D:\sanshe.txt', /get_lun
  printf, lun, arr
  free_lun, lun

end