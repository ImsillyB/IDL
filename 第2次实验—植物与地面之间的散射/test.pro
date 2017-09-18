fn = dialog_pickfile()
nb = file_lines(fn)
data = dblarr(3, nb)
openr, lun, fn, /get_lun
readf, lun, data
free_lun, lun

end