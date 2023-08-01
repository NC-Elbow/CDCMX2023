using Images, LinearAlgebra 
#= 
Here we will go through a simple loop to make a video

Let's start with a very red Oaxaca image
https://www.nomadicmatt.com/travel-blogs/oaxaca/
=#

originalIMG = Images.load("/home/clark/CDCMX/images/oaxaca.jpg")

ch = channelview(originalIMG)
rc=ch[1,:,:]
gc=ch[2,:,:]
bc=ch[3,:,:]

imgMatrix = [[rc];[gc];[bc]];

protanomoly = [0.152286	  1.052583	-0.204868;
               0.114503	  0.786281	 0.099216;		
               -0.003882  -0.048116	 1.051998]

deuteranomaly = [0.367322	0.860646	-0.227968;
                 0.280085	0.672501	0.047413;
                 -0.01182	0.04294	    0.968881]

tritanomoly = [1.255528	  -0.076749	  -0.178779;
				-0.078411  0.930809	   0.147602;
				0.004733   0.691367	   0.3039]

randomMixing = randn(3,3)
randomMixing = randomMixing./sum(randomMixing,dims=2) #make columns sum to 1

pt = protanomoly*imgMatrix;
dt = deuteranomaly*imgMatrix;
tt = tritanomoly*imgMatrix;
rt = randomMixing*imgMatrix; 
ptimg = colorview(RGB,pt[1],pt[2],pt[3])
dtimg = colorview(RGB,dt[1],dt[2],dt[3])
ttimg = colorview(RGB,tt[1],tt[2],tt[3])
rdimg = colorview(RGB,rt[1],rt[2],rt[3])

function showSuperPosedImage(image1, image2, t)
    newimg = (1-t)*image1 + t*image2
end


bigIMG = [originalIMG originalIMG; 
          originalIMG originalIMG]

newIMG = [ptimg dtimg;
          ttimg rdimg]


#=
Let's fade this from our original four images into our color blind landscape 
slowly say with 200 images
=#

for k = 0:200
    tempimg = showSuperPosedImage(bigIMG, newIMG, k/200)
    tempname = string(1000+k,".jpg")[2:end] #gives a three digit counter starting with 000.jpg
    save(string("/home/clark/CDCMX/images/img2scenes/",tempname), tempimg)
end    

#=
now ffmpeg to make a short  video
=#
