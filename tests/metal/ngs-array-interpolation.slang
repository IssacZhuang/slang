//TEST:SIMPLE(filecheck=CHECK): -target metal -stage vertex -entry vsMain
//TEST:SIMPLE(filecheck=CHECK): -target metal -stage fragment -entry fsMain

// An array forces the whole interface to be recreated, including scalar/vector siblings.
struct Varyings
{
    float4 p : SV_Position;
    nointerpolation uint tag : TAG;
    centroid noperspective float2 uv : UV;
    sample float weight : WEIGHT;
    nointerpolation uint a[2] : TEXCOORD4;
};

// CHECK-DAG: {{\[\[}}flat{{\]\]}} uint {{tag_[0-9]+}} {{\[\[}}user(TAG){{\]\]}};
// CHECK-DAG: {{\[\[}}centroid_no_perspective{{\]\]}} float2 {{uv_[0-9]+}} {{\[\[}}user(UV){{\]\]}};
// CHECK-DAG: {{\[\[}}sample_perspective{{\]\]}} float {{weight_[0-9]+}} {{\[\[}}user(WEIGHT){{\]\]}};
// CHECK-DAG: {{\[\[}}flat{{\]\]}} uint {{a_0_[0-9]+}} {{\[\[}}user(TEXCOORD_4){{\]\]}};
// CHECK-DAG: {{\[\[}}flat{{\]\]}} uint {{a_1_[0-9]+}} {{\[\[}}user(TEXCOORD_5){{\]\]}};
Varyings vsMain(float4 p : POSITION, uint tag : TAG)
{
    Varyings result;
    result.p = p;
    result.tag = tag;
    result.uv = p.xy;
    result.weight = p.z;
    result.a[0] = tag + 1;
    result.a[1] = tag + 2;
    return result;
}

float4 fsMain(Varyings input) : SV_Target
{
    return float4(input.uv * input.weight, input.tag + input.a[0], input.a[1]);
}
