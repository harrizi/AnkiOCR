#!/bin/sh

# From https://yui-spl2.medium.com/making-tesseract-portable-in-macos-with-runtime-linking-f25c8159727a

if ! command -v tesseract &> /dev/null
then
    brew install tesseract
fi

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

mkdir tesseract_standalone
cp -r /usr/local/Cellar/tesseract tesseract_standalone/
cp -r /usr/local/Cellar/leptonica tesseract_standalone/
cp -r /usr/local/Cellar/libpng tesseract_standalone/
cp -r /usr/local/Cellar/libtiff tesseract_standalone/
cp -r /usr/local/Cellar/webp tesseract_standalone/
cp -r /usr/local/Cellar/openjpeg tesseract_standalone/
cp -r /usr/local/Cellar/jpeg tesseract_standalone/
cp -r /usr/local/Cellar/giflib tesseract_standalone/

cd tesseract_standalone/tesseract/4.1.1/bin/
install_name_tool -change /usr/local/opt/leptonica/lib/liblept.5.dylib ../../../leptonica/1.81.1/lib/liblept.5.dylib tesseract
install_name_tool -change /usr/local/Cellar/tesseract/4.1.1/lib/libtesseract.4.dylib @executable_path/../lib/libtesseract.4.dylib tesseract
install_name_tool -change /usr/local/opt/leptonica/lib/liblept.5.dylib ../../../leptonica/1.81.1/lib/liblept.5.dylib ../../../tesseract/4.1.1/lib/libtesseract.4.dylib
install_name_tool -change /usr/local/opt/libpng/lib/libpng16.16.dylib ../../../libpng/1.6.37/lib/libpng16.16.dylib ../../../leptonica/1.81.1/lib/liblept.5.dylib
install_name_tool -change /usr/local/opt/jpeg/lib/libjpeg.9.dylib ../../../jpeg/9d/lib/libjpeg.9.dylib ../../../leptonica/1.81.1/lib/liblept.5.dylib
install_name_tool -change /usr/local/opt/giflib/lib/libgif.7.dylib ../../../giflib/5.2.1/lib/libgif.7.dylib ../../../leptonica/1.81.1/lib/liblept.5.dylib
install_name_tool -change /usr/local/opt/giflib/lib/libgif.dylib ../../../giflib/5.2.1/lib/libgif.dylib ../../../leptonica/1.81.1/lib/liblept.5.dylib 
install_name_tool -change /usr/local/opt/libtiff/lib/libtiff.5.dylib ../../../libtiff/4.3.0/lib/libtiff.5.dylib ../../../leptonica/1.81.1/lib/liblept.5.dylib

# WebP
install_name_tool -change /usr/local/opt/webp/lib/libwebp.7.dylib ../../../webp/1.2.1/lib/libwebp.7.dylib ../../../leptonica/1.81.1/lib/liblept.5.dylib
install_name_tool -change /usr/local/opt/webp/lib/libwebpmux.3.dylib ../../../webp/1.2.1/lib/libwebpmux.3.dylib ../../../leptonica/1.81.1/lib/liblept.5.dylib

# Openjpeg
install_name_tool -change /usr/local/opt/openjpeg/lib/libopenjp2.7.dylib ../../../openjpeg/2.4.0/lib/libopenjp2.2.4.0.dylib ../../../leptonica/1.81.1/lib/liblept.5.dylib
install_name_tool -change /usr/local/opt/jpeg/lib/libjpeg.9.dylib ../../../jpeg/9d/lib/libjpeg.9.dylib ../../../libtiff/4.3.0/lib/libtiff.5.dylib
