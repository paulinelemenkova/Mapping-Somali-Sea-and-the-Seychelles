#!/bin/sh
# Purpose: shaded relief grid raster map from the GEBCO dataset (here: the Somali Sea and Seychelles, Indian Ocean)
# GMT modules: gmtset, gmtdefaults, grdcut, makecpt, grdimage, psscale, grdcontour, psbasemap, gmtlogo, psconvert

# GMT set up
gmt set FORMAT_GEO_MAP=dddF \
    MAP_FRAME_PEN=dimgray \
    MAP_FRAME_WIDTH=0.1c \
    MAP_TITLE_OFFSET=1c \
    MAP_ANNOT_OFFSET=0.1c \
    MAP_TICK_PEN_PRIMARY=thinner,dimgray \
    MAP_GRID_PEN_PRIMARY=thin,white \
    MAP_GRID_PEN_SECONDARY=thinnest,white \
    FONT_TITLE=12p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY=7p,Helvetica,dimgray \
    FONT_LABEL=7p,Helvetica,dimgray
# Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults

img2grd grav_27.1.img -R39/70/-27/12 -GgravSom.grd -T1 -I1 -E -S0.1 -V

gdalinfo gravSom.grd -stats
# Minimum=-145.066, Maximum=546.361
# Make color palette
# makecpt --help
gmt makecpt -Chaxby.cpt -V -T-100/100/1 > colors.cpt

# Generate a file
ps=Grav_Som.ps
# Make raster image
gmt grdimage gravSom.grd -Ccolors.cpt -R39/70/-27/12 -JM6i -P -I+a15+ne0.75 -Xc -K > $ps

# Add grid
gmt psbasemap -R -J \
    -Bpx10f5a5 -Bpyg10f5a5 -Bsxg5 -Bsyg5 \
    --MAP_TITLE_OFFSET=0.8c \
    --FONT_TITLE=14p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    -B+t"Marine free-air gravity anomaly: Somali Sea and Seychelles" -O -K >> $ps
    
# Add shorelines
gmt grdcontour gravSom.grd -R -J -C30 -W0.1p -O -K >> $ps
    
# Add scale, directional rose
gmt psbasemap -R -J \
    --FONT_LABEL=10p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=8p,Helvetica,black \
    --MAP_LABEL_OFFSET=0.1c \
    -Lx12.7c/-2.5c+c50+w800k+l"Mercator projection. Scale: km"+f \
    -UBL/-5p/-75p -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P \
    -Ia/thinnest,blue -Na -N1/thinner,red -Wthin -Df -O -K >> $ps

# Add legend
gmt psscale -Dg39/-29.5+w15.2c/0.4c+h+o0.0/0i+ml -R -J -Ccolors.cpt \
    --FONT_LABEL=8p,Helvetica,black \
    --MAP_LABEL_OFFSET=0.1c \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,black \
    -Bg10f5a20+l"Color scale 'haxby': Bill Haxby's color scheme for geoid & gravity [C=RGB]" \
    -I0.2 -By+lm -O -K >> $ps

# Texts
gmt pstext -R -J -N -O -K \
-F+jTL+f13p,Helvetica,black+jLB+a-53 -Gwhite@40 >> $ps << EOF
64.7 -20.1 Mid-Indian Ridge
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f13p,Helvetica,black+jLB+a-40 -Gwhite@40 >> $ps << EOF
58.0 7.1 C  a  r  l  s  b  e  r  g
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f13p,Helvetica,black+jLB+a-70 -Gwhite@40 >> $ps << EOF
65.8 0.5 R  i  d  g  e
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f16p,Helvetica,white+jLB+a-307 >> $ps << EOF
44.0 -4.8 S o m a l i    S e a
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f14p,Helvetica,black+jLB -Gwhite@30 >> $ps << EOF
41.0 8.0 Ethiopia
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,Helvetica,black+jLB -Gwhite@30 >> $ps << EOF
44.7 -17.5 Madagascar
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f14p,Helvetica,black+jLB+a-315 >> $ps << EOF
42.5 0.2 S o m a l i
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f14p,Helvetica,black+jLB -Gwhite@30 >> $ps << EOF
54.5 -3.4 Seychelles
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,Times-Roman,black+jLB -Gwhite@30 >> $ps << EOF
58.0 -6.0 Mascarene
58.0 -7.0 Plateau
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f13p,Helvetica,black+jLB -Gwhite@30 >> $ps << EOF
55.5 -22.3 Réunion
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f13p,Helvetica,black+jLB -Gwhite@30 >> $ps << EOF
57.5 -21.3 Mauritius
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f13p,Helvetica,black+jLB -Gwhite@30 >> $ps << EOF
43.0 -11.2 Comoros
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f13p,Helvetica,white+jLB+a-300 >> $ps << EOF
39.5 -21.2 Mozambique Channel
EOF

# Add GMT logo
gmt logo -Dx6.2/-3.3+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y13.0c -N -O \
    -F+f12p,Helvetica,black+jLB >> $ps << EOF
2.5 11.0 Satellite derived gravity grid (CryoSat-2 and Jason-1)
EOF

# Convert to image file using GhostScript
gmt psconvert Grav_Som.ps -A1.0c -E720 -Tj -Z
