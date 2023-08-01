import .ImageTools as tb

img = Images.load("/home/clark/CDCMX/images/SmokyMountains.jpg")

ch = channelview(img)
rc=ch[1,:,:]
gc=ch[2,:,:]
bc=ch[3,:,:]

#=
Now let's switch some channels
    =#

imgBGR = colorview(RGB,bc,gc,rc)

rows,cols = size(rc);
#cols > rows
squareimage = img[:,div(cols-rows,2):div(cols-rows,2)+rows-1]
sqch = channelview(squareimage)
src = sqch[1,:,:]
sgc = sqch[2,:,:]
sbc = sqch[3,:,:]

#flip to the blue channel as transpose...
transposesqaure = colorview(RGB,src,sgc,sbc')

#Let's look at a negative red channel
negred = colorview(RGB,1 .- rc, gc,bc)

fullneg = colorview(RGB,1 .- rc, 1 .- gc, 1 .-bc)



#Let's let the red channel be the intensity
redIntensity = colorview(RGBA,rc,gc,bc,rc)

randomIntensity = colorview(RGBA,rc,gc,bc,rand(Float64,size(rc)))