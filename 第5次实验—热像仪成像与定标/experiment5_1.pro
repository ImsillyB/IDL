pro experiment5_1

;*******************读取文件************************
  data1 = dblarr(640, 480)
  data1 = pick_file()
  
  data2 = dblarr(640, 480)
  data2 = pick_file()
  
  data3 = dblarr(640, 480)
  data3 = pick_file()
  
  data4 = dblarr(640, 480)
  data4 = pick_file()

  data5 = dblarr(640, 480)
  data5 = pick_file()
  
  data6 = dblarr(640, 480)
  data6 = pick_file()

  tar1 = dblarr(640, 480)
  tar1 = pick_file()
  
  tar2 = dblarr(640, 480)
  tar2 = pick_file()

;*********************创建校正数组*********************

  arr = dblarr(2,6)
  
  arr[1, 0] = average(data1)
  arr[1, 1] = average(data2)
  arr[1, 2] = average(data3)
  arr[1, 3] = average(data4)
  arr[1, 4] = average(data5)
  arr[1, 5] = average(data6)
  
  arr[0, 0] = 25.8
  arr[0, 1] = 30.4
  arr[0, 2] = 35.3
  arr[0, 3] = 40.1
  arr[0, 4] = 49.5
  arr[0, 5] = 59.3
  
;**********************创建校正函数**********************

  k = LadFit(arr[0, *], arr[1, *])
  
;**********************校正*********************
  
  pic1 = dblarr(640, 480)
  pic2 = dblarr(640, 480)
  
  
  pic1 = k[1] * tar1 + k[0]
  pic2 = k[1] * tar2 + k[0]
  
  pic1 = reverse(pic1)
  pic2 = reverse(pic2)
;****************输出图像**********************

  !p.multi = [0, 2, 1, 0, 0]
  tvscl, pic2
  
 ; write_image, 'D:\汪梓鑫\实验报告\遥感综合实验\第5次试验\热像仪数据（王and左）\1.jpg',JPEG, pic1
 ; write_image, 'D:\汪梓鑫\实验报告\遥感综合实验\第5次试验\热像仪数据（王and左）\2.jpg',JPEG, pic2
  
  openw , lun, 'D:\汪梓鑫\实验报告\遥感综合实验\第5次试验\热像仪数据（王and左）\1.txt', /get_lun
  printf, lun, pic1
  free_lun, lun
  
  openw , lun, 'D:\汪梓鑫\实验报告\遥感综合实验\第5次试验\热像仪数据（王and左）\2.txt', /get_lun
  printf, lun, pic2
  free_lun, lun

end



function pick_file
  fn = dialog_pickfile(path = 'D:\汪梓鑫\实验报告\遥感综合实验\第5次试验\热像仪数据（王and左）')
  nb = file_lines(fn)
  data = dblarr(640, nb)
  openr, lun, fn, /get_lun
  readf, lun, data
  free_lun, lun
  return, data
end



function average, data


  sum = 0
  for i = 191, 229 do begin
    for j = 203, 230 do begin
      sum = sum + data[i, j]
    endfor
  endfor
  
  a = sum / ((229 - 191) * (230 - 203))
  
  return, a


end