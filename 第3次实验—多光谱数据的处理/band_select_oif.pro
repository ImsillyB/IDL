pro Band_select_OIF

  t1 = systime(1)
  
  fn = dialog_pickfile(title = 'choose RS ', path = 'D:\汪梓鑫\实验报告\遥感综合实验\第三次实验\c\c')
  
  envi_open_file, fn, r_fid = fid
  envi_file_query, fid, ns = ns, nl = nl, nb = nb, dims = dims, $
    data_type = data_type, interleave = interleave, offset = offset
  
  data = make_array(ns, nl, nb, type = data_type)
  for i = 0, nb - 1 do data[*, *, i] = envi_get_data(fid = fid, dims = dims, pos = i)
  
  
  ;**********计算标准差和相关系数*******
  ;
  ;计算各个波段的标准差
  stddev_array = fltarr(nb)
  for i = 0, nb - 1 do stddev_array[i] = stddev(data[*, *, i])
  
  
  ;计算各个波段的相关系数
  cor_array = fltarr(nb, nb)
  for i = 0, nb - 2 do begin
    for j = i + 1, nb - 1 do begin
      cor_array[i, j] = correlate(data[*, *, i], data[*, *, j])
    endfor
  endfor
  
  cor_array = abs(cor_array) ;相关系数的绝对值
  
  ;*************计算任意3个波段组合的OIF**********
  
  ;从nb个波段去除3个波段的所有组合数目
  nums = ceil(factorial(nb) / (factorial(nb - 3) * factorial(3)))
  
  bands = intarr(3, nums) ;记录各个波段组合的3个波段
  OIF = fltarr(nums)      ;用于记录各个波段的OIF值
  
  ;遍历每一种波段组合，计算各个组合的OIF值
  ii = 0L
  for i = 0, nb - 3 do begin
    for j = i + 1, nb - 2 do begin
      for k = j + 1, nb - 1 do begin
        bands[*, ii] = [i, j, k] + 1
        OIF[ii] = total(stddev_array[[i, j, k]]) / ([cor_array[i, j] + cor_array[i, k] + cor_array[j, k]])
        ii = ii + 1       
      endfor
    endfor
  endfor
  
  
  ;*********输出结果**********
  
  
  ;按照OIF值从高到低进行排序
  s = reverse(sort(OIF))
  OIF_sorted = OIF[s]
  bands_sorted = bands[*, s]
  
  ;打印出OIF值最高的10种组合
  for i = 0, 9 do begin
    print,i+1,'b'+string(bands_sorted[*,i], format ='(i3.3)'), $
      OIF_sorted[i], format = '(i4, 3a6, f10.2)'
  endfor
  
  t2 = systime(1)
  
  print, '耗时(分钟):', (t2 - t1)/60
  
end