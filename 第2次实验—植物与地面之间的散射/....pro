fn = dialog_pickfile(path='D:\汪梓鑫\实验报告\遥感综合实验\第二次试验')
nb = file_lines(fn)
data = fltarr(3, nb)
openr, lun, fn, /get_lun
readf, lun, data
free_lun, lun

wv = transpose(data[0, *])   ;波长
ref = transpose(data[2, *])  ;反射率

fn = dialog_pickfile(path='D:\汪梓鑫\实验报告\遥感综合实验\第二次试验')
nb = file_lines(fn)
data1 = fltarr(3, nb)
openr, lun, fn, /get_lun
readf, lun, data1
free_lun, lun

ref1 = transpose(data1[2, *])

fn = dialog_pickfile(path='D:\汪梓鑫\实验报告\遥感综合实验\第二次试验')
nb = file_lines(fn)
data2 = fltarr(3, nb)
openr, lun, fn, /get_lun
readf, lun, data2
free_lun, lun

ref2 = transpose(data2[2, *])


ref1 = ref1 + ref2


result = LinFit(ref1, ref, MEASURE_ERRORS=sqrt(abs(ref)))
a = result[0]
b = result[1]

result = POLY_FIT(ref1, ref, 2, measure_error = REPLICATE(0.01, n_elements(ref1)))
l = result[0]
m = result[1]
n = result[2]
;ref = ref/ref1
;************************光谱平滑滤波*****************************

;ref_smoothed = ref
;width = 5
;for i = width/2, nb-1-width/2 do begin
;  ref_smoothed[i] = total(ref[i-width/2:i+width/2])/width
;endfor

;ref1_smoothed = ref1
;width = 5
;for i = width/2, nb-1-width/2 do begin
;  ref1_smoothed[i] = total(ref1[i-width/2:i+width/2])/width
;endfor

;ref2_smoothed = ref2
;width = 5
;for i = width/2, nb-1-width/2 do begin
;  ref2_smoothed[i] = total(ref2[i-width/2:i+width/2])/width
;endfor

;**********************绘制光谱曲线********************************
plot, ref1, ref, xtitle = 'only plant + only ground', ytitle = 'plant + ground', $
  xrange = [min(ref1), max(ref1)], yrange = [0, max(ref)], xstyle = 1, ystyle = 16, $
  color = '000000'xl, background = 'FFFFFF'xl, /nodata
oplot, ref1, ref, color = '0000FF'xl,linestyle = 1, thick = 2
oplot, ref1, a + b * ref1, color = 'FF0000'xl, thick = 2
oplot, ref1, l + m * ref1 + n * ref1 ^ 2, color = '00FF00'xl, thick = 2


cor_x = [0.15, 0.2, 0.25]
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

xyouts, 0.22, 0.85, 'san dian tu ', /normal, color = '0000FF'xl
xyouts, 0.22, 0.80, 'zhi xian ni he', /normal, color = 'FF0000'xl
xyouts, 0.22, 0.75, 'er ci qu xian ni he', /normal, color = '00FF00'xl

end