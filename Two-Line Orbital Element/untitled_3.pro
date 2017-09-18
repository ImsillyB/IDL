openr,lun,'D:\汪梓鑫\o文件.txt',/get_lun
data = dblarr (43974)
readf,lun,data
free_lun, lun


data1=dblarr(12,1008)
data2=dblarr(4,5000)
i=0
while i le 1007 do begin
  t=7
  data1[0,i]=data[t-7]
  data1[1,i]=data[t-6]
  data1[2,i]=data[t-5]
  data1[3,i]=data[t-4]
  data1[4,i]=data[t-3]
  data1[5,i]=data[t-2]
  data1[6,i]=data[t-1]
  data1[7,i]=data[t]
  data1[8,i]=data[t+1]
  data1[9,i]=data[t+2]
  data1[10,i]=data[t+3]
  data1[11,i]=data[t+4]

  k=0
  while k le 4 do begin
    j=t+data[t]
    data2[0,i*4+k]=data[j+1+4*k]
    data2[1,i*4+k]=data[j+2+4*k]
    data2[2,i*4+k]=data[j+3+4*k]
    data2[3,i*4+k]=data[j+4+4*k]
    k=k+1
  endwhile

  t=t+data[t]*5+8
  i=i+1
endwhile
print,data1

end