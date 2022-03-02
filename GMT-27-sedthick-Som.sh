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

gmt grdcut GlobSed-v2.nc -R39/70/-27/12 -Gsom_sed.nc

gdalinfo som_sed.nc -stats
# Minimum=8.000, Maximum=8652.404
# Make color palette
# makecpt --help
gmt makecpt -Cturbo.cpt -V -T0/8653/100 > colors.cpt
# -Ic

# Generate a file
ps=Som_Sediments.ps
# Make raster image
gmt grdimage som_sed.nc -Ccolors.cpt -R39/70/-27/12 -JM6i -P -I+a15+ne0.75 -Xc -K > $ps

# Add grid
gmt psbasemap -R -J \
    -Bpx10f5a5 -Bpyg10f5a5 -Bsxg5 -Bsyg5 \
    --MAP_TITLE_OFFSET=0.8c \
    --FONT_TITLE=14p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    -B+t"Sediment thickness in the Somali Sea and Seychelles" -O -K >> $ps
    
# Add shorelines
gmt grdcontour som_sed.nc -R -J -C200 -W0.1p -O -K >> $ps
    
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
    --FONT_LABEL=9p,Helvetica,black \
    --MAP_LABEL_OFFSET=0.1c \
    --FONT_ANNOT_PRIMARY=8p,Helvetica,black \
    -Bg500f250a1000+l"Color scale 'turbo': (Google's Improved Rainbow Colormap for Visualization [0/8653, C=RGB])" \
    -I0.2 -By+lm -O -K >> $ps

# Texts
gmt pstext -R -J -N -O -K \
-F+jTL+f14p,Helvetica,yellow+jLB+a-53 >> $ps << EOF
65.2 -19.0 Mid-Indian Ridge
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f15p,Helvetica,yellow+jLB+a-40 >> $ps << EOF
58.0 7.6 C  a  r  l  s  b  e  r  g
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f15p,Helvetica,yellow+jLB+a-70 >> $ps << EOF
66.0 0.5 R  i  d  g  e
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f16p,Helvetica,white+jLB+a-315 >> $ps << EOF
44.0 -4.8 S o m a l i    S e a
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f14p,Helvetica,white+jLB >> $ps << EOF
41.0 8.0 Ethiopia
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,Helvetica,white+jLB >> $ps << EOF
44.7 -17.5 Madagascar
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f14p,Helvetica,white+jLB+a-315 >> $ps << EOF
42.5 0.2 S o m a l i
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f14p,Helvetica,white+jLB >> $ps << EOF
54.5 -3.4 Seychelles
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,Helvetica,white+jLB >> $ps << EOF
58.0 -6.0 Mascarene
58.0 -7.0 Plateau
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f13p,Helvetica,white+jLB >> $ps << EOF
55.5 -22.3 Réunion
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f13p,Helvetica,white+jLB >> $ps << EOF
57.5 -21.3 Mauritius
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f13p,Helvetica,white+jLB >> $ps << EOF
61.7 -20.7 Rodrigues
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f13p,Helvetica,white+jLB >> $ps << EOF
43.0 -11.2 Comoros
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f13p,Helvetica,white+jLB >> $ps << EOF
45.0 -12.2 Mayotte
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f13p,Helvetica,white+jLB+a-300 >> $ps << EOF
39.5 -21.2 Mozambique Channel
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f13p,Helvetica,white+jLB >> $ps << EOF
47.5 -10.4 Glorioso
47.5 -11.2 Islands
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f13p,Helvetica,white+jLB >> $ps << EOF
54.0 -15.2 Tromelin
EOF

# Add GMT logo
gmt logo -Dx6.2/-3.3+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y13.0c -N -O \
    -F+f12p,Helvetica,black+jLB >> $ps << EOF
-0.3 11.0 GlobSed 5 arc minute grid Version 3 by NOAA World Data Service for Geophysics
EOF

# Convert to image/pdf file using GhostScript
# gmt psconvert Som_Sediments.ps -A1.0c -E720 -Tj -Z
gmt psconvert Som_Sediments.ps -A1.0c -E720 -Tf -Z
