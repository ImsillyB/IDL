openr,lun,'D:\汪梓鑫\星历.txt',/get_lun
data = dblarr(36,29)
readf,lun,data
free_lun, lun

ton = [.6519D-08,.1490D-07,-.5960D-07,-.1192D-06]
ion = [.7782D+05,.3277D+05,-.6554D+05,-.1966D+06]

locat = dblarr(3,4032)
trans = dblarr(3,3)
approx_postion = [-2001264.8792,5408037.6082,2716771.1050]
antenna = -0.046

guancezhan = dblarr(3,1008)
;导入卫星星历文件，构成36列29行的数组
;构建坐标数组
;构建转换矩阵
;定义常量

openr,lun,'D:\汪梓鑫\o文件.txt',/get_lun
aa = dblarr (43974)
readf,lun,aa
free_lun, lun

data_o = dblarr (28, 1008)

a_i = 0
a_n = 0
a_j = 0
a_k = 0
for a_i = 0, 1007 do begin
  a_l = 0
  a_j = 0
  for a_j = 0, 11 do begin
    data_o[a_j,a_i] = aa[a_n+a_j]
  endfor
  a_j = 11
  a_n = a_n+a_j
  a_l = a_l+a_j
  a_k = data_o[7,a_i] - 4
  data_o[7,a_i] = 4
  for a_j = 1, 16 do begin
    data_o[a_l+a_j, a_i] = aa[a_n+a_j+a_k]
  endfor
  a_n = a_n + a_j + a_k * 5
endfor

;读取.o文件，并且创建数组

 GM = 3.9860047e14
 omega_e = 7.292115e-5
 ;定义参数

 ii = 0
 jj = 0
for jj = 0, 3 do begin
 for i = 0 , 1007 do begin
  for ii = 0, 27 do begin
    t1 = julday(data[2,ii],data[3,ii],2000+data[1,ii],data[4,ii],data[5,ii],data[6,ii])-julday(1,6,1980)
    t2 = t1/7-fix(t1/7)
    t = t2*24*3600*7
    
    delta_t = data[7,ii]+data[8,ii]*(t-data[18,ii])+data[9,ii]*(data[18,ii])^2
    if data_o[8+jj,i] eq data[0,ii] then begin
      if data_o[3,i] lt data[4,ii] or data_o[8+jj,i] ne data[0,ii+1] then begin
        locat1 = dblarr(3,1)

        a = (data[17,ii])^2
        ;加速度a计算

        n0 = sqrt(GM / (a ^ 3))
        ;平均角速度

        t1 = julday(data_o[1,i],data_o[2,i],2000+data_o[0,i],data_o[3,i],data_o[4,i],data_o[5,1])-julday(1,6,1980)
        
        ;print, t1
        
        t2 = t1/7-fix(t1/7)
        t = t2*24*3600*7
        tk = t-data[18,ii]
        
        ;print, tk

        if tk gt 302400 then begin
          tk = tk-604800
        endif else begin
          if tk lt -302500 then begin
            tk = tk+604800
          endif
        endelse
        
        tk -= delta_t
        ;计算时间差tk

        n = n0 + data[12,ii]
        Mk = data[13,ii] + n * tk
        
        ;print,n,Mk

        ;计算平角速度和平近点角

        Ek = Mk + 0.01*sin(Mk)
        Ek = Mk + 0.01*sin(Ek)
        Ek = Mk + 0.01*sin(Ek)
        
        ;计算片近点角Ek
        ;print,Ek

        fk1 = (sqrt(1-0.01^2)*sin(Ek))/(cos(Ek)-0.01)
        fk = atan(fk1)
        ;计算真近点角fk
        ;Print,fk

        Phyk = fk+data[24,ii]
        ;计算升交距角
        ;print,Phyk

        delta_uk = data[17,ii]*sin(2*Phyk)+data[14,ii]*cos(2*Phyk)
        delta_rk = data[11,ii]*sin(2*Phyk)+data[23,ii]*cos(2*Phyk)
        delta_ik = data[21,ii]*sin(2*Phyk)+data[9,ii]*cos(2*Phyk)
        ;计算卫星轨道摄动项改正数
        ;print,delta_uk,delta_rk,delta_ik

        rk = a*(1-0.01*cos(Ek))+delta_rk

        ik = data[22,ii]+delta_ik+data[26,ii]*tk

        uk = Phyk + delta_uk
        ;计算卫星轨道参数
        ;print,rk,ik,uk

        gpsday = data[28,ii]*7+julday(1,6,1980)-julday(1,1,2000)
        T = gpsday/36525
        gastweek = 6*3600+41*60+50.5481+8640184.812866*T+0.093104*(T^2)-(6.2e-6)*(T^3)
        omegatoe = data[20,ii]+gastweek
        omega = omegatoe+data[25,ii]*tk
        Lk = data[20,ii]+(data[25,ii]-omega_e)*tk -data[25,ii]*t
;        计算观测瞬间升交点的经度Lk
;        print,Lk

        locat1[0,0] = rk*cos(uk)
        locat1[1,0] = rk*sin(uk)
        locat1[2,0] = 0

        trans[0,0] = cos(Lk)
        trans[0,1] = sin(Lk)
        trans[0,2] = 0
        trans[1,0] = -sin(Lk)*cos(ik)
        trans[1,1] = cos(Lk)*cos(ik)
        trans[1,2] = sin(ik)
        trans[2,0] = sin(Lk)*sin(ik)
        trans[2,1] = -cos(Lk)*sin(ik)
        trans[2,2] = cos(ik)

        locat1 = locat1 # trans

        locat[0,4*i+jj] = locat1[0,0]
        locat[1,4*i+jj] = locat1[0,1]
        locat[2,4*i+jj] = locat1[0,2]

      endif
    endif
  endfor
 endfor
endfor

;print, locat

;计算卫星的坐标

for i = 0, 1007 do begin
;  print, locat[0,3+i*4],locat[0,2+i*4]
  a1 = 2*(locat[0,1+i*4]-locat[0,0+i*4])
  a2 = 2*(locat[0,2+i*4]-locat[0,1+i*4])
  a3 = 2*(locat[0,3+i*4]-locat[0,2+i*4])
  b1 = 2*(locat[1,1+i*4]-locat[1,0+i*4])
  b2 = 2*(locat[1,2+i*4]-locat[1,1+i*4])
  b3 = 2*(locat[1,3+i*4]-locat[1,2+i*4])
  c1 = 2*(locat[2,1+i*4]-locat[2,0+i*4])
  c2 = 2*(locat[2,2+i*4]-locat[2,1+i*4])
  c3 = 2*(locat[2,3+i*4]-locat[2,2+i*4])
  d1 = -(data_o[19,i])^2+(data_o[15,i])^2-(locat[0,1+i*4])^2+(locat[0,0+i*4])^2-(locat[1,1+i*4])^2+(locat[1,0+i*4])^2-(locat[2,1+i*4])^2+(locat[2,0+i*4])^2
  d2 = -(data_o[23,i])^2+(data_o[19,i])^2-(locat[0,2+i*4])^2+(locat[0,1+i*4])^2-(locat[1,2+i*4])^2+(locat[1,1+i*4])^2-(locat[2,2+i*4])^2+(locat[2,1+i*4])^2
  d3 = -(data_o[27,i])^2+(data_o[23,i])^2-(locat[0,3+i*4])^2+(locat[0,2+i*4])^2-(locat[1,3+i*4])^2+(locat[1,2+i*4])^2-(locat[2,3+i*4])^2+(locat[2,2+i*4])^2
   
  abc = a1*b2*c3-a1*c2*b3-b1*a2*c3+b1*c2*a3+c1*a2*b3-c1*b2*a3
  
  guancezhan[0,i] = (b1*c2*d3-b1*c3*d2-c1*b2*d3+c1*d2*b3+d1*b2*c3-d1*c2*b3)/abc
  guancezhan[1,i] = (a1*c2*d3-a1*c3*d2-c1*a2*d3+c1*d2*a3+d1*a2*c3-d1*c2*a3)/abc
  guancezhan[2,i] = (b1*a2*d3-b1*a3*d2-a1*b2*d3+a1*d2*b3+d1*b2*a3-d1*a2*b3)/abc
endfor

;计算观测站的坐标

;print, locat
print, guancezhan
end