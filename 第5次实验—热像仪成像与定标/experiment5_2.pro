pro experiment5_2
  fn = dialog_pickfile(path = 'D:\汪梓鑫\实验报告\遥感综合实验\第5次试验\热像仪数据（王and左）\1.txt')
  data1 = dblarr(640, 480)
  openr, lun, fn, /get_lun
  readf, lun, data1
  free_lun, lun
  
  fn = dialog_pickfile(path = 'D:\汪梓鑫\实验报告\遥感综合实验\第5次试验\热像仪数据（王and左）\IR004860.txt')
  data2 = dblarr(640, 480)
  openr, lun, fn, /get_lun
  readf, lun, data2
  free_lun, lun
  
  fn = dialog_pickfile(path = 'D:\汪梓鑫\实验报告\遥感综合实验\第5次试验\热像仪数据（王and左）\2.txt')
  data3 = dblarr(640, 480)
  openr, lun, fn, /get_lun
  readf, lun, data3
  free_lun, lun
  
  fn = dialog_pickfile(path = 'D:\汪梓鑫\实验报告\遥感综合实验\第5次试验\热像仪数据（王and左）\IR004860.txt')
  data4 = dblarr(640, 480)
  openr, lun, fn, /get_lun
  readf, lun, data4
  free_lun, lun
  
  a1 = dblarr(640, 480)
  a2 = dblarr(640, 480)
  
  for i = 0, 639 do begin
    for j = 0, 479 do begin
      a1[i, j] = (data1[i, j] - data2[i, j]) / data2[i, j]
    endfor
  endfor
  
  for i = 0, 639 do begin
    for j = 0, 479 do begin
      a2[i, j] = (data3[i, j] - data4[i, j]) / data4[i, j]
    endfor
  endfor

  openw , lun, 'D:\汪梓鑫\实验报告\遥感综合实验\第5次试验\热像仪数据（王and左）\误差1.txt', /get_lun
  printf, lun, a1
  free_lun, lun
  
  openw , lun, 'D:\汪梓鑫\实验报告\遥感综合实验\第5次试验\热像仪数据（王and左）\误差2.txt', /get_lun
  printf, lun, a2
  free_lun, lun



end