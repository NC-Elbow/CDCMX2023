import .ImageTools as tb 
using Images
#=
Let's give an example of building a colorblind image from a colorful image

Check here and download a free image
https://www.pexels.com/search/colorful%20background/
=#

img = Images.load("/home/clark/CDCMX/images/pexels-alexander-grey-1566909.jpg")

ch = channelview(img);
rc = ch[1,:,:]
gc = ch[2,:,:]
bc = ch[3,:,:]


#Just check what the individual channels look like

grayimg = Gray.(rc) #look at red channel in gray scale

imgMatrix = [[rc];[gc];[bc]] #make this into a matrix of matrices


protanomoly = [0.152286	  1.052583	-0.204868;
               0.114503	  0.786281	 0.099216;		
               -0.003882  -0.048116	 1.051998]

deuteranomaly = [0.367322	0.860646	-0.227968;
                 0.280085	0.672501	0.047413;
                 -0.01182	0.04294	    0.968881]

tritanomoly = [1.255528	  -0.076749	  -0.178779;
				-0.078411  0.930809	   0.147602;
				0.004733   0.691367	   0.3039]

pt = protanomoly*imgMatrix;
dt = deuteranomaly*imgMatrix;
tt = tritanomoly*imgMatrix;

ptimg = colorview(RGB,pt[1],pt[2],pt[3])
dtimg = colorview(RGB,dt[1],dt[2],dt[3])
ttimg = colorview(RGB,tt[1],tt[2],tt[3])