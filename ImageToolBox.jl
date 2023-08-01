using Dates, LinearAlgebra
using Plots, CSV, DataFrames
using MAT, Images, ImageShow 
using DSP: conv

#=
Some custom built image processing tools
=#

function getRGBchannels(rgbimg)
    channels = channelview(rgbimg)
    redChannel = channels[1,:,:]
    greenChannel = channels[2,:,:]
    blueChannel = channels[3,:,:]
    return redChannel, greenChannel, blueChannel
end

function symmetricCropImage(img, nRowsToCut, nColsToCut)
    newimg = img[nRowsToCut : end-(nRowsToCut-1), nColsToCut : end - (nColsToCut - 1)]
    return newimg
end

function assymetricCropImage(img, topRow, bottomRow, leftCol, rightCol)
    newimg = img[topRow:bottomRow, leftCol:rightCol]
    return newimg
end

function buildImageByChannels(redchannel, greenchannel, bluechannel)
    nrows, ncols = size(redchannel)
    newimg = []
    for c = 1:ncols
        for r = 1:nrows
            push!(newimg, RGB{Float32}(redchannel[r,c],greenchannel[r,c], bluechannel[r,c]))
        end
    end
    newimg = reshape(newimg, (nrows, ncols))
    return RGB{Float32}.(newimg)
end

function getRGBAchannels(rgbimg)
    channels = channelview(rgbimg)
    redChannel = channels[1,:,:]
    greenChannel = channels[2,:,:]
    blueChannel = channels[3,:,:]
    achannel = channel[4,:,:]
    return redChannel, greenChannel, blueChannel, achannel
end

function buildImageByFourChannels(redchannel, greenchannel, bluechannel, achannel)
    nrows, ncols = size(redchannel)
    newimg = []
    for c = 1:ncols
        for r = 1:nrows
            push!(newimg, RGBA{Float32}(redchannel[r,c],greenchannel[r,c], bluechannel[r,c], achannel[r,c]))
        end
    end
    newimg = reshape(newimg, (nrows, ncols))
    return RGBA{Float32}.(newimg)
end


function getNegativeChannel(channel)
    newchannel = ones(size(channel)) - channel
    return newchannel
end

function showGrayImage(channel)
    newimg = Gray{Float32}.(channel)
    return newimg
end

function showSuperPosedImage(image1, image2, t)
    newimg = (1-t)*image1 + t*image2
end

function showThreeChannel(fullscene,channelOne, channelTwo, channelThree)
    rc = fullscene[:,:,channelOne]
    gc = fullscene[:,:,channelTwo]
    bc = fullscene[:,:,channelThree]
    img = buildImageByChannels(rc,gc,bc)
    return img
end

function superPoseMultipleImages(;weights::Vector,imgDict::Dict)
    img = 0.
    for (wt,key) in enumerate(keys(imgDict))
        img .+= weights[wt] .* imgDict[key]
    end    
end 

function getReducedChannels(fullscene, colorList_df::DataFrame)
    gdf = groupby(coloList_df,:Color)
    newScene = zeros(size(fullscene)[1],size(fullscene)[2],length(gdf))
    channelNames = []
    for (n,grouping) in enumerate(gdf)
        push!(channelNames,gdf[n][1,:Color])
        tempChannel = mean(fullscene[:,:,grouping[!,:Channel]],dims=3)
        newScene[:,:,n] .= tempChannel[:,:,1]
    end 
    return newScene   
end

function showChannelConvolution(channel::Array, convulution::Array = [1 0 -1;1 0 -1;1 0 -1])
    img = Gray.(conv(convolution, channel))
    return img 
end

function getCommonKernels()
    convdict = Dict()
    convdict[:EdgeTop] = [1 1 1;0 0 0; -1 -1 -1]
    convdict[:Identity] = [0 0 0;0 1 0;0 0 0]
    convdict[:Edges] = [0 1 0;1 -4 1;0 1 0]
    return convdict
end

function showColorBlindImage(img, colorBlindMatrix)
    rc,gc,bc = channelview(img)
    img0 = [[rc];[gc];[bc]]
    img1 = colorBlindMatrix*img0
    newRc = img1[1]
    newGc = img1[2]
    newBc = img1[3]
    newImg = colorview(RGB,newRc,newGc,newBc)
    return newImg, newRc, newGc, newBc
end

function prepareImageForSaving(rgbimg)
    r,g,b = channelview(rgbimg)
    r = map(x -> maximum([0,x]),r) #this makes sure we don't have any negative colors
    g = map(x -> maximum([0,x]),g)
    b = map(x -> maximum([0,x]),b)
    r = map(x -> minimum([1,x]),r) #this makes sure we don't have any colors > 1
    g = map(x -> minimum([1,x]),g)
    b = map(x -> minimum([1,x]),b)
    newimg = colorview(RGB,r,g,b)
    # save(filepath, clamp01nan(img))
    return newimg
end

#=
ffmpeg -r 20 -i 1%3d.png -pix_fmt yuv420p test.mp4
=#
