options(digits=20)
## The MIT License (MIT)
## 
## Copyright (c) 2014 Federal Office of Topography swisstopo, Wabern, CH
## 
## Permission is hereby granted, free of charge, to any person obtaining a copy
##  of this software and associated documentation files (the "Software"), to deal
##  in the Software without restriction, including without limitation the rights
##  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
##  copies of the Software, and to permit persons to whom the Software is
##  furnished to do so, subject to the following conditions:
## 
## The above copyright notice and this permission notice shall be included in
##  all copies or substantial portions of the Software.
## 
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
##  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
##  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
##  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
##  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
##  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
##  THE SOFTWARE.
## 
## 
## Source: http://www.swisstopo.admin.ch/internet/swisstopo/en/home/topics/survey/sys/refsys/projections.html (see PDFs under "Documentation")
## Updated 9 dec 2014
## Please validate your results with NAVREF on-line service: http://www.swisstopo.admin.ch/internet/swisstopo/en/home/apps/calc/navref.html (difference ~ 1-2m)

## Convert WGS lat/long (° dec) to CH y
WGS.to.CH.y <- function(lat, lng){
  ## Converts decimal degrees to sexagesimal seconds
  lat <- DEC.to.SEX(lat)
  lng <- DEC.to.SEX(lng)
  
  ## Auxiliary values (% Bern)
  lat_aux <- (lat - 169028.66)/10000
  lng_aux <- (lng - 26782.5)/10000
  
  ## Process Y
  y <- {600072.37 +
      211455.93 * lng_aux -
      10938.51 * lng_aux * lat_aux -
      0.36 * lng_aux * (lat_aux^2) -
      44.54 * (lng_aux^3)}
  
  return(y)
}

## Convert WGS lat/long (° dec) to CH x
WGS.to.CH.x <- function(lat, lng){
  
  ## Converts decimal degrees to sexagesimal seconds
  lat <- DEC.to.SEX(lat)
  lng <- DEC.to.SEX(lng)
  
  ## Auxiliary values (% Bern)
  lat_aux <- (lat - 169028.66)/10000
  lng_aux <- (lng - 26782.5)/10000
  
  ## Process X
  x <- {200147.07 +
      308807.95 * lat_aux + 
      3745.25 * (lng_aux^2) +
      76.63 * (lat_aux^2) -
      194.56 * (lng_aux^2) * lat_aux +
      119.79 * (lat_aux^3)}
  
  return(x)
}


## Convert CH y/x to WGS lat
CH.to.WGS.lat <- function (y, x){
  
  ## Converts military to civil and  to unit = 1000km
  ## Auxiliary values (% Bern)
  y_aux <- (y - 600000)/1000000
  x_aux <- (x - 200000)/1000000
  
  ## Process lat
  lat <- {16.9023892 +
      3.238272 * x_aux -
      0.270978 * (y_aux^2) -
      0.002528 * (x_aux^2) -
      0.0447   * (y_aux^2) * x_aux -
      0.0140   * (x_aux^3)}
  
  ## Unit 10000" to 1 " and converts seconds to degrees (dec)
  lat <- lat * 100/36
  
  return(lat)  
}

## Convert CH y/x to WGS long
CH.to.WGS.lng <- function (y, x){
  
  ## Converts military to civil and  to unit = 1000km
  ## Auxiliary values (% Bern)
  y_aux <- (y - 600000)/1000000
  x_aux <- (x - 200000)/1000000
  
  ## Process long
  lng <- {2.6779094 +
      4.728982 * y_aux +
      0.791484 * y_aux * x_aux +
      0.1306   * y_aux * (x_aux^2) -
      0.0436   * (y_aux^3)}
  
  ## Unit 10000" to 1 " and converts seconds to degrees (dec)
  lng <- lng * 100/36
  
  return(lng)
}


## Convert decimal degrees to sexagesimal seconds
DEC.to.SEX <- function(angle){
  
  ## Extract DMS
  angle_chr <- as.character(angle)
  deg <- as.numeric(strsplit(angle_chr, "\\.")[[1]][1])
  min <- as.numeric(strsplit(as.character((angle-deg)*60), "\\.")[[1]][1])
  sec <- (((angle-deg)*60) - min) * 60
  
  ## Result in seconds
  return(sec + min*60 + deg*3600)
  
}