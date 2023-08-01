using DSP: conv
using Images, LinearAlgebra

# get an image of an insect of other camouflage animal

img = Images.load("/home/clark/CDCMX/images/chameleon.jpg")

# just pulling this straight from image tool box
function getCommonKernels()
    convdict = Dict()
    convdict[:EdgeTop] = [1 1 1;0 0 0; -1 -1 -1]
    convdict[:Identity] = [0 0 0;0 1 0;0 0 0]
    convdict[:Edges] = [0 1 0;1 -4 1;0 1 0]
    return convdict
end

convdict = getCommonKernels()
edgedetector = convdict[:Edges]

# Let's get our channels
ch = channelview(img);
rc=ch[1,:,:]
gc=ch[2,:,:]
bc=ch[3,:,:]
#check the green channel
Gray.(gc)

#Now let's see the edges 
Gray.(conv(gc,edgedetector))

