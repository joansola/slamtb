function imCell = getCell(u,imGrid)

imCell = ceil(u.*imGrid.numCells./imGrid.imSize);
