breed [viruss virus]
breed [imun_cells imun_cell]
breed [info_cells info_cell]

info_cells-own [
  find?
]

imun_cells-own [
  life
]
patches-own [
  name
  reproductible_virus?
  prod_imun_cells
  memory
  activated_memory?
]

;;On crée nos cellules
to init-simulation
   __clear-all-and-reset-ticks
   initialisation-patches
   create-viruss nb-virus [
    set shape "virus2"
    move-to one-of patches
    set color orange
    set size 1
   ]
   create-imun_cells nb-imun_cells [
    set shape "antibody"
    move-to one-of patches
    set color green
    set life life_immun_cells
    set size 1
   ]
  create-info_cells nb-info_cells [
    set shape "brain4"
    move-to one-of patches
    set color black
    set find? false
    set size 1
   ]
  define_imun_home
end

to define_imun_home
  ask patches with [pcolor < 68 and pcolor > 61] [
    set prod_imun_cells starting_prod_imun_cell
    set memory memory_timer
    set activated_memory? false
  ]
end


;;On crée l'environnement
to initialisation-patches
 import-pcolors "base4.png"
  ask patches [
    ifelse pcolor > 11 and pcolor < 19
    [ set reproductible_virus? true ]
    [ set reproductible_virus? false ]
  ]
end

;;On fais tout ici
to go
  move-imun_cells
  move-info_cells
  move-virus
  reproduce-virus
  transmit-info-reproduce-imun_cells
  reproduce-imun_cells
  update_cells
  update_memory
  send_virus
  tick
end

to send_virus
  if show_memory = true and ticks mod time_recalls = 0 [
    create-viruss nb-virus [
    set shape "virus"
    move-to one-of patches
    set color orange
    set size 1
   ]
  ]
end

to update_cells
  ask imun_cells [
    set life life - 1
    if life = 0 [die]
  ]
end

to update_memory
  ask one-of patches with [ pcolor < 68 and pcolor > 61 ] [
    ifelse activated_memory? = false [
      ask patches with [ pcolor < 68 and pcolor > 61 ] [
        set memory max list (memory - 1) 0
        if memory = 0 [
          set prod_imun_cells max list (prod_imun_cells - round (nb-info_cells / 5)) 0
        ]
      ]
      ][ask patches with [ pcolor < 68 and pcolor > 61 ] [
        set memory memory_timer
        set activated_memory? false
      ]
    ]
  ]
end
to move-virus
  ask viruss with [ [reproductible_virus?] of patch-here != true ] [
    right random 360 ;
    repeat dist-virus [
      let prey one-of imun_cells-here
      if prey != nobody [die]
      if [pcolor] of patch-here != red [forward 1]
    ]
  ]
end

to move-imun_cells
  ask imun_cells [
    right random 360
    repeat dist-imun_cells-basic [
      forward 1
      ;;si bactérie sur le chemin, kill la bactérie
      let all_virus_here viruss-here      ; on en a un? si oui,
      ask all_virus_here [ die ]        ; tue le :)
    ]
  ]
end

to move-info_cells
  ask info_cells [
    repeat dist-imun_cells-basic [
      ifelse find? = true [;; si trouvé rentre
        let home_imun_cells patches with [pcolor < 68 and pcolor > 61]
        let home_imun_cell one-of home_imun_cells
        face home_imun_cell
        forward 1
      ]
      [;;sinon cherche
        right random 360
        forward 1

        let all_virus_here_info viruss-here
        if any? all_virus_here_info [
          set find? true
          set color red
        ]
      ]
    ]
  ]
end

to reproduce-imun_cells
  ask one-of patches with [ pcolor < 68 and pcolor > 61 ][
    if random 1000 < prod_imun_cells [
      repeat ceiling prod_imun_cells / 1000 [
        ask one-of info_cells [
          hatch-imun_cells 1 [
          set shape "antibody"
          move-to one-of patches with [pcolor < 68 and pcolor > 61]
          set color green
          set size 1
          set life life_immun_cells
          ]
        ]
      ]
    ]
  ]
end

to transmit-info-reproduce-imun_cells
  ask info_cells with [find? = true] [
    if pcolor < 68 and pcolor > 61 [
      set find? false
      set color black
      ask patches with [pcolor < 68 and pcolor > 61] [
        set prod_imun_cells prod_imun_cells + addition_of_info_cells_in_prod
        set activated_memory? true
      ]
    ]
  ]
end

to reproduce-virus
  ask patches with [ reproductible_virus? = true] [
    let list_virus_here viruss-here
    if list_virus_here != nobody [
      ask list_virus_here [
        if random 1000 < taux_reproduction_virus * 10 [
          hatch 1 [
            right random 360
            forward dist-virus
          ]
        ]
      ]
    ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
251
10
907
667
-1
-1
8.0
1
10
1
1
1
0
1
1
1
-40
40
-40
40
0
0
1
ticks
30.0

SLIDER
0
103
172
136
nb-virus
nb-virus
0
50
29.0
1
1
NIL
HORIZONTAL

BUTTON
96
55
201
88
NIL
init-simulation
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
0
52
63
85
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
1027
50
1368
200
infections
ticks
nb-individus
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"info_cells" 1.0 0 -16383231 true "" "plot count info_cells"
"virus" 1.0 0 -5298144 true "" "plot count viruss"
"imun_cells" 1.0 0 -13840069 true "" "plot count imun_cells"

SLIDER
0
138
172
171
nb-imun_cells
nb-imun_cells
1
50
29.0
1
1
NIL
HORIZONTAL

SLIDER
0
172
172
205
nb-info_cells
nb-info_cells
0
100
55.0
1
1
NIL
HORIZONTAL

SLIDER
0
236
172
269
dist-virus
dist-virus
0
100
31.0
1
1
NIL
HORIZONTAL

SLIDER
0
269
172
302
dist-imun_cells-basic
dist-imun_cells-basic
0
100
6.0
1
1
NIL
HORIZONTAL

SLIDER
0
433
203
466
taux_reproduction_virus
taux_reproduction_virus
0
10
5.0
0.1
1
(%)
HORIZONTAL

PLOT
1028
221
1228
371
mémoire
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"mémoire" 1.0 0 -2674135 true "" "plot one-of [prod_imun_cells] of patches with [ pcolor < 68 and pcolor > 61]  "

PLOT
1020
395
1373
557
info_cells
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"find=true" 1.0 0 -5298144 true "" "plot count info_cells with [find? = true]"
"find=false" 1.0 0 -13840069 true "" "plot count info_cells with [find? = false]"

SLIDER
0
525
221
558
starting_prod_imun_cell
starting_prod_imun_cell
0
100
0.0
1
1
(déci %)
HORIZONTAL

SLIDER
0
558
208
591
addition_of_info_cells_in_prod
addition_of_info_cells_in_prod
0
100
20.0
1
1
NIL
HORIZONTAL

SLIDER
0
591
172
624
memory_timer
memory_timer
0
10
5.0
1
1
NIL
HORIZONTAL

SLIDER
0
466
172
499
life_immun_cells
life_immun_cells
0
100
51.0
1
1
tick
HORIZONTAL

SWITCH
0
329
131
362
show_memory
show_memory
1
1
-1000

SLIDER
0
362
172
395
time_recalls
time_recalls
200
1000
400.0
100
1
NIL
HORIZONTAL

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

antibody
true
1
Polygon -2674135 true true 150 30 120 45 60 60 60 195 75 240 120 270 150 285 180 270 225 240 240 195 240 60 180 45 150 30
Polygon -16777216 false false 150 30 120 45 60 60 60 195 75 240 120 270 150 285 180 270 225 240 240 195 240 60 180 45 150 30
Polygon -16777216 true false 105 90 135 120 135 210 120 210 120 135 90 105 105 90
Polygon -16777216 true false 210 120 190 142 191 159 210 135 210 120
Polygon -16777216 true false 192 90 162 120 162 210 177 210 177 135 207 105 192 90
Polygon -16777216 true false 90 120 110 142 109 159 90 135 90 120

antibody2
true
1
Polygon -2674135 true true 150 30 120 45 60 60 60 195 75 240 120 270 150 285 180 270 225 240 240 195 240 60 180 45 150 30
Polygon -16777216 false false 150 30 120 45 60 60 60 195 75 240 120 270 150 285 180 270 225 240 240 195 240 60 180 45 150 30
Polygon -16777216 true false 150 210 210 135 214 121 210 108 201 96 188 93 172 93 159 98 150 105 150 210
Polygon -16777216 true false 150 210 90 135 86 121 90 108 99 96 112 93 128 93 141 98 150 105 150 210

brain
true
0
Polygon -2064490 true false 152 247 152 67 158 46 182 43 201 50 209 66 233 66 246 78 256 98 255 119 244 132 261 147 267 163 258 188 242 198 248 210 241 226 224 240 211 233 204 251 191 259 175 261 158 259 151 251 151 242
Polygon -2064490 true false 145 58 145 238 139 259 115 262 96 255 88 239 64 239 51 227 41 207 42 186 53 173 36 158 30 142 39 117 55 107 49 95 56 79 73 65 86 72 93 54 106 46 122 44 139 46 146 54 146 63

brain2
true
0
Circle -2674135 true false 135 86 74
Circle -2674135 true false 153 66 88
Circle -2674135 true false 113 43 102
Circle -2674135 true false 108 166 83
Circle -2064490 true false 77 46 69
Circle -2064490 true false 37 80 72
Circle -2064490 true false 76 80 89
Circle -2064490 true false 45 128 64
Circle -2064490 true false 76 139 84
Circle -2064490 true false 60 173 70
Circle -2064490 true false 115 71 74
Circle -2674135 true false 122 136 61
Circle -2674135 true false 189 102 67
Circle -2674135 true false 169 144 72
Circle -2674135 true false 155 179 63
Polygon -2674135 true false 55 162 59 153 67 145 78 145 76 153 68 152 64 158 61 165 55 164
Polygon -2064490 true false 212 118 221 116 227 118 234 123 235 135 230 136
Polygon -2064490 true false 185 224 194 216 197 207 189 210 185 219 187 224
Polygon -2674135 true false 151 112 143 111 138 103 139 97 144 98 144 105

brain3
true
0
Polygon -16777216 true false 155 261 155 51 166 36 191 28 207 38 210 51 233 57 242 79 244 102 237 114 253 120 261 131 258 153 244 174 232 178 245 204 235 215 219 225 208 225 212 251 198 262 169 268 155 262
Polygon -16777216 true false 144 261 144 51 133 36 108 28 92 38 89 51 66 57 57 79 55 102 62 114 46 120 38 131 41 153 55 174 67 178 54 204 64 215 80 225 91 225 87 251 101 262 130 268 144 262
Polygon -1 true false 110 43 118 43 130 56 131 80 131 93 129 103 118 108 105 115 105 126 112 126 122 120 130 116 129 135 129 152 131 171 131 188 130 205 132 229 131 241 130 251 117 252 111 249 103 237 104 226 107 212 94 210 83 210 75 204 69 198 73 187
Polygon -1 true false 75 178 72 163 64 160 60 154 57 139 56 127 64 126 77 113 76 104 68 93 68 80 74 71 85 65 97 61 99 52 106 47 109 43 99 172 117 186 121 219
Polygon -1 true false 170 53 182 43 195 41 198 54 201 64 213 65 224 76 228 83 228 92 219 106 221 121 243 130 247 135 245 156 235 165 224 169 212 167 204 163 198 155 189 160 188 168 199 178 200 183 192 184
Polygon -1 true false 191 183 179 181 166 175 159 169 162 154 165 112 163 99 164 82 165 61 168 50 173 50 184 72
Polygon -1 true false 200 182 210 180 222 181 231 191 229 203 222 209 215 215 207 215 197 219 202 231 194 254 186 257 171 257 162 256 160 242 173 240 176 225 168 230 163 227 160 211 160 196 161 179 159 168 200 121 183 176 197 179

brain4
true
0
Circle -7500403 true true 86 26 67
Circle -7500403 true true 162 43 95
Circle -7500403 true true 197 108 85
Circle -7500403 true true 162 148 95
Circle -7500403 true true 147 206 67
Polygon -7500403 true true 150 60 150 255 240 165 150 60
Circle -7500403 true true 147 26 67
Circle -7500403 true true 43 43 95
Polygon -7500403 true true 150 45 150 240 60 150 150 45
Circle -7500403 true true 86 206 67
Circle -7500403 true true 43 148 95
Circle -7500403 true true 18 108 85
Circle -1 true false 159 39 42
Circle -1 true false 99 39 42
Circle -1 true false 177 56 67
Circle -1 true false 56 56 67
Circle -1 true false 207 116 67
Circle -1 true false 26 116 67
Circle -1 true false 56 161 67
Circle -1 true false 159 219 42
Circle -1 true false 99 219 42
Circle -1 true false 90 45 60
Circle -1 true false 105 195 30
Circle -1 true false 176 101 67
Polygon -1 true false 135 207 140 238 128 229 129 211
Polygon -1 true false 109 102 120 117 127 118 134 116 142 111 143 195 137 185 127 184 118 186 64 136 82 101 112 107
Polygon -1 true false 158 62 161 88 165 96 171 100 178 106 188 114 174 117 164 112 161 108 162 160 204 165 215 112 159 59
Circle -1 true false 176 161 67
Polygon -7500403 true true 256 191 241 194 232 194 220 192 217 187 218 181 226 180 235 183 249 184 254 193
Polygon -7500403 true true 124 195 116 193 114 190 116 184 122 184 134 188
Polygon -1 true false 164 248 160 234 162 150 204 156 196 238 180 250
Circle -1 true false 167 197 42
Circle -1 true false 93 201 35

virus
true
0
Circle -2674135 true false 33 138 85
Circle -2674135 true false 183 78 85
Circle -2064490 true false 54 54 192
Circle -2674135 true false 63 33 85
Circle -2674135 true false 165 135 30
Circle -2674135 true false 116 206 67

virus2
true
0
Polygon -2674135 true false 207 159 270 177 265 183 211 168 207 157
Polygon -2674135 true false 162 89 185 28 194 34 172 91 160 88
Polygon -2674135 true false 104 106 73 67 83 64 116 101 102 106
Polygon -2674135 true false 166 210 189 266 198 263 176 205 165 213
Polygon -2674135 true false 73 216 98 187 107 203 79 224 73 215
Circle -2064490 true false 75 75 150
Circle -2064490 true false 175 10 30
Circle -2064490 true false 54 39 42
Circle -2064490 true false 255 165 30
Circle -2064490 true false 180 255 30
Circle -2064490 true false 54 204 42
Circle -2674135 true false 126 101 16
Circle -2674135 true false 171 131 33
Circle -2674135 true false 93 148 41
@#$#@#$#@
NetLogo 6.3.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="calcul Scales sensitivity" repetitions="10" runMetricsEveryStep="false">
    <setup>init-simulation</setup>
    <go>pas-simulation</go>
    <timeLimit steps="2500"/>
    <metric>count individus with [infecte?]</metric>
    <enumeratedValueSet variable="nb-individus">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="taux-infectes-init">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dist-max-deplacement">
      <value value="2"/>
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-infection">
      <value value="2"/>
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="proba-infection">
      <value value="0.4"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-perception">
      <value value="5"/>
      <value value="6"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="signature proba_infection_100-2" repetitions="100" runMetricsEveryStep="false">
    <setup>init-simulation</setup>
    <go>pas-simulation</go>
    <timeLimit steps="2500"/>
    <metric>count individus with [infecte? ]</metric>
    <enumeratedValueSet variable="taux-infectes-init">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nb-individus">
      <value value="100"/>
    </enumeratedValueSet>
    <steppedValueSet variable="proba-infection" first="0.1" step="0.01" last="1"/>
    <enumeratedValueSet variable="distance-infection">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-perception">
      <value value="5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dist-max-deplacement">
      <value value="2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="sensitivity2" repetitions="10" runMetricsEveryStep="false">
    <setup>init-simulation</setup>
    <go>pas-simulation</go>
    <timeLimit steps="2500"/>
    <metric>count individus with [infecte?]</metric>
    <enumeratedValueSet variable="nb-individus">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="taux-infectes-init">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dist-max-deplacement">
      <value value="1.5"/>
      <value value="2.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-infection">
      <value value="1.5"/>
      <value value="2.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="proba-infection">
      <value value="0.5"/>
      <value value="0.6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-perception">
      <value value="5"/>
      <value value="6"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="test_lecon" repetitions="10" runMetricsEveryStep="false">
    <setup>init-simulation</setup>
    <go>pas-simulation</go>
    <timeLimit steps="2500"/>
    <metric>count individus with [infecte?]</metric>
    <enumeratedValueSet variable="proba-infection">
      <value value="0.13"/>
      <value value="0.5"/>
    </enumeratedValueSet>
    <steppedValueSet variable="dist-max-deplacement" first="1" step="0.5" last="3"/>
    <enumeratedValueSet variable="nb-individus">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-infection">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="taux-infectes-init">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-perception">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="proba-infection">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dist-max-deplacement">
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nb-individus">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-infection">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="taux-infectes-init">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-perception">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="signature_lecon_proba_infection" repetitions="10" runMetricsEveryStep="false">
    <setup>init-simulation</setup>
    <go>pas-simulation</go>
    <timeLimit steps="1000"/>
    <metric>count individus with [ infecte?]</metric>
    <enumeratedValueSet variable="nb-individus">
      <value value="100"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="taux-infectes-init">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dist-max-deplacement">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-infection">
      <value value="2"/>
    </enumeratedValueSet>
    <steppedValueSet variable="proba-infection" first="0.1" step="0.1" last="1"/>
    <enumeratedValueSet variable="distance-perception">
      <value value="10"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="MAPSCours" repetitions="10" runMetricsEveryStep="false">
    <setup>init-simulation</setup>
    <go>pas-simulation</go>
    <timeLimit steps="2500"/>
    <metric>count individus with [infecte?]</metric>
    <enumeratedValueSet variable="proba-infection">
      <value value="0.4"/>
      <value value="0.8"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="taux-infectes-init">
      <value value="0.01"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-perception">
      <value value="5"/>
      <value value="6"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="dist-max-deplacement">
      <value value="2"/>
      <value value="3"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="distance-infection">
      <value value="2"/>
      <value value="3"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
