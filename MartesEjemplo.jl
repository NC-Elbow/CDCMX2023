using MAT, Images
using CSV, DataFrames
using StatsBase,Images,DSP,MAT

img = Images.load(filepath)

canals = channelview(img)
rojo = canals[1,:,:]
verde = canals[2,:,:]
azul = canals[3,:,:]

function showSuperPosedImage(image1, image2, t)
    newimg = (1-t)*image1 + t*image2
end

imgMatriz = [[rojo];[verde];[azul]];

A = rand(3,3)
aleatorioCanals = A ./ sum(A,dims=2) #make columns sum to 1, easier for saving images

img2 = aleatorioCanals*imgMatriz
img2 = colorview(RGB,img2[1],img2[2],img[3])

#now make the frames 
N = 100 #number of frames

for k=0:N
    tempImg = showSuperPosedImage(img,img2,k/N) #k/N percentage of img2 
    baseName = "C:\\Users\\CIVIL-XX\\Pictures\\CDCMX\\"
    tempName = string(1000+k,".png")[2:end] 
    newName = string(baseName,tempName) #names frames 000.png, 001.png ...
    save(newName,tempImg)
end

#=
navigate to folder containing images 
ffmpeg -r 25 -i %3d.png -pix_fmt yuv420p movieName.avi
=#