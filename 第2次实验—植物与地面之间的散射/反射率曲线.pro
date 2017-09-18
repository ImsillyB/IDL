fn = dialog_pickfile(path='D:\汪梓鑫\实验报告\遥感综合实验\第二次试验')
nb = file_lines(fn)
data = fltarr(3, nb)
openr, lun, fn, /get_lun
readf, lun, data
free_lun, lun




wv = transpose(data[0, *])   ;波长
ref = transpose(data[2, *])  ;反射强度

;************************光谱平滑滤波*****************************

ref_smoothed = ref
width = 5
for i = width/2, nb-1-width/2 do begin
  ref_smoothed[i] = total(ref[i-width/2:i+width/2])/width
endfor

;**********************绘制光谱曲线********************************
plot, wv, ref, xtitle = 'Wavelenth(nm)', ytitle = 'Reflectance', $
  xrange = [200, 1200], xstyle = 1, ystyle = 16, $
  color = '000000'xl, background = 'FFFFFF'xl, /nodata
oplot, wv, ref, color = '0000FF'xl, linestyle = 2, thick = 1
oplot, wv, ref_smoothed, color = 'FF0000'xl, thick = 2

cor_x = [0.15, 0.2]
cor_y = [0.86, 0.81]
cor_data = convert_coord(cor_x, cor_y[0], /normal, /to_data)
oplot, [cor_data[0, 0], cor_data[0, 1]], $
  [cor_data[1, 0], cor_data[1, 1]], color = '0000FF'xl
cor_data = convert_coord(cor_x, cor_y[1], /normal, /to_data)
oplot, [cor_data[0, 0], cor_data[0, 1]], $
  [cor_data[1, 0], cor_data[1, 1]], color = 'FF0000'xl

xyouts, 0.22, 0.85, 'Original spectra', /normal, color = '0000FF'xl
xyouts, 0.22, 0.80, 'Smoothed spectra', /normal, color = 'FF0000'xl

end