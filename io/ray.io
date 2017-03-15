//
// Ported from ray.cpp, a computer language shootout benchmark by Jon Harrop
// http://www.ffconsultancy.com/free/ray_tracer/comparison.html
//

delta := 2.22045e-16 sqrt
infinity := Number constants NaN

Vector unitise := method( self * (1 / dot( self ) sqrt) )

Hit := List clone do (
  set := getSlot("append")
)

Ray := Object clone do (

  init := method (
    self orig := Vector clone setSize( 3 )
    self dir  := Vector clone setSize( 3 )
  )

  set := method ( orig, dir,
    self orig = orig
    self dir = dir
    self
  )

)

Sphere := Object clone do (

  init := method (
    self center := Vector clone setSize( 3 )
    self radius := 0
  )

  set := method( center, radius,
    self center = center
    self radius = radius
    self
  )

  ray_sphere := method ( ray,
    v := center - ray orig
    b := v dot( ray dir )
    disc := b^2 - v dot( v ) + radius^2
    if( disc < 0, return infinity )
    d := disc sqrt
    t2 := b + d
    if( t2 < 0, return infinity )
    t1 := b - d
    return if( t1 > 0, t1, t2 )
  )

  intersect := method ( hit, ray,
    lambda := ray_sphere( ray )
    if( lambda >= hit at(0), return hit )
    return Hit clone set( lambda, (ray orig + ray dir * lambda - center) unitise )
  )

)

Group := Object clone do (

  init := method (
    self bound := Sphere clone
    self child := List clone
  )

  set := method( bound, child,
    self bound = bound
    self child = child
    self
  )

  intersect := method ( hit, ray,
    hit2 := hit
    l := bound ray_sphere( ray )
    if( l >= hit at(0), return hit )
    child foreach( it,
      hit2 = it intersect( hit2, ray )
    )
    return hit2
  )

)

_intersect := method ( ray, scene,
  hit := scene intersect( Hit clone set( infinity, vector( 0, 0, 0 ) ), ray )
  return hit
)

ray_trace := method ( light, ray, scene,
  hit := _intersect( ray, scene )
  if( hit at(0) == infinity, return 0 )
  g := hit at(1) dot( light )
  if( g >= 0, return 0 )
  p := ray orig + ray dir * hit at(0) + hit at(1) * delta
  return if( _intersect( Ray clone set( p, light * -1 ), scene ) at(0) < infinity, 0, -g )
)

create := method ( level, center, radius,
  s := Sphere clone set( center, radius )
  if( level == 1, return s )
  child := List clone
  child append( s )
  rn := 3 * radius / 12 sqrt
  for( dz, -1, 1, 2,
    for( dx, -1, 1, 2,
      child append( create( level - 1, vector( dx, 1, dz ) * rn + center, radius / 2 ) )
    )
  )
  return Group clone set( Sphere clone set( center, 3 * radius ), child )
)

level := 6; n := 64; ss := 4
light := vector( -1, -3, 2 ) unitise
scene := create( level, vector( 0, -1, 0 ), 1 )

//write( "P5\n", n, " ", n, "\n255\n" )

file := File clone open( "ray.raw" )

for( y, n - 1, 0,
  writeln( "y = ", y )
  for( x, 0, n - 1,
    g := 0
    for( dx, 0, ss,
      for( dy, 0, ss,
        dir := vector( x + dx * 1 / ss - n / 2, y + dy * 1 / ss - n / 2, n )
        g = g + ray_trace( light, Ray clone set( vector( 0, 0, -4 ), dir ), scene )
      )
    )
    file write( (0.5 + 255 * g / (ss^2)) roundDown asCharacter )
  )
  Collector collect
)

file close
