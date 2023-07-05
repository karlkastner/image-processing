
file = '/home/pia/10791437_8747_DBS012261/dicom/00000001/00000002/00000000'
img=dicomread(file);
img=double(img);
img=uint8(255*img/max(img(:)));
imshow(img);
imwrite(img,[file,'.jpg']);

