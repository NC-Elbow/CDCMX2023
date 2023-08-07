using Images

img = Images.load("/home/clark/CDCMX/images/GaliaEjemplo.jpg")

#img = Images.load("C:\\Users\\CIVIL-05\\CdCMx\\nini.jpg")
lineas, columnas = size(img);
println("The size of the original image is ", size(img))

canals = channelview(img); #use the semicolon

println("The full image size is ", size(canals))
rojo = canals[1,:,:]
verde = canals[2,:,:]
azul = canals[3,:,:]

sinazul = colorview(RGB,rojo,verde, zeros(lineas,columnas))
sinverde = colorview(RGB, rojo, zeros(lineas, columnas),azul)
sinrojo = colorview(RGB,zeros(lineas, columnas),verde, azul)
grbimg = colorview(RGB,verde,rojo,azul)

rojoNegativo = 1 .- rojo;
verdeNegativo = 1 .- verde;
azulNegativo = 1 .- azul;
fullGreen = colorview(RGB,rojo,ones(lineas,columnas),azul)

halfGreen = (fullGreen + sinverde)./2

#save("/home/clark/CDCMX/images/lunesSinRojo.png",sinrojo))