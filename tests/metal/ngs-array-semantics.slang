//TEST:SIMPLE(filecheck=VS): -target metal -stage vertex -entry vsMain
//TEST:SIMPLE(filecheck=FS): -target metal -stage fragment -entry fsMain

// Both stages must normalize TEXCOORD4 before incrementing its element indices.
struct Varyings
{
    float4 p : SV_Position;
    float a[2] : TEXCOORD4;
    float x : TEXCOORD6;
    float2 uv[2] : TEXCOORD8;
};

// VS: struct vsMain_Result
// VS: float [[A0:a_0_[0-9]+]] {{\[\[}}user(TEXCOORD_4){{\]\]}};
// VS: float [[A1:a_1_[0-9]+]] {{\[\[}}user(TEXCOORD_5){{\]\]}};
// VS: float {{x_[0-9]+}} {{\[\[}}user(TEXCOORD_6){{\]\]}};
// VS: float2 [[UV0:uv_0_[0-9]+]] {{\[\[}}user(TEXCOORD_8){{\]\]}};
// VS: float2 [[UV1:uv_1_[0-9]+]] {{\[\[}}user(TEXCOORD_9){{\]\]}};
// VS: {{\[\[}}vertex{{\]\]}}
// VS-DAG: ->[[A0]] = {{[A-Za-z_0-9]+}}.{{a_[0-9]+}}[int(0)];
// VS-DAG: ->[[A1]] = {{[A-Za-z_0-9]+}}.{{a_[0-9]+}}[int(1)];
// VS-DAG: ->[[UV0]] = {{[A-Za-z_0-9]+}}.{{uv_[0-9]+}}[int(0)];
// VS-DAG: ->[[UV1]] = {{[A-Za-z_0-9]+}}.{{uv_[0-9]+}}[int(1)];
Varyings vsMain(float4 p : POSITION)
{
    Varyings result;
    result.p = p;
    result.a[0] = p.x;
    result.a[1] = p.y;
    result.x = p.z;
    result.uv[0] = p.xy;
    result.uv[1] = p.zw;
    return result;
}

// FS: struct pixelInput
// FS: float [[A0:a_0_[0-9]+]] {{\[\[}}user(TEXCOORD_4){{\]\]}};
// FS: float [[A1:a_1_[0-9]+]] {{\[\[}}user(TEXCOORD_5){{\]\]}};
// FS: float {{x_[0-9]+}} {{\[\[}}user(TEXCOORD_6){{\]\]}};
// FS: float2 [[UV0:uv_0_[0-9]+]] {{\[\[}}user(TEXCOORD_8){{\]\]}};
// FS: float2 [[UV1:uv_1_[0-9]+]] {{\[\[}}user(TEXCOORD_9){{\]\]}};
// FS: {{\[\[}}fragment{{\]\]}}
// FS-DAG: {{a_[0-9]+}}[int(0)] = {{[A-Za-z_0-9]+}}.[[A0]];
// FS-DAG: {{a_[0-9]+}}[int(1)] = {{[A-Za-z_0-9]+}}.[[A1]];
// FS-DAG: {{uv_[0-9]+}}[int(0)] = {{[A-Za-z_0-9]+}}.[[UV0]];
// FS-DAG: {{uv_[0-9]+}}[int(1)] = {{[A-Za-z_0-9]+}}.[[UV1]];
float4 fsMain(Varyings input) : SV_Target
{
    return float4(input.uv[0] + input.uv[1], input.a[0] + input.a[1], input.x);
}
