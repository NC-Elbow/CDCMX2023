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

protanomaly = [0.152286	  1.052583	-0.204868;
               0.114503	  0.786281	 0.099216;		
               -0.003882  -0.048116	 1.051998]

deuteranomaly = [0.367322	0.860646	-0.227968;
                 0.280085	0.672501	0.047413;
                 -0.01182	0.04294	    0.968881]

tritanomaly = [1.255528	  -0.076749	  -0.178779;
				-0.078411  0.930809	   0.147602;
				0.004733   0.691367	   0.3039]

imgMatriz=[[rojo];[verde];[azul]];                

daltonismo = deuteranomaly*imgMatriz;
tipo2 = colorview(RGB,daltonismo[1],daltonismo[2],daltonismo[3])

function showSuperPosedImage(image1, image2, t)
    newimg = (1-t)*image1 + t*image2
end

newImg = showSuperPosedImage(img, tipo2, 0.8) # 80% daltonismo


