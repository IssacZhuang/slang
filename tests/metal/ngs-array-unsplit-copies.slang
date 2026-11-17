//TEST:SIMPLE(filecheck=MATRIX): -target metal -stage vertex -entry vsMatrix
//TEST:SIMPLE(filecheck=NESTED): -target metal -stage fragment -entry fsNested
//TEST:SIMPLE(filecheck=SYSTEM): -target metal -stage vertex -entry vsClip

// This pass splits scalar/vector user arrays, not matrix, multidimensional, or system arrays.
// Retained arrays must still be copied in both directions when another field is expanded.
struct MatrixOutput
{
    float4 p : SV_Position;
    float2x2 matrices[2] : MATRIX0;
    float a[2] : TEXCOORD0;
};

// MATRIX: struct vsMatrix_Result
// MATRIX: array<matrix<float,int(2),int(2)> , int(2)> [[FLAT:matrices_[0-9]+]]
// MATRIX: struct MatrixOutput
// MATRIX: array<matrix<float,int(2),int(2)> , int(2)> [[LOCAL:matrices_[0-9]+]];
// MATRIX: {{\[\[}}vertex{{\]\]}}
// MATRIX: ->[[FLAT]] = {{[A-Za-z_0-9]+}}.[[LOCAL]];
MatrixOutput vsMatrix(float4 p : POSITION)
{
    MatrixOutput result;
    result.p = p;
    result.matrices[0] = float2x2(p.xy, p.zw);
    result.matrices[1] = float2x2(p.zw, p.xy);
    result.a[0] = p.x;
    result.a[1] = p.y;
    return result;
}

struct NestedInput
{
    float a[2] : TEXCOORD0;
    nointerpolation uint values[2][2] : DATA0;
};

// NESTED: struct pixelInput
// NESTED: array<array<uint, int(2)>, int(2)> [[FLAT:values_[0-9]+]]
// NESTED: struct pixelInput
// NESTED: array<array<uint, int(2)>, int(2)> [[LOCAL:values_[0-9]+]];
// NESTED: {{\[\[}}fragment{{\]\]}}
// NESTED: ->[[LOCAL]] = {{[A-Za-z_0-9]+}}.[[FLAT]];
float4 fsNested(NestedInput input) : SV_Target
{
    return float4(input.values[0][0], input.values[0][1], input.values[1][0], input.values[1][1]) +
        input.a[0] + input.a[1];
}

struct ClipOutput
{
    float4 p : SV_Position;
    float clips[2] : SV_ClipDistance;
    float a[2] : TEXCOORD0;
};

// SYSTEM: struct vsClip_Result
// SYSTEM: array<float, int(2)> [[FLAT:clips_[0-9]+]]
// SYSTEM: struct ClipOutput
// SYSTEM: array<float, int(2)> [[LOCAL:clips_[0-9]+]];
// SYSTEM: {{\[\[}}vertex{{\]\]}}
// SYSTEM: ->[[FLAT]] = {{[A-Za-z_0-9]+}}.[[LOCAL]];
ClipOutput vsClip(float4 p : POSITION)
{
    ClipOutput result;
    result.p = p;
    result.clips[0] = p.x;
    result.clips[1] = p.y;
    result.a[0] = p.z;
    result.a[1] = p.w;
    return result;
}
