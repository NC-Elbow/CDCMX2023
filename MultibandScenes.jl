using MAT, Images, ImageShow, StatsBase
using CSV, DataFrames

#=
downloaded image from 
https://personalpages.manchester.ac.uk/staff/d.h.foster/Hyperspectral_images_of_natural_scenes_04.html
(scene 4)
following instructions on 
https://personalpages.manchester.ac.uk/staff/d.h.foster/Tutorial_HSI2RGB/Tutorial_HSI2RGB.html
and 
https://github.com/JuliaIO/MAT.jl
=#

function getColor(x) 
    if x<380
        clr = "ultraviolet"
    elseif 380 <= x < 450
        clr = "violet"
    elseif 450<=x<485
        clr = "blue"
    elseif 485<=x < 500
        clr = "cyan"
    elseif 500<=x<565
        clr = "green"
    elseif 564<=x<590
        clr= "yellow"
    elseif 590<=x<635
        clr = "orange"
    elseif 635<= x < 750
        clr = "red"
    else
        clr = "infrared"
    end #if
    return clr 
end



function getScene(matpathImage = "/home/clark/CDCMX/scene4/ref_cyflower1bb_reg1.mat", 
    matpathRadiance = "/home/clark/CDCMX/scene4/radiance_by_reflectance_cyflower1.mat")
        
    fileImg = matopen(matpathImage)
    sceneVars = keys(read(fileImg)) 
    fileRad = matopen(matpathRadiance)
    radianceVars = keys(read(fileRad)) 
    #in sceneVars
    #should get "reflectances" from 
    #KeySet for a Dict{String, Any} with 1 entry. Keys:
    #    "reflectances"


    #in radianceVars
    #KeySet for a Dict{String, Any} with 1 entry. Keys:
    #"radiance"

    #=
    It can be a little tricky to manipulate keys here 
    sceneVars has one object which is itself a dictionary.
    sceneVars.dict 
    It's one entry, so to get that single item
    sceneKey = unique(keys(sceneVars.dict))[1]

    =#
    sceneKey = unique(keys(sceneVars.dict))[1]
    fullscene = read(fileImg,sceneKey); #use that semicolon or get a HUGE printout.

    radianceKey = unique(keys(radianceVars.dict))[1]
    radiances = read(fileRad,radianceKey);
    return fullscene, radiances
end



#=
Will will get all the image matrices by the command 
fullscene, radiances = getScene()
You will need to adjust the input to match your local computer
which will look something like this, 
the folder structure will be important depending on whether you use Windows, Apple, or Linux
fullscene, radiances = getScene("/home/me/pictures/ref_cyflower1bb_reg1.mat", 
"/home/me/pictures/radiance_by_reflectance_cyflower1.mat")

=#


function getRadianceDataFrame(radiances::Matrix) #should be of type matrix
    radiance_df = DataFrame(radiances,:auto) #here we're just putting our radiance information into a spreadsheet
    rename!(radiance_df, :x1 => :Wavelength, :x2=>:Intensity)
    colors = getColor.(radiance_df[!,:Wavelength]) #this will simply print the color
    insertcols!(radiance_df,3,"Color"=>colors)
    insertcols!(radiance_df,1,:ChannelNumber => collect(1:size(radiances)[1]))
    return radiance_df
end



function showWavelengthVsIntensity(wavelengths, intensities)
    img=plot(wavelengths, intensities)
    #=
    wavelengths is likely going to be
    the first column of the radiances file
    radiances[:,1]
    
    intensities can be either the second column of the radiances matrix radiances[:,2]
    or we can plot the intensities at a single pixel
    fullscene[x,y,:] at pixel x,y
    try pixel 200, 500
    showWavelengthVsIntensity(radiances[:,1],fullscene[200,500,:])    
    =#
    return img
end

function tuneRange(imgArray;minValue = 0.0, maxValue = 1.0)
    newArray = map(x-> maximum([minValue,x]), imgArray)
    newArray = map(x-> minimum([maxValue,x]), newArray)
    return newArray
end




#=
The next function requires a little explanation.
=#
function getAverageColors(fullscene, radiances)
    radiance_df = getRadianceDataFrame(radiances)
    sceneColors = unique(radiance_df[!,:Color])
    sceneDict = Dict()
    for clr in sceneColors
        tempKey = Symbol(string(clr,"Average"))
        clr_df = filter(row->row[:Color]==clr,radiance_df)
        tempScene = mean(fullscene[:,:,clr_df[!,:ChannelNumber]],dims=3)
        tempScene = reshape(tempScene,size(tempScene)[1:2])
        sceneDict[tempKey] = tuneRange(tempScene)
    end
    return sceneDict
end

function showImageByColorNames(sceneDict;red = "red",green = "green", blue = "blue")
    redchannel = sceneDict[Symbol(string(red,"Average"))]
    greenchannel = sceneDict[Symbol(string(green,"Average"))]
    bluechannel = sceneDict[Symbol(string(blue,"Average"))]
    img = colorview(RGB,redchannel,greenchannel,bluechannel)
    return img
end


function cleanImageForSaving(imgMatrix)
    newMatrix = map(x -> maximum([0,x]),imgMatrix)
    newMatrix = map(x -> minimum([1,x]), newMatrix)
    return newMatrix
end

#=
A new trick I've just learned
to make sure all values are in range, julia will do that with
save(filepath, map(clamp01nan,img))

clamp01(x) is exactly my function tuneRange
clamp01nan(x) sets all NaN to 0.
=#
