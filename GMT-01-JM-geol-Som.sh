#!/bin/sh
# Purpose: shaded relief grid raster map from the GEBCO dataset (here: the Somali Sea and the Seychelles, Indian Ocean)
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

grdcut GEBCO_2019.nc -R39/70/-27/12 -Gsom_relief.nc
#grdcut ETOPO1_Ice_g_gmt4.grd -R39/70/-27/12 -Gsom_relief.nc

gdalinfo som_relief.nc -stats
# Minimum=-6538.000, Maximum=2805.000
# Make color palette
# makecpt --help
gmt makecpt -Ctopo.cpt -V -T-6857/3206 > myocean.cpt


# Generate a file
ps=Geol_Som.ps
# Make raster image
gmt grdimage som_relief.nc -Cmyocean.cpt -R39/70/-27/12 -JM6i -P -I+a15+ne0.75 -Xc -K > $ps

# Add grid
gmt psbasemap -R -J \
    -Bpx10f5a5 -Bpyg10f5a5 -Bsxg5 -Bsyg5 \
    --MAP_TITLE_OFFSET=0.8c \
    --FONT_TITLE=14p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=7p,Helvetica,black \
    -B+t"Geologic map of the Somali Sea and the Seychelles, Indian Ocean" -O -K >> $ps
    
# Add shorelines
gmt grdcontour som_relief.nc -R -J -C800 -W0.1p -O -K >> $ps
    
# Add scale, directional rose
gmt psbasemap -R -J \
    --FONT_LABEL=10p,Helvetica,black \
    --FONT_ANNOT_PRIMARY=8p,Helvetica,black \
    --MAP_LABEL_OFFSET=0.1c \
    -Lx12.7c/-4.1c+c50+w800k+l"Mercator projection. Scale: km"+f \
    -UBL/-5p/-115p -O -K >> $ps

# Add coastlines, borders, rivers
gmt pscoast -R -J -P \
    -Ia/thinnest,blue -Na -N1/thinner,red -W0.1p -Df -O -K >> $ps

# Add legend
gmt psscale -Dg39/-29.5+w15.2c/0.4c+h+o0.0/0i+ml -R -J -Cmyocean.cpt \
    --FONT_LABEL=8p,Helvetica,black \
    --MAP_LABEL_OFFSET=0.1c \
    --FONT_ANNOT_PRIMARY=6p,Helvetica,black \
    -Baf+l"Color scale 'topo': Sandwell/Anderson colors for topography [R=-6538/2805, H=0, C=HSV]" \
    -I0.2 -By+lm -O -K >> $ps

gmt psxy -R -J ridge.gmt -Sf0.5c/0.15c+l+t -Wthin,yellow -Gpurple -O -K >> $ps
gmt psxy -R -J TP_Indian.txt -L -Wthickest,red -O -K >> $ps
gmt psxy -R -J TP_Australian.txt -L -Wthickest,red -O -K >> $ps
#gmt psxy -R -J TP_African.txt -L -Wthickest,red -O -K >> $ps

gmt psxy -R -J ophiolites.gmt -Sc0.2c -Ggoldenrod1 -W0.08 -O -K >> $ps
gmt psxy -R -J LIPS.2011.gmt -L -Gpink1@50 -Wthinnest,red -O -K >> $ps

# Add tectonic slab contours
gmt psxy -R -J GSFML_SF_FZ_KM.gmt -Wthick,yellow -O -K >> $ps
gmt psxy -R -J GSFML_SF_FZ_RM.gmt -Wthick,gold1 -O -K >> $ps
gmt psxy -R -J transform.gmt -Sc0.05c -Ggreen -Wthick,yellow -O -K >> $ps
gmt psmeca -R CMT.txt -J -Sd0.4/2/u -Gred -L0.1p -O -K >> $ps
gmt psmeca -R CMT.txt -J -Sc0.1/2/u -Gred -L0.1p -Fa/5p/it \
    -Fepurple -Fgmagenta -Ft -W0.1p -Fz -Eyellow -O -K >> $ps
gmt psmeca CMT.txt -R -J -Sd0.5/2/u -Gred -L0.1p -Fa/5p/it \
    -Fepurple -Fgmagenta -Ft -F+f8p,Times-Roman,yellow+jLB \
    -W0.1p -Fz -Ewhite -O -K >> $ps

# Texts
gmt pstext -R -J -N -O -K \
-F+f14p,Helvetica,gold+jLB -Gdimgray@30>> $ps << EOF
47 5.2 A F R I C A N   P L A T E
63 10.5 INDIAN
63 9.0 PLATE
EOF
gmt pstext -R -J -N -O -K \
-F+f14p,Helvetica,gold+jLB+a-270 -Gdimgray@30>> $ps << EOF
69 -19.5 AUSTRALIAN PLATE
EOF
#
gmt pstext -R -J -N -O -K \
-F+jTL+f14p,Helvetica,brown+jLB+a-53 >> $ps << EOF
65.2 -19.5 Mid-Indian Ridge
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
-F+jTL+f16p,Helvetica,white+jLB+a-315 >> $ps << EOF
47.0 -3.8 B a s i n
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f14p,Helvetica,brown+jLB >> $ps << EOF
42.0 6.0 Ethiopia
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,Helvetica,black+jLB -Gwhite@30 >> $ps << EOF
44.7 -17.5 Madagascar
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f14p,Helvetica,brown+jLB+a-315 >> $ps << EOF
42.5 0.2 S o m a l i
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f14p,Helvetica,white+jLB >> $ps << EOF
54.5 -3.4 Seychelles
EOF
gmt pstext -R -J -N -O -K \
-F+jTL+f12p,Times-Roman,black+jLB -Gwhite@30 >> $ps << EOF
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
62.2 -20.7 Rodrigues
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
-F+jTL+f13p,Helvetica,brown+jLB+a-300 >> $ps << EOF
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

# Add legend
gmt pslegend -R -J -Dx1.5/-3.4+w15.0c+o-1.5/0.1c \
    -F+pthin+ithinner+gwhite \
    --FONT=9p,Helvetica,black -O -K << FIN >> $ps
N 3
S 0.3c t 0.2c red 0.02c 1.0c Volcanoes
S 0.3c - 0.9c - 0.5p,yellow 1.0c Fracture zones
S 0.3c - 0.8c - 0.5p,red 1.0c Ridge
S 0.3c - 0.9c - 1.0p,red 1.0c Tectonic plate boundary
S 0.3c - 0.9c - 1.0p,yellow 1.0c Transform fault
S 0.3c r 0.5c pink1@50 0.01c 1.0c Large igneous province
FIN

# Add GMT logo
gmt logo -Dx6.2/-4.8+o0.1i/0.1i+w2c -O -K >> $ps

# Add subtitle
gmt pstext -R0/10/0/15 -JX10/10 -X0.5c -Y13.0c -N -O \
    -F+f12p,Helvetica,black+jLB >> $ps << EOF
2.5 11.0 GEBCO 15 arc sec resolution global terrain model grid
EOF

# Convert to image file using GhostScript
gmt psconvert Geol_Som.ps -A2.5c -E720 -Tj -Z
