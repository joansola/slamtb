%GETCELL  Get image cell corresopnding to a given pixel.

function imCell = getCell(u,imGrid)

imCell = ceil(u.*imGrid.numCells./imGrid.imSize);









