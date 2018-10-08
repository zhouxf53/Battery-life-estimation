import csv
import numpy as np
import pickle

#reading data
#comma delimiated values
T_mlx2=np.zeros((16,4))
T_mlx=np.zeros((16,4))
T_amb=0
I_all=0
with open('datafile.asc') as BatteryRawData:
    csvReader = csv.reader(BatteryRawData, delimiter=',')
    i=0
    rownum=1
    for row in csvReader:
        if (row): #skip empty line
            #fetch melexis sensor data
            if rownum<=1:
                temp=row
                rownum+=1
            elif rownum==2:
                T_amb=np.dstack((T_amb,row))
                rownum+=1
            elif rownum==3:
                T_mlx2[:,0]=row
                rownum+=1
            elif rownum==4:
                T_mlx2[:,1]=row
                rownum+=1
            elif rownum==5:
                T_mlx2[:,2]=row
                rownum+=1
            elif rownum==6:
                T_mlx2[:,3]=row
                rownum+=1
                T_mlx=np.dstack((T_mlx,T_mlx2))
            elif rownum<=16:
                temp=row
                rownum+=1
            elif rownum==17:
                I_all=np.dstack((I_all,row))
                rownum+=1
            elif rownum==18:
                temp=row
                rownum=1
                i=i+1


T_mlx=T_mlx[:,:,1:]
T_amb=T_amb[:,:,1:]
I_all=I_all[:,:,1:]
total=i
#average the temperature in the interest area
T_mlx_interest=T_mlx[2:11,1:3,:]
T_mlx_mean=np.zeros((1,T_mlx_interest.shape[2]))
for i in range(0,T_mlx_interest.shape[2]):
    T_mlx_mean[:,i]=T_mlx_interest[:,:,i].mean()

T_mlx_mean=np.reshape(T_mlx_mean,(130,T_mlx_interest.shape[2]//130))
T_mlx_charge=T_mlx_mean[0:70,:]
T_mlx_discharge=T_mlx_mean[70:,:]

f = open('store.pckl', 'wb')
pickle.dump(T_mlx_charge, f)
f.close()





