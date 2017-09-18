pro spectra_processing
;对光谱文件进行批处理，包括断点校正，平滑和光谱指标计算
;
  work_dir = dialog_pickfile(path = 'D:\汪梓鑫\实验报告\遥感综合实验\第一组\第一组',/directory)
  cd, work_dir
  fns = file_search('*.sed', count=fnums)

;结果数组
;

  nl = file_lines(fns[0])
  ref_processed = fltarr(fnums, nl)  ;预处理后的反射率


  for i = 0, fnums - 1 do begin
    data = fltarr(2, nl)
    openr, lun, fns[i], /get_lun
    readf, lun, data
    free_lun, lun
    wv = data[0, *]
    ref = data[1, *]

    ref_processed[i, *] = smooth(ref, 5)
    
    plot, wv, ref, xtitle = 'Wavelenth(nm)', ytitle = 'Reflectance', $
      xrange = [200, max(wv)], xstyle = 1, ystyle = 16, $
      color = '000000'xl, background = 'FFFFFF'xl, /nodata
    oplot, wv, ref, color = '0000FF'xl, linestyle = 2, thick = 1
    oplot, wv, ref_processed[1, *], color = 'FF0000'xl, thick = 2

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

    
    
  
  endfor
end

