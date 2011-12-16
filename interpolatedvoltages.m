function Vscalp=interpolatedvoltages(interpVertices,interpfaces,origvertices,origfaces,origvoltages)

scalpvert = interpVertices';
scalpface = interpfaces;
elecvert  = origvertices';
elecface  = origfaces;

% Extract electric potential at time t for electrodes
Velec = origvoltages';

Scalpindex = dsearchn(scalpvert,elecvert)';

% Calculate the Laplacian matrix
lap = mesh_laplacian(scalpvert,scalpface);

% Calculate interpolation matrix, based on Laplacian
[Lint, keepindex, repindex] = mesh_laplacian_interp(lap,Scalpindex);

% Interpolate potential to scalp

if isempty(repindex),
   Vscalp = Lint * Velec';
else
   Vscalp = Lint * Velec(:,keepindex)';
end


end

%---------------------------------------------------------------------------




