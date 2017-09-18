pro experiment4_2
  fn = dialog_pickfile(path = 'D:\汪梓鑫\实验报告\遥感综合实验\第4次试验\实验4数据及说明\实验4数据及说明')
  openr, lun, fn, /get_lun
  
  
  nl = file_lines(fn)
  data = strarr(nl)
  readf, lun, data
  
  time = dblarr(3, nl)
  Ta = fltarr(3, nl)
  We = dblarr(3, nl)
  
  for i = 0, nl - 1 do begin
    tdata = strsplit(data[i], ',', /extract)
    Ta[0, i] = float(tdata[1])
    Ta[1, i] = float(tdata[2])
    Ta[2, i] = float(tdata[3])
    We[0, i] = float(tdata[4])
    We[1, i] = float(tdata[5])
    We[2, i] = float(tdata[6])
    
    t_time = strsplit(tdata[0], ' ', / extract)
    hour = strsplit(t_time[1], ':', /extract)
    time[0, i] = hour[0] 
    time[1, i] = hour[1]
    time[2, i] = hour[2]
  endfor
  
  free_lun, lun
  
  Ti = dblarr(nl)
  for i = 0, nl - 1 do begin
    Ti[i] = time[0, i] + time[1, i] / 60 + time[2, i] / 3600
  endfor
  
  !p.multi = [0, 2, 1, 0, 0]
  plot, Ti, Ta[0, *], xtitle = 'Time(h)', ytitle = 'Temp(c)', $
    xrange = [min(Ti[*]), max(Ti[*])], yrange = [16, 22], xstyle = 1, ystyle = 16, $
    color = '000000'xl, background = 'FFFFFF'xl, $
    title = 'temprature', /nodata
  oplot, Ti, Ta[0, *], color = '0000FF'xl, thick = 2
  oplot, Ti, Ta[1, *], color = 'FF0000'xl, thick = 2
  oplot, Ti, Ta[2, *], color = '00FF00'xl, thick = 2
  
  plot, Ti, We[0, *], xtitle = 'Time(h)', ytitle = 'Water(%)', $
    xrange = [min(Ti[*]), max(Ti[*])], yrange = [2, 14], xstyle = 1, ystyle = 16, $
    color = '000000'xl, background = 'FFFFFF'xl, $
    title = 'water', /nodata
  oplot, Ti, We[0, *], color = '0000FF'xl, thick = 2
  oplot, Ti, We[1, *], color = 'FF0000'xl, thick = 2
  oplot, Ti, we[2, *], color = '00FF00'xl, thick = 2

  cor_x = [0.65, 0.70, 0.75]
  cor_y = [0.86, 0.81, 0.76]
  cor_data = convert_coord(cor_x, cor_y[0], /normal, /to_data)
  oplot, [cor_data[0, 0], cor_data[0, 1]], $
    [cor_data[1, 0], cor_data[1, 1]], color = '0000FF'xl
  cor_data = convert_coord(cor_x, cor_y[1], /normal, /to_data)
  oplot, [cor_data[0, 0], cor_data[0, 1]], $
    [cor_data[1, 0], cor_data[1, 1]], color = 'FF0000'xl
  cor_data = convert_coord(cor_x, cor_y[2], /normal, /to_data)
  oplot, [cor_data[0, 0], cor_data[0, 1]], $
    [cor_data[1, 0], cor_data[1, 1]], color = '00FF00'xl

  xyouts, 0.5, 0.85, 'up', /normal, color = '0000FF'xl
  xyouts, 0.5, 0.80, 'middle', /normal, color = 'FF0000'xl
  xyouts, 0.5, 0.75, 'down', /normal, color = '00FF00'xl
  
  
  
  
end