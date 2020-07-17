# in 2D

## vertices

vertices = each permutation of [x, y] being 0 or 1

- [0, 0]
- [0, 1]
- [1, 0]
- [1, 1]

## line

line = pair of vertices differing in only 1 coordinate e.g. vertices where

- given x=0, a.x==b.x, a.y!=b.y
- given x=1, a.x==b.x, a.y!=b.y
- given y=0, a.x!=b.x, a.y==b.y
- given y=1, a.x!=b.x, a.y==b.y

# in 3D

## vertices

vertices = each permutation of [x, y, z] being 0 or 1

- [0, 0, 0], [0, 0, 1], [0, 1, 0], ...

## line

line = pair of vertices differing in only 1 coordinate e.g. vertices where

- a.x==b.x, a.y==b.y, a.z!=b.z
- ...

## plane

plane = vertices grouped by either x, y, or z e.g. all vertices where

- x==1
- y==0
- z==0
  -...

# in 4D

## vertices

vertices = each permutation of [x, y, z, w] being 0 or 1, e.g.

- [0, 0, 0, 0], [0, 0, 0, 1], [0, 0, 1, 0], ...
- ...

## line

line = pair of vertices differing in only 1 coordinate e.g. vertices where

- a.x==b.x, a.y==b.y, a.z!=b.z
- ...

## plane

plane = vertices grouped by either x, y, or z e.g. all vertices where

- x==1
- y==0
- z==0
  -...

## volume

volume = vertices grouped by w?
