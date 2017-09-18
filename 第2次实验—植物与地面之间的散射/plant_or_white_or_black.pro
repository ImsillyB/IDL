pro plant_or_white_or_black
  fn = dialog_pickfile(path='D:\汪梓鑫\第三次实验\2017_Mar_14\2017_Mar_14')
  nb = file_lines(fn)
  data_white1 = fltarr(2, nb)
  openr, lun, fn, /get_lun
  readf, lun, data_white1
  free_lun, lun
  
  wv = data_white1[0, *]
  ref_white1 = data_white1[1, *]
  
  fn = dialog_pickfile(path='D:\汪梓鑫\第三次实验\2017_Mar_14\2017_Mar_14')
  nb = file_lines(fn)
  data_white2 = fltarr(2, nb)
  openr, lun, fn, /get_lun
  readf, lun, data_white2
  free_lun, lun
  
  ref_white2 = data_white2[1, *]
  
  fn = dialog_pickfile(path='D:\汪梓鑫\第三次实验\2017_Mar_14\2017_Mar_14')
  nb = file_lines(fn)
  data_white3 = fltarr(2, nb)
  openr, lun, fn, /get_lun
  readf, lun, data_white3
  free_lun, lun

  ref_white3 = data_white3[1, *]
  
  fn = dialog_pickfile(path='D:\汪梓鑫\第三次实验\2017_Mar_14\2017_Mar_14')
  nb = file_lines(fn)
  data_black1 = fltarr(2, nb)
  openr, lun, fn, /get_lun
  readf, lun, data_black1
  free_lun, lun

  ref_black1 = data_black1[1, *]
  
  fn = dialog_pickfile(path='D:\汪梓鑫\第三次实验\2017_Mar_14\2017_Mar_14')
  nb = file_lines(fn)
  data_black2 = fltarr(2, nb)
  openr, lun, fn, /get_lun
  readf, lun, data_black2
  free_lun, lun

  ref_black2 = data_black2[1, *]
  ref_white = (ref_white1 + ref_white2 + ref_white3)/3
  ref_black = (ref_black1 + ref_black2)/2
  ref_white = ref_white - ref_black/2
;  fn = dialog_pickfile(path='D:\汪梓鑫\第三次实验\2017_Mar_14\2017_Mar_14')
;  nb = file_lines(fn)
;  data_plant3 = fltarr(2, nb)
;  openr, lun, fn, /get_lun
;  readf, lun, data_plant3
;  free_lun, lun
;  
;  ref_plant3 = data_plant3[1, *]
  

  
  width = 5
  ref_white_smoothed = ref_white
  for i = width/2, nb-1-width/2 do begin
    ref_white_smoothed[i] = total(ref_white[i-width/2:i+width/2])/width
  endfor
  
  plot, wv, ref_white, xtitle = 'Wavelenth(nm)', ytitle = 'Reflectance(%)', $
    xrange = [200, 1200], yrange = [0, max(ref_white_smoothed[*])], xstyle = 1, ystyle = 16, $
    color = '000000'xl, background = 'FFFFFF'xl, /nodata
  oplot, wv, ref_white, color = '00FF00'xl, linestyle = 2, thick = 2
  oplot, wv, ref_white_smoothed, color = '0000FF'xl, thick = 2

  cor_x = [0.15, 0.2]
  cor_y = [0.86, 0.81]
  cor_data = convert_coord(cor_x, cor_y[0], /normal, /to_data)
  oplot, [cor_data[0, 0], cor_data[0, 1]], $
    [cor_data[1, 0], cor_data[1, 1]], color = '00FF00'xl

  cor_data = convert_coord(cor_x, cor_y[1], /normal, /to_data)
  oplot, [cor_data[0, 0], cor_data[0, 1]], $
    [cor_data[1, 0], cor_data[1, 1]], color = '0000FF'xl
    
  
  xyouts, 0.22, 0.85, 'white plastic', /normal, color = '00FF00'xl
  xyouts, 0.22, 0.80, 'white plastic smoothed', /normal, color = '0000FF'xl
  
    
end
  
  
