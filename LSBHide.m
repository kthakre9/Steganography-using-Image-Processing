function [Stego, Extracted] = LSBHide(Cover, Hidden, n)
%LSBHide
% [Stego, Extracted] = LSBHide(Cover, Hidden, n)
% Hide Hidden in the n least significant bits of Cover

Stego = uint8(bitor(bitand(Cover, bitcmp(2^n - 1, 8)) , bitshift(Hidden, n - 8)));
Extracted = uint8(bitand(255, bitshift(Stego, 8 - n)));
