function y = myfitness(x)

% Created by Rodrigo Benevides - aug/2019

model = callcomsol

numcells_defect = 8;
larmvec = defect_generate(x(2),x(1),numcells_defect); 
wpadvec = defect_generate(x(4),x(3),numcells_defect); 
wcellvec = zeros(1,numcells_defect)+500;
hcellvec = zeros(1,numcells_defect)+795;
lwavvec = defect_generate(x(6),x(5),numcells_defect); %zeros(1,numcells_defect)+171; 
warmvec = zeros(1,numcells_defect)+110; 
lpadvec =  zeros(1,numcells_defect)+137;

p.mirror.w_cell = 500e-9;
p.mirror.h_cell = 795e-9;
p.mirror.l_arm = x(2)*1e-9;
p.mirror.w_arm = 110e-9;
p.mirror.l_pad = 137e-9;
p.mirror.w_pad = x(4)*1e-9;
p.mirror.th = 250e-9;
p.mirror.l_wav = x(6)*1e-9;

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



% ---- Generate new geometry -------- 
%
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
% model.component('comp1').geom('geom1').feature('wp1').geom.create(strcat('arr',num2str(idx_array)), 'Array');
model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('arr',num2str(idx_array))).set('fullsize', [p.mirror.ncells 1]);
model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('arr',num2str(idx_array))).set('displ', {num2str(p.mirror.w_cell) '0'});
model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('arr',num2str(idx_array))).selection('input').set({'pol1'});

% Defect c-shapes

w_displac = p.mirror.ncells*p.mirror.w_cell;
for ii = 1:p.defect.ncells
%     model.component('comp1').geom('geom1').feature('wp1').geom.create(strcat('pol',num2str(ii+1)), 'Polygon');
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
%     model.component('comp1').geom('geom1').feature('wp1').geom.create(strcat('mov',num2str(ii)), 'Move');
    model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('mov',num2str(ii))).set('displx', num2str(w_displac));
    model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('mov',num2str(ii))).selection('input').set({strcat('pol',num2str(ii+1))});
    w_displac = w_displac + p.defect.w_cell(ii);
end
    
% Select corners of the waveguide

% model.component('comp1').geom('geom1').feature('wp1').geom.create('boxsel1', 'BoxSelection');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('boxsel1').set('entitydim', 0);
model.component('comp1').geom('geom1').feature('wp1').geom.feature('boxsel1').set('ymin', 0);
model.component('comp1').geom('geom1').feature('wp1').geom.feature('boxsel1').set('ymax', num2str(p.mirror.l_wav/2+10e-9));

% model.component('comp1').geom('geom1').feature('wp1').geom.create('boxsel2', 'BoxSelection');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('boxsel2').set('entitydim', 0);
model.component('comp1').geom('geom1').feature('wp1').geom.feature('boxsel2').set('ymin', num2str(p.mirror.l_wav/2+p.mirror.l_pad+10e-9));
model.component('comp1').geom('geom1').feature('wp1').geom.feature('boxsel2').set('ymax',  num2str(p.mirror.l_wav/2+p.mirror.l_arm+10e-9));

% model.component('comp1').geom('geom1').feature('wp1').geom.create('boxsel3', 'BoxSelection');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('boxsel3').set('entitydim', 0);
model.component('comp1').geom('geom1').feature('wp1').geom.feature('boxsel3').set('ymin', num2str(p.mirror.l_pad+p.mirror.l_wav/2-50e-9));
model.component('comp1').geom('geom1').feature('wp1').geom.feature('boxsel3').set('ymax', num2str(p.mirror.l_pad+p.mirror.l_wav/2+50e-9));

% Create the fillets of the waveguide
% model.component('comp1').geom('geom1').feature('wp1').geom.create('fil1', 'Fillet');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('fil1').set('radius', '30[nm]');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('fil1').selection('point').named('boxsel1');

% model.component('comp1').geom('geom1').feature('wp1').geom.create('fil2', 'Fillet');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('fil2').set('radius', '30[nm]');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('fil2').selection('point').named('boxsel2');

% model.component('comp1').geom('geom1').feature('wp1').geom.create('fil3', 'Fillet');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('fil3').set('radius', '15[nm]');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('fil3').selection('point').named('boxsel3');

% Create the snowflakes
% model.component('comp1').geom('geom1').feature('wp1').geom.create('r1', 'Rectangle');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('r1').set('pos', {'0' '0'});
model.component('comp1').geom('geom1').feature('wp1').geom.feature('r1').set('base', 'center');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('r1').set('size', {num2str(2*p.mirror.snow.l_snow) num2str(p.mirror.snow.w_snow)});
% model.component('comp1').geom('geom1').feature('wp1').geom.create('r2', 'Rectangle');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('r2').set('pos', {'0' '0'});
model.component('comp1').geom('geom1').feature('wp1').geom.feature('r2').set('rot', 60);
model.component('comp1').geom('geom1').feature('wp1').geom.feature('r2').set('base', 'center');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('r2').set('size', {num2str(2*p.mirror.snow.l_snow) num2str(p.mirror.snow.w_snow)});
% model.component('comp1').geom('geom1').feature('wp1').geom.create('r3', 'Rectangle');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('r3').set('pos', {'0' '0'});
model.component('comp1').geom('geom1').feature('wp1').geom.feature('r3').set('rot', -60);
model.component('comp1').geom('geom1').feature('wp1').geom.feature('r3').set('base', 'center');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('r3').set('size', {num2str(2*p.mirror.snow.l_snow) num2str(p.mirror.snow.w_snow)});

% model.component('comp1').geom('geom1').feature('wp1').geom.create('uni1', 'Union');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('uni1').set('intbnd', false);
model.component('comp1').geom('geom1').feature('wp1').geom.feature('uni1').selection('input').set({'r1' 'r2' 'r3'});

idx_mov = ii+1;
% model.component('comp1').geom('geom1').feature('wp1').geom.create(strcat('mov',num2str(idx_mov)), 'Move');
model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('mov',num2str(idx_mov))).set('displx', num2str(-p.mirror.w_cell/2));
model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('mov',num2str(idx_mov))).set('disply',  num2str(p.mirror.h_cell/2+p.mirror.snow.hc_snow/2));
model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('mov',num2str(idx_mov))).selection('input').set({'uni1'});

% Select corners of the snowflake
% model.component('comp1').geom('geom1').feature('wp1').geom.create('disksel1', 'DiskSelection');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('disksel1').set('entitydim', 0);
model.component('comp1').geom('geom1').feature('wp1').geom.feature('disksel1').label('sel_obtuse');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('disksel1').set('posx', num2str(-p.mirror.w_cell/2));
model.component('comp1').geom('geom1').feature('wp1').geom.feature('disksel1').set('posy', num2str(p.mirror.h_cell/2+p.mirror.snow.hc_snow/2));
model.component('comp1').geom('geom1').feature('wp1').geom.feature('disksel1').set('r', num2str(p.mirror.snow.l_snow+30e-9));
model.component('comp1').geom('geom1').feature('wp1').geom.feature('disksel1').set('rin', num2str(p.mirror.snow.l_snow-30e-9));

% model.component('comp1').geom('geom1').feature('wp1').geom.create('disksel2', 'DiskSelection');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('disksel2').set('entitydim', 0);
model.component('comp1').geom('geom1').feature('wp1').geom.feature('disksel2').label('sel_acute');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('disksel2').set('posx', num2str(-p.mirror.w_cell/2));
model.component('comp1').geom('geom1').feature('wp1').geom.feature('disksel2').set('posy', num2str(p.mirror.h_cell/2+p.mirror.snow.hc_snow/2));
model.component('comp1').geom('geom1').feature('wp1').geom.feature('disksel2').set('r', num2str(p.mirror.snow.r_snow+30e-9));

% Create the fillets of the snowflake
% model.component('comp1').geom('geom1').feature('wp1').geom.create('fil4', 'Fillet');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('fil4').set('radius', '30[nm]');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('fil4').selection('point').named('disksel1');

% model.component('comp1').geom('geom1').feature('wp1').geom.create('fil5', 'Fillet');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('fil5').set('radius', '15[nm]');
model.component('comp1').geom('geom1').feature('wp1').geom.feature('fil5').selection('point').named('disksel2');

% Copy snowflake and make arrays
idx_copy = 1;
% model.component('comp1').geom('geom1').feature('wp1').geom.create(strcat('copy',num2str(idx_copy)), 'Copy');
model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('copy',num2str(idx_copy))).set('displx', num2str(p.mirror.w_cell/2));
model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('copy',num2str(idx_copy))).set('disply', num2str(p.mirror.snow.hc_snow));
model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('copy',num2str(idx_copy))).selection('input').set('fil5');

idx_array = idx_array+1;
% model.component('comp1').geom('geom1').feature('wp1').geom.create(strcat('arr',num2str(idx_array)), 'Array');
model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('arr',num2str(idx_array))).set('fullsize', [p.mirror.ncells+p.defect.ncells+1 ceil(p.mirror.snow.nrows/2)]);
model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('arr',num2str(idx_array))).set('displ', {num2str(p.mirror.w_cell) num2str(2*p.mirror.snow.hc_snow)});
model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('arr',num2str(idx_array))).selection('input').set('fil5');

idx_array = idx_array+1;
% model.component('comp1').geom('geom1').feature('wp1').geom.create(strcat('arr',num2str(idx_array)), 'Array');
model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('arr',num2str(idx_array))).set('fullsize', [p.mirror.ncells+p.defect.ncells ceil(p.mirror.snow.nrows/2)]);
model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('arr',num2str(idx_array))).set('displ', {num2str(p.mirror.w_cell) num2str(2*p.mirror.snow.hc_snow)});
model.component('comp1').geom('geom1').feature('wp1').geom.feature(strcat('arr',num2str(idx_array))).selection('input').set({'copy1'});
% model.component('comp1').geom('geom1').feature('wp1').geom.feature('r4').set('size', {num2str(w_displac) num2str(p.mirror.h_cell/2+p.mirror.snow.nrows*p.mirror.snow.hc_snow)});

model.component('comp1').geom('geom1').run;

% Extrude workplane
% model.component('comp1').geom('geom1').create('ext1', 'Extrude');
model.component('comp1').geom('geom1').feature('ext1').setIndex('distance', num2str(p.mirror.th/2), 0);
model.component('comp1').geom('geom1').feature('ext1').selection('input').set({'wp1'});

% Create holes with the shape
% model.component('comp1').geom('geom1').create('blk1', 'Block');
model.component('comp1').geom('geom1').feature('blk1').set('pos', {num2str(-p.mirror.w_cell/2) '0' '0'});
%for a single defect
model.component('comp1').geom('geom1').feature('blk1').set('size', {num2str(w_displac-p.defect.w_cell(ii)/2) num2str(p.mirror.h_cell/2+p.mirror.snow.hc_snow*p.mirror.snow.nrows) num2str(p.mirror.th/2)}); 
%for a double defect
% model.component('comp1').geom('geom1').feature('blk1').set('size', {num2str(w_displac) num2str(p.mirror.h_cell/2+p.mirror.snow.hc_snow*p.mirror.snow.nrows) num2str(p.mirror.th/2)});

% model.component('comp1').geom('geom1').create('dif1', 'Difference');
model.component('comp1').geom('geom1').feature('dif1').selection('input').set({'blk1'});
model.component('comp1').geom('geom1').feature('dif1').selection('input2').set({'ext1'});


% Create air box
% model.component('comp1').geom('geom1').create('blk2', 'Block');
model.component('comp1').geom('geom1').feature('blk2').set('pos', {num2str(-p.mirror.w_cell/2-5*p.mirror.w_cell) '0' '0'});
%for a single defect
model.component('comp1').geom('geom1').feature('blk2').set('size', {num2str(w_displac+5*p.mirror.w_cell-p.defect.w_cell(ii)/2) num2str(14*p.mirror.h_cell/2) num2str(10*p.mirror.th/2)});
%for a double defect
%model.component('comp1').geom('geom1').feature('blk2').set('size', {num2str(w_displac+5*p.mirror.w_cell) num2str(14*p.mirror.h_cell/2) num2str(10*p.mirror.th/2)});

model.component('comp1').geom('geom1').run;

% ----  Create boxes for boundary conditions ------ %

% model.component('comp1').selection.create('box2', 'Box');
model.component('comp1').selection('box2').label('electromag');
model.component('comp1').selection('box2').set('xmin', '-inf');
model.component('comp1').selection('box2').set('xmax', 'inf');
model.component('comp1').selection('box2').set('ymin', '-inf');
model.component('comp1').selection('box2').set('ymax', 'inf');
model.component('comp1').selection('box2').set('zmin', '-inf');
model.component('comp1').selection('box2').set('zmax', 'inf');

% model.component('comp1').selection.create('box6', 'Box');
model.component('comp1').selection('box6').label('elec_pec');
model.component('comp1').selection('box6').set('entitydim', 2);
model.component('comp1').selection('box6').set('xmin', num2str(-p.mirror.w_cell/2-5*p.mirror.w_cell-10e-9));
model.component('comp1').selection('box6').set('xmax', num2str(w_displac-p.defect.w_cell(ii)+10e-9));
model.component('comp1').selection('box6').set('ymin', '-10[nm]');
model.component('comp1').selection('box6').set('ymax','10[nm]');
model.component('comp1').selection('box6').set('zmin', '-10[nm]');
model.component('comp1').selection('box6').set('zmax', num2str(10*p.mirror.th/2+10e-9));
model.component('comp1').selection('box6').set('condition', 'inside');

% model.component('comp1').selection.create('box7', 'Box');
model.component('comp1').selection('box7').label('elec_pmc1');
model.component('comp1').selection('box7').set('entitydim', 2);
model.component('comp1').selection('box7').set('xmin', num2str(w_displac-p.defect.w_cell(ii)-10e-9));
model.component('comp1').selection('box7').set('xmax', num2str(w_displac-p.defect.w_cell(ii)+10e-9));
model.component('comp1').selection('box7').set('ymin', '-10[nm]');
model.component('comp1').selection('box7').set('ymax', num2str(14*p.mirror.h_cell/2+10e-9));
model.component('comp1').selection('box7').set('zmin', '-10[nm]');
model.component('comp1').selection('box7').set('zmax', num2str(10*p.mirror.th/2+10e-9));
model.component('comp1').selection('box7').set('condition', 'inside');

% model.component('comp1').selection.create('box8', 'Box');
model.component('comp1').selection('box8').label('elec_pmc2');
model.component('comp1').selection('box8').set('entitydim', 2);
model.component('comp1').selection('box8').set('xmin', num2str(-p.mirror.w_cell/2-5*p.mirror.w_cell-10e-9)); 
model.component('comp1').selection('box8').set('xmax', num2str(w_displac-p.defect.w_cell(ii)+10e-9));
model.component('comp1').selection('box8').set('ymin', '-10[nm]');
model.component('comp1').selection('box8').set('ymax', num2str(14*p.mirror.h_cell/2+10e-9));
model.component('comp1').selection('box8').set('zmin', '-10[nm]');
model.component('comp1').selection('box8').set('zmax', '10[nm]');
model.component('comp1').selection('box8').set('condition', 'inside');

% model.component('comp1').selection.create('box9', 'Box');
model.component('comp1').selection('box9').label('elec_scat');
model.component('comp1').selection('box9').set('entitydim', 2);
model.component('comp1').selection('box9').set('xmin', num2str(-p.mirror.w_cell/2-5*p.mirror.w_cell-10e-9));
model.component('comp1').selection('box9').set('xmax', num2str(-p.mirror.w_cell/2-5*p.mirror.w_cell+10e-9));
model.component('comp1').selection('box9').set('ymin', num2str(14*p.mirror.h_cell/2-10e-9));
model.component('comp1').selection('box9').set('ymax', num2str(14*p.mirror.h_cell/2+10e-9));
model.component('comp1').selection('box9').set('zmin', num2str(10*p.mirror.th/2-10e-9));
model.component('comp1').selection('box9').set('zmax', num2str(10*p.mirror.th/2+10e-9));
model.component('comp1').selection('box9').set('condition', 'intersects');


model.component('comp1').mesh('mesh1').run;

model.sol('sol1').feature('e1').set('transform', 'eigenfrequency');
model.sol('sol1').feature('e1').set('neigs', 2);
model.sol('sol1').feature('e1').set('shift', '194e12');
model.sol('sol1').feature('e1').set('eigref', '194e12');
model.sol('sol1').feature('e1').feature('aDef').set('complexfun', true);
model.sol('sol1').feature('e1').feature('d1').active(true);
model.sol('sol1').feature('e1').feature('d1').label('Suggested Direct Solver (emw)');
model.sol('sol1').feature('e1').feature('i1').label('Suggested Iterative Solver (emw)');
model.sol('sol1').feature('e1').feature('i1').set('linsolver', 'bicgstab');
model.sol('sol1').runAll;

test = mpheval(model,'emw.Qfactor');
Qopt = max(max(test.d1));
y = 1e7-Qopt;
end

