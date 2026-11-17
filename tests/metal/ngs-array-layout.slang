//TEST:SIMPLE(filecheck=SCALAR): -target metal -stage vertex -entry vsScalar
//TEST:SIMPLE(filecheck=ARRAY): -target metal -stage vertex -entry vsArray
//TEST:SIMPLE(filecheck=INPUT): -target metal -stage vertex -entry vsInput
//TEST:SIMPLE(filecheck=MIXED): -target metal -stage vertex -entry vsMixed

// Expanding a must not leave b indexed against the original, shorter struct layout.
struct ScalarOutput
{
    float4 p : SV_Position;
    float a[2] : TEXCOORD0;
    float b;
};

// SCALAR: struct vsScalar_Result
// SCALAR: float4 {{p_[0-9]+}} {{\[\[}}position{{\]\]}};
// SCALAR: float [[A0:a_0_[0-9]+]] {{\[\[}}user(TEXCOORD){{\]\]}};
// SCALAR: float [[A1:a_1_[0-9]+]] {{\[\[}}user(TEXCOORD_1){{\]\]}};
// SCALAR: float [[B:b_[0-9]+]] {{\[\[}}user(_SLANG_ATTR_2){{\]\]}};
// SCALAR: {{\[\[}}vertex{{\]\]}}
// SCALAR-DAG: ->[[A0]] = {{[A-Za-z_0-9]+}}.{{a_[0-9]+}}[int(0)];
// SCALAR-DAG: ->[[A1]] = {{[A-Za-z_0-9]+}}.{{a_[0-9]+}}[int(1)];
// SCALAR-DAG: ->[[B]] = {{[A-Za-z_0-9]+}}.{{b_[0-9]+}};
ScalarOutput vsScalar(float4 p : POSITION)
{
    ScalarOutput result;
    result.p = p;
    result.a[0] = p.x;
    result.a[1] = p.y;
    result.b = p.z;
    return result;
}

struct ArrayOutput
{
    float4 p : SV_Position;
    float a[2] : TEXCOORD0;
    float b[2];
};

// ARRAY: struct vsArray_Result
// ARRAY: float {{a_0_[0-9]+}} {{\[\[}}user(TEXCOORD){{\]\]}};
// ARRAY: float {{a_1_[0-9]+}} {{\[\[}}user(TEXCOORD_1){{\]\]}};
// ARRAY: float [[B0:b_0_[0-9]+]] {{\[\[}}user(_SLANG_ATTR_2){{\]\]}};
// ARRAY: float [[B1:b_1_[0-9]+]] {{\[\[}}user(_SLANG_ATTR_3){{\]\]}};
// ARRAY: {{\[\[}}vertex{{\]\]}}
// ARRAY-DAG: ->[[B0]] = {{[A-Za-z_0-9]+}}.{{b_[0-9]+}}[int(0)];
// ARRAY-DAG: ->[[B1]] = {{[A-Za-z_0-9]+}}.{{b_[0-9]+}}[int(1)];
ArrayOutput vsArray(float4 p : POSITION)
{
    ArrayOutput result;
    result.p = p;
    result.a[0] = p.x;
    result.a[1] = p.y;
    result.b[0] = p.z;
    result.b[1] = p.w;
    return result;
}

struct Input
{
    float a[2] : TEXCOORD0;
    float b;
};

// INPUT: struct vertexInput
// INPUT: float [[A0:a_0_[0-9]+]] {{\[\[}}attribute(0){{\]\]}};
// INPUT: float [[A1:a_1_[0-9]+]] {{\[\[}}attribute(1){{\]\]}};
// INPUT: float [[B:b_[0-9]+]] {{\[\[}}attribute(2){{\]\]}};
// INPUT: {{\[\[}}vertex{{\]\]}}
// INPUT-DAG: {{a_[0-9]+}}[int(0)] = {{[A-Za-z_0-9]+}}.[[A0]];
// INPUT-DAG: {{a_[0-9]+}}[int(1)] = {{[A-Za-z_0-9]+}}.[[A1]];
// INPUT-DAG: ->{{b_[0-9]+}} = {{[A-Za-z_0-9]+}}.[[B]];
float4 vsInput(Input input) : SV_Position
{
    return float4(input.a[0], input.a[1], input.b, 1.0);
}

struct MixedOutput
{
    float4 p : SV_Position;
    float a[2] : TEXCOORD0;
};

// MIXED: struct vsMixed_Result
// MIXED: float4 {{p_[0-9]+}} {{\[\[}}position{{\]\]}};
// MIXED: float [[A0:a_0_[0-9]+]] {{\[\[}}user(TEXCOORD){{\]\]}};
// MIXED: float [[A1:a_1_[0-9]+]] {{\[\[}}user(TEXCOORD_1){{\]\]}};
// MIXED: float2 [[UV:uv_[0-9]+]] {{\[\[}}user(TEXCOORD_6){{\]\]}};
// MIXED: float2 [[TAIL:tail_[0-9]+]] {{\[\[}}user(TEXCOORD_8){{\]\]}};
// MIXED: struct vertexInput
// MIXED: float4 [[P_INPUT:p_[0-9]+]] {{\[\[}}attribute(0){{\]\]}};
// MIXED: float2 [[TAIL_INPUT:tail_[0-9]+]] {{\[\[}}attribute(1){{\]\]}};
// MIXED: {{\[\[}}vertex{{\]\]}}
// MIXED-SAME: vsMixed({{[A-Za-z_0-9]+}} [[PARAM:[A-Za-z_0-9]+]] {{\[\[}}stage_in{{\]\]}})
// MIXED: float2 [[UV_VALUE:[A-Za-z_0-9]+]] = [[PARAM]].[[P_INPUT]].zw;
// MIXED: float2 [[TAIL_VALUE:[A-Za-z_0-9]+]] = [[PARAM]].[[TAIL_INPUT]] + [[PARAM]].[[P_INPUT]].xy;
// MIXED-DAG: ->[[A0]] = {{[A-Za-z_0-9]+}}.{{a_[0-9]+}}[int(0)];
// MIXED-DAG: ->[[A1]] = {{[A-Za-z_0-9]+}}.{{a_[0-9]+}}[int(1)];
// MIXED-DAG: ->[[UV]] = [[UV_VALUE]];
// MIXED-DAG: ->[[TAIL]] = [[TAIL_VALUE]];
MixedOutput vsMixed(
    float4 p : POSITION,
    out float2 uv : TEXCOORD6,
    inout float2 tail : TEXCOORD8)
{
    MixedOutput result;
    result.p = p;
    result.a[0] = p.x;
    result.a[1] = p.y;
    uv = p.zw;
    tail += p.xy;
    return result;
}
