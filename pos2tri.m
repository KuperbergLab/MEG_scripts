
function [tri]=pos2tri(pos)
pos_u=pos;
pos_mean=mean(pos_u,2);
pos_u=pos_u-repmat(pos_mean,[1 length(pos_u)]);

D=pdist(pos_u','mahalanobis');
pos_g=mdscale(D,2)';
tri=delaunay(pos_g(1,:),pos_g(2,:));

end