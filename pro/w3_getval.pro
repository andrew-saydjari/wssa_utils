;+
; NAME:
;   w3_getval
;
; PURPOSE:
;   return WSSA tile values sampled at list of input sky locations
;
; CALLING SEQUENCE:
;   vals = w3_getval(ra, dec)
;
; INPUTS:
;   ra - input list of RA values, assumed J2000
;   dec - input list of DEC values, assumed J2000
;
; OPTIONAL INPUTS:
;   exten - extension, either as an integer or string, acceptable
;           values depend on release, but for release='dev':
;                0: 'clean'
;                1: 'dirt'
;                2: 'cov'
;                3: 'sfd'
;                4: 'min'
;                5: 'max'
;                6: 'amsk'
;                7: 'omsk'
;                8: 'art'
;
; KEYWORDS:
;   tilepath - directory containing WSSA tile fits files
;   release  - for now 'dev' or '1.0', 'dev' is default
;   large - set for 8k x 8k tiles, default is 3k x 3k
;   mjysr - set for result in MJy/sr, default is W3 DN
;
; OUTPUTS:
;   vals - values at (ra, dec) interpolated off of WSSA tiles
;
; OPTIONAL OUTPUTS:
;   
; EXAMPLES:
;   
; COMMENTS:
;   
; REVISION HISTORY:
;   2013-Aug-19 - Aaron Meisner
;----------------------------------------------------------------------
function w3_getval, ra, dec, exten=exten, tilepath=tilepath, release=release, $
                    large=large, mjysr=mjysr

  if ~keyword_set(exten) then exten = 0
  exten = string_to_ext(exten, release=release)
; ----- don't try to interpolate off of SFD extension
  if exten EQ string_to_ext('sfd') then return, -1

  coord_to_tile, ra, dec, tnum, x=x, y=y
  vals = tile_val_interp(tnum, x, y, exten=exten, tpath=tilepath, $ 
      release=release)

  if n_elements(vals) GT 1 then vals = reform(vals, size(ra, /dim))

  if keyword_set(mjysr) then begin
      par = tile_par_struc(release=release, large=large)
      vals *= float(par.calfac) ; don't convert vals to double
  endif

  return, vals

end
