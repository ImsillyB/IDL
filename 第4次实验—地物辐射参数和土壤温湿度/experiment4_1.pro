pro experiment4_1
  fn = dialog_pickfile(path = 'D:\汪梓鑫\实验报告\遥感综合实验\第4次试验\实验4数据及说明\实验4数据及说明')
  openr, lun, fn, /get_lun
  
  
  nl = file_lines(fn)
  data = strarr(nl)
  readf, lun, data
  
  time = dblarr(3, nl)
  V = fltarr(2, nl)
  T = dblarr(2, nl)
  
  for i = 0, nl - 1 do begin
    tdata = strsplit(data[i], ', ', /extract)
    T[0, i] = float(tdata[4])
    T[1, i] = float(tdata[5])
    t_time = strsplit(tdata[1], ' ', /extract)
    hour = strsplit(t_time[0], ':', /extract)
    time[0, i] = hour[0]
    time[1, i] = hour[1]
    time[2, i] = hour[2]
  endfor
  
  ti = dblarr(nl)
  for i = 0, nl - 1 do begin
    ti[i] = time[0, i] + time[1, i] / 60 + time[2, i] / 3600
  endfor
  
  free_lun, lun
  
  plot, ti, T[1, *], xtitle = 'Time(h)', ytitle = 'temperature', $
    xrange = [min(ti[*]), max(ti[*])], yrange = [19, 40], xstyle = 1, ystyle = 16, $
    color = '000000'xl, background = 'FFFFFF'xl, $
    title = 'temperature', /nodata
  oplot, ti, T[0, *], color = '0000FF'xl, thick = 2
  oplot, ti, T[1, *], color = '00FF00'xl, thick = 2

  cor_x = [0.65, 0.70]
  cor_y = [0.86, 0.81]
  cor_data = convert_coord(cor_x, cor_y[0], /normal, /to_data)
  oplot, [cor_data[0, 0], cor_data[0, 1]], $
    [cor_data[1, 0], cor_data[1, 1]], color = '0000FF'xl
  cor_data = convert_coord(cor_x, cor_y[1], /normal, /to_data)
  oplot, [cor_data[0, 0], cor_data[0, 1]], $
    [cor_data[1,0], cor_data[1, 1]], color = '00FF00'xl


  xyouts, 0.5, 0.85, 'ground', /normal, color = '0000FF'xl
  xyouts, 0.5, 0.80, 'mechine', /normal, color = '00FF00'xl
  
   
  
  
  
  
  
  
end