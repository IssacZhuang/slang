//TEST:SIMPLE(filecheck=AFTER): -target metal -stage vertex -entry uintBaseAfter
//TEST:SIMPLE(filecheck=BEFORE): -target metal -stage vertex -entry uintBaseBefore
//TEST:SIMPLE(filecheck=AFTER): -target metal -stage vertex -entry intBaseAfter
//TEST:SIMPLE(filecheck=BEFORE): -target metal -stage vertex -entry intBaseBefore
//TEST:SIMPLE(filecheck=AFTER): -target metal -stage vertex -entry ushortBaseAfter
//TEST:SIMPLE(filecheck=BEFORE): -target metal -stage vertex -entry ushortBaseBefore
//TEST:SIMPLE(filecheck=AFTER): -target metal -stage vertex -entry shortBaseAfter
//TEST:SIMPLE(filecheck=BEFORE): -target metal -stage vertex -entry shortBaseBefore
//TEST:SIMPLE(filecheck=AFTER): -target metal -stage vertex -entry unusedBaseAfter
//TEST:SIMPLE(filecheck=BEFORE): -target metal -stage vertex -entry unusedBaseBefore

// A declared base is reused once, at native width, regardless of its declared type or order.
// AFTER: (uint [[V:[^ ]+]] {{\[\[}}vertex_id]], uint [[B:[^ ]+]] {{\[\[}}base_vertex]])
// AFTER-NOT: {{ - }}
// AFTER: float([[V]] - [[B]])
// AFTER-NOT: {{ - }}
// BEFORE: (uint [[B:[^ ]+]] {{\[\[}}base_vertex]], uint [[V:[^ ]+]] {{\[\[}}vertex_id]])
// BEFORE-NOT: {{ - }}
// BEFORE: float([[V]] - [[B]])
// BEFORE-NOT: {{ - }}

[shader("vertex")]
float4 uintBaseAfter(uint v : SV_VertexID, uint b : SV_StartVertexLocation) : SV_Position
{
    return float4(v, b, 0, 1);
}

[shader("vertex")]
float4 uintBaseBefore(uint b : SV_StartVertexLocation, uint v : SV_VertexID) : SV_Position
{
    return float4(v, b, 0, 1);
}

[shader("vertex")]
float4 intBaseAfter(uint v : SV_VertexID, int b : SV_StartVertexLocation) : SV_Position
{
    return float4(v, b, 0, 1);
}

[shader("vertex")]
float4 intBaseBefore(int b : SV_StartVertexLocation, uint v : SV_VertexID) : SV_Position
{
    return float4(v, b, 0, 1);
}

[shader("vertex")]
float4 ushortBaseAfter(uint v : SV_VertexID, uint16_t b : SV_StartVertexLocation) : SV_Position
{
    return float4(v, b, 0, 1);
}

[shader("vertex")]
float4 ushortBaseBefore(uint16_t b : SV_StartVertexLocation, uint v : SV_VertexID) : SV_Position
{
    return float4(v, b, 0, 1);
}

[shader("vertex")]
float4 shortBaseAfter(uint v : SV_VertexID, int16_t b : SV_StartVertexLocation) : SV_Position
{
    return float4(v, b, 0, 1);
}

[shader("vertex")]
float4 shortBaseBefore(int16_t b : SV_StartVertexLocation, uint v : SV_VertexID) : SV_Position
{
    return float4(v, b, 0, 1);
}

// Even a base unused by the shader body must not narrow the internal subtraction.
[shader("vertex")]
float4 unusedBaseAfter(uint v : SV_VertexID, uint16_t b : SV_StartVertexLocation) : SV_Position
{
    return float4(v, 0, 0, 1);
}

[shader("vertex")]
float4 unusedBaseBefore(uint16_t b : SV_StartVertexLocation, uint v : SV_VertexID) : SV_Position
{
    return float4(v, 0, 0, 1);
}
