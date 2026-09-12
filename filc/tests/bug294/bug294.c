#include <stddef.h>

typedef struct
{
	float x, y, z;
} Vec3;

typedef struct
{
	Vec3 v;
	float s;
} Quat;

typedef struct
{
	Vec3 p;
	Quat q;
} Transform;

_Static_assert( sizeof( Vec3 ) == 12 && _Alignof( Vec3 ) == 4, "unexpected Vec3 layout" );
_Static_assert( sizeof( Quat ) == 16 && _Alignof( Quat ) == 4, "unexpected Quat layout" );
_Static_assert( sizeof( Transform ) == 28 && _Alignof( Transform ) == 4, "unexpected Transform layout" );
_Static_assert( offsetof( Transform, q ) == 12, "unexpected Transform::q offset" );

static volatile float sink;
static const Vec3 zero = { 0.0f, 0.0f, 0.0f };

static inline Vec3 cross( Vec3 a, Vec3 b )
{
	return (Vec3){ a.y * b.z - a.z * b.y, a.z * b.x - a.x * b.z, a.x * b.y - a.y * b.x };
}

static inline Vec3 inv_rotate_vector( Quat q, Vec3 v )
{
	Vec3 t1 = cross( q.v, v );
	Vec3 t2 = (Vec3){ t1.x + q.s * v.x, t1.y + q.s * v.y, t1.z + q.s * v.z };
	Vec3 t3 = cross( q.v, t2 );
	return (Vec3){ v.x - 2.0f * t3.x, v.y - 2.0f * t3.y, v.z - 2.0f * t3.z };
}

static inline Transform to_relative_transform( Transform t, Vec3 base )
{
	Transform r;
#if defined( FILC_REPRO_SCALAR_COPY )
	r.q.v.x = t.q.v.x;
	r.q.v.y = t.q.v.y;
	r.q.v.z = t.q.v.z;
	r.q.s = t.q.s;
#else
	r.q = t.q;
#endif
	r.p = (Vec3){ t.p.x - base.x, t.p.y - base.y, t.p.z - base.z };
	return r;
}

static inline Transform invert_transform( Transform t )
{
	Transform r;
	r.p = inv_rotate_vector( t.q, (Vec3){ -t.p.x, -t.p.y, -t.p.z } );
	r.q = (Quat){ { -t.q.v.x, -t.q.v.y, -t.q.v.z }, t.q.s };
	return r;
}

static void refresh_cache( Transform xf )
{
	Transform meshTransform = to_relative_transform( xf, zero );
	Transform result = invert_transform( meshTransform );
	sink += result.p.x + result.q.v.z;
}

int main( void )
{
	Transform xf = { { 1.0f, 2.0f, 3.0f }, { { 0.1f, 0.2f, 0.3f }, 0.9f } };
	refresh_cache( xf );
	return sink == 0.0f;
}
