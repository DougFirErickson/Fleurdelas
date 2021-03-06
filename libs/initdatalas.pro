; docformat = 'rst'
;+
; This program initializes a structure to read each point data record
; from a .las lidar file.
;
; :Category:
; 	LAS
;
; :Return:
;   The program returns a single structure corresponding to
;   a single data record of a .las file.
;   
;   For more information on the .las lidar data format, see http://www.lasformat.org
;
;	:Uses:
;   InitDataLAS, pData, PointFormat=PointFormat
;
;       PointFormat: Specifies the requested format of the data record.
;
;	:Example:
;		A quick example on how to use this method
;
; :Params:
;    pData: out, required, type=structure
;     This represent the returned structure corresponding to the point format
;
; :Keywords:
;    pointFormat: in, required, type=byte
;     This byte describe the point format
;
; :History:
;   Written by David Streutker, March 2006.
;   Modify by Antoine Cottin, July 2012.
;     - Add support to LAS file point format 4 and 5
;
; :Author:
;   Antoine Cottin
;-
pro initdatalas, pData, pointFormat = pointFormat

compile_opt idl2, logical_predicate

    ; Define the data structure
case 1 of
  
  pointFormat le 5: begin
    pData = {format0,  $
    east    : 0L,  $     ; X data
    north   : 0L,  $     ; Y data
    elev    : 0L,  $     ; Z data
    inten   : 0US, $     ; Intensity
    nReturn : 0B,  $     ; Return number, number of returns, scan direction, edge
    class   : 0B,  $     ; Classification
    angle   : 0B,  $     ; Scan angle
    user    : 0B,  $     ; User data
    source  : 0US  $     ; Point source ID
  }
  end
  
  pointFormat gt 5: begin
    pData = {format0,  $
      east    : 0L,  $            ; X data
      north   : 0L,  $            ; Y data
      elev    : 0L,  $            ; Z data
      inten   : 0US, $            ; Intensity
      nReturn : bytarr(2),  $    ; same as above but with more bits, 16 bits instead of 8 bits
      class   : 0B,  $            ; Classification
      user    : 0B,  $            ; Scan angle
      angle   : 0S,  $            ; User data
      source  : 0US, $            ; Point source ID
      time    : 0.0D $            ; GPS time (mandatory)
    }
    End
  
  Else:
  
endcase


    ; Modifying the point structure in function of the pointFormat

if pointFormat eq 1 then pData = {format1, inherits format0, time:0.0D}    ; GPS time field

if pointFormat eq 2 then pData = {format2, inherits format0, R:0US, G:0US, B:0US}    ; RGB channels values

if pointFormat eq 3 then pData = {format3, inherits format0, time:0.0D, R:0US, G:0US, B:0US}    ; GPS time field & RGB channels values

if pointFormat eq 4 then pData = {format4, inherits format0, time:0.0D, wDescriptorIndex:0B, offsetWaveData:0ULL, wPacketSize:0UL, returnPointWaveLocation:0.0, X:0.0, Y:0.0, Z:0.0 }

if pointFormat eq 5 then begin
  dum = {format3, inherits format0, time:0.0D, R:0US, G:0US, B:0US}    ; GPS time field & RGB channels values
  pData = {format5, inherits format3, wDescriptorIndex:0B, offsetWaveData:0ULL, wPacketSize:0UL, returnPointWaveLocation:0.0, X:0.0, Y:0.0, Z:0.0 }
endif

if pointFormat eq 6 then pData = {format6, inherits format0}

if pointFormat eq 7 then pData = {format7, inherits format0, R:0US, G:0US, B:0US }    ; RGB channels values

if pointFormat eq 8 then pData = {format8, inherits format0, R:0US, G:0US, B:0US, NIR:0US }    ; RGB+NIR channels values

if pointFormat eq 9 then pData = {format9, inherits format0, wDescriptorIndex:0B, offsetWaveData:0ULL, wPacketSize:0UL, returnPointWaveLocation:0.0, X:0.0, Y:0.0, Z:0.0 }

if pointFormat eq 10 then begin
  dum = {format8, inherits format0, R:0US, G:0US, B:0US, NIR:0US }    ; RGB+NIR channels values
  pData = {format10, inherits format8, wDescriptorIndex:0UB, offsetWaveData:0ULL, wPacketSize:0UL, returnPointWaveLocation:0.0, X:0.0, Y:0.0, Z:0.0 }
endif

end