function out = callcomsol;

% Created by Rodrigo Benevides - aug/2019 

import com.comsol.model.*
import com.comsol.model.util.*

model = ModelUtil.create('Model');

model.modelPath('C:\Users\Claus\Documents\Phonon guiding\optimization');

model.label('c-shape-Qopt-genalg.mph');

model.comments(['Untitled\n\n']);

% ------ Generate geometry parameters for mirror and defect ----- %

numcells_defect = 8;
larmvec = defect_generate(270,207,numcells_defect); %[257.4,244.8,232.2,219.6,207]
wpadvec = defect_generate(210,177,numcells_defect); %[203.4,196.8,190.2,183.6,177];
wcellvec = zeros(1,numcells_defect)+500;
hcellvec = zeros(1,numcells_defect)+795;
lwavvec = defect_generate(185,170,numcells_defect); % zeros(1,numcells_defect)+171; % 
warmvec = zeros(1,numcells_defect)+110; %defect_generate(135,110,numcells_defect); %
lpadvec =  zeros(1,numcells_defect)+137; %defect_generate(155,125,numcells_defect); %

% Mirror waveguide
p.mirror.w_cell = 500e-9;
p.mirror.h_cell = 795e-9;
p.mirror.l_arm = 270*1e-9;
p.mirror.w_arm = 110e-9;
p.mirror.l_pad = 137e-9;
p.mirror.w_pad = 210*1e-9;
p.mirror.th = 250e-9;
p.mirror.l_wav = 185e-9;

p.mirror.ncells = 8;

% Mirror snowflake
p.mirror.snow.w_cell = 500e-9;
p.mirror.snow.r_snow = 107e-9;
p.mirror.snow.w_snow = 77e-9;
p.mirror.snow.l_snow = 205e-9;
p.mirror.snow.hc_snow = 442e-9;

p.mirror.snow.nrows = 7;

% Defect waveguide  
p.defect.h_cell = hcellvec*1e-9;
p.defect.w_cell = wcellvec*1e-9;
p.defect.l_arm = larmvec*1e-9;
p.defect.w_arm = warmvec*1e-9;
p.defect.l_pad = lpadvec*1e-9;
p.defect.w_pad = wpadvec*1e-9;
p.defect.th = 250*1e-9;
p.defect.l_wav = lwavvec*1e-9;

p.defect.ncells = numcells_defect;

% Defect snowflake
p.defect.snow.w_cell = 500;
p.defect.snow.r_snow = 107;
p.defect.snow.w_snow = 77;
p.defect.snow.l_snow = 205;
p.defect.snow.hc_snow = 442;


% ------ Creating geometry ------ %

model.component.create('comp1', true);
model.component('comp1').geom.create('geom1', 3);

model.component('comp1').geom('geom1').create('wp1', 'WorkPlane');
model.component('comp1').geom('geom1').feature('wp1').set('unite', true);

% Mirror c-shape
model.component('comp1').geom('geom1').feature('wp1').geom.create('pol1', 'Polygon');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('pol1').set('source', 'table');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('pol1').set('table', {num2str(-p.mirror.w_arm-p.mirror.w_pad/2) num2str(p.mirror.l_wav/2);  ...
num2str(-p.mirror.w_arm-p.mirror.w_pad/2) num2str(p.mirror.l_wav/2+p.mirror.l_arm);  ...
num2str(p.mirror.w_arm+p.mirror.w_pad/2) num2str(p.mirror.l_wav/2+p.mirror.l_arm);  ...
num2str(p.mirror.w_arm+p.mirror.w_pad/2) num2str(p.mirror.l_wav/2);  ...
num2str(p.mirror.w_pad/2) num2str(p.mirror.l_wav/2);  ...
num2str(p.mirror.w_pad/2) num2str(p.mirror.l_wav/2+p.mirror.l_pad);  ...
num2str(-p.mirror.w_pad/2) num2str(p.mirror.l_wav/2+p.mirror.l_pad);  ...
num2str(-p.mirror.w_pad/2) num2str(p.mirror.l_wav/2);  ...
num2str(-p.mirror.w_arm-p.mirror.w_pad/2) num2str(p.mirror.l_wav/2)});

idx_array = 1;
model.component('comp1').geom('geom1').feature('wp1').geom.create(strcat('arr',num2str(idx_array)), 'Array');
model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('arr',num2str(idx_array))).set('fullsize', [p.mirror.ncells 1]);
model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('arr',num2str(idx_array))).set('displ', {num2str(p.mirror.w_cell) '0'});
model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('arr',num2str(idx_array))).selection('input').set({'pol1'});

% Defect c-shapes

w_displac = p.mirror.ncells*p.mirror.w_cell;
for ii = 1:p.defect.ncells
    model.component('comp1').geom('geom1').feature('wp1').geom.create(strcat('pol',num2str(ii+1)), 'Polygon');
    model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('pol',num2str(ii+1))).set('source', 'table');
    model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('pol',num2str(ii+1))).set('table', {num2str(-p.defect.w_arm(ii)-p.defect.w_pad(ii)/2) num2str(p.defect.l_wav(ii)/2);  ...
        num2str(-p.defect.w_arm(ii)-p.defect.w_pad(ii)/2) num2str(p.defect.l_wav(ii)/2+p.defect.l_arm(ii));  ...
        num2str(p.defect.w_arm(ii)+p.defect.w_pad(ii)/2) num2str(p.defect.l_wav(ii)/2+p.defect.l_arm(ii));  ...
        num2str(p.defect.w_arm(ii)+p.defect.w_pad(ii)/2) num2str(p.defect.l_wav(ii)/2);  ...
        num2str(p.defect.w_pad(ii)/2) num2str(p.defect.l_wav(ii)/2);  ...
        num2str(p.defect.w_pad(ii)/2) num2str(p.defect.l_wav(ii)/2+p.defect.l_pad(ii));  ...
        num2str(-p.defect.w_pad(ii)/2) num2str(p.defect.l_wav(ii)/2+p.defect.l_pad(ii));  ...
        num2str(-p.defect.w_pad(ii)/2) num2str(p.defect.l_wav(ii)/2);  ...
        num2str(-p.defect.w_arm(ii)-p.defect.w_pad(ii)/2) num2str(p.defect.l_wav(ii)/2)});
    model.component('comp1').geom('geom1').feature('wp1').geom.create(strcat('mov',num2str(ii)), 'Move');
    model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('mov',num2str(ii))).set('displx', num2str(w_displac));
    model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('mov',num2str(ii))).selection('input').set({strcat('pol',num2str(ii+1))});
    w_displac = w_displac + p.defect.w_cell(ii);
end
    
% Select corners of the waveguide

model.component('comp1').geom('geom1').feature('wp1').geom.create('boxsel1', 'BoxSelection');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('boxsel1').set('entitydim', 0);
model.component('comp1').geom('geom1').feature('wp1').geom.feature('boxsel1').set('ymin', 0);
model.component('comp1').geom('geom1').feature('wp1').geom.feature('boxsel1').set('ymax', num2str(p.mirror.l_wav/2+10e-9));

model.component('comp1').geom('geom1').feature('wp1').geom.create('boxsel2', 'BoxSelection');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('boxsel2').set('entitydim', 0);
model.component('comp1').geom('geom1').feature('wp1').geom.feature('boxsel2').set('ymin', num2str(p.mirror.l_wav/2+p.mirror.l_pad+10e-9));
model.component('comp1').geom('geom1').feature('wp1').geom.feature('boxsel2').set('ymax',  num2str(p.mirror.l_wav/2+p.mirror.l_arm+10e-9));

model.component('comp1').geom('geom1').feature('wp1').geom.create('boxsel3', 'BoxSelection');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('boxsel3').set('entitydim', 0);
model.component('comp1').geom('geom1').feature('wp1').geom.feature('boxsel3').set('ymin', num2str(p.mirror.l_pad+p.mirror.l_wav/2-50e-9));
model.component('comp1').geom('geom1').feature('wp1').geom.feature('boxsel3').set('ymax', num2str(p.mirror.l_pad+p.mirror.l_wav/2+50e-9));

% Create the fillets of the waveguide
model.component('comp1').geom('geom1').feature('wp1').geom.create('fil1', 'Fillet');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('fil1').set('radius', '30[nm]');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('fil1').selection('point').named('boxsel1');

model.component('comp1').geom('geom1').feature('wp1').geom.create('fil2', 'Fillet');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('fil2').set('radius', '30[nm]');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('fil2').selection('point').named('boxsel2');

model.component('comp1').geom('geom1').feature('wp1').geom.create('fil3', 'Fillet');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('fil3').set('radius', '15[nm]');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('fil3').selection('point').named('boxsel3');

% Create the snowflakes
model.component('comp1').geom('geom1').feature('wp1').geom.create('r1', 'Rectangle');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('r1').set('pos', {'0' '0'});
model.component('comp1').geom('geom1').feature('wp1').geom.feature('r1').set('base', 'center');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('r1').set('size', {num2str(2*p.mirror.snow.l_snow) num2str(p.mirror.snow.w_snow)});
model.component('comp1').geom('geom1').feature('wp1').geom.create('r2', 'Rectangle');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('r2').set('pos', {'0' '0'});
model.component('comp1').geom('geom1').feature('wp1').geom.feature('r2').set('rot', 60);
model.component('comp1').geom('geom1').feature('wp1').geom.feature('r2').set('base', 'center');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('r2').set('size', {num2str(2*p.mirror.snow.l_snow) num2str(p.mirror.snow.w_snow)});
model.component('comp1').geom('geom1').feature('wp1').geom.create('r3', 'Rectangle');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('r3').set('pos', {'0' '0'});
model.component('comp1').geom('geom1').feature('wp1').geom.feature('r3').set('rot', -60);
model.component('comp1').geom('geom1').feature('wp1').geom.feature('r3').set('base', 'center');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('r3').set('size', {num2str(2*p.mirror.snow.l_snow) num2str(p.mirror.snow.w_snow)});

model.component('comp1').geom('geom1').feature('wp1').geom.create('uni1', 'Union');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('uni1').set('intbnd', false);
model.component('comp1').geom('geom1').feature('wp1').geom.feature('uni1').selection('input').set({'r1' 'r2' 'r3'});

idx_mov = ii+1;
model.component('comp1').geom('geom1').feature('wp1').geom.create(strcat('mov',num2str(idx_mov)), 'Move');
model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('mov',num2str(idx_mov))).set('displx', num2str(-p.mirror.w_cell/2));
model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('mov',num2str(idx_mov))).set('disply',  num2str(p.mirror.h_cell/2+p.mirror.snow.hc_snow/2));
model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('mov',num2str(idx_mov))).selection('input').set({'uni1'});

% Select corners of the snowflake
model.component('comp1').geom('geom1').feature('wp1').geom.create('disksel1', 'DiskSelection');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('disksel1').set('entitydim', 0);
model.component('comp1').geom('geom1').feature('wp1').geom.feature('disksel1').label('sel_obtuse');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('disksel1').set('posx', num2str(-p.mirror.w_cell/2));
model.component('comp1').geom('geom1').feature('wp1').geom.feature('disksel1').set('posy', num2str(p.mirror.h_cell/2+p.mirror.snow.hc_snow/2));
model.component('comp1').geom('geom1').feature('wp1').geom.feature('disksel1').set('r', num2str(p.mirror.snow.l_snow+30e-9));
model.component('comp1').geom('geom1').feature('wp1').geom.feature('disksel1').set('rin', num2str(p.mirror.snow.l_snow-30e-9));

model.component('comp1').geom('geom1').feature('wp1').geom.create('disksel2', 'DiskSelection');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('disksel2').set('entitydim', 0);
model.component('comp1').geom('geom1').feature('wp1').geom.feature('disksel2').label('sel_acute');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('disksel2').set('posx', num2str(-p.mirror.w_cell/2));
model.component('comp1').geom('geom1').feature('wp1').geom.feature('disksel2').set('posy', num2str(p.mirror.h_cell/2+p.mirror.snow.hc_snow/2));
model.component('comp1').geom('geom1').feature('wp1').geom.feature('disksel2').set('r', num2str(p.mirror.snow.r_snow+30e-9));

% Create the fillets of the snowflake
model.component('comp1').geom('geom1').feature('wp1').geom.create('fil4', 'Fillet');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('fil4').set('radius', '30[nm]');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('fil4').selection('point').named('disksel1');

model.component('comp1').geom('geom1').feature('wp1').geom.create('fil5', 'Fillet');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('fil5').set('radius', '15[nm]');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('fil5').selection('point').named('disksel2');

% Copy snowflake and make arrays
idx_copy = 1;
model.component('comp1').geom('geom1').feature('wp1').geom.create(strcat('copy',num2str(idx_copy)), 'Copy');
model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('copy',num2str(idx_copy))).set('displx', num2str(p.mirror.w_cell/2));
model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('copy',num2str(idx_copy))).set('disply', num2str(p.mirror.snow.hc_snow));
model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('copy',num2str(idx_copy))).selection('input').set('fil5');

idx_array = idx_array+1;
model.component('comp1').geom('geom1').feature('wp1').geom.create(strcat('arr',num2str(idx_array)), 'Array');
model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('arr',num2str(idx_array))).set('fullsize', [p.mirror.ncells+p.defect.ncells+1 ceil(p.mirror.snow.nrows/2)]);
model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('arr',num2str(idx_array))).set('displ', {num2str(p.mirror.w_cell) num2str(2*p.mirror.snow.hc_snow)});
model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('arr',num2str(idx_array))).selection('input').set('fil5');

idx_array = idx_array+1;
model.component('comp1').geom('geom1').feature('wp1').geom.create(strcat('arr',num2str(idx_array)), 'Array');
model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('arr',num2str(idx_array))).set('fullsize', [p.mirror.ncells+p.defect.ncells ceil(p.mirror.snow.nrows/2)]);
model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('arr',num2str(idx_array))).set('displ', {num2str(p.mirror.w_cell) num2str(2*p.mirror.snow.hc_snow)});
model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('arr',num2str(idx_array))).selection('input').set({'copy1'});
% model.component('comp1').geom('geom1').feature('wp1').geom.feature('r4').set('size', {num2str(w_displac) num2str(p.mirror.h_cell/2+p.mirror.snow.nrows*p.mirror.snow.hc_snow)});

model.component('comp1').geom('geom1').run;

% Extrude workplane
model.component('comp1').geom('geom1').create('ext1', 'Extrude');
model.component('comp1').geom('geom1').feature('ext1').setIndex('distance', num2str(p.mirror.th/2), 0);
model.component('comp1').geom('geom1').feature('ext1').selection('input').set({'wp1'});

% Create holes with the shape
model.component('comp1').geom('geom1').create('blk1', 'Block');
model.component('comp1').geom('geom1').feature('blk1').set('pos', {num2str(-p.mirror.w_cell/2) '0' '0'});
%for a single defect
model.component('comp1').geom('geom1').feature('blk1').set('size', {num2str(w_displac-p.defect.w_cell(ii)/2) num2str(p.mirror.h_cell/2+p.mirror.snow.hc_snow*p.mirror.snow.nrows) num2str(p.mirror.th/2)}); 
%for a double defect
% model.component('comp1').geom('geom1').feature('blk1').set('size', {num2str(w_displac) num2str(p.mirror.h_cell/2+p.mirror.snow.hc_snow*p.mirror.snow.nrows) num2str(p.mirror.th/2)});

model.component('comp1').geom('geom1').create('dif1', 'Difference');
model.component('comp1').geom('geom1').feature('dif1').selection('input').set({'blk1'});
model.component('comp1').geom('geom1').feature('dif1').selection('input2').set({'ext1'});


% Create air box
model.component('comp1').geom('geom1').create('blk2', 'Block');
model.component('comp1').geom('geom1').feature('blk2').set('pos', {num2str(-p.mirror.w_cell/2-5*p.mirror.w_cell) '0' '0'});
%for a single defect
model.component('comp1').geom('geom1').feature('blk2').set('size', {num2str(w_displac+5*p.mirror.w_cell-p.defect.w_cell(ii)/2) num2str(14*p.mirror.h_cell/2) num2str(10*p.mirror.th/2)});
%for a double defect
%model.component('comp1').geom('geom1').feature('blk2').set('size', {num2str(w_displac+5*p.mirror.w_cell) num2str(14*p.mirror.h_cell/2) num2str(10*p.mirror.th/2)});

model.component('comp1').geom('geom1').run;

% ------ Create boxes for boundary conditions ------ %

model.component('comp1').selection.create('box2', 'Box');
model.component('comp1').selection('box2').label('electromag');
model.component('comp1').selection('box2').set('xmin', '-inf');
model.component('comp1').selection('box2').set('xmax', 'inf');
model.component('comp1').selection('box2').set('ymin', '-inf');
model.component('comp1').selection('box2').set('ymax', 'inf');
model.component('comp1').selection('box2').set('zmin', '-inf');
model.component('comp1').selection('box2').set('zmax', 'inf');

model.component('comp1').selection.create('box6', 'Box');
model.component('comp1').selection('box6').label('elec_pec');
model.component('comp1').selection('box6').set('entitydim', 2);
model.component('comp1').selection('box6').set('xmin', num2str(-p.mirror.w_cell/2-5*p.mirror.w_cell-10e-9));
model.component('comp1').selection('box6').set('xmax', num2str(w_displac-p.defect.w_cell(ii)+10e-9));
model.component('comp1').selection('box6').set('ymin', '-10[nm]');
model.component('comp1').selection('box6').set('ymax','10[nm]');
model.component('comp1').selection('box6').set('zmin', '-10[nm]');
model.component('comp1').selection('box6').set('zmax', num2str(10*p.mirror.th/2+10e-9));
model.component('comp1').selection('box6').set('condition', 'inside');

model.component('comp1').selection.create('box7', 'Box');
model.component('comp1').selection('box7').label('elec_pmc1');
model.component('comp1').selection('box7').set('entitydim', 2);
model.component('comp1').selection('box7').set('xmin', num2str(w_displac-p.defect.w_cell(ii)-10e-9));
model.component('comp1').selection('box7').set('xmax', num2str(w_displac-p.defect.w_cell(ii)+10e-9));
model.component('comp1').selection('box7').set('ymin', '-10[nm]');
model.component('comp1').selection('box7').set('ymax', num2str(14*p.mirror.h_cell/2+10e-9));
model.component('comp1').selection('box7').set('zmin', '-10[nm]');
model.component('comp1').selection('box7').set('zmax', num2str(10*p.mirror.th/2+10e-9));
model.component('comp1').selection('box7').set('condition', 'inside');

model.component('comp1').selection.create('box8', 'Box');
model.component('comp1').selection('box8').label('elec_pmc2');
model.component('comp1').selection('box8').set('entitydim', 2);
model.component('comp1').selection('box8').set('xmin', num2str(-p.mirror.w_cell/2-5*p.mirror.w_cell-10e-9)); 
model.component('comp1').selection('box8').set('xmax', num2str(w_displac-p.defect.w_cell(ii)+10e-9));
model.component('comp1').selection('box8').set('ymin', '-10[nm]');
model.component('comp1').selection('box8').set('ymax', num2str(14*p.mirror.h_cell/2+10e-9));
model.component('comp1').selection('box8').set('zmin', '-10[nm]');
model.component('comp1').selection('box8').set('zmax', '10[nm]');
model.component('comp1').selection('box8').set('condition', 'inside');

model.component('comp1').selection.create('box9', 'Box');
model.component('comp1').selection('box9').label('elec_scat');
model.component('comp1').selection('box9').set('entitydim', 2);
model.component('comp1').selection('box9').set('xmin', num2str(-p.mirror.w_cell/2-5*p.mirror.w_cell-10e-9));
model.component('comp1').selection('box9').set('xmax', num2str(-p.mirror.w_cell/2-5*p.mirror.w_cell+10e-9));
model.component('comp1').selection('box9').set('ymin', num2str(14*p.mirror.h_cell/2-10e-9));
model.component('comp1').selection('box9').set('ymax', num2str(14*p.mirror.h_cell/2+10e-9));
model.component('comp1').selection('box9').set('zmin', num2str(10*p.mirror.th/2-10e-9));
model.component('comp1').selection('box9').set('zmax', num2str(10*p.mirror.th/2+10e-9));
model.component('comp1').selection('box9').set('condition', 'intersects');

aux = model.selection.create('sel_all', 'Ball');  % eps_beam-eps_air
aux.set('posx', '0');
aux.set('posy', '0');
aux.set('posz', '0');
aux.set('r', '1');
aux.set('entitydim', 3);
All_Sel = mphgetselection(model.selection('sel_all'));
clear aux;

% ------ EM physics ------- %

model.component('comp1').physics.create('emw', 'ElectromagneticWavesFrequencyDomain', 'geom1');
model.component('comp1').physics('emw').identifier('emw');
model.component('comp1').physics('emw').create('pmc1', 'PerfectMagneticConductor', 2);
model.component('comp1').physics('emw').feature('pmc1').selection.named('box7');
model.component('comp1').physics('emw').create('pmc2', 'PerfectMagneticConductor', 2);
model.component('comp1').physics('emw').feature('pmc2').selection.named('box8');
model.component('comp1').physics('emw').create('sctr1', 'Scattering', 2);
model.component('comp1').physics('emw').feature('sctr1').selection.named('box9');

% ----- Materials definitions ------ %

model.component('comp1').material.create('mat1', 'Common');
model.component('comp1').material.create('mat2', 'Common');
model.component('comp1').material('mat1').selection.set([2]);
model.component('comp1').material('mat1').propertyGroup.create('Enu', 'Young''s modulus and Poisson''s ratio');
model.component('comp1').material('mat1').propertyGroup.create('RefractiveIndex', 'Refractive index');
model.component('comp1').material('mat2').selection.set([1]);
model.component('comp1').material('mat2').propertyGroup('def').func.create('eta', 'Piecewise');
model.component('comp1').material('mat2').propertyGroup('def').func.create('Cp', 'Piecewise');
model.component('comp1').material('mat2').propertyGroup('def').func.create('rho', 'Analytic');
model.component('comp1').material('mat2').propertyGroup('def').func.create('k', 'Piecewise');
model.component('comp1').material('mat2').propertyGroup('def').func.create('cs', 'Analytic');
model.component('comp1').material('mat2').propertyGroup.create('RefractiveIndex', 'Refractive index');

model.component('comp1').material('mat1').label('Silicon');
model.component('comp1').material('mat1').set('family', 'custom');
model.component('comp1').material('mat1').set('specular', 'custom');
model.component('comp1').material('mat1').set('customspecular', [0.7843137254901961 1 1]);
model.component('comp1').material('mat1').set('diffuse', 'custom');
model.component('comp1').material('mat1').set('customdiffuse', [0.6666666666666666 0.6666666666666666 0.7058823529411765]);
model.component('comp1').material('mat1').set('ambient', 'custom');
model.component('comp1').material('mat1').set('customambient', [0.6666666666666666 0.6666666666666666 0.7058823529411765]);
model.component('comp1').material('mat1').set('noise', true);
model.component('comp1').material('mat1').set('noisefreq', 1);
model.component('comp1').material('mat1').set('lighting', 'cooktorrance');
model.component('comp1').material('mat1').set('fresnel', 0.7);
model.component('comp1').material('mat1').set('roughness', 0.5);
model.component('comp1').material('mat1').propertyGroup('def').set('relpermeability', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.component('comp1').material('mat1').propertyGroup('def').set('electricconductivity', {'1e-12[S/m]' '0' '0' '0' '1e-12[S/m]' '0' '0' '0' '1e-12[S/m]'});
model.component('comp1').material('mat1').propertyGroup('def').set('thermalexpansioncoefficient', {'2.6e-6[1/K]' '0' '0' '0' '2.6e-6[1/K]' '0' '0' '0' '2.6e-6[1/K]'});
model.component('comp1').material('mat1').propertyGroup('def').set('heatcapacity', '700[J/(kg*K)]');
model.component('comp1').material('mat1').propertyGroup('def').set('relpermittivity', {'11.7' '0' '0' '0' '11.7' '0' '0' '0' '11.7'});
model.component('comp1').material('mat1').propertyGroup('def').set('density', '2329[kg/m^3]');
model.component('comp1').material('mat1').propertyGroup('def').set('thermalconductivity', {'130[W/(m*K)]' '0' '0' '0' '130[W/(m*K)]' '0' '0' '0' '130[W/(m*K)]'});
model.component('comp1').material('mat1').propertyGroup('Enu').set('youngsmodulus', '170e9[Pa]');
model.component('comp1').material('mat1').propertyGroup('Enu').set('poissonsratio', '0.28');
model.component('comp1').material('mat1').propertyGroup('RefractiveIndex').set('n', '');
model.component('comp1').material('mat1').propertyGroup('RefractiveIndex').set('ki', '');
model.component('comp1').material('mat1').propertyGroup('RefractiveIndex').set('n', {'3.48' '0' '0' '0' '3.48' '0' '0' '0' '3.48'});
model.component('comp1').material('mat1').propertyGroup('RefractiveIndex').set('ki', {'0' '0' '0' '0' '0' '0' '0' '0' '0'});
model.component('comp1').material('mat2').label('Air');
model.component('comp1').material('mat2').set('family', 'air');
model.component('comp1').material('mat2').propertyGroup('def').func('eta').set('arg', 'T');
model.component('comp1').material('mat2').propertyGroup('def').func('eta').set('pieces', {'200.0' '1600.0' '-8.38278E-7+8.35717342E-8*T^1-7.69429583E-11*T^2+4.6437266E-14*T^3-1.06585607E-17*T^4'});
model.component('comp1').material('mat2').propertyGroup('def').func('Cp').set('arg', 'T');
model.component('comp1').material('mat2').propertyGroup('def').func('Cp').set('pieces', {'200.0' '1600.0' '1047.63657-0.372589265*T^1+9.45304214E-4*T^2-6.02409443E-7*T^3+1.2858961E-10*T^4'});
model.component('comp1').material('mat2').propertyGroup('def').func('rho').set('expr', 'pA*0.02897/8.314/T');
model.component('comp1').material('mat2').propertyGroup('def').func('rho').set('args', {'pA' 'T'});
model.component('comp1').material('mat2').propertyGroup('def').func('rho').set('dermethod', 'manual');
model.component('comp1').material('mat2').propertyGroup('def').func('rho').set('argders', {'pA' 'd(pA*0.02897/8.314/T,pA)'; 'T' 'd(pA*0.02897/8.314/T,T)'});
model.component('comp1').material('mat2').propertyGroup('def').func('rho').set('plotargs', {'pA' '0' '1'; 'T' '0' '1'});
model.component('comp1').material('mat2').propertyGroup('def').func('k').set('arg', 'T');
model.component('comp1').material('mat2').propertyGroup('def').func('k').set('pieces', {'200.0' '1600.0' '-0.00227583562+1.15480022E-4*T^1-7.90252856E-8*T^2+4.11702505E-11*T^3-7.43864331E-15*T^4'});
model.component('comp1').material('mat2').propertyGroup('def').func('cs').set('expr', 'sqrt(1.4*287*T)');
model.component('comp1').material('mat2').propertyGroup('def').func('cs').set('args', {'T'});
model.component('comp1').material('mat2').propertyGroup('def').func('cs').set('dermethod', 'manual');
model.component('comp1').material('mat2').propertyGroup('def').func('cs').set('argders', {'T' 'd(sqrt(1.4*287*T),T)'});
model.component('comp1').material('mat2').propertyGroup('def').func('cs').set('plotargs', {'T' '0' '1'});
model.component('comp1').material('mat2').propertyGroup('def').set('relpermeability', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.component('comp1').material('mat2').propertyGroup('def').set('relpermittivity', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.component('comp1').material('mat2').propertyGroup('def').set('dynamicviscosity', 'eta(T[1/K])[Pa*s]');
model.component('comp1').material('mat2').propertyGroup('def').set('ratioofspecificheat', '1.4');
model.component('comp1').material('mat2').propertyGroup('def').set('electricconductivity', {'0[S/m]' '0' '0' '0' '0[S/m]' '0' '0' '0' '0[S/m]'});
model.component('comp1').material('mat2').propertyGroup('def').set('heatcapacity', 'Cp(T[1/K])[J/(kg*K)]');
model.component('comp1').material('mat2').propertyGroup('def').set('density', 'rho(pA[1/Pa],T[1/K])[kg/m^3]');
model.component('comp1').material('mat2').propertyGroup('def').set('thermalconductivity', {'k(T[1/K])[W/(m*K)]' '0' '0' '0' 'k(T[1/K])[W/(m*K)]' '0' '0' '0' 'k(T[1/K])[W/(m*K)]'});
model.component('comp1').material('mat2').propertyGroup('def').set('soundspeed', 'cs(T[1/K])[m/s]');
model.component('comp1').material('mat2').propertyGroup('def').set('youngsmodulus', '0');
model.component('comp1').material('mat2').propertyGroup('def').set('poissonsratio', '1');
model.component('comp1').material('mat2').propertyGroup('def').addInput('temperature');
model.component('comp1').material('mat2').propertyGroup('def').addInput('pressure');
model.component('comp1').material('mat2').propertyGroup('RefractiveIndex').set('n', '');
model.component('comp1').material('mat2').propertyGroup('RefractiveIndex').set('ki', '');
model.component('comp1').material('mat2').propertyGroup('RefractiveIndex').set('n', {'1' '0' '0' '0' '1' '0' '0' '0' '1'});
model.component('comp1').material('mat2').propertyGroup('RefractiveIndex').set('ki', {'0' '0' '0' '0' '0' '0' '0' '0' '0'});

% ------ Mesh ------ %

model.component('comp1').mesh.create('mesh1');
model.component('comp1').mesh('mesh1').create('ftet1', 'FreeTet');
model.component('comp1').mesh('mesh1').run;

% ----- Study EM ----- %

model.study.create('std1');
model.study('std1').create('eig', 'Eigenfrequency');
model.study('std1').feature('eig').set('neigs', 2);
model.study('std1').feature('eig').set('neigsactive', true);
model.study('std1').feature('eig').set('shift', '194e12');
model.study('std1').feature('eig').set('shiftactive', true);
model.study('std1').feature('eig').set('activate', {'emw' 'on'});

model.sol.create('sol1');
model.sol('sol1').attach('std1');
model.sol('sol1').study('std1');
model.sol('sol1').create('st1', 'StudyStep');
model.sol('sol1').create('v1', 'Variables');
model.sol('sol1').create('e1', 'Eigenvalue');
model.sol('sol1').feature('e1').create('d1', 'Direct');
model.sol('sol1').feature('e1').create('i1', 'Iterative');
model.sol('sol1').feature('e1').feature('i1').create('mg1', 'Multigrid');
model.sol('sol1').feature('e1').feature('i1').feature('mg1').feature('pr').create('sv1', 'SORVector');
model.sol('sol1').feature('e1').feature('i1').feature('mg1').feature('po').create('sv1', 'SORVector');


out = model;
end

